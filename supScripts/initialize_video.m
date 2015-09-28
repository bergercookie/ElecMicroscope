function out = initialize_video(camera_axes, camera)
% INITIALIZE_VIDEO Initialize video on the camera axes

% make it OS-dependent

vid = videoinput(camera.adaptor,camera.Id);
hImage=image(zeros(699,1500,1),'Parent',camera_axes);
set(vid, 'ReturnedColorSpace', 'RGB');
preview(vid,hImage); % no RGB image in this case

camera.hImage = hImage;
camera.vid = vid; % pass vid for screenshot capture
camera.on = 1; % camera currently on
% camera.Id, camera.adaptor are already specified and passed inside.

out = camera;