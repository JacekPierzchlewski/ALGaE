%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_get_scen: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                               STACK:  DOWNLINK,
%                               MODULE: CHANNELS AND MODULATION
%
%                               GUI SERVICES: EDIT FIELD 'Scenario File' 
%                               GUI SERVICES: PRESS BUTTON 'Browse for Scenario File' 
%                                        
% File version 1.0 (14th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input (3):
%
%       1. hObject:     Handle to the current object.
%
%       2  handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create' (edit field 'Scenario File')
%
%                           - 'Callback' (edit field 'Scenario File')
%
%                           - 'PressButton' (press button 'Browse for Scenario File')
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

function L1a_GUI_get_scen(hObject, handles, strServ)

    % Run the correct service
    switch strServ
        
        % Create the edit text box 'scenario file'
        case 'Create'
            edit_scen_create(hObject,handles);
            
        % Callback the edit text box 'scenario file'
        case 'Callback'
            edit_scen_callback(hObject, handles);
        
        % Press button 'Browse for scenario file'   
        case 'PressButton'
            browse_scen_press(hObject, handles);
    end
end


%% Service: create GUIedit_scen object (edit field 'Scenario File')
function edit_scen_create(hObject,~)


    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
        
end


%% Service: callback GUIedit_scen object (edit field 'Scenario File')
function edit_scen_callback(hObject, handles)

    % Get the path to the file
    strPath = get(hObject,'String');
    if iscell(strPath)
        strPath = strPath{1};
    end
    
    % Separate path to directory + filename.ext
    [ strPath strFile strExt ] = fileparts(strPath);
    strFile = strcat(strFile,strExt);
    
    % Run the 'Check the Scenario File' service
    check_scen(hObject, handles, strFile, strPath);

end


%% Service: press the GUIpb_brwsScen button (browse 4 scenario file button )
function browse_scen_press(hObject, handles)
 
    % Run the file browser and get the file name
    [ strFile strPath ] = uigetfile();
            
    % Run the 'Check the Scenario File' service
    check_scen(hObject, handles, strFile, strPath);
end


%% Service: check the given scenario file 
function check_scen(hObject, handles, strFile, strPath)


    %% Load the current LTE scenario structure from the 'handle.figure1' handle    
    sScen = getappdata(handles.figure1,'sScen');
     
    %% Check the scenario file

    % Check if the file path was correctly given
    % (the cancel button was not pressed)
    if isnumeric(strFile) || isnumeric(strPath)
        return;
    end
        
    
    % Chop the eventual '/' from the end of path and add the '/' to the
    % beggining
    if ~isempty(strPath)
        
        % Add the / to the beginning
        if ~strcmp(strPath(1),'/')
            strPath = strcat('/',strPath);
        end        
        
        % Chop the / from the end
        if strcmp(strPath(end),'/')
            strPath = strPath(1:(end-1));
        end        
    end
    
        
    % Check if the directory exist
    if ~isempty(strPath)
        if ~exist(strPath,'dir')

            % Run the error info service            
            waitfor(errordlg('The directory does not exist!','No directory'));
            
            % ------------------------------------------------------------------------
            % Set text in the edit scenario file field to
            % the previous scenario file:

            % Read the current path to the scenario file 
            if isfield(sScen,'strScenFil')

                % Set the current path in the 'GUIedit_scen' edit box
                set(handles.GUIedit_scen,'String',sScen.strScenFil);
                guidata(hObject, handles);
            else
                % If there is no path in the current LTE scenario file,
                % set the current path in the 'GUIedit_scen' edit box to empty
                set(handles.GUIedit_scen,'String',' ');
                guidata(hObject, handles);            
            end
            % ------------------------------------------------------------------------                        
            return;
        end
    end
    
    % Check if the file exists
    strFulFile = strcat(strPath,'/',strFile); % Create the full path to the file            
    if exist(strFulFile,'file') ~= 2
        
        % Run the error info service            
        waitfor(errordlg('The file does not exist!','No file'));
         
        
        % ------------------------------------------------------------------------
        % Set text in the edit scenario file field to
        % the previous scenario file:
                
        % Read the current path to the scenario file 
        if isfield(sScen,'strScenFil')
            
            % Set the current path in the 'GUIedit_scen' edit box
            set(handles.GUIedit_scen,'String',sScen.strScenFil);
            guidata(hObject, handles);
            
        else
            % If there is no path in the current LTE scenario file,
            % set the current path in the 'GUIedit_scen' edit box to empty
            set(handles.GUIedit_scen,'String',' ');
            guidata(hObject, handles);
            
        end
        % ------------------------------------------------------------------------        
        
        return;
    end
    
    % Check if it is a Matlab file, 
    [ ~, ~, strExt ] = fileparts(strFile);
    if ~strcmp(strExt,'.m')
        
        % Run the error info service            
        waitfor(errordlg('It is not a MATLAB file!','File error'));

        % ------------------------------------------------------------------------
        % Set text in the edit scenario file field to
        % the previous scenario file:
                
        % Read the current path to the scenario file 
        if isfield(sScen,'strScenFil')
            
            % Set the current path in the 'GUIedit_scen' edit box
            set(handles.GUIedit_scen,'String',sScen.strScenFil);
            guidata(hObject, handles);
        else
            % If there is no path in the current LTE scenario file,
            % set the current path in the 'GUIedit_scen' edit box to empty
            set(handles.GUIedit_scen,'String',' ');
            guidata(hObject, handles);            
        end
        % ------------------------------------------------------------------------
        
        return;
    end
    
    
    %% Check if the LTE scenario file is correct
    
    % Run the check scenario file ('chcScenFil_DL1') function
    [ sScenFile strErr ] = chc_ScenFil_DL1a(strFile,strPath);
    % sScenFile - scenario from the file
    
    % If the LTE file is not correct, 
    % print out the error
    if isfield(sScenFile,'bError')
                
        % Run the error info service            
        waitfor(errordlg(strErr,'File error'));
        
        % ------------------------------------------------------------------------
        % Set text in the edit scenario file field to
        % the previous scenario file:
        
       
        % Read the current path to the scenario file 
        if isfield(sScen,'strScenFil')
            
            % Set the current path in the 'GUIedit_scen' edit box
            set(handles.GUIedit_scen,'String',sScen.strScenFil);
            guidata(hObject, handles);
        else
            % If there is no path in the current LTE scenario file,
            % set the current path in the 'GUIedit_scen' edit box to empty
            set(handles.GUIedit_scen,'String',' ');
            guidata(hObject, handles);            
        end
        % ------------------------------------------------------------------------
        
        return;
    end
    

    %% Set the 'Value' field int the 'GUIlb_band' edit box (Bandwidth)
        
    % Read the LTE Standard file
    sLTE_stand = LTE_stand();
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD
    % (structures: 'sLTE_stand'):
    
        % The cell with channel bandwidth configuration names
        cvBW    = sLTE_stand.cvBW_channel;
    
        % The cell with cyclic prefix configuration names
        cvCP    = sLTE_stand.cvCP;
            
    %----------------------------------------------------------     
    
    
    % Get the BANDWIDTH field from the LTE scenario structure
    strBand  = sScenFile.BANDWIDTH;
    
    % Get the correct number which indicates the correct bandwidth
    vInx = (1:size(cvBW,1))';    
    iInx = vInx(strcmp(strBand,cvBW));
    
    % Check if the given bandwidth was correct
    if isempty(iInx)
        
        % Unknown bandwidth:
                
        % Run the error service                
        strErr = sprintf('>> %s <<: unknown bandwidth.',strBand);
        waitfor(errordlg(strErr,'Error'));
        return;
        
    else
        
        % Set the value in the 'GUIlb_band' edit box
        set(handles.GUIlb_band,'Value',iInx);
        guidata(hObject, handles);
        
    end

    %% Set the 'Value' field int the 'GUIlb_cp' edit box (Cyclic Prefix)

    % Get the CYCLIC_PRFX field from the LTE scenario structure
    strCP  = sScenFile.CYCLIC_PRFX;
        
    % Get the correct number which indicates the correct cyclix prefix
    vInx = (1:size(cvCP,1))';    
    iInx = vInx(strcmp(strCP,cvCP));
    
    % Check if the given Cyclic Prefix was correct
    if isempty(iInx)
        
        % Unknown Cyclic Prefix:
        
        % Run the error service                
        strErr = sprintf('>> %s <<: unknown Cyclic Prefix.',strCP);
        waitfor(errordlg(strErr,'Error'));
        return;
        
    else
        
        % Set the value in the 'GUIlb_cp' edit box
        set(handles.GUIlb_cp,'Value',iInx);
        guidata(hObject, handles);

    end
     
    %% Set the value field in the 'GUIedit_RF' edit box (The number of SubFrames)
    
    % Get the N_RF field from the LTE scenario structure
    N_SF  = sScenFile.N_SF;
    
    % Check if the given number os correct
    if isnumeric(N_SF)
        
        % Set the value in the 'GUIedit_RF' edit box
        set(handles.GUIedit_RF,'String',num2str(N_SF));
        guidata(hObject, handles);        
    else
        
        % Run the error service                        
        waitfor(errordlg('The number of Radio Frames is incorrect!','Error'));
        return;        
    end
    
    %% Copy values from the 'sScenFile' strucutre into the 'sScen' structure
    
    % Get the names of the fields in the sScenFile strucutre
    cF = fieldnames(sScenFile);
    
    % Get the number of fields in the sScenFile strucutre
    nF = size(cF,1);
    
    % Loop over all fields in the sScenFile structure
    for inxF=1:nF
        sScen.(cF{inxF}) = sScenFile.(cF{inxF});
    end
    

    %% Set the 'String' field int the 'GUIedit_scen' edit box
    
    % Concatenate the Path Name and the File Name 
    % in the 'GUIedit_scen' edit box
    strFullPath = strcat(strPath,'/',strFile);
     
    % Set the string value in the 'GUIedit_scen' oject
    set(handles.GUIedit_scen,'String',strFullPath);
    guidata(hObject, handles);

    
    %% Set the 'strScenFil' field in the current LTE scenario structure
    sScen.strScenFil = strFullPath;    
    
    %% Clear the bEmpty field in the sScen strucutre
    sScen.bEmpty = 0;
    
    %% Clear the 'bGenerated' field in the sScen strucutre
    sScen.bGenerated = 0;
    
    %% Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle
    setappdata(handles.figure1,'sScen',sScen);


    %% Change the LTE scenario structure in the parent window
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Set the scenario structure in the mother widnow
    setappdata(hMother.figure1,'sScen',sScen);
    
                
    %% Unblock the Bandwidth (GUIlb_band), Cyclic Prefix (GUIlb_cp) list boxes, if these were blocked
    if strcmp(get(handles.GUIlb_band,'Enable'),'off')
        set(handles.GUIlb_band,'Enable','on');
    end
    
    if strcmp(get(handles.GUIlb_cp,'Enable'),'off')
        set(handles.GUIlb_cp,'Enable','on');
    end                
    
    %% Unblock the number of Subframes if these were blocked
    if strcmp(get(handles.GUIedit_RF,'Enable'),'off')
        set(handles.GUIedit_RF,'Enable','on');
    end
            
    
    
end

