% quickies - microscope Project

% log message
msg = sprintf('Changed Arduino port to %s', port);
logCommand(msg, handles.logwindow);


% Update handles structure
guidata(hObject, handles);


sendCommand('lampon', handles.com, handles.logwindow);