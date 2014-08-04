%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modQAM16: THE "ALGaE" PACKAGE - QAM16 MODULATION.                                    
%                                    
% Function modulate bits using QAM16 modulation according to the LTE
% specification.
%
% File version 1.0 (30th July 2011)
%
%% ------------------------------------------------------------------------
% Input (1):
%
%       1. vBits:   Vector with input bits.
%
%
% ------------------------------------------------------------------------
% Output (1):
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
function vSymb = modQAM16(vBits)


    %%
    % QPSK modulation described according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 7.1.3 (QAM16)
    %
    
    %% Set the correct modulation order
    iModOr = 4;

    %% Allocate the vector with output symbol

    % Vectorize the input bitstream
    vBits = vBits(:);       
    
    % Get the size of the input bitstream
    iInSiz = size(vBits,1);   

    % Calculate the size of the output symbol vectors
    nSymb = ceil(iInSiz/iModOr);

    % Allocate the output vector
    vSymb = zeros(nSymb,1);

        
    %% The modulation
    
    % Check if the input vector is a multiplication of 4, if not add the 0 bits to
    % the end of the vector    
    vBits = [ vBits ;  zeros(iModOr - rem(iInSiz,iModOr),1)];
    
    % Reshape the input
    mBits = reshape(vBits,iModOr,nSymb);
    
    % Loop over all symbols
    for inxSymb=1:nSymb
        
        % Get the current bits
        vB = mBits(:,inxSymb)';
        
        % Change bits into a number 
        iN = vB * [8 4 2 1]';
        
        % Put the correct symbol        
        switch iN
                        
            case 0
                vSymb(inxSymb) = 1/sqrt(10) + 1i/sqrt(10);
                
            case 1                
                vSymb(inxSymb) = 1/sqrt(10) + 3i/sqrt(10);
                
            case 2                
                vSymb(inxSymb) = 3/sqrt(10) + 1i/sqrt(10);
                
            case 3
                vSymb(inxSymb) = 3/sqrt(10) + 3i/sqrt(10);   
                
            case 4
                vSymb(inxSymb) = 1/sqrt(10) - 1i/sqrt(10);   
                
            case 5
                vSymb(inxSymb) = 1/sqrt(10) - 3i/sqrt(10);   
                
            case 6
                vSymb(inxSymb) = 3/sqrt(10) - 1i/sqrt(10);   
                
            case 7
                vSymb(inxSymb) = 3/sqrt(10) - 3i/sqrt(10);   
                
            case 8
                vSymb(inxSymb) = -1/sqrt(10) + 1i/sqrt(10);   
                
            case 9
                vSymb(inxSymb) = -1/sqrt(10) + 3i/sqrt(10);   
                
            case 10
                vSymb(inxSymb) = -3/sqrt(10) + 1i/sqrt(10);   
                
            case 11
                vSymb(inxSymb) = -3/sqrt(10) + 3i/sqrt(10);   
                
            case 12
                vSymb(inxSymb) = -1/sqrt(10) - 1i/sqrt(10);   
                
            case 13
                vSymb(inxSymb) = -1/sqrt(10) - 3i/sqrt(10);   
                
            case 14
                vSymb(inxSymb) = -3/sqrt(10) - 1i/sqrt(10);   
                
            case 15
                vSymb(inxSymb) = -3/sqrt(10) - 3i/sqrt(10);   
        end
    end
end
