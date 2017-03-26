function fDeviations

iRowOffset = 0; % terms for csvread
iColOffset = 0;
format long e; % increase decimal precision

% create square matrices to store info

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
                case 6
                    aDeviationMatrixM6(j, k) = stdev; 
                otherwise
                    fprintf('Mode ', num2str(i), ' not found.\n');
            end
        end
    end
end

% check: matrix is symmetric (equal to transpose)
% check: diagonals are all 0

end