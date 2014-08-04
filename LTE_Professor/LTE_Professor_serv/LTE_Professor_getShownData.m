%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_getShownData: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                   MODULE: LTE PROFESSOR
%                                                      
%                                                   SERVICE: Get the correct data to
%                                                            shown in the table.
%
% File version 1.0 (17th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
% ------------------------------------------------------------------------
% Output:
%
%       1. mcShow:      The data to be shown  [mcShow - matrix with cells].
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

function mcShow = LTE_Professor_getShownData(handles)


    %% Get the current view type
    strVType = getappdata(handles.figure1,'ViewType');

    switch strVType
        
        % Values of the Time/Frequency resources 
        case 'Values'
            mcShow = getValData(handles);
    
        % The modulation types in the resources
        case 'Modulations'
            mcShow = getModulations(handles);
         
        % The signals and channels types in the resources     
        case 'SigNChann'
            mcShow = getSigNChann(handles);
            
    end
end

%% Get the values of the Time/Frequency resources 
function mcShow = getValData(handles)
    
    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    
    % Get the current indices of shown symbols
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
    inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
    
    
    % Get the current indices of shown subcarriers
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');
    inxLastSub = getappdata(handles.figure1,'inxLastSub');
    
    
    
    %% Get the chunks of the currently shown matrices: 
    % (resource values and signals and channels mapping)
    
    % Get the current shown chunk of the resources matrix (values)
    mShowVal = sLTE_DL1.mTF(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);
    
    % Get the current shown chunk of the resources matrix (signals and channels map)
    mShowSC = sLTE_DL1.mSCMap(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);



    %% Allocate the 'mcShow' matrix (output matrix)
    mcShow = repmat({' '},size(mShowVal));
    

    %% Loop over all Resource Elements in the 'mShowVal' matrix
    
    % Loop over all columns
    for inxCol=1:size(mShowVal,2)
        
        % Loop over all rows
        for inxRow=1:size(mShowVal,1)

            % Depending the type of signal or channel, process the value
            % of the current Resource Element            
            switch cell2mat(mShowSC(inxRow,inxCol))
                
                % Primary Synchronization Signal
                case 'PSS'
                    
                    % Real value
                    if real(mShowVal(inxRow,inxCol)) >=0 
                        strRE = strcat(sprintf(' %2.4f',real(mShowVal(inxRow,inxCol))));
                        
                    else
                        strRE = strcat(sprintf('%2.4f',real(mShowVal(inxRow,inxCol))));
                        
                    end
                    
                    % Imag value
                    if imag(mShowVal(inxRow,inxCol)) >=0 
                        strRE = strcat(strRE,sprintf('+%2.4f',abs(imag(mShowVal(inxRow,inxCol)))));
                        
                    else
                        strRE = strcat(strRE,sprintf('-%2.4f',abs(imag(mShowVal(inxRow,inxCol)))));
                        
                    end
                    
                    % Add the 'i' at the end
                    strRE = strcat(strRE,'i');
                    
                    % Put the current Resource Element string into the
                    % output matrix
                    mcShow(inxRow,inxCol) = {strRE};
                
                % ---------------------------------------------------------------------------------    
                    
                % Other Signals or Channels    
                otherwise
                    
                    % If the value is equal to 0, put the 0 into the output
                    % matrix
                    if mShowVal(inxRow,inxCol) == 0                        
                        mcShow(inxRow,inxCol) = {'0'};
                        
                    else
                        % Real value
                        if real(mShowVal(inxRow,inxCol)) >=0 
                            strRE = strcat(sprintf(' %2.4f',real(mShowVal(inxRow,inxCol))));

                        else
                            strRE = strcat(sprintf('%2.4f',real(mShowVal(inxRow,inxCol))));

                        end

                        % Imag value
                        if imag(mShowVal(inxRow,inxCol)) >=0 
                            strRE = strcat(strRE,sprintf('+%2.4f',abs(imag(mShowVal(inxRow,inxCol)))));

                        else
                            strRE = strcat(strRE,sprintf('-%2.4f',abs(imag(mShowVal(inxRow,inxCol)))));

                        end

                        % Add the 'i' at the end
                        strRE = strcat(strRE,'i');

                        % Put the current Resource Element string into the
                        % output matrix
                        mcShow(inxRow,inxCol) = {strRE};
                    end
                % ---------------------------------------------------------------------------------                        
            end
        end
    end
end


%% Get the modulation types in the resources 
function mcShow = getModulations(handles)

    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    
    % Get the current indices of shown symbols
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
    inxLastSymb = getappdata(handles.figure1,'inxLastSymb');


    % Get the current indices of shown subcarriers
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');
    inxLastSub = getappdata(handles.figure1,'inxLastSub');
    
    
    
    %% Get the chunk of the currently shown matrix: 
    % (Modulations mapping)
    
    % Get the current shown chunk of the resources matrix (Modulations mapping)
    mcShow = sLTE_DL1.mModMap(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);

end


%% Get the signals and channels types in the resources 
function mcShow = getSigNChann(handles)

    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    
    % Get the current indices of shown symbols
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
    inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
    
    
    % Get the current indices of shown subcarriers
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');
    inxLastSub = getappdata(handles.figure1,'inxLastSub');
   
    %% Get the chunk of the currently shown matrix: 
    % (Signals and channels mapping)
    
    % Get the current shown chunk of the resources matrix (signals and channels map)
    mcShow = sLTE_DL1.mSCMap(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);    
    
end
