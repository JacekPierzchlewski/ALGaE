%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modQAM64: THE "ALGaE" PACKAGE - QAM64 MODULATION.                                    
%                                    
% Function modulate bits using QAM64 modulation according to the LTE
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
function vSymb = modQAM64(vBits)


    %%
    % QPSK modulation described according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 7.1.4 (QAM64)
    %
    
    %% Set the correct modulation order
    iModOr = 6;

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
    
    % Check if the input vector is a multiplication of 6, if not add the 0 bits to
    % the end of the vector     
    vBits = [ vBits ; zeros(iModOr - rem(iInSiz,iModOr),1)];
    
    % Reshape the input
    mBits = reshape(vBits,iModOr,nSymb);
    
    % Loop over all symbols
    for inxSymb=1:nSymb
        
        % Get the current bits
        vB = mBits(:,inxSymb)';
        
        % Change bits into a number 
        iN = vB * [32 16 8 4 2 1]';
        
        % Put the correct symbol        
        switch iN
                        
            % 000000
            case 0
                vSymb(inxSymb) = 3/sqrt(42) + 3i/sqrt(42);
                
            % 000001    
            case 1                
                vSymb(inxSymb) = 3/sqrt(42) + 1i/sqrt(42);
                
            % 000010    
            case 2                
                vSymb(inxSymb) = 1/sqrt(42) + 3i/sqrt(42);
                
            % 000011                    
            case 3
                vSymb(inxSymb) = 1/sqrt(42) + 1i/sqrt(42);   
                
            % 000100                    
            case 4
                vSymb(inxSymb) = 3/sqrt(42) + 5i/sqrt(42);   
                
            % 000101                                    
            case 5
                vSymb(inxSymb) = 3/sqrt(42) + 7i/sqrt(42);   

            % 000110                
            case 6
                vSymb(inxSymb) = 1/sqrt(42) + 5i/sqrt(42);   
                
            % 000111                 
            case 7
                vSymb(inxSymb) = 1/sqrt(42) + 7i/sqrt(42);   
                
            % 001000                
            case 8
                vSymb(inxSymb) = 5/sqrt(42) + 3i/sqrt(42);   

            % 001001
            case 9
                vSymb(inxSymb) = 5/sqrt(42) + 1i/sqrt(42);   
                
            % 001010                
            case 10
                vSymb(inxSymb) = 7/sqrt(42) + 3i/sqrt(42);   

            % 001011
            case 11
                vSymb(inxSymb) = 7/sqrt(42) + 1i/sqrt(42);   

            % 001100
            case 12
                vSymb(inxSymb) = 5/sqrt(42) + 5i/sqrt(42);   

            % 001101
            case 13
                vSymb(inxSymb) = 5/sqrt(42) + 7i/sqrt(42);   

            % 001110
            case 14
                vSymb(inxSymb) = 7/sqrt(42) + 5i/sqrt(42);   

            % 001111
            case 15
                vSymb(inxSymb) = 7/sqrt(42) + 7i/sqrt(42);   
                
            % 010000
            case 16
                vSymb(inxSymb) = 3/sqrt(42) - 3i/sqrt(42);
                
            % 010001
            case 17                
                vSymb(inxSymb) = 3/sqrt(42) - 1i/sqrt(42);
                
            % 010010
            case 18                
                vSymb(inxSymb) = 1/sqrt(42) - 3i/sqrt(42);
                
            % 010011
            case 19
                vSymb(inxSymb) = 1/sqrt(42) - 1i/sqrt(42);   
                
            % 010100
            case 20
                vSymb(inxSymb) = 3/sqrt(42) - 5i/sqrt(42);   
                
            % 010101
            case 21
                vSymb(inxSymb) = 3/sqrt(42) - 7i/sqrt(42);   
                
            % 010110
            case 22
                vSymb(inxSymb) = 1/sqrt(42) - 5i/sqrt(42);   
                
            % 010111
            case 23
                vSymb(inxSymb) = 1/sqrt(42) - 7i/sqrt(42);   

            % 011000
            case 24
                vSymb(inxSymb) = 5/sqrt(42) - 3i/sqrt(42);   

            % 011001
            case 25
                vSymb(inxSymb) = 5/sqrt(42) - 1i/sqrt(42);   
                
            % 011010
            case 26
                vSymb(inxSymb) = 7/sqrt(42) - 3i/sqrt(42);   

            % 011011                
            case 27
                vSymb(inxSymb) = 7/sqrt(42) - 1i/sqrt(42);   
                
            % 011100
            case 28
                vSymb(inxSymb) = 5/sqrt(42) - 5i/sqrt(42);   
                
            % 011101
            case 29
                vSymb(inxSymb) = 5/sqrt(42) - 7i/sqrt(42);   

            % 011110
            case 30
                vSymb(inxSymb) = 7/sqrt(42) - 5i/sqrt(42);   
                
            % 011111
            case 31
                vSymb(inxSymb) = 7/sqrt(42) - 7i/sqrt(42);                 

            % 100000
            case 32
                vSymb(inxSymb) = -3/sqrt(42) + 3i/sqrt(42);
                
            % 100001
            case 33               
                vSymb(inxSymb) = -3/sqrt(42) + 1i/sqrt(42);
                
            % 100010
            case 34               
                vSymb(inxSymb) = -1/sqrt(42) + 3i/sqrt(42);
                
            % 100011
            case 35
                vSymb(inxSymb) = -1/sqrt(42) + 1i/sqrt(42);   
                
            % 100100
            case 36
                vSymb(inxSymb) = -3/sqrt(42) + 5i/sqrt(42);   

            % 100101
            case 37
                vSymb(inxSymb) = -3/sqrt(42) + 7i/sqrt(42);   
                
            % 100110
            case 38
                vSymb(inxSymb) = -1/sqrt(42) + 5i/sqrt(42);   
                
            % 100111
            case 39
                vSymb(inxSymb) = -1/sqrt(42) + 7i/sqrt(42);   
                
            % 101000                
            case 40
                vSymb(inxSymb) = -5/sqrt(42) + 3i/sqrt(42);   
                
            % 101001                
            case 41
                vSymb(inxSymb) = -5/sqrt(42) + 1i/sqrt(42);   
                
            % 101010                                
            case 42
                vSymb(inxSymb) = -7/sqrt(42) + 3i/sqrt(42);   
                
            % 101011                
            case 43
                vSymb(inxSymb) = -7/sqrt(42) + 1i/sqrt(42);   
                
            % 101100                                
            case 44
                vSymb(inxSymb) = -5/sqrt(42) + 5i/sqrt(42);   
                
            % 101101                                                
            case 45
                vSymb(inxSymb) = -5/sqrt(42) + 7i/sqrt(42);   
                
            % 101110
            case 46
                vSymb(inxSymb) = -7/sqrt(42) + 5i/sqrt(42);   
                
            % 101111                
            case 47
                vSymb(inxSymb) = -7/sqrt(42) + 7i/sqrt(42);   
                
            % 110000
            case 48
                vSymb(inxSymb) = -3/sqrt(42) - 3i/sqrt(42);
                
            % 110001
            case 49                
                vSymb(inxSymb) = -3/sqrt(42) - 1i/sqrt(42);
                
            % 110010                
            case 50                
                vSymb(inxSymb) = -1/sqrt(42) + 3i/sqrt(42);

            % 110011                
            case 51
                vSymb(inxSymb) = -1/sqrt(42) + 1i/sqrt(42);   

            % 110100                                
            case 52
                vSymb(inxSymb) = -5/sqrt(42) - 3i/sqrt(42);   

            % 110101                                                
            case 53
                vSymb(inxSymb) = -3/sqrt(42) - 7i/sqrt(42);   

            % 110110                 
            case 54
                vSymb(inxSymb) = -1/sqrt(42) - 5i/sqrt(42);   
                
            % 110111                                 
            case 55
                vSymb(inxSymb) = -1/sqrt(42) - 7i/sqrt(42);   

            % 111000                                                 
            case 56
                vSymb(inxSymb) = -5/sqrt(42) - 3i/sqrt(42);   

            % 111001                 
            case 57
                vSymb(inxSymb) = -5/sqrt(42) - 1i/sqrt(42);   

            % 111010                
            case 58
                vSymb(inxSymb) = -7/sqrt(42) - 3i/sqrt(42);   

            % 111011
            case 59
                vSymb(inxSymb) = -7/sqrt(42) - 1i/sqrt(42);   
                
            % 111100                
            case 60
                vSymb(inxSymb) = -5/sqrt(42) - 5i/sqrt(42);   

            % 111101                
            case 61
                vSymb(inxSymb) = -5/sqrt(42) - 7i/sqrt(42);   

            % 111110                
            case 62
                vSymb(inxSymb) = -7/sqrt(42) - 5i/sqrt(42);   

            % 111111                
            case 63
                vSymb(inxSymb) = 7/sqrt(42) - 7i/sqrt(42);                 
        end
    end
end
