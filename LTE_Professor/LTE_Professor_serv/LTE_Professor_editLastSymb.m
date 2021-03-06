%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editLastSymb: : THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                     MODULE: LTE PROFESSOR
%
%                                                     SERVICE: EDIT FIELD 'Last Symbol Index'
%                                                     (GUI object: 'Edit_lastSymbInx')
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
%                           - 'Create' (Edit field 'Last Symbol Index')
%
%                           - 'Callback' (Edit field 'Last Symbol Index')
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

function LTE_Professor_editLastSymb(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            LastSymb_create(hObject);

        % Callback
        case 'Callback'
            LastSymb_callback(hObject,handles);
    end
end


%% Service: create 'Edit_lastSymbInx' object
function LastSymb_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end


%% Service: edit 'Edit_lastSymbInx' object
function LastSymb_callback(hObject,handles)
     
   % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the values of index if first symbol
    inxLastSymb = getappdata(handles.figure1,'inxLastSymb');    
 
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strLast = num2str(inxLastSymb);  % Last
        set(hObject,'String',strLast);
        return;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

   % Check if the symbol index value is in the boundaries
    
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
    
    inxLastSymb = round(inxVal);        
    if inxLastSymb < 9
        inxLastSymb = 9;
    end
    
    if inxLastSymb > N_symbTR - 1
        inxLastSymb = N_symbTR - 1;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Calculate the value of index of the first shown symbol
    inxFrstSymb = inxLastSymb - 10 + 1;
    
    % Update the subcarrier variables
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb);    
    
end
