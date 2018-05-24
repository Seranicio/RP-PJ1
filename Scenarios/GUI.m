function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 22-May-2018 16:53:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global SceneryARunDefault; 
SceneryARunDefault = 1;
global SceneryBRunDefault; 
SceneryBRunDefault = 1;
global SceneryCRunDefault; 
SceneryCRunDefault = 1;

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SceneryARun.
function SceneryARun_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryARun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TypeHog;
TypeHog = get(handles.SceneryAHOGTYPE,'Value');
global SceneryARunDefault;
global ScenaryAHOG_File;
global ScenaryAHOG_location;
close;
run('A\Main.m');
disp('--------------------------------------');
disp('A File was Created for faster runs. File Name: HOG_DATA.mat');
disp('If u done testing this scenary delete the file, Its in Corresponding folder of the scenary');

% --- Executes on button press in ScenaryAHOG.
function ScenaryAHOG_Callback(hObject, eventdata, handles)
% hObject    handle to ScenaryAHOG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScenaryAHOG
disp('Scenary A only says if its a sign stop or not');
global ScenaryAHOG_File;
global ScenaryAHOG_location;
[ScenaryAHOG_File,ScenaryAHOG_location] = uigetfile('.txt');
set(handles.SceneryADefault,'Value',0);
global SceneryARunDefault;
% global isStop;
% isStop = get(handles.isStop,'Value');
SceneryARunDefault = 0;

% --- Executes on button press in SceneryADefault.
function SceneryADefault_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryADefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SceneryADefault
set(handles.ScenaryAHOG,'Value',0);
TypeHog = get(handles.SceneryAHOGTYPE,'Value');
global SceneryARunDefault;
SceneryARunDefault = 1;

% --- Executes on selection change in SceneryAHOGTYPE.
function SceneryAHOGTYPE_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryAHOGTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SceneryAHOGTYPE contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SceneryAHOGTYPE


% --- Executes during object creation, after setting all properties.
function SceneryAHOGTYPE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SceneryAHOGTYPE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in isStop.
function isStop_Callback(hObject, eventdata, handles)
% hObject    handle to isStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of isStop


% --- Executes on button press in SceneryBKNNRun.
function SceneryBKNNRun_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryBKNNRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ScenaryBHOG_File;
global ScenaryBHOG_location;
global ScenaryBHue_File;
global ScenaryBHue_location;
global ScenaryBHaar_File;
global ScenaryBHaar_location;
global SceneryBRunDefault;
global HOGType;
global Analysis;
Analysis = get(handles.SceneryBAnalysis,'Value');
close;
run('B\ScenaryBKNN.m');
disp('--------------------------------------');
disp('A File was Created for faster runs. File Name: OrganizeFeatures.mat');
disp('If u done testing this scenary delete the file, Its in Corresponding folder of the scenary');

% --- Executes on button press in ScenaryBBinaryRun.
function ScenaryBBinaryRun_Callback(hObject,eventdata,handles)
% hObject    handle to ScenaryBBinaryRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ScenaryBHOG_File;
global ScenaryBHOG_location;
global ScenaryBHue_File;
global ScenaryBHue_location;
global ScenaryBHaar_File;
global ScenaryBHaar_location;
global SceneryBRunDefault;
global HOGType;
global Analysis;
Analysis = get(handles.SceneryBAnalysis,'Value');
global Layout;
Layout = get(handles.SceneryBLayout,'Value');
close;
run('B\ScenaryBTree.m');
disp('--------------------------------------');
disp('A File was Created for faster runs. File Name: OrganizeFeatures.mat');
disp('If u done testing this scenary delete the file, Its in Corresponding folder of the scenary');

% --- Executes on selection change in SceneryBAnalysis.
function SceneryBAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryBAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SceneryBAnalysis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SceneryBAnalysis


% --- Executes during object creation, after setting all properties.
function SceneryBAnalysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SceneryBAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ScenaryBDefault.
function ScenaryBDefault_Callback(hObject, eventdata, handles)
% hObject    handle to ScenaryBDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScenaryBDefault
global SceneryBRunDefault;
SceneryBRunDefault = 1;
set(handles.SceneryBSingle,'Value',0);

% --- Executes on button press in SceneryBSingle.
function SceneryBSingle_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryBSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SceneryBSingle
set(handles.ScenaryBDefault,'Value',0);
global ScenaryBHOG_File;
global ScenaryBHOG_location;
global ScenaryBHue_File;
global ScenaryBHue_location;
global ScenaryBHaar_File;
global ScenaryBHaar_location;
global HOGType;
disp('Choose HOG File...')
[ScenaryBHOG_File,ScenaryBHOG_location] = uigetfile('.txt');
disp('This Corresponds to?');
HOGType = input('1 - HOG01 | 2 - HOG02 | 3 - HOG03\nChoose: ');
disp('Choose Hue File...');
[ScenaryBHue_File,ScenaryBHue_location] = uigetfile('.txt');
disp('Choose Haar File...');
[ScenaryBHaar_File,ScenaryBHaar_location] = uigetfile('.txt');
global SceneryBRunDefault;
SceneryBRunDefault = 0;


% --- Executes on button press in SceneryCSingle.
function SceneryCSingle_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryCSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SceneryCSingle
set(handles.SceneryCDefault,'Value',0);
global ScenaryCHOG_File;
global ScenaryCHOG_location;
global ScenaryCHue_File;
global ScenaryCHue_location;
global ScenaryCHaar_File;
global ScenaryCHaar_location;
global HOGType;
disp('Choose HOG File...')
[ScenaryCHOG_File,ScenaryCHOG_location] = uigetfile('.txt');
disp('This Corresponds to?');
HOGType = input('1 - HOG01 | 2 - HOG02 | 3 - HOG03\nChoose: ');
disp('Choose Hue File...');
[ScenaryCHue_File,ScenaryCHue_location] = uigetfile('.txt');
disp('Choose Haar File...');
[ScenaryCHaar_File,ScenaryCHaar_location] = uigetfile('.txt');
global SceneryCRunDefault;
SceneryCRunDefault = 0;

% --- Executes on button press in SceneryCDefault.
function SceneryCDefault_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryCDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SceneryCDefault
global SceneryCRunDefault;
SceneryCRunDefault = 1;
set(handles.SceneryCSingle,'Value',0);

% --- Executes on button press in SceneryCKNNRun.
function SceneryCKNNRun_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryCKNNRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ScenaryCHOG_File;
global ScenaryCHOG_location;
global ScenaryCHue_File;
global ScenaryCHue_location;
global ScenaryCHaar_File;
global ScenaryCHaar_location;
global SceneryCRunDefault;
global HOGType;
global Analysis;
Analysis = get(handles.SceneryCAnalysis,'Value');
close;
run('C\ScenaryCKNN.m');
disp('--------------------------------------');
disp('A File was Created for faster runs. File Name: OrganizeFeatures.mat');
disp('If u done testing this scenary delete the file, Its in Corresponding folder of the scenary');

% --- Executes on button press in SceneryCSVMRun.
function SceneryCSVMRun_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryCSVMRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ScenaryCHOG_File;
global ScenaryCHOG_location;
global ScenaryCHue_File;
global ScenaryCHue_location;
global ScenaryCHaar_File;
global ScenaryCHaar_location;
global SceneryCRunDefault;
global HOGType;
close;
run('C\SVM.m');

% --- Executes on selection change in SceneryBLayout.
function SceneryBLayout_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryBLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SceneryBLayout contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SceneryBLayout


% --- Executes during object creation, after setting all properties.
function SceneryBLayout_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SceneryBLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SceneryCAnalysis.
function SceneryCAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryCAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SceneryCAnalysis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SceneryCAnalysis


% --- Executes during object creation, after setting all properties.
function SceneryCAnalysis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SceneryCAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SceneryBBayRun.
function SceneryBBayRun_Callback(hObject, eventdata, handles)
% hObject    handle to SceneryBBayRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ScenaryCHOG_File;
global ScenaryCHOG_location;
global ScenaryCHue_File;
global ScenaryCHue_location;
global ScenaryCHaar_File;
global ScenaryCHaar_location;
global SceneryCRunDefault;
global HOGType;
global Analysis;
Analysis = get(handles.SceneryCAnalysis,'Value');
close;
run('C\SceneryCBayes.m');
