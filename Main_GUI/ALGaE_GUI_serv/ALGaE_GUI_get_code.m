%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_GUI_get_code: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                           MODULE: MAIN GUI
%                                            
%                                           GUI SERVICES: EDIT FIELD 'Codewords File' 
%                                           GUI SERVICES: PRESS BUTTON 'Browse for Codewords File' 
%                                                                                                                              
% File version 1.0 (14th October 2011)
%                                 
%
%
%% ------------------------------------------------------------------------
% Input:
%       1. hObject:     Variable lenght input argument list.
%
%       2  handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create'      (edit field 'Codewords File')
%
%                           - 'Callback'    (edit field 'Codewords File')
%
%                           - 'PressButton' (press button 'Browse for Codewords File')
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

function ALGaE_GUI_get_code(hObject,handles,strServ)

    % Run the correct service
    switch strServ
        
        % Create
        case 'Create'
            edit_code_create(hObject);
        
        % Callback
        case 'Callback'
            edit_code_callback(hObject,handles);
        
        % Press button    
        case 'PressButton'
            browse_code_press(hObject, handles);
            
    end
end


%% Service: create GUIedit_codewords object (edit field 'Codewords File')
function edit_code_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: callback GUIedit_codewords object (edit field 'Codewords File')
function edit_code_callback(hObject, handles)

    % Get the path to the file
    strPath = get(hObject,'String');
    if iscell(strPath)
        strPath = strPath{1};
    end
    
    % Separate path to directory + filename.ext
    [ strPath strFile strExt ] = fileparts(strPath);
    strFile = strcat(strFile,strExt);
    
    % Run the 'Check the Codewords File' service
    check_code(hObject, handles, strFile, strPath);

end


%% Service: press the GUIedit_codewords button (browse 4 codewords file button )
function browse_code_press(hObject, handles)
 
    % Run the file browser and get the file name
    [ strFile strPath ] = uigetfile();
            
    % Run the 'Check the Codewords File' service
    check_code(hObject, handles, strFile, strPath);
end


%% Service: check the given codewords file 
function check_code(hObject, handles, strFile, strPath)


    %% Load the current LTE scenario structure from the 'handle.figure1' handle
    sScen = getappdata(handles.figure1,'sScen');
    

    %% Check the codewords file

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
            if isfield(sCodeFile,'strCodeFil')

                % Set the current path in the 'GUIedit_code' edit box
                set(handles.GUIedit_codewords,'String',sScen.strCodeFil);
                guidata(hObject, handles);
            else
                % If there is no path in the current LTE scenario file,
                % set the current path in the 'GUIedit_code' edit box to empty
                set(handles.GUIedit_codewords,'String','No codewords file - random');
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
        if isfield(sCodeFile,'strCodeFil')
            
            % Set the current path in the 'GUIedit_code' edit box
            set(handles.GUIedit_codewords,'String',sScen.strCodeFil);
            guidata(hObject, handles);
            
        else
            % If there is no path in the current LTE scenario file,
            % set the current path in the 'GUIedit_code' edit box to empty
            set(handles.GUIedit_codewords,'String','No codewords file - random');
            guidata(hObject, handles);
            
        end
        % ------------------------------------------------------------------------        
        
        return;
    end
    
    % Check if it is a Matlab file, 
    [ ~, ~, strExt ] = fileparts(strFile);
    if ~strcmp(strExt,'.mat')
        
        % Run the error info service            
        waitfor(errordlg('It is not a .mat file!','File error'));

        % ------------------------------------------------------------------------
        % Set text in the edit scenario file field to
        % the previous scenario file:
                
        % Read the current path to the scenario file 
        if isfield(sCodeFile,'strCodeFil')
            
            % Set the current path in the 'GUIedit_code' edit box
            set(handles.GUIedit_codewords,'String',sScen.strCodeFil);
            guidata(hObject, handles);
        else
            % If there is no path in the current LTE scenario file,
            % set the current path in the 'GUIedit_code' edit box to empty
            set(handles.GUIedit_codewords,'String','No codewords file - random');
            guidata(hObject, handles);            
        end
        % ------------------------------------------------------------------------
        
        return;
    end


    %% Change the Edit box with the LTE Scenario file name
    
    % Create the string with file path
    strCodeFil = strcat(strPath,'/',strFile);

    % Set the field
    set(handles.GUIedit_codewords,'String',strCodeFil);
    guidata(hObject, handles);


    %% Store the strCodeFil (string with the path to the file)
    % in the sScen.strCodeFil field
    sScen.strCodeFil = strCodeFil;


    %% Add the codewords file structure to the main GUI handle
    setappdata(handles.figure1,'sScen',sScen);


end


