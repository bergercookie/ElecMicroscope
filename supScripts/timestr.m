function [out] = timestr()
% DATETIMESTR show the current time in a formatted manner [hh:mm]

datetotal = datestr(now);
out = datetotal(end-7:end-3);
end