function [seconds] = convertTimeToSeconds(times)
% for each value in the string
% skip semi colons
% multiply numbers together
% spit out value in seconds
% go through all the times
% formatting hh:mm:ss.sss
conversion = [%secondsInHour*10 secondsInHour 0 secondsInMinute*10 secondsInMinute 0] 
for i = 1:length(timeString)
   % convert cells to better format
   % current format 00:00:00.000
   tempString = cell2mat(timeString(i));
   tempSeconds = 0.0;
   for i = 1:length(tempString)
       if (tempString(i) != ':')
           tempSeconds = tempSeconds + str2num(tempString(i))*conversion(i)
           
end
