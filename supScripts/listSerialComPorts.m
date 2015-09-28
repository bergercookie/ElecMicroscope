function thelist = listSerialComPorts()
% LISTSRIALCOMPORTS list of available communication serial ports to choose
% from. The list is returned in a cell array.


thesys = computer;

if strcmp(thesys(1:4), 'MACI')
    [status, ser_ports] = unix('ls /dev/tty.*');
    ser_ports = ser_ports(find(~isspace(ser_ports)));
    ser_ports = strrep(ser_ports, '/dev/', ' /dev/');
    ser_ports = ser_ports(2:end);
    ser_ports = strsplit(ser_ports, ' ');
elseif strfind(thesys, 'WIN')
    ser_ports = getAvailableComPorts();
%     ser_ports = findserial_win();
%     ser_ports = ser_ports';
else
    error('listSerialComPorts:else', 'Function notimplemented in the specified operating system');
end

% if ~length(ser_ports) == 1 || ~isempty(ser_ports{1})
ser_ports(end+1)  = {'loopback://'};
% else
%     ser_ports = {'loopback://'};
% end

thelist = ser_ports;