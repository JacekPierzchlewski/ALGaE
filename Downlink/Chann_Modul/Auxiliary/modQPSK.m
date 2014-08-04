%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modQPSK: THE "ALGaE" PACKAGE - QPSK MODULATION.                                    
%                                    
% Function modulate bits using QPSK modulation according to the LTE
% specification.
%
% File version 1.0 (29th July 2011)
%
%% ------------------------------------------------------------------------
% Input (1):
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

function vSymb = modQPSK(vBits)


    %%
    % QPSK modulation described according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 7.1.2 (QPSK)
    %
    
    %% Set the correct modulation order
    iModOr = 2;

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
    
    % Check if the input vector is an even number, if not add the 0 bit to
    % the end of the vector    
    vBits = [ vBits ; zeros(rem(iInSiz,iModOr),1)];
    
    % Reshape the input
    mBits = reshape(vBits,iModOr,nSymb);
    
    % Loop over all symbols
    for inxSymb=1:nSymb
        
        % Get the current bits
        vB = mBits(:,inxSymb)';
        
        % Change bits into a number 
        iN = vB * [1 2]';
        
        % Put the correct symbol        
        switch iN
                        
            case 0
                vSymb(inxSymb) = 1/sqrt(2) + 1i/sqrt(2);
                
            case 1
                vSymb(inxSymb) = -1/sqrt(2) + 1i/sqrt(2);
                
            case 2                
                vSymb(inxSymb) = 1/sqrt(2) - 1i/sqrt(2);
                
            case 3
                vSymb(inxSymb) = -1/sqrt(2) - 1i/sqrt(2);                
        end
    end
end

