%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_editFrstTime: : THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                     MODULE: LTE PROFESSOR
%
%                                                     SERVICE: EDIT FIELD 'First Symbol Time Start'
%                                                     (GUI object: 'Edit_frstTime')
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
%                           - 'Create' (Edit field 'First Symbol Time Start')
%
%                           - 'Callback' (Edit field 'First Symbol Time Start')
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

function LTE_Professor_editFrstTime(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            FrstTime_create(hObject);

        % Callback
        case 'Callback'
            FrstTime_callback(hObject,handles);
    end
end


%% Service: create 'Edit_frstTime' object
function FrstTime_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


%% Service: edit 'Edit_frstTime' object
function FrstTime_callback(hObject,handles)

    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % Get the current value of the symbol time
    tFrst = getappdata(handles.figure1,'tFrst');
 
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


    %% Get the string value from the edit text field
    strTxt = get(hObject,'String');
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    % Check if the given string is correct. Correct strinf formats:
    % >> val << or >> val [us] << or >> val [ms] << or >> val [s] <<
    % >> val us << or >> val ms << or >> val s <<
    
    % Read the string
    vScan = sscanf(strTxt,'%f %s');

    % If the vector is empty, it is an error
    if isempty(vScan)
        % Restore the previous value        
        strtFrst = sprintf('%.2f [us]',tFrst*1e6);  % First
        set(hObject,'String',strtFrst);
        return;
    end
    
    % Store the first scanned value as a time
    tFrst_ = vScan(1);
    
    
    %% If there are more then one value in a vector, check if the string which
    % creates the rest of values is equal to:
    % '[us]' or '[ms]' or [s] or 'us' or 'ms' or 's'
    if size(vScan,1) > 1        
        
        % Reset the error flag
        bError = 1;
                
        % Get the rest of the scanned values
        vScan = vScan(2:end);
        
        % If size is equal to 4, it can be '[us]' or '[ms]'
        if size(vScan,1) == 4
            % Check if the string is equal to [us]
            if (vScan(1) == '[' && vScan(2) == 'u' && vScan(3) == 's' && vScan(4) == ']') 
                bError = 0;
                iUnit = 1e-6;
            end            
            
            % Check if the string is equal to [ms]
            if (vScan(1) == '[' && vScan(2) == 'm' && vScan(3) == 's' && vScan(4) == ']') 
                bError = 0;
                iUnit = 1e-3;
            end            
            
        end

        % If size is equal to 3, it can be '[s]'
        if size(vScan,1) == 3            
            % Check if the string is equal to '[s]'
            if (vScan(1) == '[' && vScan(2) == 's' && vScan(3) == ']') 
                bError = 0;
                iUnit = 1;
            end                        
        end
        
        % If size is equal to 2, it can be 'us' or 'ms' 
        if size(vScan,1) == 2
            % Check if the string is equal to 'us'
            if (vScan(1) == 'u' && vScan(2) == 's') 
                bError = 0;
                iUnit = 1e-6;
            end                                    
            
            % Check if the string is equal to 'ms'
            if (vScan(1) == 'm' && vScan(2) == 's') 
                bError = 0;
                iUnit = 1e-3;
            end                                                
        end        

        % If size is equal to 1, it can be 's'
        if size(vScan,1) == 1
            % Check if the string is equal to 's'
            if vScan(1) == 's' 
                bError = 0;
                iUnit = 1;
            end                                    
            
        end        
        
        % if nothing was recognized, restore the previous value and abort
        if bError == 1
            % Restore the previous value        
            strFrstF = sprintf('%.2f [us]',tFrst*1e6);  % First
            set(hObject,'String',strFrstF);
            return;                
        end        
    else
        % If there was no string after the numeric value, 
        % the default unit is set to 1e-6 (us)
        iUnit = 1e-6;
        
    end
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    %% Get all needed values from the configuration structures        

        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE time configuration structure
        sT = sLTE_DL1.sT;

        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE bandwidth configuration
        % structure (structures: 'sF')

        % Get the sampling frequency
        fSmp = sT.fSmp;
        
        % Get the number of samples in symbols
        vN_smpsSymb = sT.vN_SmpsSymb;
        
        % Get the number of samples in Radio Slot
        nSmpsRS = sT.nSmpsRS;
                
        % Get the number of samples in Radio Frame
        nSmpsRF = sT.nSmpsRF;
        
        % Get the number of Subframes in the transmission
        N_SF = sT.N_SF;
                
        % Get the number of symbols in Radio Slot
        N_symbDL = sT.N_symbDL;
        
        % Get the number of symbols in a subframe
        N_symbSF = sT.N_symbSF;
        
        % Get the number of symbols in a Radio Frame
        N_symbRF = sT.N_symbRF;
        
        % Get the number of symbols in the whole transmission        
        N_symbTR = sT.N_symbTR;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  


    %% Calculate the max possible time of the first symbol, if it is needed
    % (the max possible time of the first symbol is constant for a given
    %  signal, so after first computation it is stored in the 'handles.figure1')
    if isappdata(handles.figure1,'tFrstMax') == 0

        % Calculate index of the last but one symbol which can
        % be shown as the first
        inxLastSymb = N_SF*N_symbSF - 10 - 1;

        
        % Calculate the number of full Radio Slots in the 
        % above calculate number of symbols 
        iLS_nRS = floor(inxLastSymb/N_symbDL);

        
        % Calculate the number of symbols which do not state the above
        % computed Radio Slot
        iLS_nSymb = inxLastSymb - iLS_nRS*N_symbDL;


        % Calculate the time start of the first symbol which can be shown
        % as the first         
        tFrstMax = iLS_nRS*nSmpsRS/fSmp + sum(vN_smpsSymb(1:iLS_nSymb+1)/fSmp);
        
        
        % Save the max possible time of the first symbol in the
        % 'handles.figure1'
        setappdata(handles.figure1,'tFrstMax',tFrstMax);        
        
    else
        
        % Get the max possible time of the first symbol
        tFrstMax = getappdata(handles.figure1,'tFrstMax');
    end
    
    
    %% Calculate the given time
    tFrst = tFrst_*iUnit;


    %% Check if this time is in the boundaries
    % If the time hit the boundaries, set the correct symbols indices
    %
    
    % Minimum time
    if tFrst <= 0
        
        % Index of the first symbols shown
        inxFrstSymb = 0;

        % Index of the last symbols shown
        inxLastSymb = 9;
        
        % Update the symbols 
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb); 
        
        return;
    end

    % Maximum time    
    if tFrst >= tFrstMax
        fprintf('Gosia!\n');
        
        % Index of the last symbols shown
        inxLastSymb = N_symbTR - 1;
                
        % Index of the first symbols shown
        inxFrstSymb = N_symbTR - 10;
        
        % Update the symbols 
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb); 
        
        return;
    end


    %% - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % Calculate the symbols indices
    
    % Calculate the time of the Radio Slot
    tRS = nSmpsRS/fSmp;
    
    % Calculate the time of the Radio Frame
    tRF = nSmpsRF/fSmp;
    
    % Calculate the number of full Radio Frames inside the given time
    nTRF = floor(tFrst/tRF);

    % Substract the full Radio Frames from the time
    tFrst = tFrst - nTRF*tRF;

    % Calculate the number of full Radio Slots in the rest of the time
    nTRS = floor(tFrst/tRS);
    
    % Subtract the full Radio Slots from the time
    tFrst = tFrst - nTRS*tRS;
    
    % Subtract the symbols from the rest of the time
    nTSymb = 1;
    for inxSym=1:N_symbDL
        tFrst = tFrst - vN_smpsSymb(inxSym)/fSmp;
        if tFrst > 0
            nTSymb = nTSymb + 1;
        end
    end
    
    % Calculate the first symbol index
    inxFrstSymb = N_symbRF*nTRF + N_symbDL*nTRS + nTSymb;
    if inxFrstSymb < 0
        inxFrstSymb = 0;
    end

    % Calculate the value of index of the last shown symbol
    inxLastSymb = inxFrstSymb + 10 - 1;
  
    % Update the symbols variables
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb); 

end
