%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AddSSS: THE "ALGaE" PACKAGE - SSS SIGNAL GENERATOR AND MAPPER
%
% This function generates the Secondary Synchronization Signal and map it
% to the resource elements.
%
% File version 1.0 (14th July 2011)
%
%% ------------------------------------------------------------------------
% Inputs (7):
%       1. mTF:         Time/frequency matrix with resource elements.
%
%       2. mSCMap:      Signals and channels mapping matrix.
%
%       3. mModMap:     Modulation mapping matrix.
%
%
%       4. sF:          Structure with the bandwidth (frequency) configuration.
%
%       5. sT:          Structure with the time configuration.
%
%       6. sP:          Structure with the LTE-specific parameters
%
%
%       7. hRepFil:     Handle to the report file.
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

function [ mTF mSCMap mModMap ] = AddSSS(mTF, mSCMap, mModMap, sF, sT, sP, hRepFil)


    %% SSS signal added according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.2 (Secondary synchronization signal)     
    % 

            
    %% GENERATE THE PSS SIGNAL
    %
    % Signal generated according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.2.1 (Sequence generation)     
    %         

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE-SPECIFIC PARAMETERS STRUCTURE
    % 
    % (structure: 'sP'): 
    
        % First number of a physical-layer cell identity
        N_id1       = sP.N_id1;                
        
        % Second number of a physical-layer cell identity
        N_id2       = sP.N_id2;
        
                
    %----------------------------------------------------------        
    
    % -------------------------------------------------
    % Calculate the m_0 and m_1 coefficients
    
    q_ = floor(N_id1/30);                       % Calculate q_ (q' in documentation)
    
    q = floor( (N_id1 + q_*(q_+1)*0.5) / 30);   % Calculate q 
    
    m_ = N_id1 + q*(q+1)/2;                     % Calculate m_ (m' in documentation)
        
    
    m0 = mod(m_,31);                           % Calculate m0
    
    m1 = mod(m0 + floor(m_/31) + 1,31);        % Calculate m1 



    % -------------------------------------------------
    % Calculate the s_0(n) and s_1(n) vectors:

    % - - - - - - - - - - - -
    % Calculate x(i) vector:
    
    vx = zeros(31,1);               % Allocate the vector
    
    vx(1) = 0;                      % The first 5 elements of the x 
    vx(2) = 0;                      % vector are given
    vx(3) = 0;                      %
    vx(4) = 0;                      %
    vx(5) = 1;                      %
    
    for i_ = 1:26                   %   The next 26 elements must be calculated
        vx(i_+5) = mod(vx(i_+2)+vx(i_),2);        
    end


    % - - - - - - - - - - - -
    % Calculate s_(i) vector: (s tilda in documentation)
    vs_ = 1 - 2*vx;


    % - - - - - - - - - - - -
    % Calculate the s_0
    vs_0 = zeros(32,1);
    for n=0:31
        s_position = mod(n+m0,31);        
        vs_0(n+1) = vs_(s_position+1);
    end
    
    
    % - - - - - - - - - - - -
    % Calculate the s_1
    vs_1 = zeros(32,1);
    for n=0:31
        s_position = mod(n+m1,31);        
        vs_1(n+1) = vs_(s_position+1);
    end
    
    % -------------------------------------------------

    
    
    % -------------------------------------------------
    % Calculate the c_0(n) and c_1(n) vectors:
    
    % - - - - - - - - - - - -
    % Calculate x(i) vector:
    
    vx = zeros(31,1);               % Allocate the vector
    
    vx(1) = 0;                      % The first 5 elementes of the x
    vx(2) = 0;                      % vector are given
    vx(3) = 0;                      %
    vx(4) = 0;                      %
    vx(5) = 1;                      %
    
    for i_ = 1:26                   %   The next 26 elements must be calculated
        vx(i_+5) = mod(vx(i_+3)+vx(i_),2);        
    end
    
    
    % - - - - - - - - - - - -
    % Calculate c_(i) vector: (c tilda in documentation)
    vc_ = 1 - 2*vx;    
    

    % - - - - - - - - - - - -
    % Calculate the c_0 vector
    vc_0 = zeros(32,1);
    for n=0:31
        c_position = mod(n+N_id2,31);
        vc_0(n+1) = vc_(c_position+1);
    end
    
    
    % - - - - - - - - - - - -
    % Calculate the c_1 vector
    vc_1 = zeros(32,1);
    for n=0:31
        c_position = mod(n+N_id2,31);
        vc_1(n+1) = vc_(c_position+1);        
    end    
    
    % -------------------------------------------------
    

    
    % -------------------------------------------------
    % Calculate the z_1(n) vector:

    % - - - - - - - - - - - -
    % Calculate x(i) vector:
    
    vx = zeros(31,1);               % Allocate the vector
    
    vx(1) = 0;                      % The first 5 elementes of the x
    vx(2) = 0;                      % vector are given
    vx(3) = 0;                      %
    vx(4) = 0;                      %
    vx(5) = 1;                      %
    
    for i_ = 1:26                   %   The next 26 elements must be calculated
        vx(i_+5) = mod(vx(i_+4)+vx(i_+2)+vx(i_+1)+vx(i_),2);        
    end    
        
    % - - - - - - - - - - - -
    % Calculate z_(i) vector: (z tilda in documentation)
    vz_ = 1 - 2*vx;    
    
    % - - - - - - - - - - - -
    % Calculate the z_1m0 vector
    vz_1m0 = zeros(32,1);
    for n=0:31
        z_position = mod(n+mod(m0,8),31);        
        vz_1m0(n+1) = vz_(z_position+1);
    end
    
    
    % - - - - - - - - - - - -
    % Calculate the z_1m1 vector
    vz_1m1 = zeros(32,1);
    for n=0:31
        z_position = mod(n+mod(m1,8),31);
        vz_1m1(n+1) = vz_(z_position+1);        
    end

    % -------------------------------------------------
    
    
    % -------------------------------------------------
    % Calculate the d vector with SSS sequence for a Radio Slot 0:
    vd_RS0 = zeros(62,1);
    for n=0:30
        
        % Even element
        d_position = 2*n;
        vd_RS0(d_position+1) = vs_0(n+1)*vc_0(n+1);
        
        % Odd element
        d_position = 2*n + 1;
        vd_RS0(d_position+1) = vs_1(n+1)*vc_1(n+1)*vz_1m0(n+1);
    end
    
    % -------------------------------------------------
    % Calculate the d vector with SSS sequence for a Radio Slot 10:
    vd_RS10 = zeros(62,1);
    for n=0:30
        
        % Even element
        d_position = 2*n;        
        vd_RS10(d_position+1) = vs_1(n+1)*vc_0(n+1);
        
        % Odd element
        d_position = 2*n + 1;
        vd_RS10(d_position+1) = vs_0(n+1)*vc_1(n+1)*vz_1m1(n+1);
    end

   
    %% MAPPING OF THE PSS SIGNAL TO THE RESOURCES ELEMENTS
    %
    % Signal mapped according to:
    % Source: 3GPP TS 36.211 (Physical channels and modulation)
    %         Chapter 6.11.2.2 (Mapping to resource elements)
    %

    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE BANDWIDTH PARAMETERS STRUCTURE     
    % AND THE TIME PARAMETERS STRUCTURE
    %
    % (structures: 'sF', 'sT'): 

        % The number of subcarriers in the current bandwidth
        N_scB       = sF.N_scB;
        
        % - - - - - - - - - - - - - - - - - - -
        
        % The number of symbols in a Radio Slot
        N_symbDL    = sT.N_symbDL;        
        
        % The number of symbols in a Radio Frame
        N_symbRF    = sT.N_symbRF;
        
        % The number of symbols in a subframe
        N_symbSF    = sT.N_symbSF;
        
        % The number of Subframes in the transmission
        N_SF        = sT.N_SF;
        
        % The index of the first subframe in the transmission
        FIRST_SF    = sT.FIRST_SF;        
        
    %----------------------------------------------------------        
    
    
    % -------------------------------------------------
    % Calculate the frequency position: (k vector in the documentation)
    vn = 0:61;
    vk = vn - 31 + N_scB/2;


    %----------------------------------------------------------                 
    % Calculate the number of subframes in one Radio Frame
    N_SFRF = N_symbRF / N_symbSF;
    
    % Count symbols with SSS signals
    nSSSymb_0  = 0;
    nSSSymb_10 = 0;
    
    for inxSF=FIRST_SF:(FIRST_SF+N_SF-1)
        
    	% Calculate index of the current subframe in a Radio Frame
        inxSFRF = rem(inxSF,N_SFRF);

        
        % The subframe with index 0 
        if inxSFRF == 0
            nSSSymb_0 = nSSSymb_0 + 1;
        end     
        
        % The subframe with index 5
        if inxSFRF == 5
            nSSSymb_10 = nSSSymb_10 + 1;
        end     
    end        
    
    % Allocate the vector for indices of OFDM symbol with SSS signal
    vl_0 = zeros(nSSSymb_0,1);    
    vl_10 = zeros(nSSSymb_10,1);    
    
    %--------------------------------------------------
    
            
    % -------------------------------------------------
    % Calculate the time position for radio slots 0 and 10 in the Radio Frames: (l vector in the documentation)

    % Loop over all Subframes
    inxSymb_0 = 1;    % Reset the indices of symbols with SSS signals in a Radio Slot 0
    inxSymb_10 = 1;   % Reset the indices of symbols with SSS signals in a Radio Slot 10
    
    inxSub = 1;     % Reset the subcarriers counter
    for inxSF=FIRST_SF:(FIRST_SF+N_SF-1)

        % Calculate index of the current subframe in a Radio Frame
        inxSFRF = rem(inxSF,N_SFRF);
                
        % The last but one OFDM symbol in a Radio Slot number 0  (first Radio Slot in a Radio Frame)
        if inxSFRF == 0                        
            vl_0(inxSymb_0)   = (inxSub-1)*N_symbSF + N_symbDL - 1;
            inxSymb_0 = inxSymb_0 + 1;
        end
        
        % The last but one OFDM symbol in a Radio Slot number 10 (11th Radio Slot in Radio Frame)
        if inxSFRF == 5            
            vl_10(inxSymb_10)   = (inxSub-1)*N_symbSF + N_symbDL - 1;
            inxSymb_10 = inxSymb_10 + 1;
        end        
        inxSub = inxSub + 1;
    end    

    %% ADD THE SSS SIGNAL TO THE RESOURCE ELEMENTS
    
    % Add the SSS signal into the time/frequency resource matrix
    % (Radio Slot 0 in the Radio Frame)
    mTF(vk+1,vl_0) = repmat(vd_RS0,1,nSSSymb_0);
    
    % Add the SSS signal into the time/frequency resource matrix
    % (Radio Slot 10 in the Radio Frame)
    mTF(vk+1,vl_10) = repmat(vd_RS10,1,nSSSymb_10);
        
    % Indicate the SSS into the Signals/Channels map
    mSCMap(vk+1,vl_0) = {'SSS'};
    mSCMap(vk+1,vl_10) = {'SSS'};
    
    % Indicate the BPSK modulation in the modulation map
    mModMap(vk+1,vl_0) = {'BPSK'};    
    mModMap(vk+1,vl_10) = {'BPSK'};  
    
   
    %% REPORT TO THE FILE, IF NEEDED
    if hRepFil ~= -1

        % HEADER:
        strMessage = sprintf('SECONDARY SYNCHRONIZATION SIGNAL MAPPER: \n');
        
        % Print out the SSS for a Radio Slot 0
        strMessage = sprintf('%sThe SSS signal in the Radio Slot 0: \n',strMessage);
        for inxZF=1:62
            strMessage = sprintf('%s %.6f + %.6fj\n',strMessage,real(vd_RS0(inxZF)),imag(vd_RS0(inxZF)));
        end
        strMessage = sprintf('%s\n',strMessage);

        % Print out the SSS for a Radio Slot 10
        strMessage = sprintf('%sThe SSS signal in the Radio Slot 10: \n',strMessage);
        for inxZF=1:62
            strMessage = sprintf('%s %.6f + %.6fj\n',strMessage,real(vd_RS10(inxZF)),imag(vd_RS10(inxZF)));
        end
        strMessage = sprintf('%s\n',strMessage);                        
        
        strMessage = sprintf('%s---------------------------------------------------\n\n\n',strMessage);
        
        % Dump the message to the file
        fprintf(hRepFil,strMessage);
    end    
end




