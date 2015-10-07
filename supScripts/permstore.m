function permstore(capture)
% PERMSTORE Store the images in the capture structure permanently
% todo, fix it for windows systems / --> \

iend = capture.i - 1; % always store + 1
theformat = capture.format;
sep = capture.sep;

% fprintf(1, 'In permstore: sep = %s\n', sep);


for i=1:iend
    fname = capture.cells{i, 2};
    path = capture.path;
    fname = [path, sep, fname, theformat];
    fname(3:end) = strrep(fname(3:end), ':', '_');
    img =capture.cells{i, 1};
    
    try
%         fprintf(1, 'Name = %s\n', fname);
        imwrite(img, fname);
    catch MExc
        fprintf(1, ['permstore.m> Could not save an image correctly\n\t', ...
            MExc.identifier, '\n']);
    end
        
end