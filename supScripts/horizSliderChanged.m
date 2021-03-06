function [] = verticalSliderChanged(src, data, com, logwindow)
% HORIZSLIDERCHANGED Activated when the position of the vertical Slider
% is changed. Then we parse the direction of the movement and send the
% appropriate command to the serial. 
% [NOT] in use given the current setup

global horizSlprev
curPos = src.Value;
fprintf(1, 'Previous position is: %d\n', horizSlprev);
fprintf(1, 'Current position is: %d\n', curPos);

if curPos > horizSlprev
    direction = 'RIGHT';
    buttonup_fun(com, logwindow);
elseif curPos < horizSlprev
    direction = 'LEFT';
    buttondown_fun(com, logwindow);
else
    direction = 'SAME';
end

% update the horizSlprev global variable
horizSlprev = curPos;

fprintf(1, 'Direction is %s\n', direction);

end

function [] = buttonup_fun(com, logwindow)
fprintf(1, 'Inside buttonup_fun...\n');
sendCommandLocal('RIGHT', com, logwindow);

end

function [] = buttondown_fun(com, logwindow)
fprintf(1, 'Inside buttondown_fun...\n');
sendCommandLocal('LEFT', com, logwindow);

end

function [] = sendCommandLocal(thestring, com, logwindow)
% first send the keyword 'xystage' so that the arduino program changes
% 'mode' --> see loop_filter function of arduino program
sendCommand('xystage', com, logwindow)
% issue a pause command so that arduino is ready to receive the second command
pause(0.01);
% then issue the position specified in a seperate serial command
sendCommand(thestring, com, logwindow);
end