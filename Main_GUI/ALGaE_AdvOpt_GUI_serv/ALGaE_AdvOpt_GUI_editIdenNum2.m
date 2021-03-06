%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_AdvOpt_GUI_editIdenNum2: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                      MODULE: MAIN GUI, OPTINOS
%                                                              
%                                                      GUI SERVICES: 
%                                                           EDIT FIELD 'Identity number 2'
%
% File version 1.0 (17th October 2011)
%                                 
%
%% ------------------------------------------------------------------------
% Input:
%       1. hObject:     Handle to the current object.
%
%       2  handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create' (edit text 'Identity number 2')
%
%                           - 'Initialize' (edit text 'Identity number 2')    
%
%                           - 'Callback' (edit text 'Identity number 2')
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

function ALGaE_AdvOpt_GUI_editIdenNum2(hObject, handles, strServ)
 
    % Run the correct service
    switch strServ
                
        % Create the text edit box 'Identity number 2'
        case 'Create'
            edit_IdenNum2_create(hObject);
            
        % Initialize the text edit box 'Identity number 2'
        case 'Initialize'
            edit_IdenNum2_init(handles);

        % Callback the text edit box 'Identity number 2'
        case 'Callback'
            edit_IdenNum2_callback(hObject, handles);
    end
end


%% Service: create GUIedit_IdenNum2 object (list box 'Identity number 2')
function edit_IdenNum2_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: initialize GUIedit_IdenNum2 object (list box 'Identity number 2')
function edit_IdenNum2_init(handles)

    % Get the sScen scenario structure
    sScen = getappdata(handles.figure1,'sScen');
    
    % Initialize the correct value
    set(handles.GUIedit_IdenNum2,'String',num2str(sScen.N_ID2));
end


%% Service: callback of the GUIedit_IdenNum2 object (list box 'Identity number 2')
function edit_IdenNum2_callback(hObject, handles)


    %% GET THE sScen VALUE 
    sScen = getappdata(handles.figure1,'sScen');


    %% GET THE GIVEN VALUE
    strVal = get(hObject,'String');
    
    % Translate string into int
    iVal = str2double(strVal);
        
    
    %% CHECK IF THE VALUE IS CORRECT
            
    % Read the LTE standard
    sLTE_stand = LTE_stand();
        
    % Get the minimum and maximum values of the Identity Number 2
    N_id2_min = sLTE_stand.N_id2_min;       % Minimum value
    N_id2_max = sLTE_stand.N_id2_max;       % Maximum value    
    
    
    % Check if the value is an integer
    iVal_old = iVal;
    iVal = round(iVal);
    if abs(iVal - iVal_old) > 0.000001
        
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sScen.N_ID2));
                
        % Put the error box
        waitfor(errordlg('This value must be an integer!','Error!'));
        return;
    end
    
    % Check if this value is numeric
    if isnan(iVal)
        
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sScen.N_ID2));
                
        % Put the error box
        waitfor(errordlg('This value must be an integer!','Error!'));
        return;        
    end

    % Check if the value is a real integer
    if imag(iVal) ~= 0
        
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sScen.N_ID2));
                
        % Put the error box
        waitfor(errordlg('This value must be a real integer!','Error!'));
        return;                
    end
    
    
    % Check if the value is correct
    if iVal > N_id2_max  || iVal < N_id2_min
        
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sScen.N_ID2));
                        
        % Put the error box 
        waitfor(errordlg('The given value is incorrect!','Error!'));
        return
    end

    
    %% CHANGE THE VALUE IN THE sScen STRUCTURE
    
    % ------------------------------------------
    % Locally:
    
    % Assign the correct value in the sScen structure    
    sScen.N_ID2 = iVal;        
    
    % Store the sScen structure locally
    setappdata(handles.figure1,'sScen',sScen);
            
    % ------------------------------------------
    % In the main window:
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Store the sScen structure in the mother window
    setappdata(hMother.figure1,'sScen',sScen);       
    
    
    %% CHANGE THE VALUE IN THE EDIT BOX
    
    % Change from int into the string
    strVal = num2str(iVal);

    % Set the value 
    set(hObject,'String',strVal);
    
end
