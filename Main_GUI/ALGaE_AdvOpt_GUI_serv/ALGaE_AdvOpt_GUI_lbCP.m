%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_AdvOpt_GUI_lbCP: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                              MODULE: MAIN GUI, OPTIONS 
%                                                      
%                                              GUI SERVICES: 
%                                                   LIST BOX 'Cyclic Prefix'
%
% File version 1.0 (17th October 2011)
%
%
%% ------------------------------------------------------------------------
% Input:
%       1. hObject:     Handle to the current object.
%
%       2. handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create' (list box 'Cyclic Prefix')
%
%                           - 'Initialize' (list box 'Cyclic Prefix')
%
%                           - 'Callback' (list box 'Cyclic Prefix')
%
% ------------------------------------------------------------------------
% Output:
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


function ALGaE_AdvOpt_GUI_lbCP(hObject,handles,strServ)

    % Run the correct service
    switch strServ

        % Create the edit text box 'list box 'Cyclic Prefix'
        case 'Create'
            lb_CP_create(hObject);

        % Initialize the edit text box 'list box 'Cyclic Prefix'
        case 'Initialize'
            lb_CP_init(handles);

        % Callback the edit text box 'list box 'Cyclic Prefix'
        case 'Callback'
            lb_CP_callback(handles);
    end
end


%% Service: create GUIlb_cp object (list box 'Cyclic Prefix')
function lb_CP_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: initialization of the GUIlb_cp object (list box 'Cyclic Prefix')
function lb_CP_init(handles)

    % Get the sScen scenario structure
    sScen = getappdata(handles.figure1,'sScen');
    
    % Get the Cyclic Prefix from the scenario
    CYCLIC_PRFX = sScen.CYCLIC_PRFX;

    % Read the LTE standard
    sLTE_stand = LTE_stand();

    % Get the supported types of the Cyclic Prefix
    cvCP = sLTE_stand.cvCP;

    % Calculate the index of the Cyclic Prefix
    vInx = (1:size(cvCP))';
    vInx = vInx(strcmp(CYCLIC_PRFX,cvCP));

    % Set the Cyclic Prefix value
    set(handles.GUIlb_cp,'Value',vInx);
end


%% Service: callback of the GUIlb_cp object (list box 'Cyclic Prefix')
function lb_CP_callback(handles)


    %% GET THE CURRENT VALUES OF THE LIST BOX

    % List index
    iInx = get(handles.GUIlb_cp,'Value');

    % List cell
    cL = get(handles.GUIlb_cp,'String');

    % Change the value form the cell to the correct format
    strVal = cL{iInx};


    %% CHANGE THE VALUE IN THE sScen STRUCTURE

    % ------------------------------------------
    % Locally:

    % Get the sScen value
    sScen = getappdata(handles.figure1,'sScen');
    
    % Assign the correct value in the sScen structure    
    sScen.CYCLIC_PRFX = strVal;

    % Store the sScen structure locally
    setappdata(handles.figure1,'sScen',sScen);

    % ------------------------------------------
    % In the main window:

    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');

    % Store the sScen strucutre in the mother window
    setappdata(hMother.figure1,'sScen',sScen); 
end

