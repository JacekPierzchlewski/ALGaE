%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_get_nsf: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                              STACK:  DOWNLINK,
%                              MODULE: CHANNELS AND MODULATION
%
%                              GUI SERVICES: EDIT FIELD 'The number of Suframes' 
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
%                           - 'Create' (edit field 'The number of Radio Frames')
%
%                           - 'Callback' (edit field 'The number of Radio Frames')
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

function L1a_GUI_get_nsf(hObject,handles, strServ)

    % Run the correct service
    switch strServ
        
        % Create the edit text box 'the number of radio frames'
        case 'Create'
            edit_nrf_create(hObject);
            
        % Callback the edit text box 'the number of radio frames'
        case 'Callback'
            edit_nrf_callback(hObject,handles);
        
    end
end


%% Service: create GUIedit_RF object (edit field 'The number of Subframes')
function edit_nrf_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

end


%% Service: callback GUIedit_RF object (edit field 'The number of subframes')
function edit_nrf_callback(hObject,handles)

    % Load the current LTE scenario structure from the 'handle.figure1' handle
    sScen = getappdata(handles.figure1,'sScen');

    % Get the string from the edit 
    strNSF = get(hObject,'String');

    % Change it into numeric value
    nSF = str2double(strNSF);

    % If the vaue is not correct, restore the current number of radio
    % frames
    if isnan(nSF)
        set(hObject,'String',sScen.N_SF);
        return;
    end

    % Check if it is the number of subframes is an integer.
    % If not, print out the error and restore the previous value.
    if abs(round(nSF) - nSF) > 0
        waitfor(errordlg('The number of Subframes must be an integer!','Wrong number'));
        set(hObject,'String',sScen.N_SF);
        return;
    end

    % Check if the value is correct (bigger or equal to 1).
    % If not, print out the error and restore the previous value.
    if nSF < 1
        waitfor(errordlg('The number of Subframes must be higer than 1!','Wrong number'));
        set(hObject,'String',sScen.N_SF);
        return;
    end

    % ----------------------------------------------------
    
    % Put the value to the current LTE scenario structure
    sScen.N_SF = nSF;

    % Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle
    setappdata(handles.figure1,'sScen',sScen);
    
    % ----------------------------------------------------
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Save the LTE scenario structure in the mother window
    setappdata(hMother.figure1,'sScen',sScen);

end

