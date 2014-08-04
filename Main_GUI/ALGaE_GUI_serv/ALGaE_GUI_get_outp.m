%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_GUI_get_outp: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                           MODULE: MAIN GUI
%                                            
%                                           GUI SERVICES: EDIT FIELD 'Output File' 
%                                           GUI SERVICES: PRESS BUTTON 'Browse for Output File' 
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
%                           - 'Create'      (edit field 'Output File')
%
%                           - 'Callback'    (edit field 'Output File')
%
%                           - 'PressButton' (press button 'Browse for Output File')
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

function ALGaE_GUI_get_outp(hObject,handles,strServ)

    % Run the correct service
    switch strServ
        
        % Create
        case 'Create'
            edit_outp_create(hObject);
            
            
        % Callback
        case 'Callback'
            edit_outp_callback(hObject,handles);
            
            
        % Press button    
        case 'PressButton'
            browse_outp_press(hObject, handles);
    end
end


%% Service: create GUIedit_output object (edit field 'Output File')
function edit_outp_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: callback GUIedit_output object (edit field 'Output File')
function edit_outp_callback(hObject, handles)

    % Get the path to the file
    strPath = get(hObject,'String');
    if iscell(strPath)
        strPath = strPath{1};
    end
    
    % Separate path to directory + filename.ext
    [ strPath strFile strExt ] = fileparts(strPath);
    strFile = strcat(strFile,strExt);
    
    % Run the 'Check the Output File' service
    check_outp(hObject, handles, strFile, strPath);

end


%% Service: press the GUIpb_output button (browse 4 scenario file button )
function browse_outp_press(hObject, handles)

    % Run the file browser and get the file name
    [ strFile strPath ] = uiputfile();

    % Run the 'Check the Output File' service
    check_outp(hObject, handles, strFile, strPath);

end


%% Service: check the given output file 
function check_outp(hObject, handles, strFile, strPath)


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
            % Set text in the edit output file field to
            % the previous scenario file:

            % Read the current path to the output file 
            if isfield(sScen,'strOutFil')

                % Set the current path in the 'GUIedit_output' edit box
                set(handles.GUIedit_output,'String',sScen.strOutFil);
                guidata(hObject, handles);
                
            else
                
                % If there is no path in the current LTE output file,
                % set the current path in the 'GUIedit_output' edit box to empty
                set(handles.GUIedit_output,'String','No output file!');
                guidata(hObject, handles);
                
            end
            % ------------------------------------------------------------------------
            
            return;
        end
    end
    
    
    % Check if it is a .mat file, 
    [ ~, ~, strExt ] = fileparts(strFile);
    if ~strcmp(strExt,'.mat')
        
        % Run the error info service            
        waitfor(errordlg('It is not a .mat file!','File error'));

        % ------------------------------------------------------------------------
        % Set text in the edit scenario file field to
        % the previous scenario file:

        % Read the current path to the scenario file 
        if isfield(sScen,'strOutFile')
            
            % Set the current path in the 'GUIedit_output' edit box
            set(handles.GUIedit_output,'String',sScen.strOutFil);
            guidata(hObject, handles);

        else
            fprintf('Here!\n');
            % If there is no path in the current LTE output file,
            % set the current path in the 'GUIedit_output' edit box to empty
            set(handles.GUIedit_output,'String','No output file!');
            guidata(hObject, handles); 
            
        end
        % ------------------------------------------------------------------------
        
        return;
    end

    %% Change the Edit box with the LTE output file name

    % Create the string with file path
    strOutFil = strcat(strPath,'/',strFile);

    % Set the field
    set(handles.GUIedit_output,'String',strOutFil);
    guidata(hObject, handles);

    
    %% Store the strOutFil (string with the path to the file)
    % in the scenario structure (sScen)
    sScen.strOutFil = strOutFil;


    %% Add the scenario structure to the main GUI handle
    setappdata(handles.figure1,'sScen',sScen);

end

