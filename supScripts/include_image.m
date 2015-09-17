% Script with suppementary functions

function [] = include_image(thehandle, img_path)
% INCLUDE_IMAGE Include image to the specified figure.
% Figure is specified by its handle - thehandle
% Image is specified using its relative path

axes(thehandle)
matlabImage = imread(img_path);
imshow(matlabImage)
axis off
axis image
end
