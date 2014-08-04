%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_AdvOpt_GUI: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                         MODULE: MAIN GUI, OPTIONS
%
%
% File version 1.0 (16th October 2011)
%
%% ------------------------------------------------------------------------
% Input:
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
function varargout = ALGaE_AdvOpt_GUI(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @ALGaE_AdvOpt_GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @ALGaE_AdvOpt_GUI_OutputFcn, ...
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

% --- Executes just before ALGaE_AdvOpt_GUI is made visible.
function ALGaE_AdvOpt_GUI_OpeningFcn(hObject, ~, handles, varargin)
    
    % Choose default command line output for ALGaE_AdvOpt_GUI
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
    
    % Initialize the values.    
    ALGaE_AdvOpt_init(handles);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   O U T P U T   F U N C T I O N 


% --- Outputs from this function are returned to the command line.
function varargout = ALGaE_AdvOpt_GUI_OutputFcn(hObject, ~, ~) 

    % Get default command line output from handles structure             
    varargout{1} = hObject;
   
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B O X:  B A N D W I D T H

% --- Executes during object creation, after setting all properties.
function GUIlb_band_CreateFcn(hObject, ~, handles)

    % Run the 'Bandwidth' list box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_lbband(hObject,handles,'Create');
end

% --- Executes on selection change in GUIlb_band.
function GUIlb_band_Callback(hObject, ~, handles)
    
    % Run the 'Bandwidth' list box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_lbband(hObject,handles,'Callback');
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -   L I S T   B O X:  C Y C L I X   P R E F I X 

% --- Executes during object creation, after setting all properties.
function GUIlb_cp_CreateFcn(hObject, ~, handles)

    % Run the 'Cyclic Prefix' list box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_lbCP(hObject,handles,'Create');
end


% --- Executes on selection change in GUIlb_cp.
function GUIlb_cp_Callback(hObject, ~, handles)

    % Run the 'Cyclic Prefix' list box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_lbCP(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   B O X:  I D E N T I T Y   N U M B E R   1

% --- Executes during object creation, after setting all properties.
function GUIedit_IdenNum1_CreateFcn(hObject, ~, handles)

    % Run the 'Identity Number 1' edit text box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_editIdenNum1(hObject,handles,'Create');
end


% --- Executes during edition of the text field.
function GUIedit_IdenNum1_Callback(hObject, ~, handles)

    % Run the 'Identity Number 1' edit text box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_editIdenNum1(hObject,handles,'Callback');
    
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   B O X:  I D E N T I T Y   N U M B E R   2

% --- Executes during object creation, after setting all properties.
function GUIedit_IdenNum2_CreateFcn(hObject, ~, handles)

    % Run the 'Identity Number 2' edit text box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_editIdenNum2(hObject,handles,'Create');
end


% --- Executes during edition of the text field.
function GUIedit_IdenNum2_Callback(hObject, ~, handles)

    % Run the 'Identity Number 2' edit text box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_editIdenNum2(hObject,handles,'Callback');
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   B O X:  T H E   N U M B E R   O F   S U B F R A M E S

% --- Executes during object creation, after setting all properties.
function GUIedit_NumSub_CreateFcn(hObject, ~, handles)

    % Run 'The number of subframes' edit text box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_editTNofSub(hObject,handles,'Create');
end


% --- Executes during edition of the text field.
function GUIedit_NumSub_Callback(hObject, ~, handles)

    
    % Run 'The number of subframes' edit text box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_editTNofSub(hObject,handles,'Callback');
    
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G U I   -  E D I T   B O X:  I N D E X   O F   T H E   F I R S T   S U B F R A M E

% --- Executes during object creation, after setting all properties.
function GUIedit_FrstSub_CreateFcn(hObject, ~, handles)
    
    % Run 'Index of the first subframe' edit text box service
    % with the 'Create' functionality
    ALGaE_AdvOpt_GUI_editInxFrstSub(hObject,handles,'Create');
end


% --- Executes during edition of the text field.
function GUIedit_FrstSub_Callback(hObject, ~, handles)

    % Run 'Index of the first subframe' edit text box service
    % with the 'Callback' functionality
    ALGaE_AdvOpt_GUI_editInxFrstSub(hObject,handles,'Callback');
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% I N I T I A L I Z E   T H E   V A L U E S

function ALGaE_AdvOpt_init(handles)
%
% Input:
%
%    1. handles -> handles to objects


    %% INITIALIZE THE BANDWIDTH
    ALGaE_AdvOpt_GUI_lbband(NaN,handles,'Initialize');


    %% INITIALIZE THE CYCLIC PREFIX
    ALGaE_AdvOpt_GUI_lbCP(NaN,handles,'Initialize');


    %% INITIALIZE THE IDENTITY NUMBERS

    % Identity number 1
    ALGaE_AdvOpt_GUI_editIdenNum1(NaN,handles,'Initialize');

    % Identity number 2
    ALGaE_AdvOpt_GUI_editIdenNum2(NaN,handles,'Initialize');


    %% INITIALIZE THE NUMBER OF SUBFRAMES    
    ALGaE_AdvOpt_GUI_editTNofSub(NaN,handles,'Initialize');


    %% INITIALIZE INDEX OF THE FIRST SUBFRAME
    ALGaE_AdvOpt_GUI_editInxFrstSub(NaN,handles,'Initialize');

end
