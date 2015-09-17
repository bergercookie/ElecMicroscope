function out = folderInPath(foldername)
%FOLDERINPATH Check if folder with name 'foldername' is in the current
% path.
% Return 1 if true, otherwise 0

pathCell = regexp(path, pathsep, 'split');

if ispc  % Windows is not case-sensitive
    onPath = any(strcmpi(foldername, pathCell));
else
    onPath = any(strcmp(foldername, pathCell));
end

out = onPath;