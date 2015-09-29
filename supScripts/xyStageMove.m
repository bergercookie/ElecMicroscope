function [] = xyStageMove(dir, com, logwindow)
% XYSTAGEMOVE Issue the direction and move the XY Stage accordingly
%
% todo: have to check this function

pauseTime = 0.05;

% first send the keyword 'filter' so that the arduino program changes
% 'mode' --> see loop_filter function of arduino program
sendCommand('xystage', com, logwindow)

% issue a pause command so that arduino is ready to receive the second command
pause(pauseTime); 

% then issue the position specified in a seperate serial command
sendCommand(dir, com, logwindow);