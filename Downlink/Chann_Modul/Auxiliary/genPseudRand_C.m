%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% genPseudRand_C: THE "ALGaE" PACKAGE - PSEUDO RANDOM 'C' SEQUENCE GENERATOR 
%
% This function generates the pseudo random sequence C. This sequence is
% described in chapter 7.2 of the 3GPP 36.211 V10.0.0 document.
%
%
% File version 1.0 (27th July 2011)
%
%% ------------------------------------------------------------------------
% Inputs (2):
%
%       1. iC_init:     Time/frequency matrix with resource elements.
%
%       2. iSiz:        Signals and channels mapping matrix.
%
% ------------------------------------------------------------------------
% Output (1):
%
%       1. vC:         Pseudo random seuqence c.
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

function vC = genPseudRand_C(iC_init,iSiz)

    
    % Equations constructed with accordance to chapter 
    % 7.2 of the 3GPP 36.211 V10.0.0 document  


    %% Construct the x1 pseudo random sequence
    % (x1 constructed 
    x1 = zeros(1,iSiz+1600);
    x1(1) = 1;
    for n=1:1:iSiz+1600-31
        x1(n+31) = mod(x1(n+3) + x1(n),2);
    end

    %% Construct the x2 pseudo random sequence 
    x2 = zeros(1,iSiz+1600);

    x2(31:-1:1)=dec2bin(iC_init,31)-'0';
    for n=1:1:iSiz+1600-31
        x2(n+31) = mod((x2(n+3)+x2(n+2)+x2(n+1)+x2(n)),2);
    end

    %% Construct the vC pseudo random sequence
    vC = zeros(1,iSiz);
    for n=1:1:iSiz
        vC(n) = mod(x1(n+1600)+x2(n+1600),2);
    end
end
