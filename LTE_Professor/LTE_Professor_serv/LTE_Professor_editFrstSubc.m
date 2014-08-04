%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editFrstSubc: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                   MODULE: LTE PROFESSOR
% 
%                                                   SERVICE: EDIT FIELD 'First Subcarrier Index'
%                                                   (GUI object: 'Edit_frstSubc')
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
%                           - 'Create' (Edit field 'First Subcarrier Index')
%
%                           - 'Callback' (Edit field 'First Subcarrier Index')
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

function LTE_Professor_editFrstSubc(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            FrstSubc_create(hObject);

        % Callback
        case 'Callback'
            FrstSubc_callback(hObject,handles);
    end
end

%% Service: create 'Edit_frstSubc' object
function FrstSubc_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%% Service: edit 'Edit_frstSubc' object
function FrstSubc_callback(hObject,handles)
     
    % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the values of last subcarrier indices
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');    
 
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strFrst = num2str(inxFrstSub);  % First
        set(hObject,'String',strFrst);
        return;
    end 
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the subcarrier value is in the boundaries
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE bandwidth configuration structure
        sF = sLTE_DL1.sF;        
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE bandwidth configuration
        % structure (structures: 'sF')

        % Get the number of subcarriers
        N_scB = sF.N_scB;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -                  
    
    inxFrstSub = round(inxVal);        
    if inxFrstSub < 1
        inxFrstSub = 1;
    end
    
    if inxFrstSub > (N_scB - 24 + 1)
        inxFrstSub = (N_scB - 24 + 1);
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Calculate the value of the last shown subcarrier
    inxLastSub = inxFrstSub + 24 - 1;
    
    % Update the subcarrier variables
    LTE_Professor_updateSubc(handles,inxFrstSub,inxLastSub);

end
