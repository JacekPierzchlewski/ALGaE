%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_AdvOpt_GUI_lbband: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                MODULE: MAIN GUI, OPTIONS
%                                            
%                                                GUI SERVICES: 
%                                                   LIST BOX 'Bandwidth'
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
%                           - 'Create' (list box 'Bandwidth')
%
%                           - 'Initialize' (list box 'Bandwidth')
%
%                           - 'Callback' (list box 'Bandwidth')
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

function ALGaE_AdvOpt_GUI_lbband(hObject,handles,strServ)

    % Run the correct service
    switch strServ

        % Create the edit text box list box 'Bandwidth'
        case 'Create'
            lb_band_create(hObject);

        % Initialize the edit text box list box 'Bandwidth'
        case 'Initialize'
            lb_band_init(handles);

        % Callback the edit text box list box 'Bandwidth'
        case 'Callback'
            lb_band_callback(handles);
    end
end


%% Service: create GUIlb_band object (list box 'Bandwidth')
function lb_band_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: initialization of the GUIlb_band object (list box 'Bandwidth')
function lb_band_init(handles)

    % Get the sScen scenario structure
    sScen = getappdata(handles.figure1,'sScen');

    % Get the Bandwidth from the scenario
    BANDWIDTH = sScen.BANDWIDTH;
        
    % Read the LTE standard
    sLTE_stand = LTE_stand();

    % Get the supported types of the Bandwidth
    cvBW_channel = sLTE_stand.cvBW_channel;
    
    % Calculate the index of the Bandwidth
    vInx = (1:size(cvBW_channel))';
    vInx = vInx(strcmp(BANDWIDTH,cvBW_channel));
    
    % Set the Bandwidth value
    set(handles.GUIlb_band,'Value',vInx);
end


%% Service: callback of the GUIlb_band object (list box 'Bandwidth')
function lb_band_callback(handles)


    %% GET THE CURRENT VALUES OF THE LIST BOX
     
    % List index
    iInx = get(handles.GUIlb_band,'Value');
     
    % List cell
    cL = get(handles.GUIlb_band,'String');
     
    % Change the value form the cell to the correct format
    strVal = cL{iInx};
    iVal = sscanf(strVal,'%f');
    strVal = num2str(iVal);
        
    if sum(strVal == '.') == 0
        strVal = sprintf('%s.0',strVal);
    end

    
    %% CHANGE THE VALUE IN THE sScen STRUCTURE
    
    % ------------------------------------------
    % Locally:
    
    % Get the sScen value
    sScen = getappdata(handles.figure1,'sScen');
    
    % Assign the correct value in the sScen structure    
    sScen.BANDWIDTH = strVal;        
    
    % Store the sScen structure locally
    setappdata(handles.figure1,'sScen',sScen);
            
    % ------------------------------------------
    % In the main window:
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Store the sScen strucutre in the mother window
    setappdata(hMother.figure1,'sScen',sScen);
end

