function out = initialize_video(camera_axes, camera)
% INITIALIZE_VIDEO Initialize video on the camera axes

<<<<<<< HEAD


% initialize according to platform and camera ID..
if strfind(computer, 'WIN')
    platform = 'winvideo';
else
    platform = 'macvideo';
end
vid = videoinput(platform ,cameraId);

hImage=image(zeros(699,1500,1),'Parent',camera_handle);
=======
% make it OS-dependent

vid = videoinput(camera.adaptor,camera.Id);
hImage=image(zeros(699,1500,1),'Parent',camera_axes);
>>>>>>> windows_gui_testing
set(vid, 'ReturnedColorSpace', 'RGB');
preview(vid,hImage); % no RGB image in this case


% pack into array
camera.hImage = hImage;
camera.vid = vid; % pass vid for screenshot capture
camera.on = 1; % camera currently on
<<<<<<< HEAD
camera.Id = cameraId;
camera.platform = platform;
=======
% camera.Id, camera.adaptor are already specified and passed inside.
>>>>>>> windows_gui_testing

out = camera;