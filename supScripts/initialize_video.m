function out = initialize_video(camera_handle, cameraId)
% INITIALIZE_VIDEO Initialize video on the camera axes



% initialize according to platform and camera ID..
if strfind(computer, 'WIN')
    platform = 'winvideo';
else
    platform = 'macvideo';
end
vid = videoinput(platform ,cameraId);

hImage=image(zeros(699,1500,1),'Parent',camera_handle);
set(vid, 'ReturnedColorSpace', 'RGB');
preview(vid,hImage); % no RGB image in this case


% pack into array
camera.hImage = hImage;
camera.vid = vid; % pass vid for screenshot capture
camera.on = 1; % camera currently on
camera.Id = cameraId;
camera.platform = platform;

out = camera;