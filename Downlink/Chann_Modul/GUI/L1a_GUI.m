%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                STACK:  DOWNLINK,
%                                MODULE: CHANNELS AND MODULATION
%
% File version 1.4r1 (14th October 2011)
%
%% ------------------------------------------------------------------------
% Input (1):
%
%       1. varargin:    Variable lenght input argument list.
%
% ------------------------------------------------------------------------
% Output:
%
%       no output
%
%% ------------------------------------------------------------------------ 
%
% Internals: (app data)
%
%   1. sScen - the current LTE scenario with an additional fields:
%               
%           a. strScenFil: string with the LTE scenario file.
%
%           b. strOutFile: string with the LTE output file.
%
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


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   M A I N   F U N C T I O N   (A U T O   G E N E R A T E D)
function varargout = L1a_GUI(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @L1a_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @L1a_GUI_OutputFcn, ...
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
    
    % ------------------------------------------------------------------------------------
   
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O P E N I N G   F U N C T I O N 

% --- Executes just before L1a_GUI is made visible.
function L1a_GUI_OpeningFcn(hObject, ~, handles, varargin)

    % Choose default command line output for L1a_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);


    % --------------------------------------------------------------------
    % Get the handle to the mother window
    hMother = varargin{1};
    
    % Store the handle to the mother window
    setappdata(handles.figure1,'hMother',hMother);
    
    % --------------------------------------------------------------------
        
    % Initialization function
    initValues(hObject,handles)

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O U T P U T   F U N C T I O N 

% --- Outputs from this function are returned to the command line.
function varargout = L1a_GUI_OutputFcn(hObject, ~, ~) 

    % Get default command line output from handles structure
    varargout{1} = hObject;
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B O X:   C H A N N E L   B A N D W I D T H   (GUIlb_band)

% --- Executes during object creation, after setting all properties.
function GUIlb_band_CreateFcn(hObject, ~, handles)

    % Run the 'Bandwidth' list box field service with 
    % the 'Create' functionality 
    L1a_GUI_lb_band(hObject,handles,'Create');
    
end


% --- Executes on selection change in GUIlb_band.
function GUIlb_band_Callback(hObject, ~, handles)

    % Run the 'Bandwidth' list box field service with 
    % the 'Callback' functionality 
    L1a_GUI_lb_band(hObject,handles,'Callback');

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B O X:   C Y C L I X   P R E F I X   (GUIlb_cp)

% --- Executes during object creation, after setting all properties.
function GUIlb_cp_CreateFcn(hObject, ~, handles)

    % Run the 'Cyclic Prefix' list box field service with 
    % the 'Create' functionality 
    L1a_GUI_lb_cp(hObject,handles,'Create');

end

% --- Executes on selection change in GUIlb_cp.
function GUIlb_cp_Callback(hObject, ~, handles)

    % Run the 'Cyclic Prefix' list box field service with 
    % the 'Callback' functionality 
    L1a_GUI_lb_cp(hObject,handles,'Callback');
    
end
% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   L 1 A   O P T I O N S

% --- Executes on button press in GUIpb_AdvLTEopt.
function GUIpb_AdvLTEopt_Callback(~, ~, handles)

    % Run the Advanced Options service ('Advanced Options' pressbutton)
    L1a_GUI_L1aOpt(handles);
    
end

% ------------------------------------------------------------------------------------



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   T E X T:   S C E N A R I O   F I L E

% --- Executes during object creation, after setting all properties.
function GUIedit_scen_CreateFcn(hObject, ~, handles)
    
    % Run the 'Scenario File' edit field service with 
    % the 'Create' functionality
    L1a_GUI_get_scen(hObject, handles,'Create');
    
end

% --- Executes during edition of the text field
function GUIedit_scen_Callback(hObject, ~, handles)
    
    % Run the 'Scenario File' edit field service with 
    % the 'Callback' functionality
    L1a_GUI_get_scen(hObject, handles,'Callback');
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   B R O W S E   4   S C E N A R I O   F I L E

% --- Executes on button press in GUIpb_brwsScen.
function GUIpb_brwsScen_Callback(hObject, ~, handles)

    % Run the 'Scenario File' press button service
    % (with the 'PressButton' functionality)
    L1a_GUI_get_scen(hObject, handles,'PressButton');
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   T E X T:   O U T P U T   F I L E 

% --- Executes during object creation, after setting all properties
function GUIedit_outp_CreateFcn(hObject, ~, handles)

    % Run the 'Get Output File' edit field service with 
    % the 'Create' functionality
    L1a_GUI_get_outp(hObject, handles, 'Create');

end

% --- Executes during edition of the text field
function GUIedit_outp_Callback(hObject, ~, handles)
    
    % Run the 'Get Output File' edit field service with 
    % the 'Callback' functionality
    L1a_GUI_get_outp(hObject, handles, 'Callback');

end
% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   B R O W S E   4   O U T P U T   F I L E

% --- Executes on button press in GUIpb_brwsOutp.
function GUIpb_brwsOutp_Callback(hObject, ~, handles)
    
    % Run the 'Browse For Output File' service
    L1a_GUI_get_outp(hObject, handles, 'PressButton');

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   T E X T:   T H E   N U M B E R   O F   S U B F R A M E S

% --- Executes during object creation, after setting all properties.
function GUIedit_RF_CreateFcn(hObject, ~, handles)

    % Run the 'The number of Radio Frames' edit field 
    % service with the 'Create' functionality
    L1a_GUI_get_nsf(hObject,handles,'Create');
    
end

% --- Executes during edition of the text field.
function GUIedit_RF_Callback(hObject, ~, handles)        

    % Run the 'The number of Radio Frames' edit field 
    % service with the 'Callback' functionality
    L1a_GUI_get_nsf(hObject,handles,'Callback');
    
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   V I E W   L T E   P A R A M E T E R S

% --- Executes on button press in GUIpb_vtpar.
function GUIpb_vtpar_Callback(~ , ~, handles)

    % View LTE parameters
    L1a_GUI_view_Param(handles);

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   G E N E R A T E   I Q   S I G N A L

% --- Executes on button press in GUIpb_gen.
function GUIpb_gen_Callback(~, ~, handles)
    
    % Run the generate IQ signals service ('Generate IQ signal' pressbutton)    
    L1a_GUI_genIQ_sig(handles);

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   V I E W   L T E   P R O F E S S O R

% --- Executes on button press in GUIpb_chann.
function GUIpb_chann_Callback(~, ~, handles)
    
    % Run the LTE Professor
    L1a_GUI_run_LTEProfessor(handles);

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   I N T E R N A L   F U N C T I O N :   I N I T I A L I Z A T I O N
function initValues(hObject,handles)


    %% Read the LTE standard
    sLTE_stand = LTE_stand();


    %% Get the scenario structure

    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');    
    
    % Get the scenario structure
    sScen = getappdata(hMother.figure1,'sScen');
    
    % Check the scenario structure, if the scenario exists
    if sScen.bEmpty == 0
        [sScen strErr] = chc_Scen_DL1a(sScen);
    
        % Show the error, if error exists
        if isfield(sScen,'bError')
            if sScen.bError == 1
                waitfor(errordlg(strErr,'Scenario error'));
            end
            close(gcf);
            return;
        end
    end

    %% Clear the bGenerated flag in the scenario strucutre
    sScen.bGenerated = 0;
    
    %% Set the scenario file name
        
    if sScen.bEmpty == 1
        set(handles.GUIedit_scen,'String','No scenario file!');        
    else
        set(handles.GUIedit_scen,'String',sScen.strScenFil);        
    end


    %% Set the output file name
    
    if ~isfield(sScen,'strOutFil')
        set(handles.GUIedit_outp,'String','No output file!');
    else
        set(handles.GUIedit_outp,'String',sScen.strOutFil);
    end

    
    %% Set the lenght of the signal

    if sScen.bEmpty == 1
        set(handles.GUIedit_RF,'String','???');
        set(handles.GUIedit_RF,'Enable','Off');
    else
        set(handles.GUIedit_RF,'String',sScen.N_SF);
    end


    %% Set the 'GUIlb_band' list box (Bandwidth)
    if sScen.bEmpty == 1        

        % Switch off the 'GUIlb_band' list box
        set(handles.GUIlb_band,'Enable','Off');
        guidata(hObject, handles);

    else
        
        % Get the BANDWIDTH field from the LTE scenario structure
        strBand  = sScen.BANDWIDTH;
                
        % Get the supported bandwidths from the LTE standard
        cvBW_channel = sLTE_stand.cvBW_channel;
        
        % Get the correct number which indicates the correct cyclix prefix
        vInx = (1:size(cvBW_channel,1))';    
        iInx = vInx(strcmp(strBand,cvBW_channel));
            
        % Set the value in the 'GUIlb_band' list box
        set(handles.GUIlb_band,'Value',iInx);
        guidata(hObject, handles);

    end


    %% Set the 'GUIlb_cp' list box (Cyclic Prefix)
    if sScen.bEmpty == 1        

        % Switch off the 'GUIlb_cp' list box
        set(handles.GUIlb_cp,'Enable','Off');
        guidata(hObject, handles);

    else
        
        % Get the CYCLIC_PRFX field from the LTE scenario structure
        strCP  = sScen.CYCLIC_PRFX;
                
        % Get the supported Cyclic Prefixes from the LTE standard
        cvCP = sLTE_stand.cvCP;
        
        % Get the correct number which indicates the correct cyclix prefix
        vInx = (1:size(cvCP,1))';    
        iInx = vInx(strcmp(strCP,cvCP));
            
        % Set the value in the 'GUIlb_cp' list box
        set(handles.GUIlb_cp,'Value',iInx);
        guidata(hObject, handles);

    end


    %% Set the scenario structure locally
    setappdata(handles.figure1,'sScen',sScen);
    
end
