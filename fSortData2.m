% Issues
% 1) FIXED Need to increase precision for time column - issue was with
% csvwrite in fGetMITBIHData. replaced with dlmwrite and added precision
% argument
% 2) FIXED 108, 109, 111 need to be re-got with correct precision
% 3) FIXED First waveform (V) looks upside down - it's fine, that's how the
% data looks in LightWave
% 4) FIXED Get the full arrhythmia name - you're using chars so specify the range

function fSortData2
% Step 1: Get the arrhythmia demarcations from 'PhysioBank Records.xlsx'
% delete(gcp); % shuts down any active parallel pools
WD = cd; % saves the directory you are currently in, so we can navigate back later
sOriginalDir = WD;
format long e; % increase decimal precision
sDelimiter = ',';
iRowOffset = 0;
iColOffset = 0;
sPrecision = '%.3f';   
sfileName = 'PhysioBank Records.xlsx'; 

% Step 2: Get the file numbers from 'PhysioBank Records.xlsx' 
fprintf('Select range of file numbers\n'); % prompt for xlsread
[aMITDBFileNumbers, ~, ~] = xlsread(sfileName, -1);
aMITDBFileNumbers = aMITDBFileNumbers(isfinite(aMITDBFileNumbers(:,1)),:); % removes any NaNs

% Step 3: Using the arrhythmia demarcations, window the data
% QRS complex spans 60-100 ms in healthy patients, up to
% 150 ms in patients with cardiac problems (Sivaraks 2014, Kim 2016).
% Literature indicates that 100 ms ought to be a sufficient window. I'll
% bracket the arrhythmia with 50ms on either side
windowSize = 0.1; % 100 milliseconds
sampleRate = 360; 
% parpool(4); % if this throws an error, reduce the number of pools down to however many real cores your computer has (virtual cores not allowed)
newdir = 'Test';
mkdir(newdir); % make a fresh directory to hold the test windows
iCount = 1; % for naming

for j = 1:length(aMITDBFileNumbers) % go through all the files
    sMITDBFileName = strcat('mitdb', num2str(aMITDBFileNumbers(j))); % make the file name
    fprintf(strcat('Current file: ', sMITDBFileName, '\n')); % Prints out which file we're on
    fprintf('Select range of arrhythmia locations\n'); % prompt for xlsread
    [aArrhythmiaDemarcations, ~, ~] = xlsread(sfileName, -1); % asks for the arrhythmia locations in the excel file
    aArrhythmiaDemarcations = aArrhythmiaDemarcations(isfinite(aArrhythmiaDemarcations(:,1)),:); % removes any NaNs

    file = csvread(strcat('mitdb', num2str(aMITDBFileNumbers(j)), '.csv')); % read the data in
    cd(newdir); % enter the directory
    arrWindow = zeros(73,2); % 2*windowSize + 1, and 2 columns
    
    for i = 1:length(aArrhythmiaDemarcations) % go through all arrhythmias for each file
        sMITDBArrhythmiaNumber = num2str(i);
        currentArrhythmiaLocation = aArrhythmiaDemarcations(i);
        
        % 1) Subtract arrhythmia time from full data set
        temp(:,1) = file(:,1) - currentArrhythmiaLocation;
        
        % 2) find the index of the min of the absolute value of column 1
        minVal = min(abs(temp(:,1))); 
        [~,minValIdx] = ismember(minVal,temp(:,1),'R2012a');
        
        if(minValIdx == 0) % this means we need to use the negative value instead
            [~,minValIdx] = ismember(-minVal,temp(:,1),'R2012a');
        end
        
        % 3) extract the window around this min
        % Current error: Subscripted assignment dimension mismatch.
        dLowerWindowBound = minValIdx - windowSize*sampleRate;
        dUpperWindowBound = minValIdx + windowSize*sampleRate;
        arrWindow(:,1) = file(dLowerWindowBound:dUpperWindowBound,1);
        arrWindow(:,2) = file(dLowerWindowBound:dUpperWindowBound,2); 
        
        % save the window as a csv
        iCount = iCount + 1; 
        sWindowFileName = strcat('Test', '_', num2str(iCount)); 
        % csvwrite(strcat(sWindowFileName, '.csv'), [arrWindow]);
        % return to main directory
        cd(sOriginalDir);
        dlmwrite(strcat(sWindowFileName, '.csv'), [arrWindow], 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
    end
end

% shut down parallel pool
% delete(gcp); 
end
