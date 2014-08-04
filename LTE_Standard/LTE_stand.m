%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_stand: THE "ALGaE" PACKAGE - CREATE THE MATLAB STRUCTURE WITH 
%                                  LTE STANDARD PARAMETERS
%
% File version 1.0 (13th July 2011)
%
%% ------------------------------------------------------------------------
% Input (0):
%
%       1. no input
%
% ------------------------------------------------------------------------
% Output (1):
%
%       1. sLTE_stand:  Structure with the LTE standard structure 
%       
%          Fields of the 'sLTE_stand' structure:
%               
%               % Antenna Ports configuration and transmission schemes:
%
%               .vSuppN:        The supported antenna ports [vector]
%
%               .cvSuppLTS:     The supported LTE Transmission Schemes [vector of cells]
%
%
%               ------------------------------------------------------------
%
%               % Channel bandwidth configuration:
%
%
%               .cvBW_channel   The names of LTE channel bandwidths
%                               configurations [vector of cells]
%
%               .vN_rb          The number of resource blocks in different
%                               LTE channel bandwidths configurations [vector]
%
%               ------------------------------------------------------------
%
%
%               % Physical Resource Block configuration: 
%
%               .Delta_f        Subcarriers separation
%`
%               .N_scRB         The number of subcarriers p. resource block
%
%               ------------------------------------------------------------
%
%
%               % Cyclic Prefix Configuration:
%
%               .cvCP           The names of Cyclic Prefix configurations [vector of cells]
%
%               .vN_symbDL      The number of symbols p. downlink in different CP configurations [vector]
%
%               .Ts             Basic Time Unit
%
%               .mCP_lengths    Matrix with Cyclic Prefix Lengths [matrix] 
%                               (One column - CP lenghts /all symbols in one Radio Slot/ 
%                                in one Cyclic Prefix configuration)
%               ------------------------------------------------------------
%
%
%               % Frame Structure Configuration:
%
%               .T_f            Radio frame lenght
%
%               .T_slot         Radio slot lenght
%
%               .N_rsSF         The number of radio slots in a subframe
%
%               .N_SFRF         The number of subframes in a radio frame 
%
%               ------------------------------------------------------------
%
%
%               % Synchronization Signals Configuration:
%
%               .N_id1_min      First physical layer cell identiy number
%                               min value
%
%               .N_id1_max      First physical layer cell identiy number 
%                               max value
%
%               .N_id2_min      Second physical layer cell identiy number
%                               min value
%
%               .N_id2_max      Second physical layer cell identiy number 
%                               max value
%               
%               .vN_ID2         Root indices for the Primary Synchronization 
%                               Signal [vector]
%
%               ------------------------------------------------------------
%
%               % PHICH Channel Configuration:
%
%               .vN_g           % The possible values of N_g coefficient [vector]
%
%               ------------------------------------------------------------
%
%               % PDCCH Channel Configuration:
%
%               .mPDCCH_Symb        Possible number of symbols for PDCCH in
%                                   a subframe for different bandwidths
%
%               .vPDCCH_Form        Possible PDCCH formats [vector]
%
%               .vPDCCH_CCEs        The number of CCEs in different PDCCH 
%                                   formats [vector]
%
%               .iPDCCH_REGpCCE     The number of Resource Element Groups (REGs) in a CCE
%
%               .iPDCCH_BitpCCE     The number of PDCCH bits in a CCE
%
%               .vPDCCH_CMP         The inter column permutation pattern     
%                                   [vector]           
%
%               ------------------------------------------------------------
%
%               % PDSCH Channel Configuration:
%
%               .vPDSCH_ModOrd      Possible PDSCH modulation orders 
%                                   [vector]
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


function sLTE_stand = LTE_stand()

    %#ok<*NASGU> <--- Suppress the unwanted MATLAB editor warnings

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% R A D I O   R E S O U R C E S   C O N F I G U R A T I O N S :
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% ANTENNA PORTS CONFIGURATION AND TRANSMISSION SCHEMES
    
    % The possible values of suported port numbers
    sLTE_stand.vSuppPN = [ 0 ]';

    % Supported LTE Transmission Schemes (LTS):
    sLTE_stand.cvSuppLTS    = {'SinglePort'}';


    %% CHANNEL BANDWIDTH CONFIGURATION
    % Source: 3GPP TS 36.104 ( Base Station Radio Transmission and Reception ): Table 5.6-1 
    % 

    % Channel bandwidths names:
    sLTE_stand.cvBW_channel = { '1.4' '3.0' '5.0' '10.0' '15.0' '20.0' }'; 

    % The number of Resource blocks
    sLTE_stand.vN_rb = [ 6 15 25 50 75 100 ]';
    
    
    %% PHYSICAL RESOURCE BLOCK PARAMETERS
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Table 6.2.3-1 

    % Subcarriers separation 
    sLTE_stand.Delta_f = 15e3; % [Hz]

    % The number of subcarriers in a Resource block
    sLTE_stand.N_scRB = 12;        
    
    
    %% CYCLIC PREFIX CONFIGURATION
    % Source: 
    %   [1] 3GPP TS 36.211 ( Physical channels and modulation ): Table 6.2.3-1 
    %   [2] 3GPP TS 36.211 ( Physical channels and modulation ): Chapter 6.12
    
    % Cyclic prefix configuration names [1]
    sLTE_stand.cvCP = {'NormalCP'  'ExtendedCP'}';

    % The number of symbols in a Radio Slot p. downlink [1]
    sLTE_stand.vN_symbDL = [ 7 6 ]';
        
    % Basic Time Unit [2]
    sLTE_stand.Ts = 32.552083*1e-9; % [s]
    
    % The lenghts of normal symbols in a Radio Slot [2]
    % (one column - one cyclic prefix configration type)
    sLTE_stand.mCP_lengths = [ 160 144 144 144 144 144 144 ; ...
                               512 512 512 512 512 512 0   ]' * sLTE_stand.Ts;
                
                
    %% FRAME STRUCTURE TYPE 1 CONFIGURATION
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Chapter 4.1 

    % Radio frame lenght 
    sLTE_stand.T_f = 10e-3;        % [s]

    % Radio slot lenght 
    sLTE_stand.T_slot = 0.5e-3;    % [s]

    % The number of radio slots in a subframe
    sLTE_stand.N_rsSF = 2;

    % The number of subframes in a radio frame
    sLTE_stand.N_SFRF = round(sLTE_stand.T_f/(sLTE_stand.T_slot*sLTE_stand.N_rsSF));

    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% S Y N C H R O N I Z A T I O N   S I G N A L S   C O N F I G U R A T I O N S :
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% PRIMARY SYNCHRONIZATION SIGNAL
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Table 6.11.1.1-1 
        
    % Physical layer cell identiy number (1)
    sLTE_stand.N_id1_min = 0;      % Minimum value
    sLTE_stand.N_id1_max = 167;    % Maximum value
    
    % Physical layer cell identiy number (2)
    sLTE_stand.N_id2_min = 0;      % Minimum value
    sLTE_stand.N_id2_max = 2;      % Maximum value
        
    % Root indices for the Primary Synchronization Signal
    sLTE_stand.vN_ID2 = [ 25 ; ...
                          29 ; ...
                          34 ];
        
    
    
    

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% R E F E R E N C E   S I G N A L S   C O N F I G U R A T I O N S :
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% P H Y S I C A L   C H A N N E L S   C O N F I G U R A T I O N S :
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% PHYSICAL BROADCAST CHANNEL CONFIGURATION
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Chapter 6.6 
    
    % TTI of the PBCH channel (Physical Broadcast Channel)
    sLTE_stand.iPBCH_TTI = 4;

        
    %% PHYSICAL HARQ INDICATOR CHANNEL
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Chapter 6.9 
    
    % The possible values of the N_g coefficient 
    % (The Ng coefficient controls the number of PHICH groups)
    sLTE_stand.vN_g = [ 1/6 1/2 1 2]';
    
    
    %% PHYSICAL DOWNLINK CONTROL CHANNEL
    % Source: 3GPP TS 36.211 ( Physical channels and modulation ): Chapter 6.8.1 
    
    % The possible number of symbols 
    sLTE_stand.mPDCCH_Symb = [ 2 3 4 ; ... % 1st column - 1st bandwidth
                               1 2 3 ; ... % 2nd column - 2nd bandwidth
                               1 2 3 ; ... % 3rd column - 3rd bandwidth
                               1 2 3 ; ... % 4th column - 4th bandwidth
                               1 2 3 ; ... % 5th column - 5th bandwidth
                               1 2 3 ; ]'; % 6th column - 6th bandwidth


    % The possible PDCCH formats
    sLTE_stand.vPDCCH_Form = [ 0 1 2 3 ]';
    
    % The number of CCEs in different PDCCH formats
    sLTE_stand.vPDCCH_CCEs = [ 1 2 4 8 ]';
    
    % The number of Resource Element Groups (REGs) in a CCE
    sLTE_stand.iPDCCH_REGpCCE = 9;
    
    % The number of PDCCH bits in a CCE
    sLTE_stand.iPDCCH_BitpCCE = 72;
    
    % The inter column permutation pattern
    sLTE_stand.vPDCCH_CMP = [1 17 9 25 5 21 13 29 3 19 11 27 7 23 15 31 ...
                             0 16 8 24 4 20 12 28 2 18 10 26 6 22 14 30 ]';

    %% PHYSICAL DOWNLINK SHARED CHANNEL
    
    % The possible modulation orders for the PDSCH channel
    sLTE_stand.vPDSCH_ModOrd = [2 4 6]';


end
