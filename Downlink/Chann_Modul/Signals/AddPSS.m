%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPSS: THE "ALGaE" PACKAGE - PSS SIGNAL GENERATOR AND MAPPER
% 
% This function generates the Primary Synchronization Signal and map it
% to the resource elements.
%                                                
% File version 1.0 (14th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Inputs (8):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%
%       4. sLTE_stand:  Structure with the LTE standard structure.
%
%
%       5. sF:          Structure with the bandwidth (frequency) configuration.
%
%       6. sT:          Structure with the time configuration.
%
%       7. sP:          Structure with the LTE-specific parameters
%
%
%       8. hRepFil:     Handle to the report file.
%
% ------------------------------------------------------------------------
% Outputs (3):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
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

function [ mTF mSCMap mModMap ] = AddPSS(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, hRepFil)


    %% PSS signal added according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.1 (Primary synchronization signal)     
    % 

    %% GENERATE THE PSS SIGNAL
    %
    % Signal generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.1.1 (Sequence generation)     
    %         
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD AND LTE-SPECIFIC
    % PARAMETERS STRUCTURES 
    % (structures: 'sLTE_stand' and 'sP'):

        % Vector with possible root values
        vN_ID2      = sLTE_stand.vN_ID2;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        % Second number of a physical-layer cell identity
        N_id2       = sP.N_id2;
    
    %----------------------------------------------------------    

    % Get the correct Zadoff-Chu root sequence index
    iPSSr = vN_ID2(N_id2+1);

    % Allocate the vector for the Zadoff-Chu sequence
    vd_u = zeros(62,1);
        
    % Construct the Zadoff-Chu vector
    vN1 = (0 : 30)';
    vN2 = (31 : 61)';    
    vd_u(1:31) = cos(-1*pi*iPSSr*vN1.*(vN1+1) / 63) + ...
                     1i*sin(-1*pi*iPSSr*vN1.*(vN1+1) / 63);

    vd_u(32:62) = cos(-1*pi*iPSSr*(vN2+1).*(vN2+2) / 63) + ...
                      1i*sin(-1*pi*iPSSr*(vN2+1).*(vN2+2) / 63);


    %% MAPPING OF THE PSS SIGNAL TO THE RESOURCES ELEMENTS
    %
    % Signal mapped according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.1.2 (Mapping to resource elements)
    %

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE BANDWIDTH (FREQUENCY) AND TIME 
    % CONFIGURATION STRUCTURES (structures: 'sF' and 'sT')

        % The number of subcarriers in the current bandwidth
        N_scB       = sF.N_scB;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        % The number of symbols in a Radio Slot
        N_symbDL    = sT.N_symbDL;
        
        % The number of subframes in the transmission
        N_SF        = sT.N_SF;
        
        % The index of the first subframe in the transmission
        FIRST_SF    = sT.FIRST_SF;
        
        % The number of symbols in the subframe
        N_symbSF    = sT.N_symbSF;
        
        % The number of symbols in the Radio Frame
        N_symbRF    = sT.N_symbRF;
        
    %----------------------------------------------------------     
    
    % Calculate the indices of subcarriers to which the PSS is mapped
    vn = (0:61)';
    vk = vn - 31 + N_scB/2;

    
    %----------------------------------------------------------                 
    % Calculate the number of subframes in one Radio Frame
    N_SFRF = N_symbRF / N_symbSF;
    
    % Count symbols with PSS signals
    nPSSSymb = 0;
    for inxSF=FIRST_SF:(FIRST_SF+N_SF-1)
        
        % Calculate index of the current subframe in a Radio Frame
        inxSFRF = rem(inxSF,N_SFRF);           
        
        % If the subframe has index 0 or 5, count it 
        if (inxSFRF == 0) || (inxSFRF == 5)
            nPSSSymb = nPSSSymb + 1;
        end     
    end        
    %-----------------------------------------------        
    
    % % Allocate the vector for indices of OFDM symbol with PSS signal
    vl = zeros(nPSSSymb,1);
    
    % Loop over all Subframes
    inxSymb = 1;    % Reset the index of symbols
    inxSub = 1;     % Reset the subcarriers counter
    for inxSF=FIRST_SF:(FIRST_SF+N_SF-1)

    	% Calculate index of the current subframe in a Radio Frame
        inxSFRF = rem(inxSF,N_SFRF);
                
        % The last OFDM symbol in a Radio Slot number 0  (first in Radio Frame)
        if inxSFRF == 0                        
            vl(inxSymb)   = (inxSub-1)*N_symbSF + N_symbDL;
            inxSymb = inxSymb + 1;
        end
        
        % The last OFDM symbol in a Radio Slot number 10 (11th in Radio Frame)
        if inxSFRF == 5            
            vl(inxSymb)   = (inxSub-1)*N_symbSF + N_symbDL;
            inxSymb = inxSymb + 1;
        end
        
        inxSub = inxSub + 1;
    end
    
    
    %% ADD THE PSS SIGNAL TO THE RESOURCE ELEMENTS
    
    % Put the Zadoff Chu sequence into the Resources matrix
    mTF(vk+1,vl) = repmat(vd_u,1,nPSSSymb);

    % Indicate the PSS into the Signals/Channels map
    mSCMap(vk+1,vl) = {'PSS'};
    
    % Indicate the Zadoff Chu sequence in the modulation map
    mModMap(vk+1,vl) = {'Zadoff-Chu'};


    %% REPORT TO THE FILE, IF NEEDED
    if hRepFil ~= -1

        % HEADER:
        strMessage = sprintf('PRIMARY SYNCHRONIZATION SIGNAL MAPPER: \n');
        strMessage = sprintf('%sThe PSS signal consists of Zadoff-Chu sequence. \n',strMessage);
        strMessage = sprintf('%sThe second number of a physical-layer cell identity is: %d \n',strMessage,N_id2);
        strMessage = sprintf('%sso the Zadoff-Chu root sequence index is: %d \n\n',strMessage,iPSSr);
        
        % Print out the Zadoff-Chu
        strMessage = sprintf('%sThe Zadoff-Chu sequence is: \n',strMessage);
        for inxZF=1:62
            strMessage = sprintf('%s %.6f + %.6fj\n',strMessage,real(vd_u(inxZF)),imag(vd_u(inxZF)));
        end
        strMessage = sprintf('%s\n',strMessage);
        
        strMessage = sprintf('%s---------------------------------------------------\n\n\n',strMessage);

        % Dump the message to the file
        fprintf(hRepFil,strMessage);
    end
end
