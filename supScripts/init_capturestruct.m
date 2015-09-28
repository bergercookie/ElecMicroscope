function out = init_capturestruct(theformat, thepath)
% INIT_CAPTURESTRUCT Initialize the capture struct to temporarily store
% images
% 5 fields: maxi, cells, i, path, format
% cells -  2 subfields: img, datetime

if nargin == 0;
    theformat = '.tiff';
    thepath = '.';
elseif nargin == 1
    thepath = '.';
% elseif nargin > 3
%     error('init_capturestruct:elseif', 'Number of arguements exceeds the limit set');
end

% OS-Identification to set the path seperator correctly
if strfind(computer, 'MAC')
    sep = '/';
elseif strfind(computer, 'WIN')
    sep = '\';
else
    error('init_capturestruct:else',  'Unkwown OS, please check arguement');
end

a_cell12 = cell(1,2);
capture.maxi = 100; % until 100 images
capture.cells = repmat(a_cell12, capture.maxi, 1);
capture.i = 1;
capture.path = thepath;
capture.format = theformat;
capture.sep = sep;

out = capture;
end