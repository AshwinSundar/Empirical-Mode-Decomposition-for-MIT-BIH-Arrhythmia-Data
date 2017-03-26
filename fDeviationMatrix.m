function [aDeviationMatrixM1, aDeviationMatrixM2, aDeviationMatrixM3, aDeviationMatrixM4, aDeviationMatrixM5] = fDeviationMatrix

iNumFiles = 20; % number of arrhythmia types
sfileName = 'PhysioBank Records.xlsx';
iNumModes = 5; % first 5 modes exist across all arrhythmias
iRowOffset = 0; % terms for csvread
iColOffset = 0;
format long e; % increase decimal precision

aDeviationMatrixM1 = zeros(iNumFiles); % create square matrix to store info from each mode comparison
aDeviationMatrixM2 = zeros(iNumFiles); % first 5 modes exist across all arrhythmias
aDeviationMatrixM3 = zeros(iNumFiles);
aDeviationMatrixM4 = zeros(iNumFiles);
aDeviationMatrixM5 = zeros(iNumFiles);

fprintf('Select range of arrhythmia abbreviations in sheet 3\n'); % prompt for xlsread
[~, aArrhythmiaTypes, ~] = xlsread(sfileName, -1); % gets the arrhythmia abbreviation, stores it in a cell array
aArrhythmiaTypes = char(aArrhythmiaTypes); % convert to chars
aArrhythmiaTypes = aArrhythmiaTypes(isfinite(aArrhythmiaTypes(:,1)),:); % removes any NaNs
iNumArr = length(aArrhythmiaTypes); % number of arrhythmias we're looking at

% for each average mode
for i = 1:iNumModes    
    % for each arrhythmia...
    for j = 1:iNumArr
        sModeFileName1 = strcat('AverageMode_', deblank(aArrhythmiaTypes(j, :)), num2str(i), '.csv'); % build the file name
        aModeFile1 = csvread(sModeFileName1, iRowOffset, iColOffset, 'A1..BU1'); % get the file
        fprintf(strcat(sModeFileName1, '\n')); 
        % go through every arrhythmia....
        for k = 1:iNumArr
            sModeFileName2 = strcat('AverageMode_', deblank(aArrhythmiaTypes(k, :)), num2str(i), '.csv'); % build the other file name
            aModeFile2 = csvread(sModeFileName2, iRowOffset, iColOffset, 'A1..BU1'); % get the other file
            
            % normalize the means w.r.t. each other
            aModeFile2Corr = aModeFile2 - (mean(aModeFile2) - mean(aModeFile1));
            
            % calculate the standard deviation...
            fprintf(strcat(sModeFileName2, '\n')); 
            sq = (aModeFile1 - aModeFile2Corr).^2; % square of the difference between each point
            var = mean(sq); % variance is the mean of the squared differences
            stdev = sqrt(var);
            % and enter into an NxN matrix, where N is the number of arrhythmia types
            switch(i)
                case 1
                    aDeviationMatrixM1(j, k) = stdev;
                case 2
                    aDeviationMatrixM2(j, k) = stdev;
                case 3
                    aDeviationMatrixM3(j, k) = stdev;
                case 4
                    aDeviationMatrixM4(j, k) = stdev;
                case 5
                    aDeviationMatrixM5(j, k) = stdev;
                otherwise
                    fprintf('Mode ', num2str(i), ' not found.\n');
            end
        end
    end
end

% check: matrix is symmetric (equal to transpose)
% check: diagonals are all 0

end