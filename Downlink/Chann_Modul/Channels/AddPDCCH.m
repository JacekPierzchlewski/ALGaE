%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPDCCH: THE "ALGaE" PACKAGE - PDCCH CHANNEL MODULATOR AND MAPPER
% 
% Function modulates the PDCCH channel and map it to the current subframe. 
%
% File version 1.0 (12th August 2011)
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
%       7. sLTE_stand:  Structure with the LTE standard
%
%       8. inxSF:       Index of the current porcessed subframe
%
%
%       9. sPDCCH:     Structure with the PDCCH channel
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
%       4. sPDCCH:      Structure with information about the PDCCH
%                       channel.
%
%          Fields in the 'sPDCCH' structure:
%
%                   .nPDCCHsubf     : the number of subframes with
%                                     PDCCH channel
% 
%                   .iN_BtsSub      : the number of PDCCH bits in a
%                                     Subframe
% 
%                   .iN_quadSub     : the number of PDCCH quadruplets in a Subframe 
% 
% 
%                   .m3Sym          : 3D matrix with quadruplets. One
%                                     matrix page contains quadruplets
%                                     from one Subframe.
%                                     [ 3D matrix, size: 4 x iN_quadSub x nPDCCHsubf ]                                          
% 
%                   .mC             : matrix with scrambling sequences.
%                                     One column contains scrambling sequence
%                                     from one Subframe.
%                                     [ matrix, size: iN_BtsSub x nPDCCHsubf ] 
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


function [ mTF mSCMap mModMap sPDCCH ] = AddPDCCH(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPDCCH, sCodewords)


    %% Obtain / generate bits for PDCCH channel in this subframe
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD STRUCTURE
    % (structure: 'sLTE_stand' and 'sScen'):

        % The number of PDCCH bits in a CCE
        iBitspCCE = sLTE_stand.iPDCCH_BitpCCE;

        % Permutation sequence
        vPDCCH_CMP = sLTE_stand.vPDCCH_CMP;

    %----------------------------------------------------------    
    
    
    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 

        % The first physical layer identity group number 
        N_id1       = sP.N_id1;

        % The second physical layer identity group number 
        N_id2       = sP.N_id2;
        
        % The number of PDCCH channels
        nPDCCH      = sP.nPDCCH;
                
        % The number of CCEs p. PDCCH channel
        vCCEs       = sP.vCCEs;

        
    %----------------------------------------------------------    
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 

        
        % The number of subcarriers in the bandwidth
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
        
        % The index of the first subframe in transmission
        FIRST_SF = sT.FIRST_SF;
    
    %----------------------------------------------------------        


    %---------------------------------------------------------- 
    % Calculate time parameters:
    
    % The number of subframes in a Radio Frame
    N_SFRF = N_symbRF/N_symbSF;    
    
    % Calculate index of the current subframe in a Radio Frame
    inxSFRF = rem(inxSF,N_SFRF);
    
    % The number of Radio Slots in a Subframe
    N_RSSF = N_symbSF/N_symbDL;
    
    % Calculate index of the Radio Slot with PHICH in a Radio Frame
    inxRSRF = inxSFRF*N_RSSF;    
    
    % Calculate index of the current subframe in the whole transmission
    inxSFTR = inxSF - FIRST_SF;       
    
    % Calculate index of the first symbol of the current subframe in the whole
    % transmission
    l = inxSF*N_symbSF - FIRST_SF*N_symbSF;
    
    
    %----------------------------------------------------------     

    
    % Calculate the total number of bits send in PDCCH channels 
    vN_BtsChn = iBitspCCE*vCCEs;
        
    % Calculate the total number of bits send in PDCCH channels in this subframe
    iN_BtsSub = sum(vN_BtsChn);
    
    
    % Check if the codewords input structure is valid
    if isstruct(sCodewords)
        
        % Check if the structure contains codewords for the PDCCH channel
        if isfield(sCodewords,'mPDCCHBits')
            mPDCCHBits = sCodewords.mPDCCHBits;           

            % Check the input bits lenght
            if size(mPDCCHBits,1) ~= iN_BtsSub                
                strErrMsg = sprintf('\n ERROR (AddPDCCH): The given codewords matrix has a wrong number of bits p. subframe! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Check the number of columns in matrix with PDCCH codewords
            % (Should be equal to the number of subframes)
            if size(mPDCCHBits,2) ~= N_SF
                strErrMsg = sprintf('\n ERROR (AddPDCCH): The given codewords matrix has a wrong number of columns! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Get the current codewords vector
            vPDCCHBits = mPDCCHBits(:,inxSFTR+1);                                    
            
        else
            % Generate the codewords matrix (one columns - sequence of bits p. PDCCH group)
            vPDCCHBits = randi([ 0 1 ], iN_BtsSub, 1);
        end

    else
        % Generate the bits matrix (one columns - sequence of bits p. PDCCH group)
        vPDCCHBits = randi([ 0 1 ], iN_BtsSub, 1);
    end
        
    
    %% Multiplexing
    
    % Reset the current number of CCEs
    nCCE = 0;
    
    % Reset pointer of the vPDCCHBits vector
    inxBits = 0;
    
    % Initialize vector with bits
    vBits = [];
    
    % Initialize vector which indicates NULL elements
    vNULL = [];
    
    % Loop over all channels
    for inxChan=1:nPDCCH
        
        % Take the number of CCEs in this channel
        iCCE = vCCEs(inxChan);
        
        % Take the number of bits in this channel
        nBits = vN_BtsChn(inxChan); 
                            
        % Calculate the number of null CCEs
        nNullCCEs = rem(nCCE,iCCE);
        
        % Calculate the number of null elements
        nNull = iBitspCCE*nNullCCEs;

        % Put null elements and bits from this channel into the vector with bits
        vBits = [ vBits ; zeros(nNull,1) ; vPDCCHBits(inxBits+1:inxBits+nBits) ]; %#ok<AGROW>

        % Indicate null elements and bits in the vNULL vector
        vNULL = [vNULL  ; ones(nNull,1) ; zeros(nBits,1)];             %#ok<AGROW>
        
        % Update the number of CCEs
        nCCE = nCCE + nNullCCEs + iCCE;
        
        % Move the pointer of the vPDCCHBits vector forward
        inxBits = inxBits + nBits;        
    end
    
    % Make the new multiplexed vector the main vector with data
    vPDCCHBits = vBits;
    
    % Get the number of bits in the new vector
    nBits = size(vPDCCHBits,1);
    
    
    %% Scrambling 
    
    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2;    
    
    % Calculate the initialization number
    iC_init = floor(inxRSRF/2)*2^9 + iN_id;

    % Generate the scrambling pseudo random sequence
    vC = genPseudRand_C(iC_init,nBits)';

    % Scramble the bit vector
    vPDCCHScr = mod(vPDCCHBits+vC,2);



    %% Modulation
    
    % Run the modulation
    vPDCCHSym =  modQPSK(vPDCCHScr);
    
    % Generate vector which indicates NULL symbols after modulation
    vNULLSymb = vNULL(2:2:size(vNULL,1));
    
    % Put the NULL elements to 0
    vPDCCHSym(vNULLSymb==1) = 0;    



    %% Quadruplet permutation

    % Calculate the number of quadruplets
    % (There are 8 bits hidden in one quadruplet)
    nQuad = nBits/8;
        
    % Reshape symbols into quadruplets
    mQ = reshape(vPDCCHSym, 4, nQuad);
    
    % The number of columns in the permutation matrix
    nC = size(vPDCCH_CMP,1);
    
    % Calculate the number of rows in the permutation matrix 
    nR = ceil(nQuad/nC);
    
    % Calculate the number of <NULL elements>
    nNull = nR*nC - nQuad;
    
    % Generate the permutation matrix
    vPrmMat = [ zeros(1,nNull)  1:nQuad ];    
    mPrmMat = reshape(vPrmMat,nC,nR);
    mPrmMat = mPrmMat';
    
    % Permute columns
    mPrmMat = mPrmMat(:,vPDCCH_CMP+1);
    
    % Reshape indices of quadruplets into vector
    vPrmMat = mPrmMat(:);

    % Remove empty indices (NULL elements)
    vPrmMat = vPrmMat(vPrmMat>0);

    % Sort quadruplets according to the permutation
    mQ = mQ(:,vPrmMat);


    %% Cyclic Shift
    mQ_ = zeros(size(mQ));
    
    % Loop over all quadruplets
    for inxQ = 0:(nQuad-1)
        
        mQ_(:,inxQ+1) = mQ(:,mod(inxQ+iN_id,nQuad)+1);
        
    end

    %% Mapping to Resource Elements
            
    % Calculate positions of quadruplets
    [ mSub , mSym ] = calcQuadPos(mSCMap, sP, sT, sF, l, nQuad);
               
    % Create the index matrix
    mI = (mSym-1).*N_scB + mSub;
        
    % Map the PDCCH quadruplets to the Resource Elements 
    mTF(mI) = mQ_;
    
    % Denote the PDCCH
    mSCMap(mI) = {'PDCCH'};
    
    % Denote the modulation used for PDCCH
    mModMap(mI) = {'QPSK'};    
    
    
    %% PDCCH channel information structure service:
    
    % Check if the number of subframes with PDCCH was already started
    if isfield(sPDCCH,'nPDCCHsubf') 
                 
        % Get the number of subframes with PDCCH
        nPDCCHsubf = sPDCCH.nPDCCHsubf;
                
        % Increase the number of subframes with PDCCH
        nPDCCHsubf = nPDCCHsubf + 1; 
        
    else

        % The number of subframes with PDCCH was not yet started, start it
        nPDCCHsubf = 1;        
        
        % Store the number of bits send in the PDCCH channel in one
        % subframe
        sPDCCH.iN_BtsSub = iN_BtsSub;

        % Calculate the number of PDCCH quadruplets in one Subframe
        iN_quadSub = iN_BtsSub/8;
        
        % Store the number of PDCCH quadruplets in one Subframe
        sPDCCH.iN_quadSub = iN_quadSub;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Allocate matrices for information in the channel information
        % structure:
                
        % Allocate 3D matrix for quadruplets with symbols mapped to the PDCCH channel
        sPDCCH.m3Sym = zeros(4, iN_quadSub, N_SF);
        
        % Allocate matrix for scrambling pseudo sequences
        sPDCCH.mC = zeros(iN_BtsSub,N_SF);
        
    end

    % Store the number of subframes with PDCCH channels
    sPDCCH.nPDCCHsubf = nPDCCHsubf;
    
    % Store the quadruplets with PDCCH channel
    sPDCCH.m3Sym = mQ_;
    
    % Store the scrambling sequence for this subframe
    sPDCCH.mC(:,iN_BtsSub) = vC;
    
end



%% INTERNAL FUNCTION: calculate positions of PDCCH quadruplets
%   
%   ----------------------------------------------------------------
%   Inputs (6): 
%   
%           1. mSCMap:      structure with the current LTE scenario 
%
%           2. sP:          structure with the LTE standard parameters
%
%           3. sT:          structure with the LTE bandwidth frequency 
%                           configuration
%
%           4. sF:          structure woith other LTE-specific parameters
%
%           5. inxSym:      handle to the report file
%
%           6. nQuad:       the number of PDCCH quadruplets to be mapped
%
%   ----------------------------------------------------------------
%   Outputs (2): 
%
%           1. mSub:        matrix with indices of subcarriers for elements
%                           of quadruplet
%
%           2. mSym         matrix with indices of symbols for elements
%                           of quadruplets
%
%
function [ mSub , mSym ] = calcQuadPos(mSCMap, sP, sT, sF, inxSym, nQuad)
    

    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 
        
        % The number of symbols dedicated for PDCCH channel
        nPDCCHSym      = sP.nPDCCHSym;
    
    %----------------------------------------------------------
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 
        
        % The number of subcarriers in a bandwidth
        N_scB = sF.N_scB;
        
        % The current number of antenna ports
        nAnt       = sF.nAnt;

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        % CP type index
        inxCP     = sT.inxCP;
           
    %----------------------------------------------------------


    %----------------------------------------------------------
    % Set up the number of RE in REGs in every symbols 
    % for PDCCH
    
    % First symbol
    nREG1 = 6;

    % In the second symbol, there is a different number of REs in REG
    % dependently on the number of Antenna Ports
    if nAnt == 0 || nAnt == 1
        nREG2 = 4;
    else
        nREG2 = 6;
    end

    % Third symbol
    nREG3 = 4;

    % In the fourth symbol, there is a different number of REs in REG
    % dependently on the size of a cyclic prefix
    if inxCP == 1
        nREG4 = 4;     % Normal CP
    else
        nREG4 = 6;     % Extended CP
    end

    % Contruct a vector 
    vSymbRegs = [ nREG1 nREG2 nREG3 nREG4 ]';
    
        
    %----------------------------------------------------------



    %----------------------------------------------------------

    % Allocate matrix for indices of subcarriers and symbols
    mSub = zeros(4,nQuad);  % Subcarriers
    mSym = zeros(4,nQuad);  % Symbols
    
    % Initialize m_ (Resource Element Groupd Number)
    m_ = 0;
    
    % Initialize k_
    k_ = 0;
    
    % Initialize the l_ (symbol index)
    l_ = 0;

    % Loop until all quadruplets
    while m_ < nQuad
        
        % Get the correct number of RE in REG for this symbol
        nReg = vSymbRegs(l_+1);
        
        % Check if this subcarrier index represents REG        
        if rem(k_,nReg) == 0
            
            % Check if this REG contains PHICH or PDCFICH
            bEmpty = 1;
            
            % Loop over all subcarriers
            for inxSub=0:(nReg-1)

                % Take the Resource Element
                cRE = mSCMap(k_+inxSub+1, inxSym+l_+1);

                % Convert the Resource Element into a string
                strRE = cell2mat(cRE);
                
                % Check if this element is occupied
                if strcmp(strRE,'PHICH') == 1 || strcmp(strRE,'PCFICH') == 1                
                    bEmpty = 0;
                end                
            end
            
            % If this REG is empty, put the RE from this REG into
            % the 'mSub' and 'mSym' matrices
            if bEmpty == 1
                
                % Reset the index of subcarrier in the REG
                inxSub = 0;
                
                % Loop over all elements of the quadruplet
                for inxEl=1:4
                    
                    % Take the Resource Element
                    cRE = mSCMap(k_+inxSub+1, inxSym+l_+1);

                    % Convert the Resource Element into a string
                    strRE = cell2mat(cRE);
                
                    % Check if this element is occupied by Reference Signal
                    while strcmp(strRE,'RS') == 1
                        
                        % Move the subcarrier forward
                        inxSub = inxSub + 1;
                        
                        % Take the Resource Element
                        cRE = mSCMap(k_+inxSub+1, l_+1);

                        % Convert the Resource Element into a string
                        strRE = cell2mat(cRE);                        
                    end 
                    
                    % Store index of symbol for this element of
                    % quadruplet                                                                     
                    mSym(inxEl,m_+1) = inxSym+l_+1;

                    % Store index of subcarier for this element of
                    % quadruplet
                    mSub(inxEl,m_+1) = k_+inxSub+1;

                    % Move the subcarrier index forward
                    inxSub = inxSub + 1;                       
                end                                                    
                            
                % Move forward index of the quadruplet
                m_ = m_ + 1;                 
                
            end
        end    
        
        % Move the symbols index forward
        l_ = l_ + 1;

        % Check if it was the last index of symbol dedicated for PDCCH
        if l_ == nPDCCHSym

            % Move index of the symbol to the beginning
            l_ = 0;
            
            % Move index of the subcarrier forward
            k_ = k_ + 1;
            
            % Check if the index is too big
            if k_ == N_scB
                error('ERROR (AddPDCCH): The total size of the PDDCH channels is too big!');
            end
        end               
    end
end

