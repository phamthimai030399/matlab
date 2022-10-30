function varargout = BienSoXeGUI(varargin)
% BIENSOXEGUI MATLAB code for BienSoXeGUI.fig
%      BIENSOXEGUI, by itself, creates a new BIENSOXEGUI or raises the existing
%      singleton*.
%
%      H = BIENSOXEGUI returns the handle to a new BIENSOXEGUI or the handle to
%      the existing singleton*.
%
%      BIENSOXEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIENSOXEGUI.M with the given input arguments.
%
%      BIENSOXEGUI('Property','Value',...) creates a new BIENSOXEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BienSoXeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BienSoXeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BienSoXeGUI

% Last Modified by GUIDE v2.5 04-Dec-2019 18:31:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BienSoXeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BienSoXeGUI_OutputFcn, ...
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
create_templates();
% End initialization code - DO NOT EDIT


% --- Executes just before BienSoXeGUI is made visible.
function BienSoXeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BienSoXeGUI (see VARARGIN)

% Choose default command line output for BienSoXeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BienSoXeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BienSoXeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOpen.
function btnOpen_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
set(handles.uipanel3,'title','Bien So');
[filename path]=uigetfile({'*.jpg';'*.png';'*.JPG';'*.PNG'},'Chon Mot Anh');
img = imread(strcat(path,filename));
set(handles.txtPath,'String',strcat(path,filename));
axes(handles.axes1);
imshow(img);


% --- Executes on button press in btnNhanDang.
function btnNhanDang_Callback(hObject, eventdata, handles)
% hObject    handle to btnNhanDang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = getimage(handles.axes1);
if isempty(img);
    return
end
axes(handles.axes2);
imshow(img);
%tien xu ly
%bien anh ve anh da cap xam
grayimg = rgb2gray(img);
pause(0.5);
imshow(grayimg);
%tang cuong chat luong anh(tang do tuong phan)
grayimg=imadjust(grayimg);
pause(0.5)
imshow(grayimg);
%dua ve anh den trang
bwimg=im2bw(grayimg);
pause(0.5);
imshow(bwimg);
%xoa bot cac vung doi tuong co dien tich nho
bwimg=bwareaopen(bwimg,3500);
pause(0.5);
imshow(bwimg);
%Bat dau xu ly
%tim bien bang toan tu sobel
bwimg=edge(bwimg,'sobel');
pause(0.5);
imshow(bwimg);
%phat hien cac khoi hinh chu nhat
%st=strel('rectangle',[1 2])
st=strel('diamon',2)
bwimg = imdilate(bwimg,st);
pause(0.5);
imshow(bwimg)
bwimg = imfill(bwimg,'holes');
pause(0.5);
imshow(bwimg);
%st=strel('rectangle',[6 12]);
st=strel('diamon',10)
bwimg = imerode(bwimg,st);
pause(0.5);
imshow(bwimg);
improp = regionprops(bwimg,'BoundingBox','Area','Image')
areas = improp.Area
count = numel(improp)
boundingBox=improp.BoundingBox;
maxa=areas
for i = 1:count
    if maxa<improp(i).Area
        maxa=improp(i).Area;
        boundingBox=improp(i).BoundingBox;  
    end
end

%cat anh de lay bien so
plate = imcrop(grayimg,boundingBox);
pause(0.5);
axes(handles.axes3);
imshow(plate)

plate = imresize(plate, [240 NaN]);
plate=im2bw(plate);
[h, w] = size(plate);
%neu la bien o to
if h<(1/2)*w

    plate = imopen(plate, strel('rectangle', [4 4]));


    plate = bwareaopen(~plate, 500);

    [h, w] = size(plate);



    improps=regionprops(plate,'BoundingBox','Area', 'Image');
    count = numel(improps);

    textBienSo=[];

        for i=1:count
            ow = length(improps(i).Image(1,:));
            oh = length(improps(i).Image(:,1));
            if ow<(h/2) & oh>(h/3)
                letter=readLetter(improps(i).Image);
                figure; imshow(improps(i).Image);
                textBienSo=[textBienSo letter];
            end
        end
else%neu la bien xe may
    %cat bien xe may ra thanh hai nua tren duoi
    firstPart = imcrop(plate, [1 1 w h/2]);
    figure
    imshow(firstPart)
    firstPart = imopen(firstPart, strel('rectangle', [4 4]));

%Loai bo cac doi tuong qua nho <1000px
    firstPart = bwareaopen(~firstPart, 1000);
% lay chieu cao va chieu rong
    [h, w] = size(firstPart);


%Cat tung chu so trong bien so
    improps=regionprops(firstPart,'BoundingBox','Area', 'Image');
    count = numel(improps);

    textBienSo=[];

        for i=1:count
            ow = length(improps(i).Image(1,:));
            oh = length(improps(i).Image(:,1));
            if ow<(h/2) & oh>(h/3)%so sanh voi mau co san de phat hien ky tu
                letter=readLetter(improps(i).Image); 
                %figure; imshow(improps(i).Image);
                textBienSo=[textBienSo letter];
            end
        end
    
    %Nua duoi lam tuong tu
    [h w] = size(plate);
    secondPart = imcrop(plate,[1 h/2 w h]);
     figure
    imshow(secondPart)
    secondPart = imopen(secondPart, strel('rectangle', [4 4]));


    secondPart = bwareaopen(~secondPart, 1000);

    [h, w] = size(secondPart);


    improps=regionprops(secondPart,'BoundingBox','Area', 'Image');
    count = numel(improps);
        for i=1:count
            ow = length(improps(i).Image(1,:));
            oh = length(improps(i).Image(:,1));
            if ow<(h/2) & oh>(h/3)
                letter=readLetter(improps(i).Image); 
                %figure; imshow(improps(i).Image);
                textBienSo=[textBienSo letter];
            end
        end
end
set(handles.uipanel3,'title',textBienSo);




function txtPath_Callback(hObject, eventdata, handles)
% hObject    handle to txtPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPath as text
%        str2double(get(hObject,'String')) returns contents of txtPath as a double


% --- Executes during object creation, after setting all properties.
function txtPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
