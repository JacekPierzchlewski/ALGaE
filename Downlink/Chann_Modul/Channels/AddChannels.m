%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddChannels: THE "ALGaE" PACKAGE - PHYSICAL CHANNELS MODULATORS AND 
%                                    MAPPERS (WRAPPER)
%
% This function runs mappers of signals.
%                                                
% File version 1.0 (17th June 2011)
%                                 
%% ------------------------------------------------------------------------
% Inputs (9):
%
%       1. mTF:         Time/frequency matrix with resource elements (4 Radio Frames)
%
%       2. mSCMap:      Signals and channels mapping matrix (4 Radio Frames)
%
%       3. mModMap:     Modulation mapping matrix (4 Radio Frames)
%
%
%       4. sLTE_stand:  Structure with the LTE standard
%
%
%       5. sF:          Structure with the LTE bandwidth (frequency) configuration
%
%       6. sT:          Structure with the LTE time configuration
%
%       7. sT:          Structure with other LTE-specific parameters
%
%
%       8. sCodewords:  Structure with codewords
%
%       9. hWaitBar:    Handle to the optional waitbar
%
%
% ------------------------------------------------------------------------
% Outputs (8):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%       4. sPBCH:       Info structure with PBCH channel data and parameters.
%
%       5. sPCFICH:     Info structure with PCFICH channel data and parameters.
%
%       6. sPHICH:      Info structure with PHICH channel data and parameters.
%
%       7. sPDCCH:      Info structure with PDCCH channel data and parameters.
%
%       8. sPDSCH:      Info structure with PDSCH channel data and parameters.
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

function [ mTF mSCMap mModMap sPBCH sPCFICH sPHICH sPDCCH sPDSCH ] = AddChannels(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, sCodewords, hWaitBar)


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME PARAMETERS STRUCTURE 
    %
    % (structure: 'sT'): 
        
        % The number of Subframes in the transmission
        N_SF        = sT.N_SF;
        
        % The index of the first subframe in the transmission
        FIRST_SF    = sT.FIRST_SF;        
        
    %---------------------------------------------------------- 


    % Initialize the channel information structures
    sPBCH   = struct();
    sPCFICH = struct();
    sPHICH  = struct();
    sPDCCH  = struct();
    sPDSCH  = struct();


    %% Loop over all subcarriers
    
    % -------------------------------------
    % Waitbar service
    if hWaitBar ~= -1
        
        % Set the number of waitbar jumps        
        cnstJump = 4;          
        
        % Reset the channel progress
        iChanProg = 1;                               
        
        % Generate vector with jump progress
        vJmpProg = [(ceil(N_SF/cnstJump):ceil(N_SF/cnstJump):N_SF)' ; N_SF];
        if size(vJmpProg,1) < cnstJump
            vJmpProg = [ vJmpProg ; N_SF ];
        end
    end
    
    % -------------------------------------
    
    % The loop starts here
    for inxSF=FIRST_SF:(FIRST_SF+N_SF-1)
    
        % PHYSICAL BROADCAST CHANNEL

        % Add the PBCH sginal
        [ mTF mSCMap mModMap sPBCH ] = AddPBCH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPBCH, sCodewords);

        % -----------------------------------------------------------

        
        % PHYSICAL CONTROL FORMAT INDICATOR CHANNEL
        [ mTF mSCMap mModMap sPCFICH ] = AddPCFICH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPCFICH, sCodewords);
        
        % -----------------------------------------------------------


        % PHYSICAL HARQ INDICATOR CHANNEL
        [ mTF mSCMap mModMap sPHICH ] = AddPHICH(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sCodewords);

        % -----------------------------------------------------------


        % PHYSICAL DOWNLINK CONTROL CHANNEL
        [ mTF mSCMap mModMap sPDCCH ] = AddPDCCH(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPDCCH, sCodewords);
        
        % -----------------------------------------------------------
        
        
        % PHYSICAL DOWNLINK SHARED CHANNEL
        [ mTF mSCMap mModMap sPDSCH ] = AddPDSCH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPDSCH, sCodewords);

        
        % -----------------------------------------------------------


        % ------------------------------------- 
        % Waitbar service
        if hWaitBar ~= -1
            
            % If one of the jump thresholds is set, jump the waitbar
            % forward
            if sum(iChanProg == vJmpProg) > 0
                waitbar(3/8 + 5/8*(iChanProg/N_SF),hWaitBar);
            end
                     
            % Move the channel progress forward
            iChanProg = iChanProg + 1;
        end
        
        % -----------------------------------------------------------
    end


    %% PREPARE THE PBCH CHANNEL INFORMATION STRUCUTRE: 
    % Due to very long TTI of the PBCH channel, this strucutre 
    % needs additional processing.
    
    % ---------------------------------------------------------------
    % sPBCH:
        
    % Check if this channel was mapped
    if ~isfield(sPBCH,'nPBCHsubf')
        
        % The signal was not mapped, save the number of subframes with PBCH
        % to zero
        sPBCH.nPBCHsubf = 0;

    else
        % The signal was mapped:
        
        % Reshape the PBCH bitstream. One columns contains bits send in PBCH from one
        % subframe.

            % Get the number of bits in PBCH p. TTI
            nBits_TTI = sPBCH.nBits_TTI;

            % Get the number of subframes with PBCH
            nPBCHsubf = sPBCH.nPBCHsubf;

            % Get the number of PBCH TTI
            nPBCH_TTI = sPBCH.nPBCH_TTI;

            % Get the index of the Radio Frame in PBCH TTI
            PBCH_RFINX = sT.PBCH_RFINX;

        % Calculate the number of PBCH bits p. Subframe
        nBits_SF  = nBits_TTI/4;

        % Reshape 
        sPBCH.mPBCHBits = reshape(sPBCH.mPBCHBits,nBits_SF,nPBCH_TTI*4);

        % Cut the matrix with symbols to the correct number of symbols
        sPBCH.mPBCHBits = sPBCH.mPBCHBits(:,PBCH_RFINX+1:PBCH_RFINX+nPBCHsubf);


        % Reshape the PBCH symbols. One columns contains PBCH symbols from one
        % subframe.

            % Get the number of symbols in PBCH p. TTI
            nModSymb_TTI = sPBCH.nModSymb_TTI;

            % Get the number of PBCH TTI
            nPBCH_TTI = sPBCH.nPBCH_TTI;


        % Calculate the number of modulation symbols p. Subframe
        nModSymb_SF  = nModSymb_TTI/4;

        % Reshape 
        sPBCH.mPBCHSym = reshape(sPBCH.mPBCHSym,nModSymb_SF,nPBCH_TTI*4);

        % Cut the matrix with symbols to the correct number of symbols
        sPBCH.mPBCHSym = sPBCH.mPBCHSym(:,PBCH_RFINX+1:PBCH_RFINX+nPBCHsubf);

    end
    % ---------------------------------------------------------------   
end
