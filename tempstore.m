function capture = tempstore(img, capture)
% TEMPSTORE stores the specified image to the capture structure
% It fills in the date and updates the current index.
% Finally return the struct capture so that the modified values take effect

% tested, nickkouk.

i = capture.i;

if i <= capture.maxi
    capture.cells(i, :) = deal({img, datetimestr});
    capture.i = i + 1;
else 
    error('tempstore_fun:else', 'index exceeds limit');
end