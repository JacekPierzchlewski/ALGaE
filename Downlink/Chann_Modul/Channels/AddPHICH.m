%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddPHICH: THE "ALGaE" PACKAGE - PHICH CHANNEL MODULATOR AND MAPPER
% 
% Function modulates the PHICH channel and map it to the current subframe.                                    
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
%       9. sPHICH:      Info structure with PHICH channel data and parameters.
%                       (the strucutre may be empty)
%
%       10. sCodewords: Structure with codewords.
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
%       4. sPHICH:      Info structure with information about the PHICH
%                       channel.
%
%          Fields in the 'sPHICH' structure:
%
%               .iN_BtsSub      : the number of bits send in the PHICH channel
%                                 in one subframe.
%
%               .iN_grp         : the number of PHICH groups in one subframe.               
%
%               .iN_seq         : the number of sequences in a PHICH group
%
%               .iN_SeqSymb     : the number of symbols transmitted in one PHICH
%                                 group
%
%               .mC             : Matrix with scrambling pseudo sequences
%                                 used in PHICH channel. Scrambling sequence
%                                 changes in every subframes - one
%                                 columns contains PHICH scrambling
%                                 sequence used in one subframe. 
%                                 Size: [ iN_SeqSymb x nPHICHsubf ]
%
%               .nPHICHsubf     : the number of subframes with the PHICH
%                                 channel.
%
%               .m4Bits         : 4D Matrix with bits send in the PHICH channel. 
%                                 One matrix cube refers to PHICH channels
%                                 send in one subframe. One matrix plane
%                                 refers to a PHICH group in a subframe.
%                                 One column refers to bits send in one sequence.  
%                                 Size: [ iN_Bts x iN_seq x iN_grp x nPHICHsubf ]                                          
%
%               .m4Sym          : 4D Matrix with symbols send in the PHICH channel.
%                                 One matrix cube refers to PHICH channels                                 
%                                 send in one subframe. One matrix plane
%                                 refers to a PHICH group in a subframe.
%                                 One column refers to one qudruplet.                                 
%                                 Size: [ 4 x 3 x iN_grp x nPHICHsubf ]                                          
%                               
%               .m4k            : 3D matrix with indices of subcarriers
%                                 with PHICH quadruplets.
%                                 One matrix cube refers to PHICH channels     
%                                 send in one subframe. One matrix plane
%                                 refers to a PHICH group in a subframe.
%                                 One column refers to one qudruplet.                                 
%                                 Size: [ 4 x 3 x iN_grp x nPHICHsubf ]
%
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


function [ mTF mSCMap mModMap sPHICH ] = AddPHICH(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sCodewords)


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME PARAMETERS STRUCTURE
    % 
    % (structure: 'sT'):

        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;

    %----------------------------------------------------------    

    % Run different functions dependently on the type of the Cyclic Prefix
    if N_symbDL == 7

        % Normal CP
        [ mTF mSCMap mModMap sPHICH ] = AddPHICH_NorCP(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sCodewords);

    else

        % Extended CP
        [ mTF mSCMap mModMap sPHICH ] = AddPHICH_ExtCP(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sCodewords);

    end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% I N T E R N A L   F U N C T I O N S
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INTERNAL FUNCTION: Modulate and map PHICH channel (Normal CP case)
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
%       9. sPHICH:      Info structure with PHICH channel data and parameters.
%                       (the strucutre may be empty)
%
%       10. sCodewords: Structure with codewords.
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
%       4. sPHICH:      Info structure with information about the PHICH
%                       channel.
%
%
function [ mTF mSCMap mModMap sPHICH ] = AddPHICH_NorCP(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sCodewords)
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD STRUCTURE
    % (structure: 'sLTE_stand' and 'sScen'):
            
        % Get the possible values of the N_g parameter
        vN_g = sLTE_stand.vN_g;        
        
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

        % The Ng coefficient which controls the number of PHICH groups
        N_g          = sP.N_g;
        
    %----------------------------------------------------------  


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 
    
        % The number of Resource Blocks
        N_rb = sF.N_rb;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;
    
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;
        
        % The total number of suframes
        N_SF = sT.N_SF;        
        
        % Index of the first subframe in transmission
        FIRST_SF = sT.FIRST_SF;        
        
    %----------------------------------------------------------      
    
    
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
    

    %% Calculate the number of PHICH groups
    
    % Check if the given N_g parameter is correct
    if sum(N_g == vN_g) == 0
        error('The given N_g parameter is incorrect!');                
    end
        
    % The number of PHICH groups
    iN_grp = ceil(N_g*(N_rb/8));

    % The number of PHICH sequences in one PHICH group
    % for the normal CP 
    iN_seq = 8;

    
    %% Obtain / generate bits for PHICH channel in this subframe
    
    % The number of bits p. PHICH sequence for the normal CP
    iN_Bts = 3;
    
    % The number of bits send in one PHICH group
    iN_BtsGrp = iN_seq * iN_Bts;
    
    % The total number of bits send in PHICH channels in this subframe
    iN_BtsSub = iN_grp * iN_BtsGrp;
    
    % Check if the codewords input structure is valid
    if isstruct(sCodewords)
        
        % Check if the structure contains bits for the PHICH channel
        if isfield(sCodewords,'mPHICHBits')
            mPHICHBits = sCodewords.mPHICHBits;           

            % Check the input bits lenght
            if size(mPHICHBits,1) ~= iN_BtsSub                
                strErrMsg = sprintf('\n ERROR (AddPHICH): The given bit matrix has a wrong number of bits p. subframe! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Check the number of columns in matrix with PHICH bits
            % (Should be equal to the number of subframes)
            if size(mPHICHBits,2) ~= N_SF
                strErrMsg = sprintf('\n ERROR (AddPHICH): The given bit matrix has a wrong number of columns! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Get the current bitstream vector
            vPHICHBits = mPHICHBits(:,inxSFTR+1);
            
            % Reshape the vector into a 3D matrix 
            mBts = reshape(vPHICHBits,iN_Bts,iN_seq,iN_grp);
            
        else
            % Generate the bits matrix (one columns - sequence of bits p. PHICH group)
            mBts = randi([ 0 1 ],iN_Bts,iN_seq,iN_grp);
        end

    else
        
        % Generate the bits matrix (one columns - sequence of bits p. PHICH group)
        mBts = randi([ 0 1 ],iN_Bts,iN_seq,iN_grp);
    end


    %% Premodulate bits (BPSK)
    mSymb = modBPSK(mBts);


    %% Modulate all groups
    
    % Matrix with PHICH sequences (w)
    mSeq = [1   1   1   1  ; ...
            1  -1   1  -1  ; ...
            1   1  -1  -1  ; ...
            1  -1  -1   1  ; ...
            1i  1i  1i  1i ; ...
            1i -1i  1i -1i ; ...
            1i  1i -1i -1i ; ...
            1i -1i -1i  1i ]';



    % ----------------------------------------------
    % Allocate matrix for modulated PHICH channels
    
    % The number of modulated symbols in a PHICH sequence 
    iN_SeqSymb = 12;
    
    % Allocate the matrix
    md = zeros(iN_SeqSymb, iN_seq, iN_grp);

    % ----------------------------------------------


    % ----------------------------------------------        
    % Generate the cell specific scrambling sequence

    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2;

    % Calculate the initialization number
    iC_init = (floor(inxRSRF/2)+1)*(2*iN_id+1)*2^9 + iN_id;

    % Generate the scrambling pseudo random sequence
    vC = genPseudRand_C(iC_init,iN_SeqSymb)';

    % ----------------------------------------------    

    % The loop over all groups starts here
    for inxGrp=0:(iN_grp - 1)
        
        % --------------------------
        % Loop over all sequences in a group
        for inxSeq=0:(iN_seq - 1)
            
            % Get the current orthogonal sequence
            w = mSeq(:,inxSeq+1);            
            
            % --------------------------
            % Loop over modulated symbols in a PHICH seguence
            for inxSym=0:(iN_SeqSymb - 1)
                                
                % Calculate the current element
                md(inxSym+1,inxSeq+1,inxGrp+1) = ...
                                                        ...
                w(mod(inxSym,4)+1)*(1-2*vC(inxSym+1))*mSymb(floor(inxSym/4)+1,inxSeq+1,inxGrp+1);
                                
            end
        end 
    end
    
    
    %% Sum over all orthogonal sequences
    m_y_ = sum(md,2);
    
    % Reshape the above matrix into a 2D matrix 
    % (one PHICH group in one column)
    m_y_ = reshape(m_y_,iN_SeqSymb,iN_grp,1);
    

    %% PHICH channel information structure service:
    
    % Check if the number of subframes with PHICH was already started
    if isfield(sPHICH,'nPHICHsubf') 
        
        % Get the number of subframes with PHICH
        nPHICHsubf = sPHICH.nPHICHsubf;
                
        % Increase the number of subframes with PHICH
        nPHICHsubf = nPHICHsubf + 1;
                      
    else
        
        % The number of subframes with PHICH was not yet started, start it
        nPHICHsubf = 1;

        % Store the number of bits send in the PHICH channel in one
        % subframe
        sPHICH.iN_BtsSub = iN_BtsSub;
                
        % Store the number of PHICH groups in a subframe
        sPHICH.iN_grp = iN_grp;
        
        % Store the number of PHICH sequences in a PHICH group
        sPHICH.iN_seq = iN_seq;        
        
        % Store the number of bits p. PHICH sequence
        sPHICH.iN_Bts = iN_Bts;
        
        % Store the number of modulated symbols in a PHICH sequence 
        sPHICH.iN_SeqSymb = iN_SeqSymb;
        
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Allocate matrices for information in the channel information
        % structure:
        
        % Allocate matrix for scrambling pseudo sequences
        sPHICH.mC = zeros(iN_SeqSymb,N_SF);

        % Allocate 4D matrix for bits transmitted in PHICH channel
        sPHICH.m4Bits = zeros(iN_Bts, iN_seq, iN_grp, N_SF);

        % Allocate 3D matrix for symbols mapped to PHICH channel
        sPHICH.m4Sym = zeros(4,3,iN_grp,N_SF);
        
        % Allocate matrix for indices subcarriers with PHICH channel
        sPHICH.m4k = zeros(4,3,iN_grp,N_SF);        
        
    end
    
    % Store the scrambling pseudo sequence 
    sPHICH.mC(:,nPHICHsubf) = vC;
    
    % Store the bits transmitted in this subframe
    sPHICH.m4Bits(:,:,:,nPHICHsubf) = mBts;
    
    % Store the current symbols send in the PHICH channel
    sPHICH.m4Sym(:,:,:,nPHICHsubf) = reshape(m_y_,4,3,iN_grp);
    
    % Store the current number of subframes with PHICH
    sPHICH.nPHICHsubf = nPHICHsubf;  
    

    %% Map the PHICH channels in the resources
    [ mTF mSCMap mModMap sPHICH ] = MapPHICH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPHICH, m_y_);                

end


%% INTERNAL FUNCTION: Modulate and map PHICH channel (Extended CP case)
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
%       9. sPHICH:      Info structure with PHICH channel data and parameters.
%                       (the strucutre may be empty)
%
%       10. sCodewords: Structure with codewords.
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
%       4. sPHICH:      Info structure with information about the PHICH
%                       channel.
%
%
function [ mTF mSCMap mModMap sPHICH ] = AddPHICH_ExtCP(mTF, mSCMap, mModMap, sF, sT, sP, sLTE_stand, inxSF, sPHICH, sPHYChan)

   %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD STRUCTURE
    % (structure: 'sLTE_stand' and 'sScen'):
            

        % Get the possible values of the N_g parameter
        vN_g = sLTE_stand.vN_g;        
        
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

        % The Ng coefficient which controls the number of PHICH groups
        N_g          = sP.N_g;
                
    %----------------------------------------------------------  

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % AND THE TIME PARAMETERS STRUCTURE
    % (structures: 'sT', 'sF'): 
    
        % The number of Resource Blocks
        N_rb = sF.N_rb;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;
    
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The number of symbols in a Radio Frame
        N_symbRF  = sT.N_symbRF;

        % The total number of suframes
        N_SF = sT.N_SF;

        % Index of the first subframe in transmission
        FIRST_SF = sT.FIRST_SF;         
    %----------------------------------------------------------      
    
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
    

    %% Calculate the number of PHICH groups
    
    % Check if the given N_g parameter is correct
    if sum(N_g == vN_g) == 0
        error('The given N_g parameter is incorrect!');
    end
    
    % The number of PHICH groups (for the extended CP)
    iN_grp = 2*ceil(N_g*(N_rb/8));

    % The number of PHICH sequences in one PHICH group
    % for the extended CP 
    iN_seq = 4;
    
    
    %% Obtain / generate bits for PHICH channel in this subframe
    
    % The number of bits p. PHICH sequence for the extended CP
    iN_Bts = 3;
  
    % The number of bits send in one PHICH group
    iN_BtsGrp = iN_seq * iN_Bts;

    % The total number of bits send in PHICH channels in this subframe
    iN_BtsSub = iN_grp * iN_BtsGrp;

    % Check if the physicall channels input structure is valid
    if isstruct(sPHYChan)
        
        % Check if the structure contains bits for the PHICH channel
        if isfield(sPHYChan,'mPHICHBits')
            mPHICHBits = sPHYChan.mPHICHBits;           

            % Check the input bits lenght
            if size(mPHICHBits,1) ~= iN_BtsSub                
                strErrMsg = sprintf('\n ERROR (AddPHICH): The given bit matrix has a wrong number of bits p. subframe! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Check the number of columns in matrix with PHICH bits
            % (Should be equal to the number of subframes)
            if size(mPHICHBits,2) ~= N_SF
                strErrMsg = sprintf('\n ERROR (AddPHICH): The given bit matrix has a wrong number of columns! BAILING OUT! \n');
                error(strErrMsg);
            end

            % Get the current bitstream vector
            vPHICHBits = mPHICHBits(:,inxSFTR+1);
            
            % Reshape the vector into a 3D matrix 
            mBts = reshape(vPHICHBits,iN_Bts,iN_seq,iN_grp);
            
        else
            % Generate the bits matrix (one columns - sequence of bits p. PHICH group)
            mBts = randi([ 0 1 ],iN_Bts,iN_seq,iN_grp);
        end

    else
        
        % Generate the bits matrix (one columns - sequence of bits p. PHICH group)
        mBts = randi([ 0 1 ],iN_Bts,iN_seq,iN_grp);
    end

    
    
    %% Premodulate bits (BPSK)
    mSymb = modBPSK(mBts);


    %% Modulate all groups

    % Matrix with PHICH sequences (w) (externap CP)
    mSeq = [1   1   ; ...
            1  -1   ; ...
            1i  1i  ; ...
            1i -1i  ]';


    % ----------------------------------------------
    % Allocate matrix for modulated PHICH channels
    
    % The number of modulated symbols in a PHICH sequence 
    iN_SeqSymb = 6;
    
    % Allocate the matrix
    md = zeros(iN_SeqSymb, iN_seq, iN_grp);
        
    % ----------------------------------------------


    % ----------------------------------------------        
    % Generate the cell specific scrambling sequence
    
    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2;
    
    % Calculate the initialization number
    iC_init = (floor(inxRSRF/2)+1)*(2*iN_id+1)*2^9 + iN_id;
    
    % Generate the scrambling pseudo random sequence
    vC = genPseudRand_C(iC_init,iN_SeqSymb)';

    % ----------------------------------------------    
    
        
    % The loop over all groups starts here
    for inxGrp=0:(iN_grp - 1)
        
        % --------------------------
        % Loop over all sequences in a group
        for inxSeq=0:(iN_seq - 1)
            
            % Get the current orthogonal sequence
            w = mSeq(:,inxSeq+1);            
            
            % --------------------------
            % Loop over modulated symbols in a PHICH seguence
            for inxSym=0:(iN_SeqSymb - 1)
                                
                % Calculate the current element
                md(inxSym+1,inxSeq+1,inxGrp+1) = ...
                                                        ...
                w(mod(inxSym,2)+1)*(1-2*vC(inxSym+1))*mSymb(floor(inxSym/2)+1,inxSeq+1,inxGrp+1);
                                
            end
        end 
    end   

    
    %% Resource Group Alignement
    
    % Allocate the matrix for alligned PHICH groups 
    md0 = zeros(2*iN_SeqSymb, iN_seq, iN_grp);
    
    % Loop over all PHICH groups
    for inxGrp=0:(iN_grp - 1)
        
        % Loop over all PHICH sequences
        for inxSeq=0:(iN_seq - 1)
        
            % Even groups allignement
            if mod(inxGrp,2) == 0
                
                % Loop over all quadruplets
                for inxQuad=0:(2*iN_SeqSymb/4 - 1)
                    md0(4*inxQuad+1,inxSeq+1,inxGrp+1) = md(2*inxQuad+1,inxSeq+1,inxGrp+1);
                    md0(4*inxQuad+2,inxSeq+1,inxGrp+1) = md(2*inxQuad+2,inxSeq+1,inxGrp+1);
                    md0(4*inxQuad+3,inxSeq+1,inxGrp+1) = 0;
                    md0(4*inxQuad+4,inxSeq+1,inxGrp+1) = 0;
                end
                
            % Odd groups allignement
            else

                % Loop over all quadruplets
                for inxQuad=0:(2*iN_SeqSymb/4 - 1)
                    md0(4*inxQuad+1,inxSeq+1,inxGrp+1) = 0;
                    md0(4*inxQuad+2,inxSeq+1,inxGrp+1) = 0;
                    md0(4*inxQuad+3,inxSeq+1,inxGrp+1) = md(2*inxQuad+1,inxSeq+1,inxGrp+1);
                    md0(4*inxQuad+4,inxSeq+1,inxGrp+1) = md(2*inxQuad+2,inxSeq+1,inxGrp+1);
                end                
            end        
        end
    end


    
    %% Sum over all orthogonal sequences
    m_y_ = sum(md0,2);
    
    % Reshape the above matrix into a 2D matrix 
    % (one PHICH group in one column)
    m_y_ = reshape(m_y_,2*iN_SeqSymb,iN_grp,1);
    

    %% PHICH channel information structure service:
    
    % Check if the number of subframes with PHICH was already started
    if isfield(sPHICH,'nPHICHsubf') 
        
        % Get the number of subframes with PHICH
        nPHICHsubf = sPHICH.nPHICHsubf;
                
        % Increase the number of subframes with PHICH
        nPHICHsubf = nPHICHsubf + 1;
                      
    else
        
        % The number of subframes with PHICH was not yet started, start it
        nPHICHsubf = 1;        
        
        % Store the number of bits send in the PHICH channel in one
        % subframe
        sPHICH.iN_BtsSub = iN_BtsSub;

        % Store the number of PHICH groups in a subframe
        sPHICH.iN_grp = iN_grp;
        
        % Store the number of PHICH sequences in a PHICH group
        sPHICH.iN_seq = iN_seq;        
        
        % Store the number of modulated symbols in a PHICH sequence 
        sPHICH.iN_SeqSymb = iN_SeqSymb;
                
        % Store the number of bits p. PHICH sequence
        sPHICH.iN_Bts = iN_Bts;        
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Allocate matrices for information in the channel information
        % structure:
        
        % Allocate matrix for scrambling pseudo sequences
        sPHICH.mC = zeros(iN_SeqSymb,N_SF);

        % Allocate 4D matrix for bits transmitted in PHICH channel
        sPHICH.m4Bits = zeros(iN_Bts, iN_seq, iN_grp, N_SF);

        % Allocate 3D matrix for symbols mapped to PHICH channel
        sPHICH.m4Sym = zeros(4,3,iN_grp,N_SF);
        
        % Allocate matrix for indices subcarriers with PHICH channel
        sPHICH.m4k = zeros(4,3,iN_grp,N_SF);        
    end
    
    % Store the scrambling pseudo sequence 
    sPHICH.mC(:,nPHICHsubf) = vC;
    
    % Store the bits transmitted in this subframe
    sPHICH.m4Bits(:,:,:,nPHICHsubf) = mBts;
    
    % Store the current symbols send in the PHICH channel
    sPHICH.m4Sym(:,:,:,nPHICHsubf) = reshape(m_y_,4,3,iN_grp);
    
    % Store the current number of subframes with PHICH
    sPHICH.nPHICHsubf = nPHICHsubf;


    %% Map the PHICH channels in the resources
    [ mTF mSCMap mModMap sPHICH ] = MapPHICH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPHICH, m_y_);

end


%% ------------------------------------------------------------
%% ------------------------------------------------------------
%% Map PHICH channels 
function [ mTF mSCMap mModMap sPHICH ] = MapPHICH(mTF, mSCMap, mModMap, sF, sT, sP, inxSF, sPHICH, m_y_)

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
    
        % The number of subcarriers
        N_scB = sF.N_scB;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        % The number of symbols in a subframe
        N_symbSF  = sT.N_symbSF;

        % The index of the first subframe in transmission
        FIRST_SF = sT.FIRST_SF;
        
    % ----------------------------------------------------------      

    % Calculate the N^cell_ID
    iN_id = 3*N_id1 + N_id2;
    

    % ------------------------------------------------------------    
    
    % Calculate index of the first symbol of the current subframe in the whole
    % transmission
    l = inxSF*N_symbSF - FIRST_SF*N_symbSF;
  
    % ------------------------------------------------------------
    
            
    % ------------------------------------------------------------
    % Create matrix with Resource Element Groups not assigned to PCFICH
    mREG = (1:N_scB);
    mREG = reshape(mREG,6,N_scB/6);

    % Loop over all Resource Element Groups
    for inxREG=1:N_scB/6
        
        % Take indices of subcarriers in the current REG        
        vREG = mREG(:,inxREG); 

        % Reset the 'occupied' flag
        iOcc = 0;

        % Loop over all subcarriers in the current REG        
        for inxSub=1:6
 
            % Take the current Resource Element
            cRE = mSCMap(vREG(inxSub),l+1);
            strRE = cell2mat(cRE);
            
            % If the Resource Element is occupied by PCFICH, denote it
            % and jump out from the loop
            if strcmp(strRE,'PCFICH')
                iOcc = 1;
                break;
            end
        end

        % If this REG is occupied, denote it in the mREG matrix
        if iOcc == 1
            mREG(:,inxREG) = 0;                
        end
    end

    % Remove from the mREG matrix REGs which were denoted as occupied
    vREG = mREG(mREG>0);
    mREG = reshape(vREG,6,size(vREG,1)/6);

    % Calculate the number of REGs not assigned to PCFICH in first symbols
    % in a subframe
    n0 = size(mREG(),2);

    % ------------------------------------------------------------


    % ------------------------------------------------------------
    
    % Get the number of PHICH groups
    iN_grp = size(m_y_,2);
    
    % Get index of the current PHICH subframe in the transmission
    nPHICHsubf = sPHICH.nPHICHsubf;
    
    % Loop over all PHICH groups
    for inxGrp=0:(iN_grp - 1)
                
        % Take the first PHICH group
        vGrp = m_y_(:,inxGrp+1);
        
        % Reshape the PHICH group into 3 quadruplets
        mGrp = reshape(vGrp,4,3);
        
        % Loop over all quadruplets
        for inxQuad=1:3
            
            % Calculate index of a free REG. The current quadruplet
            % will be mapped into this REG
            n_i = mod( (iN_id + inxGrp + floor((inxQuad-1)*n0/3)),n0);
            
            % Get the current indices of subcarriers
            vSubInx = mREG(:,n_i+1);
            
            % Loop over all 4 elements of quadruplet (mapping)
            iInxSub_REG = 1;    % Reset the index of subcarrier in the REG
            for inxEl=1:4
                
                % Take the current index of the subcarrier
                k = vSubInx(iInxSub_REG);
                
                % Check the current Resource Element in the 
                % Signals and Channels mapping table                
                cRE = mSCMap(k,l+1);
                strRE = cell2mat(cRE);
                
                % If the Resource Element is occupied by PCFICH, denote it
                % and jump out from the loop
                while ~strcmp(strRE,'.')

                    % Move to the next subcarrier
                    iInxSub_REG = iInxSub_REG + 1;

                    % Take the index of the next subcarrier
                    k = vSubInx(iInxSub_REG);

                    % Check the current Resource Element in the 
                    % Signals and Channels mapping table                
                    cRE = mSCMap(k,l+1);
                    strRE = cell2mat(cRE);                    
                end

                % Map the current element

                % Map the element to the time/frequency matrix 
                mTF(k,l+1)    = mGrp(inxEl,inxQuad);

                % Map the channel
                mSCMap(k,l+1) = {'PHICH'};

                % Map the modulation
                mModMap(k,l+1) = {'QAM256'};  
                
                % Store index of the subcarrier
                sPHICH.m4k(inxEl,inxQuad,inxGrp+1,nPHICHsubf) = k;
            end
        end
    end
    % ------------------------------------------------------------
end

