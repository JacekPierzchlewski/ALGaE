%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modBPSK: THE "ALGaE" PACKAGE - BPSK MODULATION.                                    
%                                    
% Function modulate bits using BPSK modulation according to the LTE
% specification.
%
% File version 1.0 (29th July 2011)
%
%% ------------------------------------------------------------------------
% Input:
%       1. vBits:   Vector with input bits.
%
%
% ------------------------------------------------------------------------
% Output:
%
%       1. vSymb:   Vector with output symbols.
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

function vSymb = modBPSK(vBits)


    %%
    % QPSK modulation described according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 7.1.1 (BPSK)
    %
    
    %% Set the correct modulation map
    vMap = [ 1/sqrt(2)+1i/sqrt(2) -1/sqrt(2)-1i/sqrt(2) ];
    
    
    %% Modulate - translate the bits into symbols
    vSymb = vMap(vBits + 1);    
    
end

