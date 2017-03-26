function plotAll

tFiles = dir('AverageMode*'); % gets all files starting with AverageMode
iNumFiles = length(tFiles); % number of files to iterate through
scrsz = get(groot,'ScreenSize'); % gets size of screen
h = figure('Name','Plots','NumberTitle','off', 'PaperType', 'A', 'Position', [1 1 scrsz(3) scrsz(4)], 'InvertHardcopy', 'off', 'Resize', 'on'); % create new figure
iNumTypes = 21; % Number of types of arrhythmias that I want to compare
for i = 1:iNumFiles
    sArrFileName = getfield(tFiles(i), 'name'); % gets the file name
    aMode = csvread(sArrFileName);
    scrollsubplot(4, 1, i); % this function is not native to matlab. needs to be downloaded - http://www.mathworks.com/matlabcentral/fileexchange/7730-scrollsubplot
    plot(aMode(1:73)'); 
    title(sArrFileName, 'FontSize', 8);
    axis off; 
end
end


