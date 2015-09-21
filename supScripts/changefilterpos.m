function [] = changefilterpos(pos, com, logwindow)
% CHANGEFILTERPOS Change the position of the filter set to the specified
% one - pos. Then announce it through the logWindow.
%
% todo: have to check this function

% first send the keyword 'filter' so that the arduino program changes
% 'mode' --> see loop_filter function of arduino program
sendCommand('filter', com, logwindow)

% issue a pause command so that arduino is ready to receive the second command
pause(0.05); 

% then issue the position specified in a seperate serial command
sendCommand(pos, com, logwindow);