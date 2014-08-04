%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_DL1a: THE "ALGaE" PACKAGE - ALGaE LTE SIGNAL GENERATOR
%                                 STACK:  DOWNLINK, 
%                                 MODULE: CHANNELS AND MODULATION (L1a Layer)
%
% File version 0.12 (17th August 2011)
%
%% ------------------------------------------------------------------------
% Inputs (4):
%
%       1. LTEScen:     string with a path to a file with the current LTE scenario, 
%                       or a structure with the current LTE scenario
%
%       2. Codewords:   string with a path to a file with codewords,
%                       or a structure with codewords,
%                       or integer with 0 in a case of no codewords
%                       given
%
%       3. strRepFil:   string with a report file name,
%                       ( if strRepFil is set to >>''<<, there is no report file)
%
%       4. bGUIBar:     Flag (integer) which inidicates if the Signal generation 
%                       progress should be shown by the GUI bar.
%                       [ 0 - gui bar off, 1 - gui bar on ]
%
% ------------------------------------------------------------------------
%
% Output (1):
%
%       1. sLTE_DL1:     Downlink layer 1 output structure.
%       
%          Fields of the 'sLTE_DL1' structure:
%
%               % I and Q signals:
%
%               .vI         Vector with I signal
%
%               .vQ         Vector with Q signal
%
%               .mSymInx    Matrix with information about indices of
%                           symbols in the vI and vQ vectors.                           
%
%               ------------------------------------------------------------
%
%
%               % Resource matrices:
%
%               .mTF        time/frequency matrix with resource elements 
%                           [ 1 subcarrier = 1 row, 1 symbol = 1 column ]
%
%               .mModMap    matrix with modulation mapping 
%                           [ 1 subcarrier = 1 row, 1 symbol = 1 column ]
%
%               .mSCMap     matrix with signals and channels mapping 
%                           [ 1 subcarrier = 1 row, 1 symbol = 1 column ]
%
%               ------------------------------------------------------------
%
%
%               % Time/frequency configuration strucutres (3 structures):
%
%               .sF         bandwidth (frequency) configuration structure
% 
%                   Fields in the sF structure:
% 
%                       .Delta_f    : frequency separation between subcarriers
%         
%                       .N_rb       : number of Resource Blocks in the current bandwidth 
%         
%                       .N_scB      : number of subcarriers in the current bandwidth
%         
%                       .N_ifft     : size of the IFFT 
%         
%                       .F_fB       : frequency spectrum of the current bandwidth
%        
%        
%                       .strTrans   : the transmission scheme
%        
%                       .nAnt       : the number of antenna ports
%               
%
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sT         time configuration structure
%
%                   Fields in the 'sT' structure:
%
%                       .N_symbDL       : the current number of symbols in a Radio Slot     
%
%                       .vCP_lengths    : vector with time lenghts of symbols in a Radio Slot, 
%                                         lenght calculated together with CP's [vector]                                         
%
%                       .N_symbSF       : the number of LTE symbols in a Subframe
%
%                       .N_symbRF       : the number of LTE symbols in a Radio Frame
%
%                       .N_symbTR       : the number of LTE symbols in the whole
%                                         transmission
%
%                       .N_SF           : the number of subframes in the whole transmission    
%
%                       .N_RF           : the number of full(!) Radio Frames in the whole
%                                         transmission  
%
%                       .FIRST_SF       : position of the first transmitted subframe, in a
%                                         Radio Slot 
%                                         
%                       .PBCH_RFINX     : index of the first transmitted Radio Frame in a PBCH TTI
%
%                       .fSmp           : sampling frequency for vI and vQ vectors
%                                          
%                       .vN_SmpsCP      : the number of samples in Cyclic Prefixes in a Radio Slot  
%                                         [vector]
%
%                       .vN_SmpsSymb    : the number of samples in symbols in a Radio Slot, 
%                                         calculated together with CP's [vector]
%
%                       .nSmpsRS        : the total number of samples in a Radio Slot
%
%                       .nSmpsSF        : the total number of samples in a SubFrame
%
%                       .nSmpsRF        : the total number of samples in a RadioFrame
%
%                       .nSmpsTR        : the total number of samples in the transmission
%               
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sP         structure with other LTE-specific configuration parameters
%
%                   Fields in the 'sP' structure:
%
%                       .RNTI           : RNTI ident. number
%
%                       .N_id1          : First number of a physical-layer cell identity
%
%                       .N_id2          : Second number of a physical-layer cell identity
% 
%                       .N_g            : The Ng coefficient which controls the number of PHICH groups
% 
%                       .nPDCCH         : the number of PDCCH channels p. subframe
% 
%                       .vPDCCHFor      : formats of the PDCCH channels [vector]
% 
%                       .vCCEs          : the number of CCEs occupied by PDCCH [vector]
% 
%                       .nPDCCHSym      : the number of symbols dedicated to PDCCH channels
%
%                       .iModOrd        : the PDSCH modulation order
%
%
%
%               % ------------------------------------------------------------
%
%               % Physicall channels information structures:
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
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sPCFICH:   structure with information about 
%                           Physical Control Format Broadcast Channel (PCFICH)     
%                   
%                   Fields in the 'sPCFICH' structure:
%
%                       .mC             : Matrix with scrambling pseudo sequences
%                                         used in PCFICH channel. Scrambling sequence
%                                         changes in every subframes - one
%                                         columns contains PCFICH scrambling
%                                         sequence used in one subframe. 
%                                         [ matrix, size:  32 x no. of subframes with PCFICH ]
%                   
%                       .mBits          : Matrix with bits send in PCFICH channel. 
%                                         One column contains bits send in one
%                                         subframe.
%                                         [ matrix, size: 32 x no. of subframes with PCFICH ]
%                                           
%                       .m3Sym          : 3D matrix with symbols quadruplets mapped
%                                         into the PCFICH channel. There are 4 PCFICH 
%                                         quadruplets in one subframe, one
%                                         quadruplet contains 4 symbols.
%                                         Quadruplets from one subframe are stored
%                                         in one plane. 
%                                         [ matrix, size: 4 x 4 x no. of subframes with PCFICH ]
%                                           
%                       .m3k            : 3D matrix for subcarriers indices with PCFICH 
%                                         quadruplets. Indices for one quadruplet
%                                         are in one column. One matrix plane
%                                         refers to one PCFICH group
%                                         [ 3D matrix, size: 4 x 4 x no. of subframes with PCFICH ]
%         
%                       .nPCFICHsubf    : the number of subframes with PCFICH
%                                         channel
%
%
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sPHICH     structure with information about 
%                           Physicall HARQ Indicator Channel (PHICH)
%
%                   Fields in the 'sPHICH' structure:
%
%                       .iN_BtsSub      : the number of bits send in the PHICH channel
%                                         in one subframe.
%         
%                       .iN_grp         : the number of PHICH groups in one subframe.               
%         
%                       .iN_seq         : the number of sequences in a PHICH group
%         
%                       .iN_SeqSymb     : the number of symbols transmitted in one PHICH
%                                         group
%         
%                       .mC             : matrix with scrambling pseudo sequences
%                                         used in PHICH channel. Scrambling sequence
%                                         changes in every subframes - one
%                                         columns contains PHICH scrambling
%                                         sequence used in one subframe. 
%                                         [ matrix, size: iN_SeqSymb x nPHICHsubf ]
%         
%                       .nPHICHsubf     : the number of subframes with the PHICH
%                                         channel.
%         
%                       .m4Bits         : 4D Matrix with bits send in the PHICH channel. 
%                                         One matrix cube refers to PHICH channels
%                                         send in one subframe. One matrix plane
%                                         refers to a PHICH group in a subframe.
%                                         One column refers to bits send in one sequence.  
%                                         [ 4D matrix, size: iN_Bts x iN_seq x iN_grp x nPHICHsubf ]                                          
%         
%                       .m4Sym          : 4D Matrix with symbols send in the PHICH channel.
%                                         One matrix cube refers to PHICH channels                                 
%                                         send in one subframe. One matrix plane
%                                         refers to a PHICH group in a subframe.
%                                         One column refers to one qudruplet.                                 
%                                         [ 4D matrix, size: 4 x 3 x iN_grp x nPHICHsubf ]                                          
%                                       
%                       .m4k            : 3D matrix with indices of subcarriers
%                                         with PHICH quadruplets.
%                                         One matrix cube refers to PHICH channels     
%                                         send in one subframe. One matrix plane
%                                         refers to a PHICH group in a subframe.
%                                         One column refers to one qudruplet.                                 
%                                         [ 3D matrix, size: 4 x 3 x iN_grp x nPHICHsubf ]
%
%
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sPDCCH     structure with information about 
%                           Physicall Downlink Control Channel (PDCCH)                                   
%
%                   Fields in the 'sPDCCH' structure:
%
%
%                       .nPDCCHsubf     : the number of subframes with
%                                         PDCCH channel
%                       
%                       .iN_BtsSub      : the number of PDCCH bits in a
%                                         Subframe
%
%                       .iN_quadSub     : the number of PDCCH quadruplets in a Subframe 
%
%
%                       .m3Sym          : 3D matrix with quadruplets. One
%                                         matrix page contains quadruplets
%                                         from one Subframe.
%                                         [ 3D matrix, size: 4 x iN_quadSub x nPDCCHsubf ]                                          
%
%                       .mC             : matrix with scrambling sequences.
%                                         One column contains scrambling sequence
%                                         from one Subframe.
%                                         [ matrix, size: iN_BtsSub x nPDCCHsubf ]                                          
%
%
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%               .sPDSCH     structure with information about 
%                           Physicall Downlink Shared Channel (PDSCH)
%
%                   Fields in the 'sPDSCH' structure:
%
%                       .nPDSCHsubf     : the number of subframes with
%                                         PDSCH channel
%     
%                       mN_Sym          : matrix with the number of transmitted
%                                         PDSCH symbols                                      
%     
%                       vsPDSCHSym      : vector of strucutres with PDSCH symbols
%                                         transmitted on PDSCH codewords
%
%
%               % - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%               
%               .sScen      structure with scenario used to generate the
%                           signal
%
%               ------------------------------------------------------------
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

function sLTE_DL1 = LTE_DL1a(LTEScen,Codewords,strRepFil,bGUIBar)


    %% READ THE LTE STANDARD FILE
    sLTE_stand = LTE_stand();

    % ---------------------------------------------------------------------

    %% READ THE GIVEN LTE SCENARIO FILE, OR TAKE THE GIVEN LTE SCENARIO STRUCTURE
    
    % Script checks, if the given 'LTEScen' argument is a string or not.
    % If it is a string, it is treated as a path to the scenario file,
    % otherwise it is taken as a structure with LTE scenario.
    %
    if ischar(LTEScen)
        
        % Case: string with a path to file
        
        % --------------------------------
        % Check if the LTE scenario file exists
        if ~exist(LTEScen,'file')

            % The below error is thrown out when the given file in not found
            error('ERROR (LTE_DL1): LTE scenario file is not found! BAILING OUT!');
        end

        % --------------------------------
        % Check the LTE scenario file: 

        % Divide the path to the LTE scenario file into parts
        [ strPath, strFile, strExt ] = fileparts(LTEScen);

        % Check if it is the .m file
        if ~strcmp(strExt,'.m')
            error('ERROR (LTE_DL1): LTE scenario file must be a .m file! BAILING OUT!');
        end

        % Read the scenario configuration file and check the content
        % (LTE scenario parser)
        [ sScen strErr ] = chc_ScenFil_DL1a(strFile,strPath);

        % Check if the LTE scenario parser put an error mark?
        % If yes, throw out an error and bail out!
        if isfield(sScen,'bError')
            error(strErr);
        end

        % ---------------------------------------------------------------------
    else
        % Case: structure with LTE scenario
        
        % If it is not a string, it is an LTE scenario structure
        sScen = LTEScen;
        [ sScen strErr ] = chc_Scen_DL1a(sScen);

        % Check if the LTE scenario parser put an error mark?
        % If yes, throw out an error and bail out!
        if isfield(sScen,'bError')
            error(strErr);
        end
    end
    
    
    %% READ THE GIVEN FILE WITH CODEWORDS, OR TAKE THE GIVEN CODEWORDS STRUCTURE
    % Script checks, if the given 'Codewords' argument is a string or not.
    % If it is a string, it is treated as a path to file with physical channels,
    % otherwise it is taken as a structure with physcial channels.
    %        
    if ischar(Codewords)
        % Case: string with a path to file
        
        % Check if user gave the empty file name. If so, indicate no
        % input channels. Otherwise, process the given file name.        
        if strcmp(Codewords,'')
            
            % Indicate the empty input structure:
            sCodewords = 0;            
        else
            
            % Check the given file name:

            % --------------------------------
            % Check if the file with codewords exists
            if ~exist(Codewords,'file')

                % The below error is thrown out when the given file in not found
                strMsg = sprintf('ERROR (LTE_DL1): The given file with codewords is not found! BAILING OUT!');
                error(strMsg);
            end
            
            % --------------------------------
            
            % Remove the file extension from the filename
            [ ~, ~, strExt ] = fileparts(Codewords);
            
            % Check if this file has .mat extension
            if ~strcmp(strExt,'.mat')
                strMsg = sprintf('\n ERROR (LTE_DL1): File with codewords signal must have a .mat extension! BAILING OUT!');
                error(strMsg);
            end

            % Read the file
            sWrap = load(Codewords);
            
            % Check if this file contains codewords
            if ~isfield(sWrap,'sCodewords')
                strMsg = sprintf('\n ERROR (LTE_DL1): The given file does not contain codewords! BAILING OUT!');
                error(strMsg);
            end

            % Get the structure with codewords
            sCodewords = sWrap.sCodewords;
        end
        
        % ---------------------------------------------------------------------
        
    else
        % Case: structure with codewords
        
        % If it is not a string, it is an LTE Downlink codewords structure
        % of an integer with 0
        sCodewords = Codewords;        
    end
    
    

    %% OPEN THE REPORT FILE (IF THE REPORT FILE IS SPECIFIED)
    
    % Script checks if the given 'strRepFil' argument is empty (equal to '').
    % If it is empty, no report file is created. Otherwise, the 'strRepFil' argument
    % is passed into the 'opnRepFil' function and the report file is
    % created.
    % In a case of no report file, the handle to this report file is set to -1.
    %
    if ischar(strRepFil)

        % Check if the report file was specified
        if ~strcmp(strRepFil,'')

            % Divide the report file name into parts
            [ ~, strRepFil, ~ ] = fileparts(strRepFil);        

            % Create the report file name
            strRepFil = strcat(strRepFil,'.txt');

            % Open the report file and return the handle
            hRepFil = fopen(strRepFil,'w');

            % Was there a problem while opening the report file?
            if hRepFil == -1                
                error('ERROR (LTE_DL1): I can not open the report file! BAILING OUT!');
            end
        else

            % Set the File Handle to minus one to indicate no report file
            hRepFil=-1;
        end
        % ---------------------------------------------------------------------
        
    else
        % Check if user has specified the strRepFil to 0
        if strRepFil == 0
            
            % Set the File Handle to minus one to indicate no report file
            hRepFil=-1;
        else            
            error('ERROR (LTE_DL1): I can not open the report file! BAILING OUT!');
        end
    end

    %% GENERATE THE CURRENT LTE BANDWIDTH AND TIME CONFIGURATION STRUCTURES 

    % The 'LTE_DL1_res' function returns the current time and frequency
    % configuration based on the current scenario file and the LTE standard
    % file. 
    % The configuration is held inside 3 structures: 
    %
    %   - sF (frequency configuration structure)
    %   - sT (time configuration structure)
    %   - sP (other LTE-specific parameters)
    %
    [ sF sT sP ] = LTE_DL1a_res(sScen,sLTE_stand,hRepFil);


    %% ALLOCATE RESOURCES MATRICES FOR THE WHOLE TRANSMISSION
    
    % GET THE NEEDED VALUES FROM THE STRUCTURES

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE BANDWIDTH (FREQUENCY) CONFIGURATION STRUCTURE
    % (structures: 'sF'):

        % The number of subcarriers in the bandwidth 
        N_scB = sF.N_scB;
    
        % The number of antennas
        nAnt = sF.nAnt;
        
    %----------------------------------------------------------


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE TIME CONFIGURATION STRUCTURE
    % (structures: 'sT'):

        % The number of symbols in the whole transmission
        N_symbTR = sT.N_symbTR;

    %----------------------------------------------------------


    % ------------------------------------------------------------------------
    % Allocate resources matrices for the whole transmission:
    %
    % mTF:      time/frequency resources matrix for the whole transmission
    %
    % mModMap:  resources matrix with modulation mapping for the whole transmission
    %
    % mSCMap:   resources matrix with signals and channel mapping for the whole transmission
    %
    
    
    % --------------------------------
    % Allocate the time/frequency resources matrix for the whole transmission
    mTF = zeros(N_scB,N_symbTR, nAnt);

    % Allocate the resources matrix with modulation mapping for the whole transmission
    mModMap = repmat({'.'}, [ N_scB, N_symbTR, nAnt] );

    % Allocate the resources matrix with signals and channel mapping for the whole transmission
    mSCMap = repmat({'.'}, [ N_scB, N_symbTR, nAnt]);
    % --------------------------------


    % ------------------------------------------------------------------------


    %% MAP THE SIGNALS AND CHANNELS INTO ALL RADIO FRAMES


    %----------------------------------------------------------
    % Start the waitbar, if it was requested
    if bGUIBar == 1
        hWaitBar = waitbar(0,'Sig. and Chan. mapping...');   
    else
        hWaitBar = -1;
    end
    %----------------------------------------------------------    
    
    
    % ------------------------------------------------------------
    % Run the signals mapper:
    [ mTF mSCMap mModMap ] = AddSignals(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, hRepFil, hWaitBar);
    
    % ------------------------------------------------------------
    % Run the channels mapper:
    [ mTF mSCMap mModMap sPBCH sPCFICH sPHICH sPDCCH sPDSCH ] = AddChannels(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, sCodewords, hWaitBar);

    % ---------------------------------------------------------------------

    % ----------------------------------------------------------    
    % Close the waitbar, if it is needed
    if bGUIBar == 1        
        close(hWaitBar);    
    end
    %----------------------------------------------------------  
    

    %% CLIP THE RESOURCES MATRICES TO THE NEEDED SIZE 
    % (number of symbols in the transmission):    

    % Matrix with time / frequency resources:
    mTF = mTF(:,1:N_symbTR);
    
    % Matrix with signals and channels mapping:
    mSCMap = mSCMap(:,1:N_symbTR);
    
    % Matrix with modulation mapping:
    mModMap = mModMap(:,1:N_symbTR);
    
    % ---------------------------------------------------------------------    


    %% PERFORM THE OFDM BASEBAND SIGNAL GENERATOR
    
    % Generate the symbols signal from the time/frequency matrix
    vSymbs = genOFDM(mTF, sF, sT, hRepFil);
   
    
    % Add The Cyclic Prefixes into the symbols signal
    % (output: I and Q signals)
    [ vI vQ mSymInx ] = AddCP(vSymbs, sF, sT, bGUIBar);
    
    % ---------------------------------------------------------------------
   
    
        
    %% CREATE THE OUTPUT STRUCUTRE (sLTE_DL1)
    
    % ========================================================================
    % Signals:
    % Save the I and Q into the output structure
    sLTE_DL1.vI = vI;
    sLTE_DL1.vQ = vQ;
    
    % Save the matrix with the information about inidces of Cyclic Prefixes and
    % Symbols in the vI and vQ vectors:
    sLTE_DL1.mSymInx = mSymInx;
    
    % ========================================================================
    
    
    % ========================================================================
    % Configuration structures:
    % Save the bandwidth configuration strucutres
    sLTE_DL1.sF = sF;
    
    % ------------------------------
    
    % Save the time configuration strucutres
    sLTE_DL1.sT = sT;        

    % ------------------------------
    
    % Save structure with the LTE-specific configuration parameters
    sLTE_DL1.sP = sP;
    
    % ========================================================================
    
    
    % ========================================================================
    % Resource matrices:
    % Save the time/frequency resources matrix
    sLTE_DL1.mTF = mTF;

    % ------------------------------
    
    % Save the resources matrix with modulation mapping
    sLTE_DL1.mModMap = mModMap;
    
    % ------------------------------
    
    % Save the resources matrix with signals/ channels mapping
    sLTE_DL1.mSCMap = mSCMap;
    
    % ========================================================================

    
    % ========================================================================
    % Add PBCH channel structure:
    sLTE_DL1.sPBCH = sPBCH;

    % ------------------------------
    
    % Add PCFICH channel structure:
    sLTE_DL1.sPCFICH = sPCFICH;

    % ------------------------------

    % Add PHICH channel structure:
    sLTE_DL1.sPHICH = sPHICH;

    % ------------------------------

    % Add PDCCH channel structure:
    sLTE_DL1.sPDCCH = sPDCCH;

    % ------------------------------
    
    % Add PDSCH channel structure:
    sLTE_DL1.sPDSCH = sPDSCH;

    % ------------------------------        
    
    
    % ========================================================================
  
    % ------------------------------        
    % Add the used scenario structure to the LTE DL1 output structure
    sLTE_DL1.sScen = sScen;
    
    % ------------------------------        
end

