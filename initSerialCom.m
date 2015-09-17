function out = initSerialCom(portNum, loghandle)
% INITSERIALCOM Initialize the serial communication with Arduino. 
% Return a structure with information to pass around
 
BaudRate = 9600;
timeouttime = 0.1;
s1 = serial(portNum, 'BaudRate', BaudRate, 'Timeout',timeouttime);
% s1 = serial(portNum, 'BaudRate', BaudRate);
fopen(s1);

com.port = portNum;
com.mode = 'serial';
com.endchar = '\n';
com.fid = s1;
com.initialized = 1;

% return com struct
out = com;
end