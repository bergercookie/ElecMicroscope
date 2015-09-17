function plot2handle(xnum, ynum, plot_handle)
%PLOT2HANDLE plot the centers of the holes in the specified
% (plot_hande) axes

% get the center from the subroutine below.
[xs, ys] = initMeshStruct(xnum, ynum);



plot(plot_handle, xs, ys, 'ro', 'MarkerSize', 20);
hold(plot_handle, 'on');
plot(plot_handle, xs, ys, 'r*', 'MarkerSize', 5);

% hold on;
% for x = xs
%     for y = ys
%         circle(x, y, 0.1);
%         hold on;
%     end
% end
% set(theplot, 'Parent', plot_handle);

function [X,Y] = initMeshStruct(xnum,ynum)
%INITMESHSTRUCT Create a 2D mesh based on the number of holes on the X, Y
% axes.
% Return the coordinates of the centers of the holes in the X,Y arrays

% get the coordinates of the holes in the X, Y directions.
xspots = linspace(0,1,xnum);
yspots = linspace(0,1,ynum);

[X,Y] = meshgrid(xspots, yspots);
