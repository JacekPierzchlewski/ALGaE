%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddSignals: THE "ALGaE" PACKAGE - REFERENCE AND SYNCHRONIZATION SIGNALS 
%                                       GENERATORS AND MAPPERS (WRAPPER)
%
% This function runs generators and mappers of reference and synchronization 
% signals.
%
% File version 1.0 (5th August 2011)
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
%       4. sLTE_stand:  Structure with the LTE standard parameter
%
%
%       5. sF:          Structure with the LTE bandwidth (frequency) configuration
%
%       6. sT:          Structure with the LTE time configuration
%
%       7. sT:          Structure with other LTE-specific parameters
%
%
%       8. hRepFil:     Handle to the report file
%
%       9. hWaitBar:    Handle to the optional waitbar
%
%
% ------------------------------------------------------------------------
% Outputs (3):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
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

function [ mTF mSCMap mModMap ] = AddSignals(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, hRepFil, hWaitBar)

    %% SYNCHRONIZATION SIGNALS
    % Synchronization signals generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11 (Synchronization signals)
    %

    % Add the PSS signal
    [ mTF mSCMap mModMap ] = AddPSS(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP, hRepFil);

    % Waitbar service
    if hWaitBar ~= -1
        waitbar(1/8,hWaitBar);
    end    
    
    % ----------------------------------------------------------------------
    
    % Add the SSS signal
    [ mTF mSCMap mModMap ] = AddSSS(mTF, mSCMap, mModMap, sF, sT, sP, hRepFil);

    % Waitbar service
    if hWaitBar ~= -1
        waitbar(2/8,hWaitBar);
    end    
    

    %% CELL SPECIFIC REFERENCE SIGNALS
    % Cell specific reference signals generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.10.1 (Cell-specific reference signals)
    %

    % Add the RS sginal
    [ mTF mSCMap mModMap ] = AddRS(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP);
    
    % Waitbar service
    if hWaitBar ~= -1
        waitbar(3/8,hWaitBar);
    end      
end

