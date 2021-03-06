%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editLastRF: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                 MODULE: LTE PROFESSOR
%
%                                                 SERVICE: EDIT FIELD 'Last Symbol Radio Frame Index'
%                                                 (GUI object: 'Edit_lastRF')
%                                                                                                                            
% File version 1.0 (17th July 2011)
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
%                           - 'Create' (Edit field 'Last Symbol Radio Frame Index')
%
%                           - 'Callback' (Edit field 'Last Symbol Radio Frame Index')
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

function LTE_Professor_editLastRF(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            LastRF_create(hObject);

        % Callback
        case 'Callback'
            LastRF_callback(hObject,handles);
    end
end


%% Service: create 'Edit_lastRF' object
function LastRF_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


%% Service: edit 'Edit_lastRF' object
function LastRF_callback(hObject,handles)
     
     % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the value of index of the last Radio Frame, Radio Slot and 
    % index of a Symbol inside the Radio Slot
    inxLastRF       = getappdata(handles.figure1,'inxLastRF');
    inxLastRS       = getappdata(handles.figure1,'inxLastRS');
    inxLastSymbsRS  = getappdata(handles.figure1,'inxLastSymbsRS');
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strFrst = num2str(inxLastRF);  % Last
        set(hObject,'String',strFrst);
        return;
    end
    
   % Check if the radio frame index value is in the boundaries
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE time configuration structure
        sT = sLTE_DL1.sT;        
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE time configuration
        % structure (structures: 'sT')

        % Get the number of Radio Frames in the transmission
        N_RF = sT.N_RF;
                
        % Get the number of symbols in the transmission
        N_symbTR = sT.N_symbTR;
                
        % Get the number of symbols in the Radio Slot
        N_symbDL = sT.N_symbDL;
        
        % Get the number of symbols in the Radio Frame
        N_symbRF = sT.N_symbRF;        
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -      
    
    inxLastRF = round(inxVal);        
    if inxLastRF < 0    
        inxLastRF = 0;
    end
    
    if inxLastRF > (N_RF - 1)
        inxLastRF = (N_RF - 1);
    end    
    
    % Calculate the current last symbol index and check it's coundaries
    inxLastSymb = inxLastRF*N_symbRF + inxLastRS*N_symbDL + inxLastSymbsRS;
    
    if inxLastSymb > N_symbTR 
        inxLastSymb = N_symbTR;
    end
    
    if inxLastSymb < 9
        inxLastSymb = 9;
    end
    
    % Calculate the current first symbol index
    inxFrstSymb = inxLastSymb - 10 + 1;
    
    % Update the symbols variables
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb);

end
