%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPBCH: THE "ALGaE" PACKAGE - PBCH CHANNEL MODULATOR AND MAPPER
% 
% Function modulates the PBCH channel and map it to the current subframe.                                    
%
% File version 1.0 (27th July 2011)
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
%       4. sLTE_stand:  Structure with the LTE standard structure.
%
%
%       5. sF:          Structure with the bandwidth (frequency) configuration.
%
%       6. sT:          Structure with the time configuration.
%
%       7. sP:          Structure with the LTE-specific parameters.
%
%
%       8. inxSF:       Index of the xurrent porcessed subframe.
%       
%       9. sPBCH:       Info structure with PBCH channel data and parameters.
%                       (the strucutre may be empty)
%
%       10. sCodewords: Structure with codewords.
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
%       4. sPBCH:       structure with information about 
%                       Physical Broadcast Channel (PBCH).
%
%               .sPBCH:       structure with information about Physical Broadcast Channel (PBCH)
%               
%                   Fields in the 'sPBCH' structure:
%     
%                       .nRESym0        : the number of Resource Elements with PBCH
%                                         in a symbol with index 0 in a subframe with PBCH                               
%     
%                       .nRESym1        : the number of Resource Elements with PBCH
%                                         in a symbol with index 1 in a subframe with PBCH
%                                       
%                       .nRESym2        : the number of Resource Elements with PBCH
%                                         in a symbol with index 2 in a subframe with PBCH
%                                       
%                       .nRESym3        : the number of Resource Elements with PBCH
%                                         in a symbol with index 3 in a subframe with PBCH
%     
%                                       
%                       .vK0            : the indices of subcarriers with PBCH in a
%                                         symbol with index 0 in a subframe with PBCH
%                                         [vector, size: nRESym0 x 1 ]
%     
%                       .vK1            : the indices of subcarriers with PBCH in a
%                                         symbol with index 1 in a subframe with PBCH
%                                         [vector, size: nRESym1 x 1 ]
%     
%                       .vK2            : the indices of subcarriers with PBCH in a
%                                         symbol with index 2 in a subframe with PBCH
%                                         [vector, size: nRESym2 x 1 ]
%     
%                       .vK3            : the indices of subcarriers with PBCH in a
%                                         symbol with index 3 in a subframe with PBCH
%                                         [vector, size: nRESym3 x 1 ]
% 
%                       .nBits_TTI      : the number of bits in a PBCH TTI (Time Transmission 
%                                         Interval )
% 
%                       .vC             : the scrmabling sequence used in PBCH
%                                         [vector, size: nBits_TTI x 1 ]  
% 
%                       .nModSymb_TTI   : the number of PBCH modulation symbols in a
%                                         PBCH TTI (Time Transmission Interval)
% 
%                       .nPBCH_TTI      : the number of started PBCH Time Transmission
%                                         Intervals in the whole transmission                                 
% 
%                       .nPBCHsubf      : the number of subframes with a PBCH
%                                         channel 
% 
%                       .mPBCHBits      : bits send in PBCH (one PBCH subframe in one column)
%                                         [matrix, size: nBits_TTI x nPBCHsubf ]
% 
%                       .mPBCHSym       : symbols send in PBCH (one PBCH subframe in one column)
%                                         [matrix, size 0.5*nBits_TTI x nPBCHsubf ]
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

function [ mTF mSCMap mModMap sPBCH ] = AddPBCH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPBCH, sCodewords)


    %% ----------------------------------------------------------
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME PARAMETERS STRUCTURE
    %
    % (structures: 'sT'): 
    
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;
                
        % Index of the first Radio Frame in PBCH TTI
        PBCH_RFINX = sT.PBCH_RFINX;
        
    %----------------------------------------------------------    
    
    % The number of subframes in a Radio Frame
    N_SFRF = N_symbRF/N_symbSF;    
    
    % Calculate index of the current subframe in a Radio Frame
    inxSFRF = rem(inxSF,N_SFRF);
    
    % PBCH is mapped only to subframes with indices 0 
    if inxSFRF ~= 0   
        return;
    end

    
    %% ----------------------------------------------------------
    % Check if the Reference Signals map was already created
    if ~isfield(sPBCH,'nRESym0')
        
        % Generate the RS signals map
        sPBCH = genRefSigMap(sPBCH,sF,sT,sP);
                
    end


    %% ----------------------------------------------------------
    
    % Index of the current Radio Frame in the transmission
    inxRF_TR = floor(inxSF/N_SFRF);

    % Calculate index of the current Radio Frame in the PBCH TTI
    inxRF_TTI = rem((inxRF_TR + PBCH_RFINX),4);
    
    % Check if the new PBCH symbols stream must be generated
    % (Due to the new PBCH TTI)
    if inxRF_TTI == 0
        
        % Generate PBCH bitstream
        sPBCH = genPBCHSymbols(sPBCH, sT, sP, sCodewords);

    else
        
        % Check if the new PBCH symbols stream must be generated
        if ~isfield(sPBCH,'mPBCHBits')
        
            % Check if the new PBCH symbols stream must be generated
            sPBCH = genPBCHSymbols(sPBCH, sT, sP, sCodewords);        
        end
    end

    % --------------------------------------------------------------


    %% Increase the number of subframes with PBCH 
    
    % Check if this number was already mapped, if not, move forward
    if ~isfield(sPBCH,'nPBCHsubf')
        sPBCH.nPBCHsubf = 1;
    else
        sPBCH.nPBCHsubf = sPBCH.nPBCHsubf + 1;
    end


    %% ----------------------------------------------------------

    % Map the PBCH to the current subframe
    [ mTF mSCMap mModMap ] = MapPBCH(mTF, mSCMap, mModMap, sT, inxSF, sPBCH);

end



%% Generate the Reference Signals map
function sPBCH = genRefSigMap(sPBCH,sF,sT,sP)
%% INDICATE THE RESOURCE ELEMENTS DEDICATED FOR REFERENCE SIGNALS
%  IN ONE RADIO SLOT 
%
% According to chapter 6.6.4 of the ... the PBCH should be mapped to
% every second Radio Slot in all Radio Frames on antenna ports 0,1,2
% and 3. 
%
% The PBCH should occupied certain subcarriers on symbols 0, 1, 2 and 3
% in the above Radio Slot, but excluding these Resource Elements which
% are dedicated for Reference Signals IRRISPECTIVELY OF THE CURRENT ANTENNA
% PORT NUMBER. 
%
% Due to the above, the function creates an auxilary resource loop matrix 
% of size equal to one Radio Slot. 
% Afterwards, all Resource Elements dedicated for Reference Signals in all
% antenna ports configurations are marked in this matrix with a 0. Resource 
% Elements not dedicated for Reference Signals are marked with 1.
%  
% 
% Based on the above mapping four vectors with indices of subcarriers
% in which PBCH can be mapped are created, These vectors are:
% vK0, vK1, vK2, vK3. One vector corresponds to one symbol in a Radio Slot dedicated  
% for PBCH.  


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 

        % The first physical layer identity group number 
        N_id1       = sP.N_id1;

        % The second physical layer identity group number 
        N_id2       = sP.N_id2;

    %---------------------------------------------------------- 

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 
    
        % The number of Resource Blocks
        N_rb = sF.N_rb;
    
        % The number of subcarriers
        N_scB = sF.N_scB;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
        % The number of symbols in a Radio Slot
        N_symbDL = sT.N_symbDL;
                
    %----------------------------------------------------------    
    
    % Allocate the auxillary matrix with a size of one Radio Slot
    mAuxRS = zeros(N_scB,N_symbDL);
    
    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2; 

    % Calculate the iNi_shift
    iNi_shift = mod(iN_id,6);
    
    % Loop over all possible antenna ports (4 antenna ports)
    for inxAntPort=0:3
        
        % -------------------------------------------------------------------
        % FIRST SYMBOL IN RADIO SLOT WITH A REFERENCE SIGNAL:

        % Index of the first symbol in the Radio Slot
        % (index in the whole transmission)
        switch inxAntPort
            case 0
                inxSym = 0;
            case 1
                inxSym = 0;
            case 2
                inxSym = 1;
            case 3
                inxSym = 1;
        end

        
        % Get the correct iNi
        switch inxAntPort
            case 0
                iNi = 0;

            case 1
                iNi = 3;

            case 2
                iNi = 3*mod(1,2);

            case 3
                iNi = 3+3*mod(1,2);
        end

        
        % Calculate the vector with a frequency position                                    
        vm = (0:2*N_rb-1)';
        vk = 6*vm + mod(iNi+iNi_shift,6);

        % Mark the signal in the Signals and Channels matrix
        mAuxRS(vk+1,inxSym+1) = 1;

        
        % -------------------------------------------------------------------
        % SECOND SYMBOL IN RADIO SLOT WITH A REFERENCE SIGNAL:            
        %
        % Only in antenna ports 0 and 1
        if inxAntPort > 1
            continue;
        end

        % Index of the second symbol in the Radio Slot
        % (index in the whole transmission)
        inxSym = N_symbDL - 3;

        % Get the correct iNi
        switch inxAntPort
            case 0
                iNi = 3;

            case 1
                iNi = 0;                    
        end

        % Calculate the vector with a frequency position                                    
        vm = (0:2*N_rb-1)';
        vk = 6*vm + mod(iNi+iNi_shift,6);
        
        % Mark the signal in the Signals and Channels matrix
        mAuxRS(vk+1,inxSym+1) = 1;
    end

    % Cut the 'mAuxRS' matrix into 4 first symbols
    mAuxRS = mAuxRS(:,1:4);



    %% ------------------------------------------------------------------
    % CREATE VECTORS WITH THE INDICES OF SUBCARRIERS WHICH CAN BU USED
    % TO MAP PBCH
    
    % Calculate indices of subcarriers dedicated for PBCH
    vk = (0:71)';
    vk = N_scB/2 - 36 + vk;       
    
    % Cut from the mAuxRS matrix this part which can be used for
    % the PBCH.
    %  
    
    % Generate vector with indices of all subcarriers
    vSubInx = (1:N_scB)';
    
    % Generate matrix with indices of all subcarriers for 4 symbols
    mSubInx = repmat(vSubInx,1,4);
    
    % Remove indices which are occupied by RS signal
    mSubInx(mAuxRS == 1) = 0;         
    
    % Generate vector with indices of all subcarriers                
    mSubInx = mSubInx(vk+1,1:4);
        
    
    % ----------------------------------------------    
    
    % Calculate the number of RE dedicated for PBCH in all 
    % 4 symbols in a second Radio Slot in a Radio Frame
    nRESym0 = sum(mSubInx(:,1) ~= 0);
    nRESym1 = sum(mSubInx(:,2) ~= 0);
    nRESym2 = sum(mSubInx(:,3) ~= 0);
    nRESym3 = sum(mSubInx(:,4) ~= 0);    

    % Store the above numbers in the sPBCH structure
    sPBCH.nRESym0 = nRESym0;
    sPBCH.nRESym1 = nRESym1;
    sPBCH.nRESym2 = nRESym2;
    sPBCH.nRESym3 = nRESym3;
    
    % ----------------------------------------------    
    
    
    % Get the indices of subcarriers dedicated for PBCH in all 
    % 4 symbols in a second Radio Slot in a Radio Frame    
    
    vK0 = mSubInx((mSubInx(:,1) ~= 0),1);
    vK1 = mSubInx((mSubInx(:,2) ~= 0),2);
    vK2 = mSubInx((mSubInx(:,3) ~= 0),3);
    vK3 = mSubInx((mSubInx(:,4) ~= 0),4);

    
    % Store the above vectors in the sPBCH structure
    sPBCH.vK0 = vK0;
    sPBCH.vK1 = vK1;
    sPBCH.vK2 = vK2;
    sPBCH.vK3 = vK3;


end


%% Generate the symbols for PBCH 
function sPBCH = genPBCHSymbols(sPBCH, sT, sP, sCodewords)


    %% GENERATE THE BITSTRAM VECTOR WHICH IS USED TO CREATE THE PBCH CHANNEL
    %
    % Bitstream generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.6 (Physical broadcast channel)
    %
        
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME PARAMETERS STRUCTURE    
    %
    % (structure: 'sT'): 
    
        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;
        
    %----------------------------------------------------------   
    
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 

        % The first physical layer identity group number 
        N_id1       = sP.N_id1;

        % The second physical layer identity group number 
        N_id2       = sP.N_id2;

    %---------------------------------------------------------- 

    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2; 
    
    
    % According to the chapter 6.6.1 of the 3GPP TS 36.211 (Physical channels and modulation)
    % there is a different number of bits transmitted in the PBCH channel
    % in one TTI
    if N_symbDL == 7
        nBits_TTI = 1920;
    else        
        nBits_TTI = 1728;
    end
    
    % Save this lenght in the sPBCH structure
    sPBCH.nBits_TTI = nBits_TTI;
    
    
    %% Get the current index of the PBCH TTI
    
    % Check if the index of PBCH TTI was initiated
    if ~isfield(sPBCH,'nPBCH_TTI')
        
        % Initiatate the index of PBCH TTI 
        nPBCH_TTI = 1;
        
        % Save this index of PBCH TTI
        sPBCH.nPBCH_TTI = nPBCH_TTI;
    else
        
        % Get the index of PBCH TTI and increment it
        nPBCH_TTI = sPBCH.nPBCH_TTI + 1;
        
        % Save the index of PBCH TTI
        sPBCH.nPBCH_TTI = nPBCH_TTI;
    end    
    
    %% Obtain or generate the PBCH bitstream.
    
    % Check if the codewrods input structure is valid
    if isstruct(sCodewords)
        
        % Check if the structure contains bits for the PBCH channel
        if isfield(sCodewords,'mPBCHBits')
            mPBCHBits = sCodewords.mPBCHBits;           

            % Check the input bits lenght
            if size(mPBCHBits,1) ~= nBits_TTI
                error('ERROR (AddPBCH): The given bit matrix has wrong number of bits p. subframe! BAILING OUT!');
            end 
                        
            % Check if the given bit matrix has correct number of columns
            if size(mPBCHBits,2) >= nPBCH_TTI     
                
                % Get the current bitstream vector
                vPBCHBits = mPBCHBits(:,nPBCH_TTI);
                
            else
                % Throw out an error
                strErrMsg = sprintf('\n ERROR (AddPBCH): The given bit matrix does not have bits for PBCH TTI # %d! \n',nPBCH_TTI);
                strErrMsg = sprintf('%s %s',strErrMsg,'ERROR (AddPBCH): Not enough column in the mPBCHBits matrix! BAILING OUT!');                
                error(strErrMsg); %#ok<SPERR>
            end
            
        else
            
            % If the structure does not contain bits for the PBCH channel
            % generate the random bits
            vPBCHBits = randi([0 1],nBits_TTI,1);
        end

    else
        % If the physicall channels input structure is not valid
        % generate the random bits
        vPBCHBits = randi([0 1],nBits_TTI,1);                        
    end


    %% Scramble 
    
    % Check if the scrambling sequence was initiated
    if ~isfield(sPBCH,'vC')
        
        % If not, generate the scrambling pseudo random sequence
        vC = genPseudRand_C(iN_id,nBits_TTI)';
        
        % Save this scrambling sequence
        sPBCH.vC = vC;
        
    else
        
        % Get the pseudo random sequence
        vC = sPBCH.vC;        
    end
     
    % Scramble the bit vector
    vPBCHScr = mod(vPBCHBits+vC,2); 


    %% Modulate
    vPBCHsym = modQPSK(vPBCHScr);
    
    % Save the lenght of modulated vector in the sPBCH structure
    sPBCH.nModSymb_TTI = size(vPBCHsym,1);
    
    
    %% Create the output structure
    
    % Save the bitstream
    sPBCH.mPBCHBits(:,nPBCH_TTI) = vPBCHBits;

    % Save the symbols dedicated for PBCH
    sPBCH.mPBCHSym(:,nPBCH_TTI) = vPBCHsym;

end



%% Map the PBCH
function  [ mTF mSCMap mModMap ] = MapPBCH(mTF, mSCMap, mModMap, sT, inxSF, sPBCH)

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    %
    % (structure: 'sT'): 

    
        % The number of symbols in a Radio Slot
        N_symbDL = sT.N_symbDL;
        
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;
        
        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;
                
        % The index of the first subframe in transmission
        FIRST_SF  = sT.FIRST_SF;
        
        % Index of the first Radio Frame in PBCH TTI
        PBCH_RFINX = sT.PBCH_RFINX;
        
    %----------------------------------------------------------    


    %----------------------------------------------------------    
    % GET THE NEEDEED DATA FROM THE PBCH CHANNEL STRUCUTRE
    % (strucutre: sPBCH)
    
        % Vectors with subcarriers dedicated for PBCH for first 4 symbols
        % in a Radio Slot with the PBCH channel
        vK0 = sPBCH.vK0;
        vK1 = sPBCH.vK1;
        vK2 = sPBCH.vK2;
        vK3 = sPBCH.vK3;

        % The number of subcarriers dedicated for PBCH in first 4 symbols
        % in a Radio Slot with the PBCH channel
        nRESym0 = sPBCH.nRESym0;
        nRESym1 = sPBCH.nRESym1;
        nRESym2 = sPBCH.nRESym2;
        nRESym3 = sPBCH.nRESym3;


        % Get the current symbols stream
        vPBCHSym = sPBCH.mPBCHSym(:,sPBCH.nPBCH_TTI);
        
    %----------------------------------------------------------    
    
    % Get the number of symbols p. TTI in PBCH channel
    nModSymb_TTI = sPBCH.nModSymb_TTI;

    
    %----------------------------------------------------------

    % The number of subframes in a Radio Frame
    N_SFRF = N_symbRF/N_symbSF;
    
    % Index of the current Radio Frame in the transmission
    inxRF_TR = floor(inxSF/N_SFRF);

    % Calculate index of the current Radio Frame in the PBCH TTI
    inxRF_TTI = rem((inxRF_TR + PBCH_RFINX),4);

    % Get the part of the PBCH stream dedicated for this Radio Frame          
    vPBCHSym = vPBCHSym(inxRF_TTI*nModSymb_TTI/4+1:(inxRF_TTI+1)*nModSymb_TTI/4);
    
    % Reset the symbols stream pointer
    inxSym = 1;
    
    %----------------------------------------------------------
    % First symbol
    
    % Calculate index of the current symbol in the whole transmission
    inxSymbTR = (inxSF-FIRST_SF)*N_symbSF + N_symbDL + 1;

    % Denote the PBCH channel in the signals and channels
    % map    
    mSCMap(vK0,inxSymbTR) = {'PBCH'};

    % Denote the modulation to QPSK
    mModMap(vK0,inxSymbTR) = {'QPSK'};

    % Map the symbol 
    mTF(vK0,inxSymbTR) = vPBCHSym(inxSym:inxSym+nRESym0-1);
    
    % Move the symbol index to the next one
    inxSym = inxSym+nRESym0;


    %----------------------------------------------------------
    % Second symbol

    % Calculate index of the current symbol in the whole transmission
    inxSymbTR = inxSymbTR + 1;

    % Denote the PBCH channel in the signals and channels
    % map        
    mSCMap(vK1,inxSymbTR) = {'PBCH'};

    % Denote the modulation to QPSK
    mModMap(vK1,inxSymbTR) = {'QPSK'};

    % Map the symbol 
    mTF(vK1,inxSymbTR) = vPBCHSym(inxSym:inxSym+nRESym1-1);

    % Move the symbol index to the next one
    inxSym = inxSym+nRESym1;

    
    %----------------------------------------------------------
    % Third symbol

    % Calculate index of the current symbol in the whole transmission
    inxSymbTR = inxSymbTR + 1;        

    % Denote the PBCH channel in the signals and channels
    % map        
    mSCMap(vK2,inxSymbTR) = {'PBCH'};

    % Denote the modulation to QPSK
    mModMap(vK2,inxSymbTR) = {'QPSK'};

    % Map the symbol 
    mTF(vK2,inxSymbTR) = vPBCHSym(inxSym:inxSym+nRESym2-1);

    % Move the symbol index to the next one
    inxSym = inxSym+nRESym2;

    
    %----------------------------------------------------------
    % Fourth symbol

    % Calculate index of the current symbol in the whole transmission
    inxSymbTR = inxSymbTR + 1;

    % Denote the PBCH channel in the signals and channels
    % map
    mSCMap(vK3,inxSymbTR) = {'PBCH'};

    % Denote the modulation to QPSK
    mModMap(vK3,inxSymbTR) = {'QPSK'};

    % Map the symbol 
    mTF(vK3,inxSymbTR) = vPBCHSym(inxSym:inxSym+nRESym3-1);        
    
end

