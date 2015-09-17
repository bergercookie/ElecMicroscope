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

% Last Modified by GUIDE v2.5 17-Sep-2015 15:43:25

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
%include the subScripts and figures folders
if ~folderInPath('./figures')
    addpath('./figures');
end
if ~folderInPath('./supScripts')
    addpath('./supScripts');
end

% Clear the 'read/write to serial' boxes
set(handles.read_edit, 'String', '');
set(handles.write_edit, 'String', '');

%--- Communication Properties
com.mode = 'loopback'; % 'loopback' / 'serial'
com.initialized = 0; %not initialized yet..
handles.com = com;

%--- Logo
% set(hObject, 'Color', [1 1 1]) % set the background color of the GUI
include_image(handles.axes1, 'images/logo/logo_ntua3.jpg');

%--- Camera Panel

%----- Initialization of capture struct
% 3 fields: maxi, cells, i
% cells -  2 subfields: img, datetime
handles.capture = init_capturestruct('.tiff', '.');

%----- Initialize video with default camera
handles.camera.Id = 1;
handles.camera = initialize_video(handles.camera_axes, ...
    handles.camera.Id );
handles.camera.Name = 'FaceTime HD Camera (Built-in)';

%----- plot XY platform
% default values in the beginning for number of holes
% initialization of holes struct
handles.holes.xNum = 12;
handles.holes.yNum = 8;
makePlatform(handles.xyplat_axes, handles.holes);


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
function license_menu_Callback(hObject, eventdata, handles)
% hObject    handle to license_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clausebsd();

% --------------------------------------------------------------------
function credits_menu_Callback(hObject, eventdata, handles)
% hObject    handle to credits_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
credits();

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

if ~isempty(selection)
    port = str{selection};
    try
        if ok % if selection is indeed made..
            if strcmp(port, 'loopback://')
                handles.com.mode = 'loopback';
            else
                fprintf(1, 'kalimera\n');
                handles.com = initSerialCom(port, handles.logwindow);
                % log message
                msg = sprintf('Changed Arduino port to %s', port);
                logCommand(msg, handles.logwindow);
            end
        end
            
    catch MExc
        % log message
        msg = sprintf('Could not change Arduino port\n%s', MExc.identifier);
        logCommand(msg, handles.logwindow, 'error');
        
        % unblocking the port by deleting the instrfindall struct
        msg = sprintf('Trying to unblock specific port..');
        logCommand(msg, handles.logwindow);
        delete(instrfindall);
        try
            handles.com = initSerialCom(port, handles.logwindow);
            
            % log message
            msg = sprintf('Changed Arduino port to %s', handles.com.port);
            logCommand(msg, handles.logwindow);
        catch MExc
            % log message
            msg = sprintf('Unblocking failed.\n%s', MExc.identifier);
            logCommand(msg, handles.logwindow, 'error');
        end
    end
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

% log message
msg = sprintf('Image successfuly taken');
logCommand(msg, handles.logwindow);


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
    
    % log message
    msg = sprintf('Camera turned off.');
    logCommand(msg, handles.logwindow);

else
    handles.camera = initialize_video(handles.camera_axes, handles.camera.Id);
    
    % log message
    msg = sprintf('Camera turned on.');
    logCommand(msg, handles.logwindow);
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in saveall_btn.
function saveall_btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveall_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

permstore(handles.capture);
numimagessaved = handles.capture.i - 1;

if numimagessaved == 0
    % log message
    msg = sprintf('Images buffer empty');
    logCommand(msg, handles.logwindow);
elseif numimagessaved == 1
    % log message
    msg = sprintf('%d Image was saved,\n\tPath=%s', ...
        numimagessaved, ...
        handles.capture.path);
    logCommand(msg, handles.logwindow);
    % clear buffer too - call clearall function
    clearall_btn_Callback(hObject, eventdata, handles);
else
    % log message
    msg = sprintf('%d Images were saved,\n\tPath=%s', ...
        numimagessaved, ...
        handles.capture.path);
    logCommand(msg, handles.logwindow);
    % clear buffer too - call clearall function
    clearall_btn_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in clearall_btn.
function clearall_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clearall_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clean buffer of images until now
handles.capture = init_capturestruct();
% log message
msg = sprintf('Cleared temp. buffer of images');
logCommand(msg, handles.logwindow);

% Update handles structure
guidata(hObject, handles);

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

% log message
msg = sprintf('Changed image format to %s', handles.capture.format);
logCommand(msg, handles.logwindow);

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

% log message
msg = sprintf('Changed image format to %s', handles.capture.format);
logCommand(msg, handles.logwindow);

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

% log message
msg = sprintf('Changed image format to %s', handles.capture.format);
logCommand(msg, handles.logwindow);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function selectcam_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to selectcam_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[devNames, devIds] = listAvailCameras();
[selection, ok] = listdlg('PromptString','Select camera:',...
    'SelectionMode','single',...
    'Name', 'Camera Selection', ...
    'ListSize', [300 200], ...
    'ListString',devNames);


% only change camera input if a choice has been made (user hasn't pressed
% cancel) or the choice is different from the previous one.
if ~isempty(selection)
    
    name = devNames{selection};
    Id = devIds{selection};
    if  Id ~= handles.camera.Id
        %initialize video using the given Device ID
        handles.camera = initialize_video(handles.camera_axes, ...
            Id);
        handles.camera.Name = name;
        
        % log message
        msg = sprintf('Camera input Changed:\n%s', name);
        logCommand(msg, handles.logwindow);
    else
        % log message
        msg = sprintf('Camera input remained unchainged (%s)', ...
            handles.camera.Name);
        logCommand(msg, handles.logwindow);
    end
else
    % log message
    msg = sprintf('Camera input remained unchainged (%s)', ...
        handles.camera.Name);
    logCommand(msg, handles.logwindow);
end

% Update handles structure
guidata(hObject, handles);

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


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in platform_popup.
function platform_popup_Callback(hObject, eventdata, handles)
% hObject    handle to platform_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns platform_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from platform_popup

contents = cellstr(get(hObject,'String'));
selected = contents{get(hObject,'Value')}

%----- String parsing using REGEXP
% parse the contents cell string
pattern = '\d*x\d*';
stringFound = regexp(selected, pattern, 'match')';
stringFound = stringFound{1} % initially returned as cell
Xpos = strfind(stringFound, 'x') % position of x in string

% get xNum, yNum
handles.holes.xNum = str2num(stringFound(1:Xpos-1));
handles.holes.yNum = str2num(stringFound(Xpos+1:end));

makePlatform(handles.xyplat_axes, handles.holes);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function platform_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to platform_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in lamp_panel.
function lamp_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in lamp_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

onValue = get(handles.lampon_btn, 'Value');
offValue = get(handles.lampoff_btn, 'Value'); % just to be complete.

try
    if onValue
        sendCommand('lampon', handles.com, handles.logwindow);
    else
        sendCommand('lampoff', handles.com, handles.logwindow);
    end
catch MExc
    switch MExc.identifier
        case 'MATLAB:nonExistentField'
            warndlg({'Arduino port has not been set yet.', ...
                'Command not sent'});
        otherwise
            rethrow(MExc)
    end
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lampon_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lampon_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over lampon_btn.
function lampon_btn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to lampon_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in filterset_panel.
function filterset_panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in filterset_panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


pos1 = get(handles.pos1_btn, 'Value');
pos2 = get(handles.pos2_btn, 'Value');
pos3 = get(handles.pos3_btn, 'Value');
pos4 = get(handles.pos4_btn, 'Value');

if pos1
    sendCommand('position1', handles.com, handles.logwindow);
elseif pos2
    sendCommand('position2', handles.com, handles.logwindow);
elseif pos3
    sendCommand('position3', handles.com, handles.logwindow);
elseif pos4
    sendCommand('position4', handles.com, handles.logwindow);
else
    error('filterset_panel:decidingPos', 'One of the Position Radiobuttoms must be switched on')
end


% --- Executes on button press in serialwrite_btn.
function serialwrite_btn_Callback(hObject, eventdata, handles)
% hObject    handle to serialwrite_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try 
com2send = get(handles.write_edit, 'String');
fprintf(handles.com.fid, com2send); % send the command in raw form
logCommand(com2send, handles.logwindow, 'raw');

catch MExc
    switch MExc.identifier
        case 'MATLAB:nonExistentField'
            warndlg({'Arduino port has not been set yet.', ...
                'Command not sent'});
        otherwise
            rethrow(MExc)
    end
end

function read_edit_Callback(hObject, eventdata, handles)
% hObject    handle to read_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of read_edit as text
%        str2double(get(hObject,'String')) returns contents of read_edit as a double


% --- Executes during object creation, after setting all properties.
function read_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to read_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function write_edit_Callback(hObject, eventdata, handles)
% hObject    handle to write_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of write_edit as text
%        str2double(get(hObject,'String')) returns contents of write_edit as a double


% --- Executes during object creation, after setting all properties.
function write_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to write_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in serialread_btn.
function serialread_btn_Callback(hObject, eventdata, handles)
% hObject    handle to serialread_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bytesize = 100;
prevTimeout = handles.com.fid.Timeout;
timeouttime = 0.05;
handles.com.fid.Timeout = timeouttime;
[resultRead, numRead] = fread(handles.com.fid, bytesize);
handles.com.fid.Timeout = prevTimeout;


resultRead = arrayfun(@char, resultRead);
resultRead = resultRead'; % take the transpose

% strip of linefeeds
indx = find(resultRead==char(13) | resultRead==char(10));
resultRead(indx) = [];

% turn the numbers received into ascii corresponding characters
if ~isempty(resultRead)
%     % print it in the read_edit area
%     oldRead = get(handles.read_edit, 'String');
%     set(handles.read_edit, 'String', [oldRead, resultRead]);
     set(handles.read_edit, 'String', resultRead);
end


% --------------------------------------------------------------------
function various_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to various_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function clcread_smenu_Callback(hObject, eventdata, handles)
% hObject    handle to clcread_smenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clears the Serial read text edit area
set(handles.read_edit, 'String', '');


% --- Executes on key press with focus on pushbutton9 and none of its controls.
function pushbutton9_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in down_btn.
function down_btn_Callback(hObject, eventdata, handles)
% hObject    handle to down_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in right_btn.
function right_btn_Callback(hObject, eventdata, handles)
% hObject    handle to right_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in up_btn.
function up_btn_Callback(hObject, eventdata, handles)
% hObject    handle to up_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in left_btn.
function left_btn_Callback(hObject, eventdata, handles)
% hObject    handle to left_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
