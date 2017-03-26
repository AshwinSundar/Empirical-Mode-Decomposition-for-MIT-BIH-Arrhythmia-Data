% This function gets MIT-BIH data using WFDB and saves it locally.

% First, get the full data set
% Second, decide whether you need the upper or lower set
% Finally, save the data locally in a csv

% Issues:
% 1) FIXED Need to increase precision for time column - problem has to do with
% csvwrite - changed to dlmwrite

function fGetMITBIHData
format long e; % increase decimal precision
% Step 1: get list of record names from PhysioBank Records.xlsx
sfileName = 'PhysioBank Records.xlsx'; 
fprintf('Select range of file numbers\n'); % prompt for xlsread
[aMITDBFileNumbers, ~, ~] = xlsread(sfileName, -1);
aMITDBFileNumbers = aMITDBFileNumbers(isfinite(aMITDBFileNumbers(:,1)),:); % removes any NaNs

% Step 2: Get the list of lead configurations to use for each data set
fprintf('Select range of lead configurations to use\n'); % prompt for xlsread
[aLeadConfigs, ~, ~] = xlsread(sfileName, -1);
aLeadConfigs = aLeadConfigs(isfinite(aLeadConfigs(:,1)),:); % removes any NaNs

% Step 3: for each title in list, get the data using WFDB. Good use of parallel
% processing - each set takes close to 10 seconds to get, and there's 50
% sets. 
cd C:\Users\Ashwin\Documents\'1 ASU'\Applied-Project\'Applied Project'\'MIT-BIH Arrhythmia Data'\wfdb-app-toolbox-0-9-9\mcode
parpool(4);
aBothLeadConfigs = zeros(650000, 2);
aTime = zeros(650000, 1); 
aLeadConfigOne = zeros(650000, 1); 
aLeadConfigTwo = zeros(650000, 1); 
sDelimiter = ',';
iRowOffset = 0;
iColOffset = 0;
sPrecision = '%.3f';
WD = cd; % saves the directory you are currently in, so we can navigate back later
sOriginalDir = WD; 
parfor i = 1:length(aMITDBFileNumbers) 
    sMITDBFileName = strcat('mitdb/', num2str(aMITDBFileNumbers(i))); 
    [aTime, aBothLeadConfigs] = rdsamp(sMITDBFileName);
    aLeadConfigOne = aBothLeadConfigs(1:end, 1); 
    aLeadConfigTwo = aBothLeadConfigs(1:end, 2); 
    
    % Write CSV file in the correct directory
    cd C:\Users\Ashwin\Documents\'1 ASU'\Applied-Project\'Applied Project'\'EMD Matlab Environ'
    
    % get only the lead config you need
    switch aLeadConfigs(i)
        case 0
            disp(strcat('skipped file: ', sMITDBFileName))
        case 1
            dlmwrite(strcat('mitdb', num2str(aMITDBFileNumbers(i)), '.csv'), [aTime aLeadConfigOne], 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
            fprintf(strcat(sMITDBFileName, ' complete with lead configuration 1.\n')); 
        case 2
            dlmwrite(strcat('mitdb', num2str(aMITDBFileNumbers(i)), '.csv'), [aTime aLeadConfigTwo], 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
            fprintf(strcat(sMITDBFileName, ' complete with lead configuration 2.\n')); 
        otherwise
            disp('Invalid lead configuration.')
    end
    % Return to the WFDB directory
    cd C:\Users\Ashwin\Dropbox\'Applied Project'\'MIT-BIH Arrhythmia Data'\wfdb-app-toolbox-0-9-9\mcode
end

% % make sure a valid lead config was entered before any heavy lifting
% if (leadConfig == 1 || leadConfig == 2)
%     % e.g. dataName = 'mitdb/100.dat'
%     [fullTime, fullSignal] = rdsamp(dataName);
%     fullData(1:end,1) = fullTime;
%     % data set 1 is lead config 1 (upper graph in LightWave). data set 2 is
%     % lead config 2 (lower graph in LightWave)
%     fullData(1:end,2) = fullSignal(1:end,leadConfig);
% else
%     fprintf('Lead config must be either 1 or 2\n'); 
% end
% 
% % 1) get the file and cell
% fileName = 'PhysioBank Records.xlsx';
% sheet = 1; 
% [~, text] = xlsread(fileName, sheet, dataRange);
% % 3) delimit the cell and store the data
% tempAPBs = strsplit(cell2mat(text), delimiter);
% convertTimeToSeconds(tempAPBs); 
% % Convert those time strings to time in seconds
% 
% % shove data into map
% %{
% for (each disorder) 
%     plot(fullData((disorder_point_n-0.05seconds):(disorder_point_n+0.05seconds),1), allData((disorder_point_n-0.05seconds):(disorder_point_n+0.05seconds),2))
%     emd(disorder_point_n-0.05seconds:disorder_point_n+0.05seconds)) 
% 
% for (25 healthy points from each patient, could be more but that's good for now)
%     do the same thing as for (each disorder)
% %}
% 
% shut down parallel processing
delete(gcp); 
% return to the directory you were originally in
cd(sOriginalDir); 
end
