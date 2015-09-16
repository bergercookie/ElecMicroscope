function varargout = microscope(varargin)
% MICROSCOPE MATLAB code for microscope.fig
%      MICROSCOPE, by itself, creates a new MICROSCOPE or raises the existing
%      singleton*.
%
%      H = MICROSCOPE returns the handle to a new MICROSCOPE or the handle to
%      the existing singleton*.
%
%      MICROSCOPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICROSCOPE.M with the given input arguments.
%
%      MICROSCOPE('Property','Value',...) creates a new MICROSCOPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before microscope_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to microscope_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help microscope

% Last Modified by GUIDE v2.5 16-Sep-2015 17:14:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @microscope_OpeningFcn, ...
                   'gui_OutputFcn',  @microscope_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before microscope is made visible.
function microscope_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to microscope (see VARARGIN)

%--- General Initialization

% Choose default command line output for microscope
handles.output = hObject;

% UIWAIT makes microscope wait for user response (see UIRESUME)
% uiwait(handles.figure1);



%--- General Initialization
clc;

%--- Communication Properties
com.mode = 'loopback'; % 'loopback' / 'serial'
com.initialized = 0; %not initialized yet..

%--- Logo
% set(hObject, 'Color', [1 1 1]) % set the background color of the GUI
include_image(handles.axes1, 'images/logo/logo_ntua3.jpg');

%--- Camera Panel

%----- Initialization of capture struct
% 3 fields: maxi, cells, i
% cells -  2 subfields: img, datetime
handles.capture = init_capturestruct('.tiff', '.');

%----- Initialize video

handles.camera = initialize_video(handles.camera_axes);


% log message
% clear it at first 
set(handles.logwindow, 'String', '');
msg = 'User Interface started successfully';
logCommand(msg, handles.logwindow);

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = microscope_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in camera_btn.
function camera_btn_Callback(hObject, eventdata, handles)
% hObject    handle to camera_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of camera_btn


% --- Executes on button press in lampoff_btn.
function lampoff_btn_Callback(hObject, eventdata, handles)
% hObject    handle to lampoff_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function view_menu_Callback(hObject, eventdata, handles)
% hObject    handle to view_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function conf_menu_Callback(hObject, eventdata, handles)
% hObject    handle to conf_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function credits_menu_Callback(hObject, eventdata, handles)
% hObject    handle to credits_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function port_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to port_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = listSerialComPorts();
[selection, ok] = listdlg('PromptString','Select the port on which the Arduino is on:',...
    'SelectionMode','single',...
    'Name', 'Arduino Port Selection', ...
    'ListSize', [300 400], ...
    'ListString',str);

port = str{selection};

try 
    if ok % if selection is indeed made..
        handles.com.port = port;
        initSerialCom(handles.com.port, handles.logwindow);
    end
    
    % log message
    msg = sprintf('Changed Arduino port to %s', handles.com.port);
    logCommand(msg, handles.logwindow);
    
catch MExc
    % log message
    msg = sprintf('Could not change Arduino port\n%s', MExc.identifier);
    logCommand(msg, handles.logwindow, 'error');
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function init_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to init_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function status_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to status_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function xy_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to xy_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function camerapath_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to camerapath_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curpath = handles.capture.path;
if strcmp(curpath, '.')
    curpath = pwd;
end

foldname = uigetdir('.', sprintf(['Select Storage dir for images,\t', ...
'Current: %s'], curpath));
handles.capture.path = foldname;

% log message
msg = sprintf('Changed path to %s', handles.capture.path);
logCommand(msg, handles.logwindow);

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function log_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to log_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_13_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in quickactions_pmenu.
function quickactions_pmenu_Callback(hObject, eventdata, handles)
% hObject    handle to quickactions_pmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns quickactions_pmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from quickactions_pmenu


% --- Executes during object creation, after setting all properties.
function quickactions_pmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to quickactions_pmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes on button press in doit_btn.
function doit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to doit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function camera_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to camera_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate camera_axes


% --- Executes on button press in shoot_btn.
function shoot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to shoot_btn (see GCBO)
% eventdata  reserved - to be defined in a future versiqon of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img = getsnapshot(handles.camera.vid);
% figure(); imshow(img);

% store the images in a struct for later manipulation
handles.capture = tempstore(img, handles.capture);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in turnonoff_btn.
function turnonoff_btn_Callback(hObject, eventdata, handles)
% hObject    handle to turnonoff_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.camera.on == 1
    closepreview(handles.camera.vid);
    include_image(handles.camera_axes, 'images/various/grey.png');
    handles.camera.on = 0;
else
    handles.camera = initialize_video(handles.camera_axes);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in saveall_btn.
function saveall_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveall_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

permstore(handles.capture);

% --- Executes on button press in clearall_btn.
function clearall_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clearall_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.capture = init_capturestruct();


% --------------------------------------------------------------------
function camera_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to camera_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function format_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to format_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function jpeg_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to jpeg_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.capture.format = '.jpeg';
set(handles.png_smenu, 'Checked', 'off');
set(handles.tiff_smenu, 'Checked', 'off');
set(handles.jpeg_smenu, 'Checked', 'on');

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function png_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to png_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.capture.format = '.png';
set(handles.png_smenu, 'Checked', 'on');
set(handles.tiff_smenu, 'Checked', 'off');
set(handles.jpeg_smenu, 'Checked', 'off');

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function tiff_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to tiff_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.capture.format = '.tiff';
set(handles.png_smenu, 'Checked', 'off');
set(handles.tiff_smenu, 'Checked', 'on');
set(handles.jpeg_smenu, 'Checked', 'off');

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function selectcam_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to selectcam_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%TODO - implement this
% str = {webcamlist};
% [selection, ok] = listdlg('PromptString','Select the camera to use:',...
%     'SelectionMode','single',...
%     'Name', 'Camera Selection', ...
%     'ListString',str)
% 
% if ok % if selection is indeed made..
%     
% end



function logwindow_Callback(hObject, eventdata, handles)
% hObject    handle to logwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of logwindow as text
%        str2double(get(hObject,'String')) returns contents of logwindow as a double


% --- Executes during object creation, after setting all properties.
function logwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% close all open fids
closestatus = fclose('all');

if closestatus == 0
    logCommand(sprintf('fds closed successfully'), handles.logwindow);
else
    logCommand('fd was not closed successfully!', handles.logwindow, 'warning');
end
logCommand('Quitting...', handles.logwindow);
% let the user see the quit actions
pause(1);

% Hint: delete(hObject) closes the figure
delete(hObject);
