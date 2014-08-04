%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_DL1a_res: THE "ALGaE" PACKAGE - RESOURCE PARAMETERS CALCULATION:
%
% This function calculates structures with:
%
%                       - Bandwidth (frequency) configuration,
%                       - Time configuration,
%                       - Other LTE-specific parameters,
%                                        
%
% File version 1.0 (8th August 2011)
%                                 
%% ------------------------------------------------------------------------
% Inputs (3):
%
%       1. sScen:       Structure with the current LTE scenario.
%
%       2. sLTE_stand:  Structure with the LTE standard structure.
%
%       3. hRepFil:     Handle to the report file.
%
%
% ------------------------------------------------------------------------
% Outputs (3):
%
%       1. sF: Structure with the bandwidth (frequency) configuration.
%           
%          Fields in the 'sF' structure:               
% 
%               .Delta_f    : frequency separation between subcarriers
% 
%               .N_rb       : number of Resource Blocks in the current bandwidth 
% 
%               .N_scB      : number of subcarriers in the current bandwidth
% 
%               .N_ifft     : size of the IFFT 
% 
%               .F_fB       : frequency spectrum of the current bandwidth
%
%
%               .strTrans   : the transmission scheme
%
%               .nAnt       : the number of antenna ports
%
%
%       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%
%       2. sT: Structure with the time resources configuration.
%
%          Fields in the 'sT' structure:
%
%               .N_symbDL       : the current number of symbols in a Radio Slot     
% 
%               .vCP_lengths    : vector with time lenghts of symbols in a Radio Slot, 
%                                 lenght calculated together with CP's [vector]                                         
% 
%               .N_symbSF       : the number of LTE symbols in a Subframe
% 
%               .N_symbRF       : the number of LTE symbols in a Radio Frame
% 
%               .N_symbTR       : the number of LTE symbols in the whole
%                                 transmission
% 
%               .N_SF           : the number of subframes in the whole transmission    
% 
%               .N_RF           : the number of full(!) Radio Frames in the whole
%                                 transmission  
% 
%               .FIRST_SF       : position of the first transmitted subframe, in a
%                                 Radio Slot 
% 
%               .PBCH_RFINX     : index of the first transmitted Radio Frame in a PBCH TTI
% 
%               .fSmp           : sampling frequency for vI and vQ vectors
% 
%               .vN_SmpsCP      : the number of samples in Cyclic Prefixes in a Radio Slot  
%                                 [vector]
% 
%               .vN_SmpsSymb    : the number of samples in symbols in a Radio Slot, 
%                                 calculated together with CP's [vector]
% 
%               .nSmpsRS        : the total number of samples in a Radio Slot
% 
%               .nSmpsSF        : the total number of samples in a SubFrame
% 
%               .nSmpsRF        : the total number of samples in a RadioFrame
% 
%               .nSmpsTR        : the total number of samples in the transmission
%
%       - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%
%
%       3. sP: Structure with other LTE-specific parameters
%
%           Fields in the 'sP' structure:
%
%               .RNTI           : RNTI ident. number
%
%               .N_id1          : First number of a physical-layer cell identity
%
%               .N_id2          : Second number of a physical-layer cell identity
% 
%               .N_g            : The Ng coefficient which controls the number of PHICH groups
% 
%               .nPDCCH         : the number of PDCCH channels p. subframe
% 
%               .vPDCCHFor      : formats of the PDCCH channels [vector]
% 
%               .vCCEs          : the number of CCEs occupied by PDCCH [vector]
% 
%               .nPDCCHSym      : the number of symbols dedicated to PDCCH channels
%
%               .iModOrd        : the PDSCH modulation order
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

function [ sF sT sP ] = LTE_DL1a_res(sScen, sLTE_stand, hRepFil)


    %% GENERATE THE FREQUENCY RESOURCES STRUCUTRE
    sF = LTE_DL1a_res_freq(sScen, sLTE_stand, hRepFil);


    %% GENERATE THE TIME RESOURCES STRUCTURE
    sT = LTE_DL1a_res_time(sScen, sLTE_stand, sF, hRepFil);


    %% GENERATE THE LTE-SPECIFIC PARAMETERS STRUCTURE
    sP = LTE_DL1a_res_LTEPar(sScen, sLTE_stand);

end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% I N T E R N A L   F U N C T I O N S
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INTERNAL FUNCTION: Generate frequency resources structure.
%   
%   This function creates structure with the LTE bandwidth frequency 
%   configuration.
%   
%   ----------------------------------------------------------------
%   Inputs (3):
%   
%           1. sScen:       structure with the current LTE scenario 
%
%           2. sLTE_stand:  structure with the LTE standard parameters
%
%           3. hRepFil:     handle to the report file
%
%   ----------------------------------------------------------------
%   Output (1):
%
%           1. sF:          structure with the LTE bandwidth frequency
%                           configuration
%
%
function sF = LTE_DL1a_res_freq(sScen, sLTE_stand, hRepFil)



    %% CHECK THE GIVEN BANDWIDTH TYPE 

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD AND SCENARIO STRUCTURES 
    % (structures: 'sLTE_stand' and 'sScen'):
            
        % Get the cell with names of bandwidths from the structure
        cvBW_channel        = sLTE_stand.cvBW_channel;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 

        % Get the name of the bandwidth in the current scenario
        BANDWIDTH           = sScen.BANDWIDTH;
        
        % Get the name of the transmission scheme
        TRANS_SCHEME        = sScen.TRANS_SCHEME;
        
    %----------------------------------------------------------
    
    % Get the index of the bandwidth
    vInxBand = (1:6)';
    inxBand = vInxBand(strcmp(cvBW_channel,BANDWIDTH));
    
    % Check if the given bandwidth exists
    if size(inxBand,1) == 0
        strError = sprintf('\nERROR: There is no >> %s << bandwidth in the LTE Standard! BAILING OUT!\n',BANDWIDTH);
        error(strError); %#ok<*SPERR>
    end
        
       
    %% ADD THE BANDWIDTH PARAMETERS TO THE sF STRUCTURE  
    %
    %   1. Delta_f  -   the frequency separation between subcarriers
    %   2. N_rb     -   the number of Resource Blocks in the current bandwidth 
    %   3. N_scB    -   the number of subcarriers in the current bandwidth
    %   4. N_ifft   -   the size of the IFFT 
    %   5. F_fB     -   the frequency spectrum of the current bandwidth 
    %
    %   6. strTrans -   the transmission scheme
    %   7. nAnt     -   the number of antenna ports
    %
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD STRUCTURE
    % (structures: 'sLTE_stand'):
            
        % Get the vector with the number of Resource Block in bandwidths
        vN_rb       = sLTE_stand.vN_rb;

        % Get the number of subcarriers in a Resource Block
        N_scRB      = sLTE_stand.N_scRB;        
        
        % Get the frequency separation between subcarriers
        Delta_f     = sLTE_stand.Delta_f;
                        
    %----------------------------------------------------------
    % Bandwidth parameters:
    
    % Get the correct number of Resource Blocks in the current bandwidth
    N_rb = vN_rb(inxBand);        
    
    % Calculate the number of subcarriers in the current bandwidth
    N_scB =  N_scRB * N_rb;    
    
    % Calculate the size of the IFFT 
    N_ifft = 2^(ceil(log2(N_scB)));
    
    % Calculate the frequency spectrum of the current bandwidth
    F_fB = Delta_f * N_scB;
    
    %----------------------------------------------------------
    
    %----------------------------------------------------------
    
    % Transmission Scheme
    switch TRANS_SCHEME
        
        % Signle Port scheme
        case 'SinglePort'
            
            % Antenna parameters:
            nAnt = 1;               % The number of antenna ports is one
    end
    
    

    %----------------------------------------------------------

    % STORE THE BANDWIDTH PARAMETERS IN THE sF STRUCTURE
    sF.Delta_f  = Delta_f;   % The frequency separation between subcarriers
    sF.N_rb     = N_rb;      % The number of Resource Blocks in the current bandwidth
    sF.N_scB    = N_scB;     % The number of subcarriers in the current bandwidth
    sF.N_ifft   = N_ifft;    % The size of the ifft
    sF.F_fB     = F_fB;      % The frequency spectrum of the current bandwidth

    sF.strTrans = TRANS_SCHEME;         % The current transmission scheme
    sF.nAnt     = nAnt;                 % The current number of antennas 


    % ---------------------------------------------------------------------------------------------------     
    % REPORT TO THE FILE, IF NEEDED
        if hRepFil ~= -1

            % REPORT THE BANDWIDTH (FREQUENCY) PARAMETERS:
            strMessage = sprintf('CURRENT BANDWIDTH (FREQUENCY) PARAMETERS: \n\n'); 
            strMessage = sprintf('%s Bandwidth: %s \n\n',strMessage,BANDWIDTH);
            strMessage = sprintf('%s The number of Resource Blocks in the current bandwidth: %d \n',strMessage,N_rb);
            strMessage = sprintf('%s The number of subcarriers in the current bandwidth:     %d \n',strMessage,N_scB);
            strMessage = sprintf('%s The size of the IFFT:                                   %d \n',strMessage,N_ifft);
            strMessage = sprintf('%s The frequency spectrum of the current bandwidth:        %.2f [MHz] \n',strMessage,F_fB/1e6);  
            
            strMessage = sprintf('%s\n The current transmission scheme: %s \n',strMessage,TRANS_SCHEME);
            strMessage = sprintf('%s\n The current number of antennas: %d \n',strMessage,nAnt);

            strMessage = sprintf('%s---------------------------------------------------\n\n\n',strMessage);

            % Dump the message to the file
            fprintf(hRepFil,strMessage);
        end
    % ---------------------------------------------------------------------------------------------------

end


%% INTERNAL FUNCTION: Generate time resources configuration structure
%   
%   This function creates structure with the LTE time
%   configuration.
%
%   ----------------------------------------------------------------
%   Inputs (4): 
%   
%           1. sScen:       structure with the current LTE scenario 
%
%           2. sLTE_stand:  structure with the LTE standard parameters
%
%           3. sF:          structure with the LTE bandwidth frequency 
%                           configuration
%
%           4. hRepFil:     handle to the report file
%
%
%   ----------------------------------------------------------------
%   Output (1): 
%
%           1. sT:          structure with the LTE time configuration
%
%
function sT = LTE_DL1a_res_time(sScen, sLTE_stand, sF, hRepFil)

    
    %% CHECK THE GIVEN CYCLIC PREFIX TYPE 
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD AND SCENARIO STRUCTURES 
    % (structures: 'sLTE_stand' and 'sScen'):

        % Get the cell with cyclic prefix configuration names
        cvCP            = sLTE_stand.cvCP;
    
        % - - - - - - - - - - - - - - - - - - - - - - - - - - -     
    
        % Check if the type of the Cyclic Prefix is given in the 
        % structure with the current LTE scenario
        if ~isfield(sScen,'CYCLIC_PRFX')
            error('The type of the Cyclic Prefix (CYCLIC_PRFX) is not specified in the LTE scenario file!');
        end
        
        % Get the name of the cyclic prefix in the current scenario
        CYCLIC_PRFX     = sScen.CYCLIC_PRFX;
        
    %----------------------------------------------------------    
   
    % Get the index of the cyclic prefix
    vInxCP = (1:2)';
    inxCP = vInxCP(strcmp(cvCP,CYCLIC_PRFX));
    
    % Check if the given cyclic prefix exists
    if size(inxCP,1) == 0
        strError = sprintf('\nERROR: There is no >> %s << CP settings in the LTE Standard! BAILING OUT!\n',CYCLIC_PRFX);
        error(strError); %#ok<*SPERR>
    end
    
        
    %% ADD THE CYCLIC PREFIX AND SYMBOL PARAMETERS TO THE sT STRUCTURE
    %
    %   1. N_symbDL     -   the number of symbols in a Radio Slot
    %   2. vCP_lengths  -   the vector with lenghts of symbols
    %   3. N_symbSF     -   the number of symbols in a Subframe
    %   4. N_symbRF     -   the number of symbols in a Radio Frame 
    %   5. N_symbTR     -   the number of symbols in the whole transmission
    %
    %   6. N_SF         -   the number of subframes in the whole transmission
    %   7. N_RF         -   the number of Radio Frames in the whole
    %                       transmission
    %   8. FIRST_SF     -   the index of the first subframe in the transmission
    %
    %   9. PBCH_RFINX   -   the index of the Radio Frame in PBCH TTI
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD AND SCENARIO STRUCTURES 
    % (structures: 'sLTE_stand' and 'sScen'):
                    
        % Get the vector with number of symbols in a Radio Slot p. downlink 
        vN_symbDL       = sLTE_stand.vN_symbDL;
        
        % Get the number of radio slots in a Subframe
        N_rsSF          = sLTE_stand.N_rsSF;
                
        % The number of subframes in a Radio Frame
        N_SFRF          = sLTE_stand.N_SFRF;
                                      
        % The lenght of symbols in a Radio Frame ( [s] )
        mCP_lengths     = sLTE_stand.mCP_lengths;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - -   
        
        % Check if the number of LTE Subframes is given in the 
        % structure with the current LTE scenario
        if ~isfield(sScen,'N_SF')
            error('The number of Subframes (N_SF) is not specified in the LTE scenario file!');
        end                

        % The number of Subframes in the whole transmission
        N_SF            = round(sScen.N_SF);
        
        % Check if the number of LTE Radio Frames is correct
        if N_SF < 1
            error('The number of LTE Subframes (N_SF) can not be lower than 1!');
        end
           
        
        % Check if index of the first LTE Subframes is given
        % in the current LTE scenario
        if ~isfield(sScen,'FIRST_SF')
            error('Index of the first subframe (FIRST_SF) is not specified in this LTE scenario file!');
        end                
        
        % Index of the first subframe in the transmission
        FIRST_SF       = sScen.FIRST_SF;
       
        if 0 > FIRST_SF || FIRST_SF > (N_SFRF-1)
            error('Index of the first subframe (inxFrstSF) is incorrect!');
        end

        % Check if index of the Radio Frame in PBCH TTI exists in LTE
        % scenario structure
        if isfield(sScen,'PBCH_RFINX')
            PBCH_RFINX = sScen.PBCH_RFINX;
        else
            PBCH_RFINX = 0;
        end                
        
                
    %---------------------------------------------------------- 
    
    % Get the current number of symbols in a Radio Slot
    N_symbDL = vN_symbDL(inxCP);
    
    % Get the correct vector with lenghts of symbols from the matrix with
    % lenght of symbols
    vCP_lengths = mCP_lengths(:,inxCP);
    vCP_lengths = vCP_lengths(1:N_symbDL);
    
    % Calculate the number of symbols in a Subframe
    N_symbSF = N_symbDL * N_rsSF;
    
    % Calculate the number of symbols in a Radio Frame
    N_symbRF = N_symbSF * N_SFRF;
        
    % Calculate the number of symbols in the whole transmission
    N_symbTR = N_SF * N_symbSF;
    
    % Calculate the number of full Radio Frames in the transmission    
    if FIRST_SF == 0
        N_RF = floor(N_SF/N_SFRF);
    else
        N_RF = floor((N_SF-N_SFRF+FIRST_SF)/N_SFRF);
        if N_RF < 0
            N_RF = 0;
        end
    end
    
    % STORE THE TIME PARAMETERS IN A STRUCTURE
    sT.N_symbDL     = N_symbDL;     % The number of symbols in a Radio Slot
    sT.vCP_lengths  = vCP_lengths;  % The vector with lenghts of symbols
    sT.N_symbSF     = N_symbSF;     % The number of symbols in a Subframe
    sT.N_symbRF     = N_symbRF;     % The number of symbols in a Radio Frame    
    sT.N_symbTR     = N_symbTR;     % The number of symbols in the whole transmission
    
    sT.N_SF         = N_SF;         % The number of subframes in the whole transmission
    sT.N_RF         = N_RF;         % The number of Radio Frames in the whole transmission
    sT.FIRST_SF     = FIRST_SF;     % The index of the first subframe in the transmission
    
    sT.PBCH_RFINX   = PBCH_RFINX;   % The index of the Radio Frame in PBCH TTI

    sT.inxCP        = inxCP;        % The CP index (1- normal, 2 - extended)


    % ---------------------------------------------------------------------------------------------------
    % REPORT TO THE FILE, IF NEEDED
        if hRepFil ~= -1

            % REPORT THE TIME PARAMETERS:
            strMessage = sprintf('CURRENT CYCLIC PREFIX AND TIME PARAMETERS: \n\n');
            strMessage = sprintf('%s Cyclic Prefix: %s \n\n',strMessage,CYCLIC_PRFX);
            strMessage = sprintf('%s The number of symbols in a Radio Slot:                 %d \n',strMessage,N_symbDL);
            strMessage = sprintf('%s The number of symbols in a Subframe:                   %d \n',strMessage,N_symbSF);
            strMessage = sprintf('%s The number of symbols in a Radio Frame:                %d \n',strMessage,N_symbRF);
            strMessage = sprintf('%s The number of symbols in the whole transmission:       %d \n',strMessage,N_symbTR);
            
            strMessage = sprintf('%s The number of Subframes in the transmission:           %d \n',strMessage,N_SF);
            strMessage = sprintf('%s The number of Radio Frames in the transmission:        %d \n',strMessage,N_RF);            
            strMessage = sprintf('%s The index of the first subframe in the transmission:   %d \n',strMessage,PBCH_RFINX);
            
            strMessage = sprintf('%s The index of the Radio Frame in PBCH TTI:              %d \n',strMessage,PBCH_RFINX);
            strMessage = sprintf('%s---------------------------------------------------\n\n\n',strMessage);                                                

            % Dump the message to the file
            fprintf(hRepFil,strMessage);
        end        
    % ---------------------------------------------------------------------------------------------------
    
    %% ADD SAMPLING PARAMETERS TO THE sT STRUCTURE
    % 
    %   1. fSmp             -   the sampling frequency
    %   2. vN_SmpsCP        -   the number of samples in cyclic prefixes 
    %   3. vN_SmpsSymb      -   the number of samples in the whole symbol + Cyclic prefixes
    %   4. nSmpsRS          -   the total number of samples in a Radio Slot
    %   5. nSmpsSF          -   the total number of samples in a SubFrame
    %   6. nSmpsRF          -   the total number of samples in a RadioFrame
    %   7. nSmpsTR          -   the total number of samples in the transmission
    %   
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE BANDWIDTH CONFIGURATION STRUCTURE
    % (structure: 'sF')
              
        % The frequency separation between subcarriers
        Delta_f     = sF.Delta_f;
        
        % The size of the IFFT
        N_ifft       = sF.N_ifft;
        
    %---------------------------------------------------------- 

    % Calculate the sampling frequency
    fSmp = Delta_f*N_ifft;
    
    % Calculate the number of samples in cyclic prefixes
    % (Create a vector with numer of samples in the cyclic prefixes for the whole radio slot)
    vN_SmpsCP = round(N_ifft*Delta_f*vCP_lengths);

    % Calculate the number of samples in the whole symbol + Cyclic prefixes
    % (Create a vector with numer of samples in the symbols+CP for the whole radio slot)
    vN_SmpsSymb = N_ifft + vN_SmpsCP;
                
    % Calculate the total number of samples in a Radio Slot
    nSmpsRS = sum(vN_SmpsSymb);
        
    % Calculate the total number of samples in a Subframe 
    nSmpsSF = N_rsSF*nSmpsRS;
    
    % Calculate the total number of samples in a Radio Frame
    nSmpsRF = nSmpsSF*N_SFRF;
    
    % Calculate the total number of samples in the whole transmission 
    nSmpsTR = N_SF*nSmpsSF;    
    
    % STORE THE TIME PARAMETERS IN A STRUCTURE
    sT.fSmp         = fSmp;         % The sampling frequency
    sT.vN_SmpsCP    = vN_SmpsCP;    % The number of samples in cyclic prefixes
    sT.vN_SmpsSymb  = vN_SmpsSymb;  % The number of samples in the whole symbol + Cyclic prefixes
    sT.nSmpsRS      = nSmpsRS;      % The total number of samples in a Radio Slot
    sT.nSmpsSF      = nSmpsSF;      % The total number of samples in a Subframe
    sT.nSmpsRF      = nSmpsRF;      % The total number of samples in a Radio Frame
    sT.nSmpsTR      = nSmpsTR;      % The total number of samples in the transmission


    %% ---------------------------------------------------------------------------------------------------
    % REPORT TO THE FILE, IF NEEDED
        if hRepFil ~= -1

            % REPORT THE SAMPLING PARAMETERS:
            strMessage = sprintf('CURRENT SAMPLING PARAMETERS : \n\n');
            strMessage = sprintf('%s The sampling frequency it is: %.2f [MHz] \n\n',strMessage,fSmp/1e6);
            strMessage = sprintf('%s The number of samples in a Radio Slot:             %d \t[samples] \n',strMessage,nSmpsRS);
            strMessage = sprintf('%s The number of samples in a Subframe:               %d \t[samples] \n',strMessage,nSmpsSF);
            strMessage = sprintf('%s The number of samples in a Radio Frame:            %d \t[samples] \n',strMessage,nSmpsRF);
            strMessage = sprintf('%s The number of samples in the whole transmission:   %d \t[samples] \n\n',strMessage,nSmpsTR);
                        
            % REPORT LENGTHS OF CYCLIC PREFIXES:
            strMessage = sprintf('%s The lenghts of cyclic prefixes:\n',strMessage);
            for inxCP=1:N_symbDL
                strMessage = sprintf('%s  %.2f [us]  - %d samples \n',strMessage,vCP_lengths(inxCP)*1e6,vN_SmpsCP(inxCP));
            end
            strMessage = sprintf('%s\n',strMessage);
            
            % REPORT LENGTHS OF SYMBOLS:
            strMessage = sprintf('%s The lenghts of symbols:\n',strMessage);
            for inxCP=1:N_symbDL
                strMessage = sprintf('%s  %.2f [us]  - %d samples \n',strMessage,(1/Delta_f + vCP_lengths(inxCP))*1e6,vN_SmpsSymb(inxCP));
            end
                                                
            strMessage = sprintf('%s---------------------------------------------------\n\n\n',strMessage);
            
            % Dump the message to the file
            fprintf(hRepFil,strMessage);
        end        
    % ---------------------------------------------------------------------------------------------------

end


%% INTERNAL FUNCTION: Create structure with the LTE-specific parameters
%   
%   This function creates structure with the LTE-specific
%   parameters
%
%   --------------------------------
%   Inputs (2):
%   
%           1. sScen:       structure with the current LTE scenario 
%
%           2. sLTE_stand:  structure with the LTE standard parameters
%
%   --------------------------------
%   Output (1):
%
%           1. sP:          structure with the LTE-specific parameters
%
%
function sP = LTE_DL1a_res_LTEPar(sScen, sLTE_stand)
 
        
    %% ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD STRUCTURE
    % (structures: 'sLTE_stand'):

    
        % Get the minimum value of the first physical cell identity number 
        N_id1_min = sLTE_stand.N_id1_min;

        % Get the maximum value of the first physical cell identity number 
        N_id1_max = sLTE_stand.N_id1_max;

        % Get the minimum value of the second physical cell identity number 
        N_id2_min = sLTE_stand.N_id2_min;

        % Get the maximum value of the second physical cell identity number 
        N_id2_max = sLTE_stand.N_id2_max;

        % Get the possible values of the N_g parameter
        vN_g = sLTE_stand.vN_g;


        % Get the possible PDCCH formats
        vPDCCH_Form = sLTE_stand.vPDCCH_Form;

        % Get the number of CCEs in different PDCCH formats
        vPDCCH_CCEs = sLTE_stand.vPDCCH_CCEs;

        % Get the channel bandwidth names
        cvBW_channel = sLTE_stand.cvBW_channel;

        % Get the possible number of symbols 
        mPDCCH_Symb = sLTE_stand.mPDCCH_Symb;


    %----------------------------------------------------------------
    
        
    % ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE SCENARIO STRUCTURES
    % (structure: 'sScen'):
        

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        % Get the current bandwidth name
        BANDWIDTH = sScen.BANDWIDTH;
            
        % Get the RNTI number
        RNTI = sScen.RNTI;

        % - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %----------------------------------------------------------
    
    %% ----------------------------------------------------------
    % RNTI ident. number
    sP.RNTI = RNTI;
    
    
    %% ----------------------------------------------------------
    % PHY layer cell identity numbers:

    % ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE  SCENARIO STRUCTURES
    % (structure: 'sScen'):
            
    
        % - - - - - - - - - - - - - - - - - - - - - - - - - - -
        % PHY layer identity numbers:
        
        % Check if the phy layer cell identity numbers are given in the
        % structure with the current LTE scenario
        if ~isfield(sScen,'N_ID1')
            error('The first physical layer cell identity number (N_ID1) is not specified in the LTE scenario file!');
        end
    
        if ~isfield(sScen,'N_ID2')
            error('The second physical layer cell identity number (N_ID2) is not specified in the LTE scenario file!');
        end        
        
        % Get the first physical layer cell identity number
        N_ID1       = sScen.N_ID1;

        % Get the second physical layer cell identity number
        N_ID2       = sScen.N_ID2;        


    % -----------------------------------------------------------------------------
    
    % Check if the given phy layer cell identity numbers are correct
    % N_ID1:
    if N_ID1 < N_id1_min
        error('The first physical layer cell identity number (N_ID1) is too small!');
    end
    
    if N_ID1 > N_id1_max
        error('The first physical layer cell identity number (N_ID1) is too large!');
    end
    
    % N_ID2:
    if N_ID2 < N_id2_min
        error('The second physical layer cell identity number (N_ID2) is too small!');
    end
    
    if N_ID2 > N_id2_max
        error('The second physical layer cell identity number (N_ID2) is too large!');
    end
    
    % Get the first number of a physical-layer cell identity and store it
    % in the output strucutre
    sP.N_id1 = N_ID1;

    % Get the second number of a physical-layer cell identity and store it
    % in the output strucutre
    sP.N_id2 = N_ID2;        
    
    %----------------------------------------------------------

    
    
    %% GET THE "CHANNELS MOULATION (L1a layer)" LTE SCENARIO SUBSTRUCTURE
    sL1a = sScen.sL1a;


    %% ----------------------------------------------------------
    % PHICH channel:

    % ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE  SCENARIO STRUCTURES
    % (structure: 'sScen'):
                
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % N_g parameter:
        
        % Check if the N_g parameter (PHICH) is given
        if ~isfield(sL1a,'N_g')
            error('The N_q parameter is not specified in the LTE scenario file! (N_q)');
        end

        % Get the N_q parameter 
        N_g = sL1a.N_g;

    % ----------------------------------------------------------        
            
    % Check if the given N_g parameter is correct
    if sum(N_g == vN_g) == 0
        error('The given N_g parameter is incorrect!');                
    end
    
    % Store the N_g parameter
    sP.N_g = N_g;    
    
    %----------------------------------------------------------
    
    

    
    %% ----------------------------------------------------------
    % PDCCH channel:

    % ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE  SCENARIO STRUCTURES
    % (structure: 'sScen'):

        % PDDCH format:
        
        % Check if the PDCCH format is given
        if ~isfield(sL1a,'vPDCCHFor')
            error('The PDCCH format is not specified in the LTE scenario file! (vPDCCHFor)');
        end
        
        % Get the PDCCH format
        vPDCCHFor = sL1a.vPDCCHFor(:);


        % - - - - - - - - - - - - - - -
        % The number of PDCCH channels:
        
        % Check if the number of PDCCH channels is given
        if ~isfield(sL1a,'nPDCCH')
            error('The number of PDCCH channels is not specified in the LTE scenario file! (nPDCCH)');
        end
        
        % Get the number of PDCCH channels 
        nPDCCH = sL1a.nPDCCH;
        
        
        % - - - - - - - - - - - - - - -
        % The number of symbols dedicated for PDCCH:
        
        % Check if the number of symbols dedicated for PDCCH is given
        if ~isfield(sL1a,'nPDCCHSym')
            error('The number of symbols dedicated for PDCCH is not specified in the LTE scenario file! (nPDCCHSym)');
        end
        
        % Get the number of symbols dedicated for PDCCH
        nPDCCHSym = sL1a.nPDCCHSym;
        
    % ----------------------------------------------------------            
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % The number of PDCCH channels:
    
    % Store the number of PDCCH channels
    sP.nPDCCH = nPDCCH;
        
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % The given PDCCH format:
        
    % Check if the number of formats is equal to the number of PDCCH
    % channels
    if size(vPDCCHFor,1) ~= nPDCCH
        error('The given vector with PDCCH formats should have lenght equal to the number of PDCCH channels!');
    end
    
    % Check if the given PDCCHs format is correct
    for inxChan=1:nPDCCH % Loop over all channels
        
        % Get the current PDCCH format
        iPDCCHFor = vPDCCHFor(inxChan);
        
        % Check if the given format is correct
        if sum(iPDCCHFor == vPDCCH_Form) == 0
            strMsg = sprintf('\nThe given PDCCH format (for the PDCCH channel #%d)is incorrect!\n',inxChan);
            error(strMsg);
        end
    end
            
    % Store the given PDCCH format
    sP.vPDCCHFor = vPDCCHFor;

    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % The number of CCEs :

    % Auxilary vector
    vInx = 1:size(vPDCCH_CCEs,1);
    
    % Allocate vector with the number of CCEs for all channels
    vCCEs = zeros(nPDCCH,1);
        
    % Loop over all PDCCH channels
    for inxChan=1:nPDCCH
        
        % Get the current PDCCH format
        iPDCCHFor = vPDCCHFor(inxChan);
        
        % Store the number of CCEs for the current channel
        vCCEs(inxChan) = vPDCCH_CCEs(vInx(iPDCCHFor == vPDCCH_Form));                        
    end
    
    % Store the vector with the number of CCEs    
    sP.vCCEs = vCCEs;
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    % The correct number of symbols dedciated for PDCCH:
    
    % Get the correct number of symbols dedciated for PDCCH    
    vPDCCH_Symb = mPDCCH_Symb(:,strcmp(cvBW_channel,BANDWIDTH));
    
    % Check if the given number of symbols dedicated for PDCCH is correct
    if sum(vPDCCH_Symb==nPDCCHSym) == 0
        error('The given number of symbols dedicated for PDCCH is incorrect!');
    end
    
    % Store the number of symbols dedicated for PDCCH channel
    sP.nPDCCHSym = nPDCCHSym;
    
    %----------------------------------------------------------

    %% ----------------------------------------------------------
    % PDSCH channel:
       
    % ----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE  SCENARIO STRUCTURES
    % (structure: 'sScen'):

        % PDSCH modulation order:
        
        % Check if the PDSCH modulation order is given
        if ~isfield(sL1a,'iModOrd')
            error('The PDSCH modulation order (iModOrd) is not specified in the LTE scenario file!');
        end
        
        % Get the PDSCH modulation order
        iModOrd = sL1a.iModOrd;
        
    % ----------------------------------------------------------
    
    % Store the number of symbols dedicated for PDSCH channel
    sP.iModOrd = iModOrd;

    %----------------------------------------------------------
end
