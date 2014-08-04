%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_GUI: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                  MODULE: MAIN GUI
%
%
% File version 1.0 (14th October 2011)
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
%
% Internals: (app data)
%
%   1. sScen - the current LTE scenario with an additional fields:
%               
%           a. strScenFil: string with the LTE scenario file.
%
%           b. strOutFile: string with the LTE output file.
%
%           c. strCodeFil: string with the codewords file.
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
function varargout = ALGaE_GUI(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ALGaE_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @ALGaE_GUI_OutputFcn, ...
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



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O P E N I N G   F U N C T I O N 

% --- Executes just before ALGaE_GUI is made visible.
function ALGaE_GUI_OpeningFcn(hObject, ~, handles, varargin)


    %% Print out No scenario file!, No codewords file - random, No output file!
    
    % No scenario file!
    set(handles.GUIedit_scenario,'String','No scenario file!');
    
    % No codewords file - random
    set(handles.GUIedit_codewords,'String','No codewords file - random data');
    
    % No output file!
    set(handles.GUIedit_output,'String','No output file!');
    
    
    %% Set the empty sScen structure
    sScen.bEmpty = 1;     
    setappdata(handles.figure1,'sScen',sScen);


    %% 
    
    % Choose default command line output for ALGaE_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O U T P U T   F U N C T I O N 

% --- Outputs from this function are returned to the command line.
function varargout = ALGaE_GUI_OutputFcn(~, ~, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S    B U T T O N:  B R O W S E   F O R   S C E N A R I O   F I L E

% --- Executes on button press in GUIpb_brwsScen.
function GUIpb_brwsScen_Callback(hObject, ~, handles)

    % Run the 'Browse for Scenario File' press button service
    % with the 'PressButton' functionality
    ALGaE_GUI_get_scen(hObject,handles,'PressButton');

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I  - E D I T   T E X T:   S C E N A R I O   F I L E

% --- Executes during object creation, after setting all properties.
function GUIedit_scenario_CreateFcn(hObject, ~, handles)

    % Run the 'Scenario file' edit box field service with 
    % the 'Create' functionality 
    ALGaE_GUI_get_scen(hObject,handles,'Create');

end

% --- Executes during edition of the text field.
function GUIedit_scenario_Callback(hObject, ~, handles)

    % Run the 'Scenario file' edit box field service with 
    % the 'Callback' functionality 
    ALGaE_GUI_get_scen(hObject,handles,'Callback');

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S    B U T T O N:  B R O W S E   C O D E W O R D S   C H A N N E L S   F I L E

% --- Executes on button press in GUIpb_codewords.
function GUIpb_codewords_Callback(hObject, ~, handles)

    % Run the 'Browse for Codewords File' press button service
    % with the 'PressButton' functionality
    ALGaE_GUI_get_code(hObject,handles,'PressButton');
    
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   T E X T:   C O D E W O R D S   C H A N N E L S   F I L E 

% --- Executes during object creation, after setting all properties.
function GUIedit_codewords_CreateFcn(hObject, ~, handles)

    % Run the 'Codewords File' edit box field service
    % with the 'Create' functionality
    ALGaE_GUI_get_code(hObject,handles,'Create');
    
end

% --- Executes during edition of the text field.
function GUIedit_codewords_Callback(hObject, ~, handles)

    % Run the 'Codewords File' edit box field service
    % with the 'Callback' functionality
    ALGaE_GUI_get_code(hObject,handles,'Callback');
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   M A I N   S E T T I N G S

% --- Executes on button press in GUIpb_MainSettings.
function GUIpb_MainSettings_Callback(~, ~, handles)

    % Run the 'Main LTE Options' service
    ALGaE_GUI_runOpt(handles);
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   C H A N N E L S   M O D U L A T I O N

% --- Executes on button press in GUIpb_ChanMod.
function GUIpb_ChanMod_Callback(hObject, ~, handles)

    % Run the 'Channels modulation layer (L1a) GUI' service
    ALGaE_GUI_runChanMod(hObject,handles);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S    B U T T O N:   U P C O N V E R S I O N

% --- Executes on button press in GUIpb_Radio.
function GUIpb_Radio_Callback(~, ~, ~)

    %% TO BE IMPLEMENTED
    fprintf('To be implemnted!\n');

end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S    B U T T O N:   B R O W S E   4   O U T P U T   F I L E

% --- Executes on button press in GUIpb_output.
function GUIpb_output_Callback(hObject, ~, handles)

    % Run the 'Browse for Output File' press button service
    % with the 'PressButton' functionality
    ALGaE_GUI_get_outp(hObject,handles,'PressButton');

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   O U T P U T   F I L E

% --- Executes during edition of the text field.
function GUIedit_output_Callback(hObject, ~, handles)

    % Run the 'Output File' edit box field service
    % with the 'Callback' functionality
    ALGaE_GUI_get_outp(hObject,handles,'Callback');

end

% --- Executes during object creation, after setting all properties.
function GUIedit_output_CreateFcn(hObject, ~, handles)

    % Run the 'Output File' edit box field service
    % with the 'Create' functionality
    ALGaE_GUI_get_outp(hObject,handles,'Create');

end
