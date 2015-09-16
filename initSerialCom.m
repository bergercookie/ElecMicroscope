function out = initSerialCom(portNum, loghandle)
% INITSERIALCOM Initialize the serial communication with the pump. 
% Return a structure with information to pass around


% find if fid is already initialized
if  any(ismember(fieldnames(com), 'fid')) 
    %todo add try/catch
    fclose(com.fid);
    logCommand('Closed existing fid...', loghandle);
end
    
BaudRate = 9600;
s1 = serial(portNum, 'BaudRate', BaudRate);
fopen(s1);

com.port = portNum;
com.mode = 'serial';
com.endchar = '\n';
com.fid = s1;
com.initialized = 1;

% return com struct
out = com;
end