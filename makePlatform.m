function makePlatform(platform_handle, holes)
%MAKEPLATFORM Draws the holes in the GUI Platform, by first resetting the
%axis, plotting and finally setting the axis correctly again.

xNum = holes.xNum;
yNum = holes.yNum;

cla(platform_handle, 'reset'); % first clear the axes
plot2handle(xNum, yNum, platform_handle);
axis(platform_handle, [-0.2, 1.2, -0.2, 1.2]);