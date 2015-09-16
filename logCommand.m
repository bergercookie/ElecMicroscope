function logCommand(msg, thehandle, ad)

% Add the command to the log Window. 
% ad arguement provides additional information to the user in case
% something went wrong - possible options are 'WARNING', 'ERROR'.
% 
% WARNING
%   For the update to take effect you have to use the guidata command in
%   the main script "microscope.m" after the sendCommand 
% (or the logCommand respectively) is run

if nargin == 2
    % format the message
    msg = ['>', timestr(), ' - ', msg];
elseif nargin == 3
    if strcmp(ad, 'warning')
        msg  = ['[WARNING]', '>', timestr(), ' - ', msg];
    elseif strcmp(ad, 'error')
        msg  = ['[ERROR]', '>', timestr(), ' - ', msg];
    end
end


% update the message list
oldmsgs = cellstr(get(thehandle,'String'));
set(thehandle,'String',[oldmsgs;{msg}] );