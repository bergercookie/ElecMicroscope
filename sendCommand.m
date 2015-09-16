function sendCommand(msg, com, thehandle)
%SENDCOMMAND Main serial communication mechanism
% Depending on the communication mode in which I am running the command
% (loopback / serial) SENDCOMMAND either sends the command to the serial
% port and then reports this in the log window or just reports it in the
% log window.
%
%WARNING:
%  For the log window to refresh you have to use guidata after the
%  sendCommand function in the microscope.m main script.

% serial communicatijon
if strcmp(com.mode, 'serial')
    msg_serial = [msg, com.endchar];
    
    % finally write to the serial port
    fprintf(com.fid, msg_serial);
end

% add to the log windows
logCommand(msg, thehandle);