function [out] = datetimestr()
% DATETIMESTR show the current date and time in a formatted manner
c = clock;
out = datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6)));

end