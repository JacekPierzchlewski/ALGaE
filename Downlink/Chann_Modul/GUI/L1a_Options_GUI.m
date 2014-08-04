%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_Options_GUI: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                        STACK:  DOWNLINK,
%                                        MODULE: CHANNELS AND MODULATION,
%                                                OPTIONS
%
% File version 1.2 (17th October 2011)
%
%% ------------------------------------------------------------------------
% Input (1):
%
%       1. varargin:    Variable lenght input argument list.
%
%                       1st argument: The current scenario structure.
%
%                       2nd argument: Handle to the mother window.
%
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
function varargout = L1a_Options_GUI(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @L1a_Options_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @L1a_Options_GUI_OutputFcn, ...
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

% --- Executes just before L1a_Options_GUI is made visible.
function L1a_Options_GUI_OpeningFcn(hObject, ~, handles, varargin)

    % Choose default command line output for L1a_Options_GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    
    % --------------------------------------------------------------------
    % Get the handle to the mother window
    hMother = varargin{2};    
    
    % Store the handle to the mother window
    setappdata(handles.figure1,'hMother',hMother);
    
    % --------------------------------------------------------------------


    % -----------------------------------------------------------------------

    % Run the opening service, if it is the first run of the function.
    % 
    % 'sScen' field in the 'handles' strucutre indicates 
    % if it is not the first run.
    %

    % If the opening serivce finish with an error, it returns 1
    if ~isappdata(handles.figure1,'sScen')

        sScen = varargin{1};

        % Set application data scenario
        setappdata(handles.figure1,'sScen',sScen);
    end

    % -----------------------------------------------------------------------

    % Initialize the values   
    L1a_Options_init(handles);
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O U T P U T   F U N C T I O N 

% --- Outputs from this function are returned to the command line.
function varargout = L1a_Options_GUI_OutputFcn(hObject, ~, ~) 

    % Get default command line output from handles structure             
    varargout{1} = hObject;
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   F I E L D:   I N D E X   O F   T H E   1 S T   R F   I N   P B C H   T T I   (GUIedit_inxRF_PBCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_inxRF_PBCH_CreateFcn(hObject, ~, handles)
        
    % Run the 'Index of the first RF in PBCH TTI' edit field 
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_inxRF(hObject,handles,'Create');    
end

% --- Executes during edition of the text field
function GUIedit_inxRF_PBCH_Callback(hObject, ~, handles)
        
    % Run the 'Index of the first RF in PBCH TTI' edit field 
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_inxRF(hObject, handles,'Callback');
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   F I E L D:   T H E   N g   P A R A M E T E R   (GUIedit_Ng_PHICH)

% --- Executes during object creation, after setting all properties.
function GUIedit_Ng_PHICH_CreateFcn(hObject, ~, handles)

    % Run the 'Ng coefficient' edit field 
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_Ng(hObject, handles, 'Create');
end


% --- Executes during edition of the text field
function GUIedit_Ng_PHICH_Callback(hObject, ~, handles)

    % Run the 'Ng coefficient' edit field 
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_Ng(hObject,handles,'Callback');
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B U T T O N:   T H E   N U M.   O F   P D C C H   C H A N N. (GUIlb_NumChan_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIlb_NumChan_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'The number of channels' list box
    % service with the 'Create' functionality
    L1a_Options_GUI_lb_NumChan(hObject, handles, 'Create');
end

% --- Executes on selection change in GUIlb_NumChan_PDCCH.
function GUIlb_NumChan_PDCCH_Callback(hObject, ~, handles)

    % Run the 'The number of channels' list box
    % service with the 'Callback' functionality
    L1a_Options_GUI_lb_NumChan(hObject, handles, 'Callback');
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   1   F O R M A T   (GUIedit_for1_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for1_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 1st PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for1(hObject,handles,'Create');
end

% --- Executes during edition of the text field
function GUIedit_for1_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 1st PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for1(hObject,handles,'Callback');
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   2   F O R M A T   (GUIedit_for2_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for2_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 2nd PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for2(hObject,handles,'Create');
end

% --- Executes during edition of the text field
function GUIedit_for2_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 2nd PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for2(hObject,handles,'Callback');
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   3   F O R M A T   (GUIedit_for3_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for3_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 3rd PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for3(hObject,handles,'Create');
end


% --- Executes during edition of the text field
function GUIedit_for3_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 3rd PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for3(hObject,handles,'Callback');
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   4   F O R M A T   (GUIedit_for4_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for4_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 4th PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for4(hObject,handles,'Create');
end

% --- Executes during edition of the text field
function GUIedit_for4_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 4th PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for4(hObject,handles,'Callback');
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   5   F O R M A T   (GUIedit_for5_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for5_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 5th PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for5(hObject,handles,'Create');
end

% --- Executes during edition of the text field
function GUIedit_for5_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 5th PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for5(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   6   F O R M A T   (GUIedit_for6_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for6_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 6th PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for6(hObject,handles,'Create');
end

% --- Executes during edition of the text field
function GUIedit_for6_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 6th PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for6(hObject,handles,'Callback');
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   7   F O R M A T   (GUIedit_for7_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for7_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 7th PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for7(hObject,handles,'Create'); 
end

% --- Executes during edition of the text field
function GUIedit_for7_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 7th PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for7(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   E D I T   F I E L D:   P D C C H   C H A N.   8   F O R M A T   (GUIedit_for8_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIedit_for8_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'Format of the 8th PDCCH channel' edit field
    % service with the 'Create' functionality
    L1a_Options_GUI_edit_for8(hObject,handles,'Create'); 
end

function GUIedit_for8_PDCCH_Callback(hObject, ~, handles)

    % Run the 'Format of the 8th PDCCH channel' edit field
    % service with the 'Callback' functionality
    L1a_Options_GUI_edit_for8(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B O X:   T H E   N U M.   O F   S Y M B.   F O R   P D C C H (GUIlb_NumSymb_PDCCH)

% --- Executes during object creation, after setting all properties.
function GUIlb_NumSymb_PDCCH_CreateFcn(hObject, ~, handles)

    % Run the 'The number of symbols for PDCCH' list box
    % service with the 'Create' functionality
    L1a_Options_GUI_lb_NumSymb(hObject,handles,'Create');
end

% --- Executes on selection change in GUIlb_NumSymb_PDCCH.
function GUIlb_NumSymb_PDCCH_Callback(hObject, ~, handles)

    % Run the 'The number of symbols for PDCCH' list box
    % service with the 'Callback' functionality
    L1a_Options_GUI_lb_NumSymb(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   P R E S S   B U T T O N:   OK (GUIpb_OK)

% --- Executes on button press in GUIpb_OK.
function GUIpb_OK_Callback(~, ~, ~)
    close(gcf);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   I N I T   F U N C T I O N

function L1a_Options_init(handles)
%
% Input (1):
%
%       1. handles -> handles to objects
%

    %% INITIALIZE INDEX OF THE FIRST TRANSMITTED RF IN PBCH TTI
    L1a_Options_GUI_edit_inxRF(NaN, handles, 'Initialize');


    %% INITIALIZE THE Ng COEFFICIENT
    L1a_Options_GUI_edit_Ng(NaN, handles, 'Initialize');



    %% INITIALIZE THE NUMBER OF PDCCH CHANNELS
    L1a_Options_GUI_lb_NumChan(NaN, handles, 'Initialize');
    
    
    
    %% INITIALIZE THE FORMATS OF PDCCH CHANNELS
    
    
    % Edit field: Format of the 8th Channel
    L1a_Options_GUI_edit_for8(NaN, handles, 'Initialize');
    
    
    % Edit field: Format of the 7th Channel
     L1a_Options_GUI_edit_for7(NaN, handles, 'Initialize');
    
    
    % Edit field: Format of the 6th Channel
    L1a_Options_GUI_edit_for6(NaN, handles, 'Initialize');

    
    % Edit field: Format of the 5th Channel
    L1a_Options_GUI_edit_for5(NaN, handles, 'Initialize');

    
    % Edit field: Format of the 4th Channel
    L1a_Options_GUI_edit_for4(NaN, handles, 'Initialize');

    
    % Edit field: Format of the 3rd Channel
    L1a_Options_GUI_edit_for3(NaN, handles, 'Initialize');

    
    % Edit field: Format of the 2nd Channel
    L1a_Options_GUI_edit_for2(NaN, handles, 'Initialize');

    
    % Edit field: Format of the 1st Channel
    L1a_Options_GUI_edit_for1(NaN, handles, 'Initialize');


    %% INITIALIZE THE NUMBER OF SYMBOLS DEDICATED FOR PDCCH CHANNEL    
    L1a_Options_GUI_lb_NumSymb(NaN, handles, 'Initialize');

end


