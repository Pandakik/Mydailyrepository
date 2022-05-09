function varargout = fin222(varargin)
% FIN222 MATLAB code for fin222.fig
%      FIN222, by itself, creates a new FIN222 or raises the existing
%      singleton*.
%
%      H = FIN222 returns the handle to a new FIN222 or the handle to
%      the existing singleton*.
%
%      FIN222('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIN222.M with the given input arguments.
%
%      FIN222('Property','Value',...) creates a new FIN222 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fin222_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fin222_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fin222

% Last Modified by GUIDE v2.5 16-Sep-2021 15:21:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fin222_OpeningFcn, ...
                   'gui_OutputFcn',  @fin222_OutputFcn, ...
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


% --- Executes just before fin222 is made visible.
function fin222_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fin222 (see VARARGIN)

% Choose default command line output for fin222
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fin222 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fin222_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% [filename file_path] =uigetfile({'*.jpg';'*.bmp';'*.*'},'打开图片');
file_path = uigetdir('*.*','请选择文件夹');%fliepath为文件夹路径</span>
  file_path =        strcat(file_path,'\');
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量
 
mx_num = zeros(20,img_num);
%a = get(handles.edit1, 'String');
%str =['图片张数为',img_num];

if img_num == 0
    strrrr = 'errooooo 没有图片！'
    set(handles.edit4, 'string', strrrr);
        set(handles.edit5, 'string', strrrr);
else
    set(handles.edit4, 'string', img_num);
    strr = '.jpg';
    set(handles.edit5, 'string', strr);
end



mx_data = zeros(5,img_num);
if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));
            %fprintf('%d %d %s\n',i,j,strcat(file_path,image_name));% 显示正在处理的图像名
            set(handles.edit1, 'string', image_name);
            axes(handles.axes1);  
            imshow(image);
            %%在axes1中显示 图像  
 
            
            %图片处理
            
            fig_ = image;


            img_adjust = imadjust(fig_,[0.65;0.7],[0,1]);
            %h = fspecial('motion',4.4);
            h=fspecial('gaussian',200);%?高斯滤波
            img_im= imfilter(img_adjust,h);
            IM2 = im2bw(img_im);      
             B=[0 1 0
               1 1 1
              0 1 0];
            %             SE = strel('line',20,90);
            IM2=imdilate(IM2,B);
            IM2 = imerode(IM2,B);
            IM2 = imerode(IM2,B);
            IM2 = imfilter(IM2 ,h);
            IM2 = imfilter(IM2 ,h);
            IM2 = imerode(IM2,B);
              IM2 = imfilter(IM2 ,h);
                IM2 = imfilter(IM2 ,h);
           axes(handles.axes4);  
            %%在axes1中显示 图像  
            imshow(IM2); 
                
img_reg = regionprops(IM2,  'area', 'boundingbox');
areas = [img_reg.Area];
rects = cat(1,  img_reg.BoundingBox);
num = 0;
k=0;
for i = 1:size(rects, 1)
    if areas(i)>50
        num = num+1;
        k = k+1;
   set(handles.edit2, 'string', num2str(size(rects, 1)));
   set(handles.edit3, 'string', num2str(areas(i)));
      mx_data(k,j)=areas(i);
   rectangle('position', rects(i, :), 'EdgeColor', 'r');
    end
end         
            
                   %图像处理过程 省略
        end
end
xlswrite('result.xls',mx_data);

% 
% str=[pathname filename];  
% %%打开图像  
% im=imread(str);  
% %%打开axes1的句柄 进行axes1的操作  
% axes(handles.axes1);  
% %%在axes1中显示 图像  
% imshow(im);  
% 
% %图像处理部分
% I=im2bw(im);
% BW1=edge(I,'canny'); %用canny算子进行边缘检测
% path1='F:\oct'; 
% name='IMG_3635.PNG';
% imwrite(BW1,[path1 name]);
% 
% str1=[path1 name];  
% im1=imread(str1);  
% axes(handles.axes4);  
% imshow(im1); 



% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
