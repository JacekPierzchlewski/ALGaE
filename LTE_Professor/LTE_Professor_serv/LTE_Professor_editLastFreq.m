%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editLastFreq: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                   MODULE: LTE PROFESSOR
%
%                                                   SERVICE: EDIT FIELD 'Last Subcarrier Frequency'
%                                                   (GUI object: 'Edit_lastFreq')
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
%                           - 'Create' (Edit field 'Last Subcarrier Frequency')
%
%                           - 'Callback' (Edit field 'Last Subcarrier Frequency')
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

function LTE_Professor_editLastFreq(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            LastFreq_create(hObject);

        % Callback
        case 'Callback'
            LastFreq_callback(hObject,handles);
    end
end

%% Service: create 'Edit_lastFreq' object
function LastFreq_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
       
end

%% Service: edit 'Edit_lastFreq' object
function LastFreq_callback(hObject,handles)

    % Get the string value from the edit text field
    strTxt = get(hObject,'String');

    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Get the current value of the first subcarrier frequency
    fLastSub = getappdata(handles.figure1,'fLastSub');    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string is correct. Correct strinf formats:
    % >> val << or >> val [kHz] << or >> val [MHz] <<
    
    % Read the string
    vScan = sscanf(strTxt,'%f %s');
    
    % If the vector is empty, it is an error
    if isempty(vScan)
        % Restore the previous value        
        strLastF = sprintf('%.2f [kHz]',fLastSub/1e3);  % First
        set(hObject,'String',strLastF);
        return;
    end
    
    % Store the first scanned value as a frequency
    fLastSub_ = vScan(1);
    
    
    % If there more then one value in a vector, check if the string which
    % creates the rest of values is equal to:
    % '[kHz]' or '[MHz]' or [Hz] or 'kHz' or 'MHz' or 'Hz'        
    if size(vScan,1) > 1        
        
        % Reset the error flag
        bError = 1;
        
        
        % Get the rest of the scanned values
        vScan = vScan(2:end);
        
        % If size is equal to 5, it can be '[kHz]' or '[MHz]'
        if size(vScan,1) == 5
            % Check if the string is equal to [kHz]
            if (vScan(1) == '[' && vScan(2) == 'k' && vScan(3) == 'H' && vScan(4) == 'z' && vScan(5) == ']') 
                bError = 0;
                iUnit = 1e3;
            end

            % Check if the string is equal to [MHz]
            if (vScan(1) == '[' && vScan(2) == 'M' && vScan(3) == 'H' && vScan(4) == 'z' && vScan(5) == ']') 
                bError = 0;
                iUnit = 1e6;
            end
        end

        % If size is equal to 4, it can be '[Hz]'
        if size(vScan,1) == 4
            % Check if the string is equal to [Hz]
            if (vScan(1) == '[' && vScan(2) == 'H' && vScan(3) == 'z' && vScan(4) == ']') 
                bError = 0;
                iUnit = 1;
            end            
        end

        % If size is equal to 3, it can be 'kHz' or 'MHz'
        if size(vScan,1) == 3            
            % Check if the string is equal to kHz
            if (vScan(1) == 'k' && vScan(2) == 'H' && vScan(3) == 'z') 
                bError = 0;
                iUnit = 1;
            end                        
            % Check if the string is equal to MHz
            if (vScan(1) == 'M' && vScan(2) == 'H' && vScan(3) == 'z') 
                bError = 0;
                iUnit = 1;
            end                                    
        end
        
        % If size is equal to 2, it can be 'Hz'
        if size(vScan,1) == 2
            % Check if the string is equal to kHz
            if (vScan(1) == 'H' && vScan(2) == 'z') 
                bError = 0;
                iUnit = 1;
            end                                    
        end        
                        
        % if nothing was recognized, restore the previous value and abort
        if bError == 1
            % Restore the previous value        
            strLastF = sprintf('%.2f [kHz]',fLastSub/1e3);  % First
            set(hObject,'String',strLastF);
            return;               
        end        
    else
        % If there was no string after the numeric value, 
        % the default unit is set to 1e3 (kHz)
        iUnit = 1e3;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Calculate the given frequency
    fLastSub = fLastSub_*iUnit;
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Check if this frequency is in the boundaries
    
      
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE bandwidth configuration structure
        sF = sLTE_DL1.sF;

        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE bandwidth configuration
        % structure (structures: 'sF')

        % Get the number of subcarriers
        N_scB = sF.N_scB;
        
        % Get the separation between subcarriers
        Delta_f = sF.Delta_f;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  

    % Minimum frequency
    if fLastSub <= (-N_scB/2+23)*Delta_f
        fLastSub = (-N_scB/2+23)*Delta_f;
    end
        
    % Maximum frequency    
    if fLastSub > N_scB/2*Delta_f
        fLastSub = N_scB/2*Delta_f;
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Calculate the frequency indices
    
    % Check if the given frequency is lower then 0
    if fLastSub <= 0
        inxLastSub = floor(fLastSub/Delta_f + 1 + N_scB/2);        
    else
        inxLastSub = ceil(fLastSub/Delta_f + N_scB/2);        
    end
    
    inxFrstSub = inxLastSub - 24 + 1;    
    
    % Update the subcarrier variables
    LTE_Professor_updateSubc(handles,inxFrstSub,inxLastSub);  
 
end



