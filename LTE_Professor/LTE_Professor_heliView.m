%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_heliView: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE
%                                               MODULE: LTE PROFESSOR,
%                                                       HELICOPTER VIEW ON RESOURCES
%
%
% File version 1.0 (25th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. varargin:    Variable lenght input argument list.
%
% ------------------------------------------------------------------------
% Output:
%
%       no output
%
%% ------------------------------------------------------------------------ 
% Copyright (c) 2010 - 2012 Jacek Pierzchlewski, (AAU TPS)
%                           AALBORG UNIVERSITY, Denmark
%                           Technology Platforms Section (AAU TPS)
%                           Email:    jap@es.aau.dk 
%                              
%                           Comments and bug reports are very welcome!
%
% Licensing: This software is published under the terms of the:
%            GNU GENERAL PUBLIC LICENSE, Version 3, 29th June 2007
%
% ------------------------------------------------------------------------ 
%
% This file is a part of the "ALGaE Package 0.14r2" (Stable). 
% ALGaE 0.14r2 released: 5th September 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Main function
function varargout = LTE_Professor_heliView(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @LTE_Professor_heliView_OpeningFcn, ...
                       'gui_OutputFcn',  @LTE_Professor_heliView_OutputFcn, ...
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
end



%% --- Executes just before LTE_Professor_heliView is made visible.
function LTE_Professor_heliView_OpeningFcn(hObject, ~, handles, varargin)
    
    % Choose default command line output for LTE_Professor_heliView
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % - - - - - - - - - - - - - - - - - - - - - - - -
    
    % Get the handle to the mother window
    hMother = varargin{1};

    % Store the handle to the mother window
    setappdata(handles.figure1,'hMother',hMother);
    
    % - - - - - - - - - - - - - - - - - - - - - - - -    
                
    % Get the LTE data structure 
    sLTE_DL1 = getappdata(hMother.figure1,'sLTE_DL1');    
    

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD
    % (structures: 'sLTE_stand'):               

        % Get the total number of subcarriers
        N_scB = sLTE_DL1.sF.N_scB;

        % Get the total number of symbols
        N_symbTR = sLTE_DL1.sT.N_symbTR;

    % ----------------------------------------------------------      


    % - - - - - - - - - - - - - - - - - - - - - - - -    
    
    % Set the current indices of shown symbols
    inxFrstSymb = 0;
    setappdata(handles.figure1,'inxFrstSymb',inxFrstSymb);
    
    % Set the current indices of shown subcarriers    
    inxFrstSub = 1;
    setappdata(handles.figure1,'inxFrstSub',inxFrstSub);            

    % - - - - - - - - - - - - - - - - - - - - - - - -

    % Save the start size of the view
    subSize = N_scB;        % The number of shown subcarrier 
    
    symSize = subSize-14;   % The number of shown symbols
    if symSize > N_symbTR
        symSize = N_symbTR;
    end
    
    setappdata(handles.figure1,'subSize',subSize); % Save the above values  
    setappdata(handles.figure1,'symSize',symSize); % ^

    % --------------------------------------------------------

    % Set the zoom slider step    
    set(handles.slider_zoom,'SliderStep', [ 1/((round (N_scB - 24)/10) )  ;  1/(N_scB - 24)]' );


    % --------------------------------------------------------
    
    
    %% Set the subcarriers slider step

    % Calculate the step
    iStep_subc = 1/(N_scB - subSize);


    % Set the step
    if iStep_subc >= 1
        
        % Set the step to 0.99
        iStep_subc = 0.99;
        
        % Set the step
        set(handles.slider_subc,'SliderStep', [  iStep_subc ; iStep_subc ]');
        
        % Save the subcarriers slider step
        setappdata(handles.figure1,'iStep_subc',iStep_subc);
        
        % Disable this slider
        set(handles.slider_subc,'Enable','off');
        
    else
        % Set the step
        set(handles.slider_subc,'SliderStep', [  iStep_subc ; iStep_subc ]');

        % Save the subcarriers slider step
        setappdata(handles.figure1,'iStep_subc',iStep_subc);
    end
    
    
    %% Set the symbols slider step

    % Calculate the step
    iStep_symb = 1/(N_symbTR - symSize);

    % Set the step     
    if iStep_symb >= 1

        % Set the step to 0.99
        set(handles.slider_symb,'SliderStep', [ 0.99  ;  0.99 ]' );
        
        % Disable this slider
        set(handles.slider_symb,'Enable','off');
        
    else
        % Set the step
        set(handles.slider_symb,'SliderStep', [ iStep_symb  ;  iStep_symb ]' );

        % Save the symbols slider step
        setappdata(handles.figure1,'iStep_symb',iStep_symb);
    end


    %% Set the sliders start values

    % --------------------------------------------------------
    % Zoom        
    set(handles.slider_zoom,'Value',1);

    % --------------------------------------------------------


    % --------------------------------------------------------
    % Subcarriers
    iSlidVal = 1 - inxFrstSub*iStep_subc;
    set(handles.slider_subc,'Value',iSlidVal);

    % --------------------------------------------------------
    
    
    % --------------------------------------------------------
    % Symbols
    iSlidVal = 1 - inxFrstSymb*iStep_symb;
    set(handles.slider_symb,'Value',iSlidVal);
    
    % --------------------------------------------------------
    

    %% Save the total number of subcarriers and the total number of symbols
    setappdata(handles.figure1,'N_scB',N_scB);
    setappdata(handles.figure1,'N_symbTR',N_symbTR);
    

    %% Prepare (color) the matrices 
    LTE_Professor_heliView_prepare(handles);
    
    
    %% Show the picture
    LTE_Professor_heliView_show(handles);    
    
end




%% --- Outputs from this function are returned to the command line.
function varargout = LTE_Professor_heliView_OutputFcn(~, ~, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end



%% --- Slider service. (zoom)

% --- Executes during object creation, after setting all properties.
function slider_zoom_CreateFcn(hObject, ~, ~)

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

% --- Executes on slider movement
function slider_zoom_Callback(hObject, ~, handles)

    % ------------------------------------------------
    
    % Get the slider value
    iSlidVal = get(hObject,'Value');

    % ------------------------------------------------
    
    % Get the number of subcarriers in the transmission
    N_scB = getappdata(handles.figure1,'N_scB');
    
    % Get the number of symbols in the transmission
    N_symbTR = getappdata(handles.figure1,'N_symbTR');
    
    % ------------------------------------------------


    %% Calculate the number of shown subcarriers
    subSize = round((N_scB - 24)*iSlidVal + 24);

    % Calculate the number of shown symbols
    symSize = subSize - 14;
    
    % Calculate the number of shown symbols
    if symSize > N_symbTR;
        symSize = N_symbTR;
    end
    
    % ------------------------------------------------

    
    % ------------------------------------------------
    
    % Save the size of the view
    setappdata(handles.figure1,'subSize',subSize);
    setappdata(handles.figure1,'symSize',symSize);

    % ------------------------------------------------


    %% Set the subcarriers slider step

    % Calculate the step
    if N_scB == subSize
        
        % Disable the slider
        set(handles.slider_subc,'Enable', 'off');
        
        % Set the slider step to 1
        iStep_subc = 1;
        
    else
        
        % Calculate the step
        iStep_subc = 1/(N_scB - subSize);
        
        % Set the step
        set(handles.slider_subc,'SliderStep', [  iStep_subc ; iStep_subc ]' );               
        
        % Enable the slider
        set(handles.slider_subc,'Enable', 'on');               
    end


    % ------------------------------------------------
    
    % Save the slider step
    setappdata(handles.figure1,'iStep_subc',iStep_subc);
    
    
    %% Set the symbols slider step

    % Calculate the step
    if N_symbTR == symSize
        
        % Disable the slider
        set(handles.slider_symb,'Enable', 'off');        
        
        % Set the slider step to 1
        iStep_symb = 1;
    else
        % Calculate the step
        iStep_symb = 1/(N_symbTR - symSize);

        % Set the step
        set(handles.slider_symb,'SliderStep', [ iStep_symb  ;  iStep_symb ]' );    
        
        % Enable the slider
        set(handles.slider_symb,'Enable', 'on');
    end


    % ------------------------------------------------

    % Save the slider step
    setappdata(handles.figure1,'iStep_symb',iStep_symb);
    
    
    %% Show the picture
    LTE_Professor_heliView_show(handles);

end



%% --- Slider service. (subcarriers)

% --- Executes during object creation, after setting all properties.
function slider_subc_CreateFcn(hObject, ~, ~)

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- Executes on slider movement.
function slider_subc_Callback(hObject, ~, handles)
    
    % Get the slider value
    iSlidVal = get(hObject,'Value');

    % Get the slider step
    iStep_subc = getappdata(handles.figure1,'iStep_subc');

    % Calculate the current start subcarrier
    inxFrstSub = round((1-iSlidVal)/iStep_subc)+1;
    
    % Set the current start subcarrier
    setappdata(handles.figure1,'inxFrstSub',inxFrstSub);    
    
    %% Show the picture
    LTE_Professor_heliView_show(handles);
    
end



%% --- Slider service. (symbols)

% --- Executes during object creation, after setting all properties.
function slider_symb_CreateFcn(hObject, ~, ~)

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- Executes on slider movement.
function slider_symb_Callback(hObject, ~, handles)

    % Get the slider value
    iSlidVal = get(hObject,'Value');

    % Get the slider step
    iStep_symb = getappdata(handles.figure1,'iStep_symb');    
   
    % Calculate the current start symbol
    inxFrstSymb = round((1-iSlidVal)/iStep_symb);
    
    % Set the current start symbol
    setappdata(handles.figure1,'inxFrstSymb',inxFrstSymb); 
    
    %% Show the picture
    LTE_Professor_heliView_show(handles);
     
end


% --- Executes on button press in Refresh.
function Refresh_Callback(~, ~, handles)
    
    %% Show the picture
    LTE_Professor_heliView_show(handles);
    
end
