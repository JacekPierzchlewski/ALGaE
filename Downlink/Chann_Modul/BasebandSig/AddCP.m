%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddCP: THE "ALGaE" PACKAGE - OFDM BASEBAND CYCLIC PREFIX INSERTION
%                                  INTO THE SYMBOLS SIGNAL
%
% This function inserts Cyclic Prefixes into LTE baseband signal.
%
%
% File version 1.4 (17th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Inputs (4):
%
%       1. vSymbs:      Complex vector with LTE symbols in time domain.
%
%       2. sF:          Structure with the bandwidth (frequency) configuration.
%
%       3. sT:          Structure with the time configuration.
%
%       4. bGUIBar:     Flag which inidicates if the Cyclic Prefix Insertion 
%                       progress should be shown by the GUI bar.
%                       [ 0 - gui bar off ]
%
% ------------------------------------------------------------------------
% Outputs (3):
%
%       1. vI:          Vector with the I signal.
%
%       2. vQ:          Vector with the Q signal.
%
%       3. mSymInx:     Matrix with the information about inidces of 
%                       Cyclic Prefixes and Symbols in the vI and vQ vectors.
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

function [ vI vQ mSymInx ] = AddCP(vSymbs, sF, sT, bGUIBar)
  

    %% Cyclic prefix added according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.12 (OFDM baseband signal generation)     
    % 
    
    %% 
    %----------------------------------------------------------
    % GET THE CURRENT NEEDED VALUES FROM BANDWIDTH AND TIME STRUCTURES
    % (structure: 'sF', 'sT'):

        % The size of the IFFT
        N_ifft    = sF.N_ifft;
    
        % - - - - - - - - - - - - - - - - - - - - - - - - - - -                
    
        % The number of samples in the transmission
        nSmpsTR         = sT.nSmpsTR;
                    
        % The number of samples in cyclic prefixes 
        vN_SmpsCP       = sT.vN_SmpsCP;
        
        % The number of symbols in the Radio Slot
        N_symbDL        = sT.N_symbDL;
        
        % The number of symbols in the whole transmission
        N_symbTR        = sT.N_symbTR;
        
    %---------------------------------------------------------- 
        
    % Allocate the vector for the output IQ signal
    vIQ = zeros(nSmpsTR,1);
        
    % Allocate the vector for the Symbols index matrix
    mSymInx = zeros(3,N_symbTR);
    
    
    %% LOOP OVER ALL SYMBOLS
    
    % Reset the first samples index 
    inxFSmp = 1;
    
    % Waitbar service
    if bGUIBar == 1
        
        % Start the waitbar
        h = waitbar(0,'Cyclic Prefix Insertion...');            
        
        % Set the number of waitbar jumps        
        cnstJump = 4;                                      
        
        % Generate vector with jump progress
        vJmpProg = [(ceil(N_symbTR/cnstJump):ceil(N_symbTR/cnstJump):N_symbTR)' ; N_symbTR];
        if size(vJmpProg,1) < cnstJump
            vJmpProg = [ vJmpProg ; N_symbTR ];
        end
    end    
    
    % The loop over all symbols starts here
    for inxSymb=1:N_symbTR
                
        % Calculate the index of the Cyclic Prefix in the Radio Slot
        inxCP = inxSymb - floor((inxSymb-1)/N_symbDL)*N_symbDL;
        
        % GET THE SAMPLING PARAMETERS FOR THIS SYMBOL:
        
            % Get the number of samples in the current cyclic prefix
            N_SmpsCP = vN_SmpsCP(inxCP);

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % Put the indices of samples from 'vSymbs' vector which are 
        % a Cyclic Prefix in this symbol, into the 'vSymbsSmps' vector.
        inxFCP = inxSymb*N_ifft-N_SmpsCP+1;     % First index of sample which states Cyclic Prefix in this symbol
        inxLCP = inxSymb*N_ifft;                % Last index of sample which states Cyclic Prefix in this symbol
        vIQ(inxFSmp:(inxFSmp+N_SmpsCP-1)) = vSymbs(inxFCP:inxLCP);
        
        % Adjust the first sample index
        inxFSmp = inxFSmp + N_SmpsCP;
                
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % Put the indices of samples from 'vSymbs' vector which are 
        % a main symbol into this symbol, into the 'vSymbsSmp' vector.
        inxFCP = (inxSymb-1)*N_ifft+1;
        inxLCP = inxSymb*N_ifft;        
        vIQ(inxFSmp:(inxFSmp+N_ifft-1)) = vSymbs(inxFCP:inxLCP);
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % Put the indices of symbol samples into the 'mSymInx' matrix
        %
        % 1st column : beginning of the cyclic prefix
        % 2nd column : end of the cyclic prefix
        % 3rd column : end of the symbol
        %
        mSymInx(:,inxSymb) = [ inxFSmp - N_SmpsCP  (inxFSmp - 1)  inxFSmp+N_ifft-1 ]';
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % Adjust the first sample index
        inxFSmp = inxFSmp + N_ifft;
        
        
        %----------------------------------------------------------    
        % Update the waitbar, if it is on, and if the progress is bigger
        % than the current step
        if bGUIBar == 1 
            
            % If one of the jump thresholds is set, jump the waitbar
            % forward
            if sum(inxSymb == vJmpProg) > 0
                
                % Update the wait bar
                waitbar(inxSymb/N_symbTR,h);
            end            
        end
        %----------------------------------------------------------  

    end
    
    % CREATE THE I AND Q SIGNALS
    vI = real(vIQ);
    vQ = imag(vIQ);
    

    %----------------------------------------------------------    
    % Close the waitbar, if the waitbar exists
    if bGUIBar == 1                
        close(h);    
    end
    %----------------------------------------------------------  
    
end

