%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editLastSubc: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                   MODULE: LTE PROFESSOR
%
%                                                   SERVICE: EDIT FIELD 'Last Subcarrier Index'
%                                                   (GUI object: 'Edit_lastSubc')
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
%                           - 'Create' (Edit field 'Last Subcarrier Index')
%
%                           - 'Callback' (Edit field 'Last Subcarrier Index')
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

function LTE_Professor_editLastSubc(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            LastSubc_create(hObject);

        % Callback
        case 'Callback'
            LastSubc_callback(hObject,handles);
    end
end

%% Service: create 'Edit_lastSubc' object
function LastSubc_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
       
end


%% Service: edit 'Edit_lastSubc' object
function LastSubc_callback(hObject,handles)

   % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Change a string into a numeric value 
    inxVal = str2double(strTxt);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the values of last subcarrier indices
    inxLastSub = getappdata(handles.figure1,'inxLastSub');    
 
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string corresponds to a numeric value
    if isnan(inxVal)
        % Restore the previous value
        strLast = num2str(inxLastSub);  % Last
        set(hObject,'String',strLast);
        return;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the subcarrier value is in the boundaries:
    
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
    
    inxLastSub = round(inxVal);        
    if inxLastSub < 24
        inxLastSub = 24;
    end
    
    if inxLastSub > N_scB;
        inxLastSub = N_scB;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Calculate the value of the first shown subcarrier
    inxFrstSub = inxLastSub - 24 + 1;
    
    % Update the subcarrier variables
    LTE_Professor_updateSubc(handles,inxFrstSub,inxLastSub);     
 
end
