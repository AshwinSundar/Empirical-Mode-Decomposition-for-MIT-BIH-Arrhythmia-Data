tFiles = dir('*.csv'); % gets all files in curent directory, puts info in a struct (t)

iNumFiles = length(tFiles); 

iRowOffset = 0;
iColOffset = 0;

format long e; % increase decimal precision

