function [] = verticalSliderChanged(src, data, logwindow)
% VERTICALSLIDERCHANGED Activated when the position of the vertical Slider
% is changed. Then we parse the direction of the movement and send the
% appropriate command to the serial. 
% [NOT] in use given the current setup

global com4sliders
global verticalSlprev

curPos = src.Value;
fprintf(1, 'Previous position is: %d\n', verticalSlprev);
fprintf(1, 'Current position is: %d\n', curPos);

if curPos > verticalSlprev
    direction = 'UP';
    buttonup_fun(com4sliders, logwindow);
elseif curPos < verticalSlprev
    direction = 'DOWN';
    buttondown_fun(com4sliders, logwindow);
else
    direction = 'SAME';
end

% update the verticalSlprev global variable
verticalSlprev = curPos;

fprintf(1, 'Direction is %s\n', direction);

end

function [] = buttonup_fun(com4sliders, logwindow)
fprintf(1, 'Inside buttonup_fun...\n');
sendCommand('UP', com4sliders, logwindow);

end

function [] = buttondown_fun(com4sliders, logwindow)
fprintf(1, 'Inside buttondown_fun...\n');
sendCommand('DOWN', com4sliders, logwindow);

end

function [] = sendCommandLocal(thestring, com4sliders, logwindow)
pausetime = 0.001;
% first send the keyword 'xystage' so that the arduino program changes
% 'mode' --> see loop_filter function of arduino program
sendCommand('xystage', com4sliders, logwindow)
% issue a pause command so that arduino is ready to receive the second command

% then issue the position specified in a seperate serial command
sendCommand(thestring, com4sliders, logwindow);
end

