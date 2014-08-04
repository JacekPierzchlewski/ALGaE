%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_Options_GUI_edit_for2: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                        STACK:  DOWNLINK,
%                                        MODULE: CHANNELS AND MODULATION,
%                                                OPTIONS
%
%                                      GUI SERVICES: EDIT FIELD 'Format of the 2nd PDCCH channel'
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
%                           - 'Create' (edit field 'Format of the 2nd PDCCH channel')
%
%                           - 'Initialize' (edit field 'Format of the 2nd PDCCH channel')
%
%                           - 'Callback' (edit field 'Format of the 2nd PDCCH channel')
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

function L1a_Options_GUI_edit_for2(hObject, handles, strServ)
    
    % Run the correct service
    switch strServ
        
        % Create the edit text box 'Format of the 2nd PDCCH channel'
        case 'Create'
            edit_for2_create(hObject);
            
        % Initialize the edit text box 'Format of the 2nd PDCCH channel'
        case 'Initialize'
            edit_for2_init(handles);
            
        % Callback the edit text box 'Format of the 2nd PDCCH channel'
        case 'Callback'
            edit_for2_callback(hObject, handles);
    end
end


%% Service: create GUIedit_for2_PDCCH object (text field 'Format of the 2nd PDCCH channel')
function edit_for2_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end     
end



%% Service: initialize GUIedit_for2_PDCCH object (text field 'Format of the 2nd PDCCH channel')
function edit_for2_init(handles)
    
    % GET THE sScen STRUCTURE
    sScen = getappdata(handles.figure1,'sScen');

    % GET THE sL1a SUBSTRUCTURE FROM THE SCENARIO STRUCTURE
    sL1a = sScen.sL1a;
            
    % GET THE NUMBER OF PDCCH CHANNELS
    nPDCCH = sL1a.nPDCCH;
    
    % Edit field: Format of the 2nd Channel
    if nPDCCH < 2
        
        % SHADOW THE EDIT FIELD, DEPENDENTLY ON THE NUMBER OF PDCCH
        % CHANNELS
        set(handles.GUIedit_for2_PDCCH,'Visible','off');
        set(handles.GUItext_for2_PDCCH,'Enable','off');
        set(handles.GUIedit_for2_PDCCH,'String',' ');
    else
        
        % GET THE VECTOR WITH FORMATS OF THE PDCCH CHANNELS
        vPDCCHFor = sL1a.vPDCCHFor;
                        
        % SET UP THE VALUE IN THE EDIT FIELD
        set(handles.GUIedit_for2_PDCCH,'String',num2str(vPDCCHFor(2)));
    end
    % ---------------------------------------
    
end



%% Service: callback GUIedit_for2_PDCCH object (text field 'Format of the 2nd PDCCH channel')
function edit_for2_callback(hObject, handles)

    
    %% GET THE sScen VALUE 
    sScen = getappdata(handles.figure1,'sScen');

    
    %% GET THE sL1a SUBSTRUCTURE FROM THE SCENARIO STRUCTURE
    sL1a = sScen.sL1a;
    

    %% GET THE GIVEN VALUE
    strVal = get(hObject,'String');
    
    % Translate string into int
    iVal = str2double(strVal);


    %% CHECK IF THE VALUE IS CORRECT
    
    % Check if the value is an integer
    iVal_old = iVal;
    iVal = round(iVal);
    if abs(iVal - iVal_old) > 0.000001
        
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sL1a.vPDCCH_Form(2)));
                
        % Put the error box
        waitfor(errordlg('This value must be an integer!','Error!'));
        return;
    end


    % Check if the value is numeric
    if isnan(iVal)

        % Set the previous value in the edit box
        set(hObject,'String',num2str(sL1a.vPDCCH_Form(2)));

        % Put the error box
        waitfor(errordlg('This value must be numeric!','Error!'));
        return;        
    end

    % Check if it is a real value
    if imag(iVal) ~= 0

        % Set the previous value in the edit box
        set(hObject,'String',num2str(sL1a.vPDCCH_Form(2)));

        % Put the error box
        waitfor(errordlg('This value must be a real integer!','Error!'));
        return;                
    end    
        
    % Read the LTE Standard
    sLTE_stand = LTE_stand();
    
    % Get the vector with possible formats of PDCCH Channels
    vPDCCH_Form = sLTE_stand.vPDCCH_Form;
        
    % Check if the value is correct
    if sum(iVal == vPDCCH_Form) == 0

        % Put the error box 
        waitfor(errordlg('The given value is incorrect!','Error!'));
         
        % Set the previous value in the edit box
        set(hObject,'String',num2str(sL1a.vPDCCH_Form(2)))
                        
        return;
    end


    %% CHANGE THE VALUE IN THE sScen STRUCTURE
    
    % ------------------------------------------
    % Locally:
    
    % Assign the correct value in the sScen structure    
    sScen.sL1a.vPDCCHFor(2) = iVal;        
    
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
