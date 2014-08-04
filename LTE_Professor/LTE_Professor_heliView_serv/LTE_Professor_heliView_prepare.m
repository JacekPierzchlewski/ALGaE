%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_heliView_prepare: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE
%                                                       MODULE: LTE PROFESSOR, 
%                                                               HELICOPTER VIEW ON RESOURCES
%
%                                                       SERVICE: Prepare the image
%
% File version 1.0 (20th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
% ------------------------------------------------------------------------
% Output:
%
%       1. none.
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

function LTE_Professor_heliView_prepare(handles)


    %% -------------------------------------------------    
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Get the LTE data structure 
    sLTE_DL1 = getappdata(hMother.figure1,'sLTE_DL1');    
    

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD
    % (structures: 'sLTE_stand'):               

        % Get the total number of subcarriers
        N_scB = sLTE_DL1.sF.N_scB;

        % Get the total number of symbols
        N_symbTR = sLTE_DL1.sT.N_symbTR;

    % ----------------------------------------------------------   

    %% Start the waitbar    
    h = waitbar(0.0,'Preparing the view...');
    
    
    %% -------------------------------------------------    
    %% Signals and Channels:    
    
    % Signals and channels labels
    EMPTY = 0;  % Empty Resource Element
    
    PSS = 1;    % Primary synchronization signal
    SSS = 2;    % Secondary synchronization signal
    RS  = 3;    % Reference signal
    
    PBCH   = 4; % Physical broadcast channel  
    PHICH  = 5; % Physical HARQ indication channel
    PCFICH = 6; % Physical control format indication channel
    PDCCH  = 7; % Physical downlink control channel
    PDSCH  = 8; % Physical downlink shared channel

    % ---------------------------------------------------
    % Get the currently shown chunk of the resources matrix (signals and channels map)
    mSCMap = sLTE_DL1.mSCMap;
    
    % ---------------------------------------------------
    % Change the cells into numeric values
    
    % Allocate the output matrix for signals and channels
    % ( Colored matrix )
    mSCMapColored = EMPTY*ones(size(mSCMap));

    % Loop over all subcarriers
    for inxSub=1:N_scB
        
        % Loop over all symbols
        for inxSymb=1:N_symbTR
            
            % Put the correct number dependently on a 
            % string inside the cell
            switch mSCMap{inxSub,inxSymb}
                    
                case 'PSS'
                    mSCMapColored(inxSub,inxSymb) = PSS;
                    
                case 'SSS'
                    mSCMapColored(inxSub,inxSymb) = SSS;
                    
                case 'RS'
                    mSCMapColored(inxSub,inxSymb) = RS;
                    
                case 'PBCH'
                    mSCMapColored(inxSub,inxSymb) = PBCH;
                    
                case 'PHICH'
                    mSCMapColored(inxSub,inxSymb) = PHICH;
                    
                case 'PCFICH'
                    mSCMapColored(inxSub,inxSymb) = PCFICH;
                    
                case 'PDCCH'
                    mSCMapColored(inxSub,inxSymb) = PDCCH;
                    
                case 'PDSCH'
                    mSCMapColored(inxSub,inxSymb) = PDSCH;                    
            end            
        end
        
        % Update the wait bar
        if rem(inxSub,20) == 0      
            waitbar(0.5*inxSub/N_scB,h);         
        end
    end

    
    % Save the colored signals/channels map
    setappdata(handles.figure1,'mSCMapColored',mSCMapColored);
    
    
    % ---------------------------------------------------
    % Create the colormap    
    mSCColMap = [1.0 1.0 1.0;  ... Empty   - White
                               ...
                 1.0 0.0 0.0;  ... PSS     - Red
                 0.0 1.0 0.0;  ... SSS     - Green
                 0.0 0.0 0.0;  ... RS      - Black
                               ...
                 0.0 0.0 1.0;  ... PBCH    - Blue
                 0.7 0.0 0.7;  ... PHICH   - Violet
                 1.0 1.0 0.0;  ... PCFICH  - Yellow
                 0.5 0.5 0.5;  ... PDCCH   - Grey
                 0.0 0.9 0.9 ];  % PDSCH   - Light green

    % Save the colormap
    setappdata(handles.figure1,'mSCColMap',mSCColMap);
    
           
           
    % ---------------------------------------------------               
    % Create the colorbar legend    
    vcSCColorBar = {'Empty'  , ...
                    'PSS'    , ...
                    'SSS'    , ...
                    'RS'     , ...
                    'PBCH'   , ...
                    'PHICH'  , ...
                    'PCFICH' , ...
                    'PDCCH'  , ...
                    'PDSCH'  , ''  };
              
    % Save the colorbar
    setappdata(handles.figure1,'vcSCColorBar',vcSCColorBar);
    
    
    % ---------------------------------------------------               
 

    %% -------------------------------------------------        
    %% Modulations:
    
    % Signals and channels labels
    EMPTY = 0;      % Empty Resource Element
    
    ZAD_CHU = 1;    % Zadoff-Chu  modulations
    BPSK    = 2;    % BPSK  modulation
    QPSK    = 3;    % QPSK  modulation
    
    QAM16   = 4;    % QAM16  modulation
    QAM64   = 5;    % QAM64  modulation
    QAM256  = 6;    % QAM256 modulation

    % ---------------------------------------------------
    % Get the currently shown chunk of the resources matrix (Modulations mapping)
    mModMap = sLTE_DL1.mModMap;    
    
    % ---------------------------------------------------
    % Change the cells into numeric values
    
    % Allocate the output matrix
    mModMapColored = EMPTY*ones(size(mModMap));

    % Loop over all subcarriers
    for inxSub=1:N_scB
        
        % Loop over all symbols
        for inxSymb=1:N_symbTR
            
            % Put the correct number dependently on a 
            % string inside the cell
            switch mModMap{inxSub,inxSymb}
                    
                case 'Zadoff-Chu'
                    mModMapColored(inxSub,inxSymb) = ZAD_CHU;
                    
                case 'BPSK'
                    mModMapColored(inxSub,inxSymb) = BPSK;
                    
                case 'QPSK'
                    mModMapColored(inxSub,inxSymb) = QPSK;
                    
                case 'QAM16'
                    mModMapColored(inxSub,inxSymb) = QAM16;
                    
                case 'QAM64'
                    mModMapColored(inxSub,inxSymb) = QAM64;  
                
                case 'QAM256'
                    mModMapColored(inxSub,inxSymb) = QAM256;  
            end
        end
        
        % Update the wait bar
        if rem(inxSub,20) == 0      
            waitbar(0.5+0.5*inxSub/N_scB,h);         
        end
    end
    
    % Save the colored modulation map
    setappdata(handles.figure1,'mModMapColored',mModMapColored);    
    
    % ---------------------------------------------------
    % Create the colormap    
    mModColMap = [1.0 1.0 1.0;  ... Empty      - White
                                ...
                  1.0 0.0 0.0;  ... Zadoff-Chu - Red
                                ...
                  0.0 1.0 0.0;  ... BPSK       - Green
                  0.0 0.0 1.0;  ... QPSK       - Blue
                                ...
                  1.0 1.0 0.0;  ... QAM16      - Yellow                                               
                  0.0 0.9 0.9;  ... QAM64      - Light green
                  0.7 0.0 0.7 ];  % QAM256     - Violet
           
    % Save the colormap
    setappdata(handles.figure1,'mModColMap',mModColMap);
    

    % ---------------------------------------------------               
    % Create the colorbar legend    
    vcModColorBar = {'Empty'       , ...
                     'Zadoff-Chu'  , ...
                     'BPSK'        , ...
                     'QPSK'        , ...
                     'QAM16'       , ...
                     'QAM64'       , ...
                     'QAM256'      , ''  };         
           
    % Save the colorbar
    setappdata(handles.figure1,'vcModColorBar',vcModColorBar);

    % Close the waitbar
    close(h);
    
end

