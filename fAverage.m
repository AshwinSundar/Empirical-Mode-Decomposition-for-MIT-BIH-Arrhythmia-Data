% is there a file containing the average modes yet?
if(exist(sModeFile, 'file'));
    % if so average with existing data
    aAverageMode = csvread(sModeFile, iRowOffset, iColOffset, 'A1..BU1'); % this assumes the data set is exactly 73 points. Might be a good idea to make this dynamic. Would need to replace 73 in the next line as well
    iNumOfAverages = csvread(sModeFile, iRowOffset, 73) + 1; % number of modes contributing to the average, add 1 because we're adding a new mode
    aNewAverageMode = aAverageMode*(iNumOfAverages - 1)/(iNumOfAverages) + aModes(k,:)*(1/iNumOfAverages); % you need to weight the new mode appropriately, not just dump it in
    dlmwrite(sModeFile, [aNewAverageMode iNumOfAverages], 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
    % dlmwrite(sModeFile, iNumOfAverages + 1, 'delimiter', sDelimiter, 'roffset', 1, 'coffset', iColOffset, 'precision', sPrecision);
else
    % if not create a new file and just dump the mode in
    aNewAverageMode = aModes(k,:);
    dlmwrite(sModeFile, [aNewAverageMode 1], 'delimiter', sDelimiter, 'roffset', iRowOffset, 'coffset', iColOffset, 'precision', sPrecision);
end