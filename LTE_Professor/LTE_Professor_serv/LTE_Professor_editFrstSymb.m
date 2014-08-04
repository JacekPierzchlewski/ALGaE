%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editFrstSymb: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                   MODULE: LTE PROFESSOR
%
%                                                   SERVICE: EDIT FIELD 'First Symbol Index'
%                                                   (GUI object: 'Edit_frstSymbInx')
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
%                           - 'Create' (Edit field 'First Symbol Index')
%
%                           - 'Callback' (Edit field 'First Symbol Index')
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

function LTE_Professor_editFrstSymb(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            FrstSymb_create(hObject);

        % Callback
        case 'Callback'
            FrstSymb_callback(hObject,handles);
    end
end

%% Service: create 'Edit_frstSymbInx' object
function FrstSymb_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% Service: edit 'Edit_frstSymbInx' object
function FrstSymb_callback(hObject,handles)
     
    % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the values of index if first symbol
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');    
 
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strFrst = num2str(inxFrstSymb);  % First
        set(hObject,'String',strFrst);
        return;
    end 
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   %% Check if the symbol index value is in the boundaries
    
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
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -      
    
    inxFrstSymb = round(inxVal);        
    if inxFrstSymb < 0
        inxFrstSymb = 0;
    end
    
    if inxFrstSymb > (N_symbTR - 10)
        inxFrstSymb = (N_symbTR - 10);
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Calculate the value of index of the last shown symbol
    
    % Update the symbols variables
    inxLastSymb = inxFrstSymb + 10 - 1;
    
    % Update the symbols variables
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb);     
    
end
