function varargout = seam(varargin)

% Begin initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seam_OpeningFcn, ...
                   'gui_OutputFcn',  @seam_OutputFcn, ...
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

% Executes just before seam is made visible.
function seam_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for seam
handles.output = hObject;

a=ones(320,420);
axes(handles.axes1);
imshow(a);

axes(handles.axes2);
imshow(a);

% Update handles structure
guidata(hObject, handles);

% Outputs from this function are returned to the command line.
function varargout = seam_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)

 [filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       a=imread(filename);
       axes(handles.axes1);
       imshow(a);
       handles.a=a;
    end
    
% Update handles structure
guidata(hObject, handles);

% Executes on button press in SeamCarving.
function SeamCarving_Callback(hObject, eventdata, handles)

a=handles.a;

[im]=a
demo=nargout==0;

k=200;
im=im2double(im);

if demo
    close(findobj(0,'type','figure','tag','seam carving demo'));
    figure; set(gcf,'tag','seam carving demo','name','Seam Carving','NumberTitle','off')
    axes('position', [0 0 1 1]);
    if size(im,3)==1
        im=im/max(im(:));
        him=imagesc(im);
        colormap gray 
    else
        him=image(im);
    end
    origim=im;
    axis equal
    axis off
end


for jj=1:k
    G=costfunction(im);
    %find shortest path in G
    Pot=G;
    for ii=2:size(Pot,1)
        pp=Pot(ii-1,:);
        ix=pp(1:end-1)<pp(2:end);
        pp([false ix])=pp(ix);
        ix=pp(2:end)<pp(1:end-1);
        pp(ix)=pp([false ix]);
        Pot(ii,:)=Pot(ii,:)+pp;
    end

    %Walk down hill
    pix=zeros(size(G,1),1);
    [mn,pix(end)]=min(Pot(end,:));
    pp=find(Pot(end,:)==mn);
    pix(end)=pp(ceil(rand*length(pp)));
    
    im(end,pix(end),:)=nan;
    for ii=size(G,1)-1:-1:1
        [mn,gg]=min(Pot(ii,max(pix(ii+1)-1,1):min(pix(ii+1)+1,end)));
        pix(ii)=gg+pix(ii+1)-1-(pix(ii+1)>1);
        im(ii,pix(ii),:)=bitand(ii,1);
    end

    if demo
        set(him,'CDATA',im);
        drawnow;
    end

    %remove seam from im & G:
    for ii=1:size(im,1)
        im(ii,pix(ii):end-1,:)=im(ii,pix(ii)+1:end,:);
    end
    im(:,end,:)=[];
end

if demo
    axes(handles.axes2);imshow(im);
end
if nargout==0
    clear im
end


    
