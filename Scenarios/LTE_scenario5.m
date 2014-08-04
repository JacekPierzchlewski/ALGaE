%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_scenario5: THE "ALGaE" PACKAGE - DOWNLINK SCENARIO 
%                                      EXAMPLE 5.0 [MHz]                                                                                          
%
% File version 1.0 (31th October 2011)
%                                 
%% ------------------------------------------------------------------------
%
% Input: no input
%
% ------------------------------------------------------------------------
% Output:
%
%       1. sScen: Structure with the current LTE scenario.
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


function sScen = LTE_scenario5()
    
    %#ok<*NASGU> 
    %#ok<*NBRAK> <--- Suppress the unwanted MATLAB editor warnings
    
    %% MAIN TRANSMISSION SETTINGS:

    % THE RNTI NUMBER
    sScen.RNTI   =  1;
    
    % LTE DOWNLINK TRANSMISSION SCHEME
    sScen.TRANS_SCHEME = 'SinglePort';
    
    % BANDWIDTH:
    sScen.BANDWIDTH   =  '5.0'; 


    % CYCLIC PREFIX TYPE:
    sScen.CYCLIC_PRFX = 'NormalCP';


    % THE TIME PARAMETERS
    sScen.N_SF = 1;       % The number of subframes

    sScen.FIRST_SF = 0;   % Index of the first transmitted subframe in a Radio Frame


    % PHYSICAL LAYER CELL IDENTITIES:

    % Physical-layer cell identity (first number)
    sScen.N_ID1 = 0;

    % Physical-layer cell identity (second number)
    sScen.N_ID2 = 1;


    %% MODULE: CHANNELS MODULATION (L1a)
    
        % PHYSICAL BROADCAST CHANNEL:

        sScen.sL1a.PBCH_RFINX = 3;  % The index of the first Radio Frame in PBCH TTI


        % PHYSICAL HARQ INDICATOR CHANNEL

        sScen.sL1a.N_g = 0.5;  % The Ng coefficient which controls the number of PHICH groups


        % PHYSICAL DOWNLINK CONTROL CHANNEL

        sScen.sL1a.vPDCCHFor = [ 1 ]';   % Formats of PDCCH channels

        sScen.sL1a.nPDCCH    = 1;        % The number of PDCCH channels

        sScen.sL1a.nPDCCHSym = 2;        % The number of symbols in a subframe dedicated for 
                                         % PDCCH channels

        % -----------------------------------------------------------------------------------------------

        % PHYSICAL DOWNLINK SHARED CHANNEL
        sScen.sL1a.iModOrd = 2;          % The PDSCH channel modulation order

end
