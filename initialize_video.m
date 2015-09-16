function out = initialize_video(camera_handle)
% INITIALIZE_VIDEO Initialize video on the camera axes

vid = videoinput('macvideo',1);
hImage=image(zeros(699,1500,1),'Parent',camera_handle);
set(vid, 'ReturnedColorSpace', 'RGB');
preview(vid,hImage); % no RGB image in this case

camera.hImage = hImage;
camera.vid = vid; % pass vid for screenshot capture
camera.on = 1; % camera currently on

out = camera;