function thelist = listSerialComPorts()
% LISTSRIALCOMPORTS list of available communication serial ports to choose
% from. The list is returned in a cell array.
% The function is os-dependent, currently implemented only in OSX systems


thesys = computer;

if strcmp(thesys(1:4), 'MACI')
    [status, ser_ports] = unix('ls /dev/tty.*');
    ser_ports = ser_ports(find(~isspace(ser_ports)));
    ser_ports = strrep(ser_ports, '/dev/', ' /dev/');
    ser_ports = ser_ports(2:end);
    ser_ports = strsplit(ser_ports, ' ');
    
else
    ser_ports = getAvailableComPorts();
%     error('listSerialComPorts:else', 'Function notimplemented in the specified operating system');
end

ser_ports(end+1)  = {'loopback://'};
thelist = ser_ports;