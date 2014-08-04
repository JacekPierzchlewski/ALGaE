%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editFrstRS: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                 MODULE: LTE PROFESSOR
%
%                                                 SERVICE: EDIT FIELD 'First Symbol Radio Slot Index'
%                                                 (GUI object: 'Edit_frstRS')
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
%                           - 'Create' (Edit field 'First Symbol Radio Slot Index')
%
%                           - 'Callback' (Edit field 'First Symbol Radio Slot Index')
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

function LTE_Professor_editFrstRS(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            FrstRS_create(hObject);

        % Callback
        case 'Callback'
            FrstRS_callback(hObject,handles);
    end
end


%% Service: create 'Edit_frstRS' object
function FrstRS_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


%% Service: edit 'Edit_frstRS' object
function FrstRS_callback(hObject,handles)
     
    % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the value of index of the first Radio Frame, Radio Slot and 
    % index of a Symbol inside the Radio Slot
    inxFrstRF       = getappdata(handles.figure1,'inxFrstRF');
    inxFrstRS       = getappdata(handles.figure1,'inxFrstRS');
    inxFrstSymbsRS  = getappdata(handles.figure1,'inxFrstSymbsRS');
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strFrst = num2str(inxFrstRS);  % Last
        set(hObject,'String',strFrst);
        return;
    end
    
   % Check if the radio slot index value is in the boundaries
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE time configuration structure
        sT = sLTE_DL1.sT;        
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE time configuration
        % structure (structures: 'sT')
                
        % Get the number of symbols in the transmission
        N_symbTR = sT.N_symbTR;
                
        % Get the number of symbols in the Radio Slot
        N_symbDL = sT.N_symbDL;
        
        % Get the number of symbols in the Radio Frame
        N_symbRF = sT.N_symbRF;        
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                  
        
    inxFrstRS = round(inxVal);        
    if inxFrstRS < 0
        inxFrstRS = 0;
    end
    
    if inxFrstRS > N_symbRF/N_symbDL
        inxFrstRS = N_symbRF/N_symbDL;
    end    
    
    % Calculate the current first symbol index and check it's boundaries
    inxFrstSymb = inxFrstRF*N_symbRF + inxFrstRS*N_symbDL + inxFrstSymbsRS;
    
    if inxFrstSymb > N_symbTR - 9 
        inxFrstSymb = N_symbTR - 9;
    end
    
    if inxFrstSymb < 0
        inxFrstSymb = 0;
    end
    
    % Calculate the current last symbol index
    inxLastSymb = inxFrstSymb + 10 - 1;
    
    % Update the symbols variables
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb);  
end
