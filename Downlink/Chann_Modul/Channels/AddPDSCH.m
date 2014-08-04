%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPDSCH: THE "ALGaE" PACKAGE - PDSCH CHANNEL MODULATOR AND MAPPER
% 
% Function modulates the PDSCH channel and map it to the current subframe. 
%
% File version 1.0 (16th August 2011)
%
%% ------------------------------------------------------------------------
% Inputs (10):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%
%       4. sF:          Structure with bandwidth (frequency) configuration.
%
%       5. sT:          Structure with the time configuration.
%
%       6. sP:          Structure with other LTE-specific parameters
%
%
%       7. sLTE_stand:  Structuree with the LTE standard
%
%       8. inxSF:       Index of the current porcessed subframe
%
%
%       9. sPDCCH:      Structure with the PDCCH channel
%
%       10. sCodewords: Structure with codewords
%
%
% ------------------------------------------------------------------------
% Outputs (4):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%       4. sPDSCH:      Structure with information about the PDSCH
%                       channel.
%
%          Fields in the 'sPDSCH' structure:
%
%                   .nPDSCHsubf     : the number of subframes with
%                                     PDSCH channel
%
%                   mN_Sym          : matrix with the number of transmitted
%                                     PDSCH symbols                                      
%
%                   vsPDSCHSym      : vector of strucutres with PDSCH symbols
%                                     transmitted on PDSCH codewords
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


function [ mTF mSCMap mModMap sPDSCH ] = AddPDSCH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPDSCH, sCodewords)

    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sF'): 

        % Get the Transmission Scheme
        strTrans = sF.strTrans;

         
    % Run the correct channel mapping function dependently 
    % on the current transmission scheme.
    % 
    switch strTrans
        
        % Single Port scheme 
        case 'SinglePort'
            [ mTF mSCMap mModMap sPDSCH ] = PDSCH_SingPort_P0(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPDSCH, sCodewords);
        
    end
end


%% PDSCH, Transmission Scheme: Single Port transmission, Port: 0
function [ mTF mSCMap mModMap sPDSCH ] = PDSCH_SingPort_P0(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPDSCH, sCodewords)


    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 

        % The RNTI ident. number
        n_rnti      = sP.RNTI;

        % The first physical layer identity group number 
        N_id1       = sP.N_id1;

        % The second physical layer identity group number 
        N_id2       = sP.N_id2;
        
        % The number of symbols dedicated for PDCCH channels
        nPDCCHSym   = sP.nPDCCHSym;
        
        % The PDSCH modulation order
        iModOrd     = sP.iModOrd;

    %----------------------------------------------------------
    
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 

        
        % The number of Resource Blocks in the bandwidth
        N_rb = sF.N_rb;
        
        % Get the number of subcarriers
        N_scB = sF.N_scB;
                
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;

        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;

        % The total number of subframes
        N_SF = sT.N_SF;
        
        % The index of the first subframe in a transmission
        FIRST_SF = sT.FIRST_SF;
    
    %----------------------------------------------------------        


    %---------------------------------------------------------- 
      
    % Calculate frequency parameters:
    
    % Get the number of subcarriers in a Resource Block
    N_scRB = N_scB / N_rb;
        
    
    %---------------------------------------------------------- 
    
    % Calculate time parameters:
    
    % The number of subframes in a Radio Frame
    N_SFRF = N_symbRF/N_symbSF;    
    
    % Calculate index of the current subframe in a Radio Frame
    inxSFRF = rem(inxSF,N_SFRF);
    
    % The number of Radio Slots in a Subframe
    N_RSSF = N_symbSF/N_symbDL;
    
    % Calculate index of the Radio Slot with PDSCH in a Radio Frame
    inxRSRF = inxSFRF*N_RSSF;    
    
    % Calculate index of the current subframe in the whole transmission
    inxSFTR = inxSF - FIRST_SF;       
        

    %% Obtain / generate bits for PDSCH channel in this subframe

    % Calculate the number of symbols dedicated for the PDSCH channel in
    % the current subframe
    nPDSCHSym = N_symbSF - nPDCCHSym;
    
    % Calculate the total number of Resource Elements in the PDSCH symbols
    nRE = N_scB*nPDSCHSym;

    % Check if the codewords input structure is valid
    if isstruct(sCodewords)

        % Check if the structure contains codewords for the PDSCH channel
        if isfield(sCodewords,'mPDSCHBits')

            % Get the strucutre with PDSCH codwords
            mPDSCHBits = sCodewords.mPDSCHBits;

            % Check the number of columns in matrix with PDSCH codewords
            % (Should be equal to the number of codewords)
            if size(mPDSCHBits,2) ~= 1
                strErrMsg = sprintf('\n ERROR (AddPDSCH): The given codewords matrix has a wrong number of columns! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Get the current codewords vector
            vPDSCHBits = mPDSCHBits(:,1,inxSFTR+1);
            
        else
            % Generate the codewords matrix 
            vPDSCHBits = randi([ 0 1 ],nRE*iModOrd,1);
        end

    else
        % Generate the bits matrix (one columns - sequence of bits p. PDCCH group)
        vPDSCHBits = randi([ 0 1 ],nRE*iModOrd,1);
    end
    
    
    %% Scrambling
    
    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2;        

    % Calculate the initialization number
    iC_init = n_rnti*2^14 + ceil(inxRSRF/2)*2^9 + iN_id;

    % Generate the scrambling pseudo random sequence
    vC = genPseudRand_C(iC_init,size(vPDSCHBits,1))';

    % Scramble the bit vector
    vPDSCHScr = mod(vPDSCHBits+vC,2);

    
    %% Modulation

    % Run the correct modulation function
    switch iModOrd

        % 2nd modulation order - QPSK
        case 2
            vPDSCHsymb = modQPSK(vPDSCHScr);
            strModul = 'QPSK';

        % 4th modulation order - QAM16
        case 4
            vPDSCHsymb = modQAM16(vPDSCHScr);
            strModul = 'QAM16';
            
        % 6th modulation order - QAM64
        case 6
            vPDSCHsymb = modQAM64(vPDSCHScr);
            strModul = 'QAM64';
            
        % Unknown modulation    
        otherwise
            strMsg = sprintf('ERROR (AddPDSCH): Unknown PDSCH modulation type!');
            error(strMsg);
    end
       
    
    %% Mapping
    
    % Reset the symbols index (index of symbols in the Subframe)
    inxSymSub = nPDCCHSym;

    % Reset the symbols index (index of symbols in the transmission)    
    inxSymTr = inxSFTR*N_symbSF + inxSymSub + 1;
    
    % -------------------------------------------    
    % Calculate where the PBCH can be found    
    
    % Calculate the center of a bandwidth
    iHB = N_scB/2;
    
    % Calculate the first subcarrier index where the PBCH can be found    
    iL_SubPBCH = iHB - 3*N_scRB + 1;
    
    % Calculate the end of the bandwidth where the PBCH can be found   
    iH_SubPBCH = iHB + 3*N_scRB;
    
    % Calculate index of the first symbol with PBCH
    iF_SymPBCH = N_symbDL;

    % Calculate index of the last symbol with PBCH
    iL_SymPBCH = N_symbDL + 3;


    % -------------------------------------------
    % Reset the subcarriers index
    inxSub = 1;
    
    % Loop over all symbols dediated for the PDSCH channel
    for inxSym = 1:size(vPDSCHsymb,1)
        
        % Reset the quit flag
        bQuit = 0;
        
        % Reset the bMapped flag
        bMapped = 0;
        
        % Loop until the symbol is mapped
        while bMapped == 0
            
            % Check if the current subframe contains PBCH channel            
            if inxSFRF==0
                
                % Check if the mapping is somewhere in PBCH region:                                
                while (iL_SubPBCH <= inxSub && inxSub <= iH_SubPBCH) && (iF_SymPBCH <= inxSymSub  && inxSymSub <= iL_SymPBCH)
                    
                    % Move the subcarier index out from the PBCH region
                    inxSub = iH_SubPBCH + 1;
                    
                    % Check if the symbol index must be push forward
                    if inxSub > N_scB
                        
                        % Reset the subcarrier index
                        inxSub = 1;
                        
                        % Move forward index of the symbol in the subframe
                        inxSymSub = inxSymSub + 1;
                        
                        % Move forward the symbols index (index of symbols in the transmission)    
                        inxSymTr = inxSFTR*N_symbSF + inxSymSub + 1;                        
                    end
                end                
            end
            
            % Check if the current Resource Element is free
            if strcmp(mSCMap{inxSub,inxSymTr},'.') == 1
                
                % The Resource Element is free, map the PDSCH channel here:                
                
                % Channel type:
                mSCMap(inxSub,inxSymTr) = {'PDSCH'};
                
                % Modulation scheme:
                mModMap(inxSub,inxSymTr) = {strModul};
                
                % The current PDSCH symbol:
                mTF(inxSub,inxSymTr) = vPDSCHsymb(inxSym);
                                
                % Set the bMapped flag
                bMapped = 1;
            end

            % Move the subcarrier index forward
            if inxSub == N_scB                                
                inxSub = 1;
            else
                inxSub = inxSub + 1;
            end
            
            % Symbols (if the subcarriers index was reseted)
            if inxSub == 1                                                            
                
                % Move forward index of the symbol in the subframe
                inxSymSub = inxSymSub + 1;
                
                % Move forward the symbols index (index of symbols in the transmission)    
                inxSymTr = inxSFTR*N_symbSF + inxSymSub + 1;
                
                % If the index of symbols in the subframe has exceeded
                % the subframe, set the quit flag
                if inxSymSub >= N_symbSF                    
                    
                    % Set the quit flag to 1
                    bQuit = 1;
                    
                    % Store the number of PDSCH symbols
                    N_symPDSCH = inxSym;                    
                    
                    % If the codewords were taken from the file supplied by
                    % the user, print out a warning
                    if isstruct(sCodewords)
                        fprintf('WARNING (AddPDSCH): In the %d subframe only a part of a codeword were mapped to the resources!\n',inxSFTR);
                    end
                    
                    % Break the while loop
                    break;
                end
            end            
        end
        
        % Check if the quit flag was set 
        if bQuit == 1
            break;            
        end
    end


    %% Add the information about the current subframe into the PDSCH output strucutre
    
    % Store the number of PDSCH symbols mapped in the current subframe
    sPDSCH.vN_symPDSCH(inxSFTR+1) = N_symPDSCH;
    
    % Store the vector with PDSCH symbols mapped in the current subframe
    sPDSCH.cvSymPDSCH{inxSFTR+1} = vPDSCHsymb(1:N_symPDSCH);

end

