%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% genOFDM: THE "ALGaE" PACKAGE - OFDM BASEBAND SIGNAL GENERATOR
%
% Function generates the OFDM baseband signal from the time/frequency
% resources matrix without Cyclic Prefies.
%                                                
% File version 1.0 (15th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Inputs (4):
%
%       1. mTF:         Matrix for the time/frequency resources
%
%       2. sF:          Structure with the bandwidth (frequency) configuration
%
%       3. sT:          Structure with the time configuration
%
%       4. hRepFil:     Report file handle
%
%
% ------------------------------------------------------------------------
% Output (1):
%
%       1. vSymbs:      Complex vector with LTE symbols in a time domain (without 
%                       the Cyclic Prefixes).
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

function vSymbs = genOFDM(mTF, sF, sT, hRepFil)
    

    %% OFDM signal generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.12 (OFDM baseband signal generation)     
    % 
    
    %% ALLOCATE THE INPUT MATRIX FOR THE IFFT

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE BANDWIDTH AND TIME CONFIGURATION STRUCTURES
    % (structure: 'sF', 'sT')
              
        % The number of subcarriers in the bandwidth
        N_scB     = sF.N_scB;
        
        % The size of the IFFT
        N_ifft    = sF.N_ifft;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % The number of symbols in the whole transmission
        N_symbTR  = sT.N_symbTR;

    %---------------------------------------------------------- 

    
    % Allocate the input matrix for the IFFT
    mIFFT = zeros(N_ifft,N_symbTR);
        
    %% MAP THE TIME/FREQUENCY MATRIX INTO THE IFFT
    
    % MAP THE NEGATIVE FREQUENCIES        
    iFrstIFFT_n   = N_ifft - N_scB/2 + 1;
    iLastIFFT_n   = N_ifft;    
    
    iFrstInxTF_n  = 1;
    iLastInxTF_n  = N_scB/2;
    
    % Map the resource elements
    mIFFT((iFrstIFFT_n:iLastIFFT_n),:) = mTF((iFrstInxTF_n:iLastInxTF_n),:);

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    % MAP THE POSITIVE FREQUENCIES    
    iFrstIFFT_p   = 2;
    iLastIFFT_p   = 2 + N_scB/2 - 1; 
    
    iFrstInxTF_p  = N_scB/2+1;
    iLastInxTF_p  = N_scB;
        
    % Map the resource elements
    mIFFT((iFrstIFFT_p:iLastIFFT_p),:) = mTF((iFrstInxTF_p:iLastInxTF_p),:);
    
    %% PERFORM THE IFFT (create a matrix with symbols)
    
    % IFFT
    mSymbs = ifft(mIFFT);
        
    % Reshape symbols into the vector
    vSymbs = mSymbs(:);    
         
    %% REPORT TO THE FILE, IF NEEDED
    if hRepFil ~= -1
        
        % SIZE OF THE IFFT:
        strMessage = sprintf('BASEBAND SIGNAL GENERATION: \n');
        strMessage = sprintf('%sSize of the IFFT: %d \n\n',strMessage,N_ifft);
        
        % MAPPING TO THE IFFT MATRIX
        strMessage = sprintf('%sResource Elements between indices %d - %d (negative frequencies) \n',strMessage,iFrstInxTF_n,iLastInxTF_n);
        strMessage = sprintf('%sare mapped to rows %d - %d in the IFFT matrix \n',strMessage,iFrstIFFT_n,iLastIFFT_n);
        strMessage = sprintf('%sResource Elements between indices %d - %d (positive frequencies) \n',strMessage,iFrstInxTF_p,iLastInxTF_p);
        strMessage = sprintf('%sare mapped to rows %d - %d in the IFFT matrix \n\n',strMessage,iFrstIFFT_p,iLastIFFT_p);
        
        strMessage = sprintf('%s---------------------------------------------------\n\n',strMessage);
                                
        % Dump the message to the file
        fprintf(hRepFil,strMessage);
    end
end
