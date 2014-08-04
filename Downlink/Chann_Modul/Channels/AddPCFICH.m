%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPCFICH: THE "ALGaE" PACKAGE - PCFICH CHANNEL MODULATOR AND MAPPER
% 
% Function modulates the PCFICH channel and map it to the current subframe.                                    
%
% File version 1.0 (29th July 2011)
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
%       9. sPCFICH:     Info structure with PCFICH channel data and parameters.
%                       (the strucutre may be empty)
%
%       10. sCodewords: Structure with codewords.
%
%
% ------------------------------------------------------------------------
% Output:
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%       4. sPCFICH:     Structure with information about the PCFICH
%                       channel.
%
%               Fields in the 'sPCFICH' structure:
% 
%                   .mC             : Matrix with scrambling pseudo sequences
%                                     used in PCFICH channel. Scrambling sequence
%                                     changes in every subframes - one
%                                     columns contains PCFICH scrambling
%                                     sequence used in one subframe. 
%                                     [ matrix, size:  32 x no. of subframes with PCFICH ]
% 
%                   .mBits          : Matrix with bits send in PCFICH channel. 
%                                     One column contains bits send in one
%                                     subframe.
%                                     [ matrix, size: 32 x no. of subframes with PCFICH ]
% 
%                   .m3Sym          : 3D matrix with symbols quadruplets mapped
%                                     into the PCFICH channel. There are 4 PCFICH 
%                                     quadruplets in one subframe, one
%                                     quadruplet contains 4 symbols.
%                                     Quadruplets from one subframe are stored
%                                     in one plane. 
%                                     [ matrix, size: 4 x 4 x no. of subframes with PCFICH ]
% 
%                   .m3k            : 3D matrix for subcarriers indices with PCFICH 
%                                     quadruplets. Indices for one quadruplet
%                                     are in one column. One matrix plane
%                                     refers to one PCFICH group
%                                     [ 3D matrix, size: 4 x 4 x no. of subframes with PCFICH ]
% 
%                   .nPCFICHsubf    : the number of subframes with PCFICH
%                                     channel
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

function [ mTF mSCMap mModMap sPCFICH ] = AddPCFICH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPCFICH, sCodewords)


    %% ----------------------------------------------------------
    
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
        N_symbDL  = sT.N_symbDL;
    
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;
        
        % the number of subframes in the tranmission
        N_SF = sT.N_SF;
        
        % The index of the first subframe in transmission
        FIRST_SF = sT.FIRST_SF;
        
    %----------------------------------------------------------    
    
    % The number of subframes in a Radio Frame
    N_SFRF = N_symbRF/N_symbSF;    
    
    % Calculate index of the current subframe in a Radio Frame
    inxSFRF = rem(inxSF,N_SFRF);
    
    % The number of Radio Slots in a Subframe
    N_RSSF = N_symbSF/N_symbDL;
    
    % Calculate index of the Radio Slot with PCFICH in a Radio Frame
    inxRSRF = inxSFRF*N_RSSF;  
    
    % Calculate index of the current subframe in the whole transmission
    inxSFTR = inxSF - FIRST_SF;
    
   

    %% Obtain / generate the PCFICH bitstream.    
       
    % Check if the codewords input structure is valid
    if isstruct(sCodewords)
        
        % Check if the structure contains bits for the PBCH channel
        if isfield(sCodewords,'mPCFICHBits')
            mPCFICHBits = sCodewords.mPCFICHBits;           

            % Check the input bits lenght
            if size(mPCFICHBits,1) ~= 32
                strErrMsg = sprintf('\n ERROR (AddPCFICH): The given bit matrix has a wrong number of bits p. subframe! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Check the number of columns in matrix with PBCH bits
            % (Should be equal to the number of subframes)
            if size(mPCFICHBits,2) ~= N_SF
                strErrMsg = sprintf('\n ERROR (AddPCFICH): The given bit matrix has a wrong number of columns! BAILING OUT! \n');
                error(strErrMsg);
            end             
            
            % Get the current bitstream vector
            vPCFICHBits = mPCFICHBits(:,inxSFTR+1);

        else
            % If the structure does not contain bits for the PBCH channel
            % generate the random bits
            vPCFICHBits = randi([0 1],32,1);
        end
        
    else
        
        % If the physicall channels input structure is not valid
        % generate the random bits
        vPCFICHBits = randi([0 1],32,1);
    end


    %% Scramble 
    
    % Calculate the initialization value
    initC = (floor(inxRSRF/2)+1)*(2*iN_id+1)*2^9 + iN_id;
        
    % Generate the scrambling pseudo random sequence
    vC = genPseudRand_C(initC,32)';
    
    % Scramble the bit vector
    vPCFICHScr = mod(vPCFICHBits+vC,2); 


    %% Modulate
    vPCFICHSym =  modQPSK(vPCFICHScr);
                
    % Reshape symbols into quadruplets
    mPCFICHSym = reshape(vPCFICHSym,4,4);


    %% PHICH channel information structure service:
    
    % Check if the number of subframes with PCFICH was already started
    if isfield(sPCFICH,'nPCFICHsubf') 
        
        % Get the number of subframes with PCFICH
        nPCFICHsubf = sPCFICH.nPCFICHsubf;
                
        % Increase the number of subframes with PCFICH
        nPCFICHsubf = nPCFICHsubf + 1; 
                      
    else
        % The number of subframes with PCFICH was not yet started, start it
        nPCFICHsubf = 1;        
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Allocate matrices for information in the channel information
        % structure:
        
        % Allocate matrix for scrambling pseudo sequences
        sPCFICH.mC = zeros(32,N_SF);
        
        % Allocate matrix for bits transmitted in PCFICH channel
        sPCFICH.mBits = zeros(32,N_SF);

        % Allocate 3D matrix for quadruplets with symbols mapped to the PCFICH channel
        sPCFICH.m3Sym = zeros(4,4,N_SF);
        
        % Allocate matrix for subcarrier indices which represents REG with PCFICH
        % quadruplets mapped into
        sPCFICH.m3k = zeros(4,4,N_SF);       
    end


    % Store this bitstream in the channel information structure
    sPCFICH.mBits(:,nPCFICHsubf) = vPCFICHBits;    

    % Store the scrambling sequence in the channel information structure
    sPCFICH.mC(:,nPCFICHsubf) = vC;

    % Store the symbols quadruplets in the channel information structure
    sPCFICH.m3Sym(:,:,nPCFICHsubf) = mPCFICHSym;

    % Store the current number of subframes with PCFICH
    sPCFICH.nPCFICHsubf = nPCFICHsubf;


    %% Map the PCFICH quadruplet symbols into the resource elements
            
    % Calculate the number of subcarriers in a Resources Block
    nSubRB = N_scB/N_rb;
    
    % Calculate the index of the symbol with PCFICH in the whole
    % transmission
    l = inxSF*N_symbSF - FIRST_SF*N_symbSF;
    
    % Calculate the k_
    k_ = nSubRB/2 * mod(iN_id,2*N_rb);

    % Loop over all quadruplets
    for inxQuad=1:4    

        % Calculate index of subcarrier which represents the Resource Element
        % Group to which the PCFICH will be mapped
        k = k_ + floor((inxQuad-1)*N_rb/2)*nSubRB/2;
        k = mod(k,N_scB);
        
        % Calculate index of the first subcarrier in the Resource Element Group
        k = floor(k/6)*6;
                
        % Loop over all elements in a quadruplet
        for inxEl=1:4

            % Check if the Resource Element is free
            cRE = mSCMap(k+1,l+1);
            strRE = cell2mat(cRE);
            while strRE ~= '.';            
                k = k + 1;
                cRE = mSCMap(k+1,l+1);
                strRE = cell2mat(cRE);                        
            end

            % Map the element
            mTF(k+1,l+1)        = mPCFICHSym(inxEl,1);

            % Indicate the channel   
            mSCMap(k+1,l+1)     = {'PCFICH'};

            % Indicate the modulation
            mModMap(k+1,l+1)    = {'QPSK'};

            % Store index of the subcarrier
            sPCFICH.m3k(inxQuad,inxEl,nPCFICHsubf) = k;
                        
            % Prepare the index of subcarrier for the next element
            k = k+1;
        end
    end
end
