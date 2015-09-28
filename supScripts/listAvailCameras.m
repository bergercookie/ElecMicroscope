function [devNames, devIds] = listAvailCameras(camera_handle)
%LISTAVAILCAMERAS create a list of the cameras supported by the Image
% Processing Toolbox. The characteristics we are interested in are
% 'DeviceID', and 'DeviceName'. 
% 
%Warning:
%  - Command is OS-dependent currently supporting only mac computers
%  - For the camera to be available the user has to restart MATLAB.

% get  available imaq devices
adaptors = imaqhwinfo(camera_handle.adaptor);
devices = adaptors.DeviceInfo;

devIds = {devices.DeviceID};
devNames = {devices.DeviceName};

end