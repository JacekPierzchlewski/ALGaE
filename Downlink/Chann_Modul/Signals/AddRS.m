%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddRS: THE "ALGaE" PACKAGE - CELL SPECIFIC REFERENCE SIGNALS GENERATOR
%                              AND MAPPER
%
% This function generates the Cell-Specific Reference Signals and map it 
% the resource elements.
%
% File version 1.0 (14th July 2011)
%
%% ------------------------------------------------------------------------
% Inputs (7):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%
%       4. sLTE_stand:  Structure with the LTE standard structure.
%
%
%       5. sF:          Structure with the bandwidth (frequency) configuration.
%
%       6. sT:          Structure with the time configuration.
%
%       7. sP:          Structure with the LTE-specific parameters
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
function [ mTF mSCMap mModMap ] = AddRS(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP)


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE FREQUENCY PARAMETERS STRUCTURE
    % 
    % (structure: 'sF'): 
    
        % The current number of antenna ports
        nAnt       = sF.nAnt;                
        
    %----------------------------------------------------------   
    for iAnt_port = 0:(nAnt-1)

        % Switch to the correct mapping function
        switch(iAnt_port)

            % Port 0
            case 0
                [ mTF mSCMap mModMap ] = AddRS_port0(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP);
            
            % The port number if not supported    
            otherwise
                error('Higher Antenna Ports are not supported!');
        end
    end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% I N T E R N A L   F U N C T I O N S
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INTERNAL FUNCTION: Map RS to antenna port # 0
%   
%   Function maps Cell specific Reference Signals for Antenna Port 0
%   
% Inputs (7):
%
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%
%       4. sLTE_stand:  Structure with the LTE standard structure.
%
%
%       5. sF:          Structure with the bandwidth (frequency) configuration.
%
%       6. sT:          Structure with the time configuration.
%
%       7. sP:          Structure with the LTE-specific parameters
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
function [ mTF mSCMap mModMap ] = AddRS_port0(mTF, mSCMap, mModMap, sLTE_stand, sF, sT, sP)

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME PARAMETERS STRUCTURE
    % AND THE FREQUENCY PARAMETERS STRUCTURE
    %
    % (structure: 'sT', 'sF'): 
    
        % The number of  Subframes
        N_SF       = sT.N_SF;                
        
        % The number of symbols in a Subframe
        N_symbSF  = sT.N_symbSF;
        
        % The number of symbols in a Radio Slot
        N_symbDL  = sT.N_symbDL;
        
        % - - - - - - - - - - - - - - - - - - - - 
        
        % The number of resource blocks in the bandwidth
        N_rb      = sF.N_rb;
        
    %----------------------------------------------------------   

    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS 
    % STRUCUTRE
    %
    % (structure: 'sP'): 
    
        % The first physical layer identity group number 
        N_id1       = sP.N_id1;
        
        % The second physical layer identity group number 
        N_id2       = sP.N_id2;
        
    %----------------------------------------------------------   
    
    
    %% GENERATE THE C VECTOR WHICH IS USED TO CREATE RS SIGNAL
    %
    % Signal generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.10.1.1 (Sequence generation) 
    %
    
    % Generate the matrix with a c vectors for all symbols in the Radio
    % Frame
    %
    % Rows      - 400 (the number of elements in the c vector)
    % Columns   - 40 (2 symbols in every Radio Slot, 20 Radio Slots in a Radio Frame)
    
    mC = zeros(400,40);     % Allocate the matrix with Reference Signals
    
    iN_id = 3*N_id1 + N_id2;    % Calculate the N^cell_ID
    
    % Calculate the N_cp parameter
    if N_symbDL == 7
        iNcp = 1; % The normal CP 
    else
        iNcp = 0; % The extended CP
    end
    
    
    % Generate RS signals for all symbols in a Radio Frame
    % (Loop over all Radio Slots)
    for inxRS=0:19
        
        % First symbol with a RS in a Radio Frame
        il = 0;
        
        % Calculate the iC_init
        iC_init= 2^10 * (7*(inxRS + 1) + il + 1) * (2*iN_id + 1) + 2*iN_id + iNcp;
        
        % Generate the c sequence
        mC(:,2*inxRS+1) = genPseudRand_C(iC_init,400)';

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        % Second symbol with a RS in a Radio Frame
        il = N_symbDL - 3;
        
        % Calculate the iC_init
        iC_init= 2^10 * (7*(inxRS + 1) + il + 1) * (2*iN_id + 1) + 2*iN_id + iNcp;
        
        % Generate the c sequence
        mC(:,2*inxRS+2) = genPseudRand_C(iC_init,400)';
        
    end

    %----------------------------------------------------------   

    
    %% MAPPING OF THE RS SIGNAL TO THE RESOURCES ELEMENTS
    %
    % Signal mapped according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.10.1.2 (Mapping to resource elements)
    %
    
    
    % Calculate the iNi_shift
    iNi_shift = mod(iN_id,6);
    
    % Get the maximum configuration of the bandwidth
    % (in resource blocks)
    N_rb_max = sLTE_stand.vN_rb(end);

    
    % Calculate the number of Radio Slots in a subframe
    N_RSSF = N_symbSF/N_symbDL;
    
    
    % The loop over all subframes
    for inxSF=1:N_SF
        
        % Loop over all Radio Slots in a subframe
        for inxRS=1:N_RSSF
           
            % Calculate the index of the current Radio Slot in the
            % transmission
            inxRS_TR = (inxSF-1)*N_RSSF + inxRS;
            
            % -------------------------------------------------------------------
            % FIRST SYMBOL IN RADIO SLOT WITH A REFERENCE SIGNAL:
            
            % Index of the first symbol in the Radio Slot
            % (index in the whole transmission)
            inxSym = (inxRS_TR-1)*N_symbDL + 1;
            
            % Calculate the vector with a frequency position
            iNi = 0;
            vm = (0:2*N_rb-1)';
            vk = 6*vm + mod(iNi+iNi_shift,6);
            
            % Get the current vector c
            vc = mC(:,2*inxRS-1);
            
            % Calculate the indices of the c vector (vc) calculated above
            % which will be used to construct the Reference Signal
            vm_ = vm + N_rb_max - N_rb;
            
            % Loop over all subcarriers with a Reference Signals in this symbol            
            for inxRefSig=1:size(vm_,1)
                
                % Calculate the current value of the Reference Signal
                % Resource Element
                iRF =    1/sqrt(2)*(1-2*vc(2*vm_(inxRefSig)+1))   + ...  % Real part
                      1i*1/sqrt(2)*(1-2*vc(2*vm_(inxRefSig)+2));         % Imaginary part
                
                % Put this reference signal into the time/frequency matrix  
                mTF(vk(inxRefSig)+1,inxSym) = iRF;
            end
            
            
            % Mark the signal in the Signals and Channels matrix
            mSCMap(vk+1,inxSym) = {'RS'};
            
            % Mark the modulation
            mModMap(vk+1,inxSym) = {'QPSK'};


            % -------------------------------------------------------------------
            % SECOND SYMBOL IN RADIO SLOT WITH A REFERENCE SIGNAL:
            
            % Index of the second symbol in the Radio Slot
            % (index in the whole transmission)
            inxSym = (inxRS_TR-1)*N_symbDL + N_symbDL - 2;

            
            % Calculate the vector with a frequency position
            iNi = 3;                            % ni parameter which is different in the second symbol            
            vk = 6*vm + mod(iNi+iNi_shift,6);    

            % Get the current vector c
            vc = mC(:,2*inxRS-1);        

            % Calculate the indices of the c vector (vc) calculated above
            % which will be used to construct the Reference Signal
            vm_ = vm + N_rb_max - N_rb;
            
            % Loop over all subcarriers with a Reference Signals in this symbol
            for inxRefSig=1:size(vm_,1)
                
                % Calculate the current value of the Reference Signal
                % Resource Element
                iRF =    1/sqrt(2)*(1-2*vc(2*vm_(inxRefSig)+1))   + ...  % Real part
                      1i*1/sqrt(2)*(1-2*vc(2*vm_(inxRefSig)+2));       % Imaginary part
                
                % Put this reference signal into the time/frequency matrix
                mTF(vk(inxRefSig)+1,inxSym) = iRF;
            end
            
            % Mark the signal in the Signals and Channels matrix
            mSCMap(vk+1,inxSym) = {'RS'};

            % Mark the modulation
            mModMap(vk+1,inxSym) = {'QPSK'};
            
            % - - - - - - - - - - - - - - - - - 
        end        
    end    
end


