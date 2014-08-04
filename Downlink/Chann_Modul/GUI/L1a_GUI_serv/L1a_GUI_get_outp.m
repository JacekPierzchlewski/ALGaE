%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_get_outp: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                               STACK:  DOWNLINK,
%                               MODULE: CHANNELS AND MODULATION
%
%                               GUI SERVICES: EDIT FIELD 'Output File' 
%                               GUI SERVICES: PRESS BUTTON 'Browse for Output File' 
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
%                           - 'Create' (edit field 'Output File')
%
%                           - 'Callback' (edit field 'Output File')
%
%                           - 'PressButton' (press button 'Browse for Output File')
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

function L1a_GUI_get_outp(hObject, handles, strServ)

    % Run the correct service
    switch strServ
        
        % Create the edit text box 'output file'
        case 'Create'
            edit_outp_create(hObject);
            
        % Callback the edit text box 'output file'
        case 'Callback'
            edit_outp_callback(hObject,handles);
        
        % Press button 'Browse for output file'   
        case 'PressButton'
            browse_outp_press(handles);
    end
end


%% Service: create GUIedit_outp object (edit field 'Output File')
function edit_outp_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: callback GUIedit_outp object (edit field 'Output File')
function edit_outp_callback(hObject,handles)

    % Load the current LTE scenario structure from the 'handle.figure1' handle    
    sScen = getappdata(handles.figure1,'sScen');
    
    % Get the file path from the edit box 'GUIedit_outp'
    strPath = get(hObject,'String');
    if iscell(strPath)
        strPath = strPath{1};
    end
    % ---------------------------------------------------------------
    
    % Check if the file path is not empty
    if isempty(strPath)     
        
        % Return to the previous path, if such exists
        if isfield(sScen,'strOutFile')
            set(hObject,'String',sScen.strOutFil);
        end
        
        return;
    end
    
    % Separate the path into file parts
    [ strDir , ~, strExt ] = fileparts(strPath);
    
    % Check if the directory exists    
    if exist(strDir,'file') ~= 7

        % Return to the previous path, if such exists
        if isfield(sScen,'strOutFile')
            set(hObject,'String',sScen.strOutFil);
        else
            set(hObject,'String','');
        end

        % Run the error info service        
        strMessage = sprintf('%s directory not found!',strDir);        
        waitfor(errordlg(strMessage,'File error'));
        return;                
    end
        
    % Check if it is a .mat file
    if strcmp(strExt,'.mat') == 0

        % Return to the previous path, if such exists
        if isfield(sScen,'strOutFile')
            set(hObject,'String',sScen.strOutFil);
        else
            set(hObject,'String','');
        end

        % Run the error info service        
        waitfor(errordlg('It must be a .mat file!','File error'));
        return;                
    end
    
    % Store the string value in the current scenario structure
    sScen.strOutFil = strPath;

    % Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle
    setappdata(handles.figure1,'sScen',sScen);
    % ---------------------------------------------------------------


    %% Change the LTE output file in the parent window
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Set the scenario structure in the mother widnow
    setappdata(hMother.figure1,'sScen',sScen);
    
    
end


%% Service: press the GUIpb_brwsOutp button (browse 4 output file button )
function browse_outp_press(handles)

    % Open the 'put file' dialog
    [ strFile strPath ]= uiputfile();
    
    % Check if the 'cancel' was not pressed
    if isnumeric(strFile) || isnumeric(strPath)
        return;
    end
    
    % ---------------------------------------------------------------
    
    % Concatenate the strFile and strPath into one file name
    strOutFile = strcat(strPath,strFile);
    
    % ---------------------------------------------------------------
    
    % Divide the output file name into the file name parts
    [ ~ , ~, strExt ] = fileparts(strOutFile);
    
    % Check if it is a .mat file
    if ~strcmp(strExt,'.mat')
        
        % Run the error info service        
        waitfor(errordlg('It must be a .mat file!','File error'));
        return;
    end

    % ---------------------------------------------------------------
    
    % Put the file name into the output file editbox
    set(handles.GUIedit_outp,'String',strOutFile);

    % ---------------------------------------------------------------
    
    % Load the current LTE scenario structure from the 'handle.figure1' handle    
    sScen = getappdata(handles.figure1,'sScen');
    
    % Store the string value in the current scenario structure
    sScen.strOutFil = strOutFile;

    % Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle
    setappdata(handles.figure1,'sScen',sScen);


    %% Change the LTE output file in the parent window
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Set the scenario structure in the mother widnow
    setappdata(hMother.figure1,'sScen',sScen);    
end




