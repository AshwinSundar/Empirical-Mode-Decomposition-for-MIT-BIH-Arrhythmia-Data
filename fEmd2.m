% modified version of fEmd.m
% designed to operate on unknown arrhythmia types - no averaging

function fEmd2
WD = cd; % saves the directory you are currently in, so we can navigate back later
sOriginalDir = WD; % extra step because of an idiosyncracy with saving the working directory in matlab
format long e; % increase decimal precision
sDelimiter = ',';
iRowOffset = 0;
iColOffset = 0;
sPrecision = '%.3f';

% get into the test directory
sTestFolder = 'Test';
cd(sTestFolder);

% get the files
tFiles = dir('*.csv'); % gets all files in curent directory, puts info in a struct (t)

tic
% iterate through each file
% file names start on 2, go to 51
for j = 2:(length(tFiles) + 1) % go through all the files
    % get into the test folder again
    cd('C:\Users\Ashwin\Documents\1 ASU\Applied-Project\Applied Project\EMD Matlab Environ\Test');
    
    % name of the current file we're on
    sFileName = getfield(tFiles(j), 'name'); 
    
    fprintf(strcat('Currently processing: ', sFileName, '\n'));
    
    % get the data set from the windowed csvs
    aData = csvread(sFileName);
    
    % decompose into empirical modes. emd function exists in original
    % directory, so go back there first.
    cd(sOriginalDir);
    aModes = emd(aData(:, 2));
    cd(sTestFolder);
    
    % save modes
    dlmwrite(strcat(sTestFolder, num2str(j+1), '_Modes.csv'), aModes, 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
       
end

% it's polite to return the user to the original directory they started in
cd(sOriginalDir);
toc
end