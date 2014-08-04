%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chc_Scen_Main: THE "ALGaE" PACKAGE - CHECK A FILE WITH LTE DOWNLINK
%                                      SCENARIO STRUCTURE  
%
%                                      MODULE: Main module
%
%
% This function checks if the LTE structure is OK. In a case of bad
% scenario structure function adds the 'bError' field to the structure.
% 
% This function checks the General parameters for the LTE transmission.
%
% The function checks the following parameters, (fields names of the 
% LTE scenario structure are given in brackets):
%
%
% File version 1.0 (14th October 2011)
%  
%
% %-----------------------------------------------------------------------------
% 
% LTE general parameters:
%
%
%                           - 1. The RNTI number
%
%                                   - if the RNTI field exist
%
%                                   - if the RNTI is a numeric
%                                     variable                                   
%
%                                   - if the RNTI is an integer variable
%
%                                   - if the RNTI is bigger than zero
%
%                           
%                           - 2. LTE Downlink Transmission Scheme 
%
%                                   - if the TRANS_SCHEME field exist
%
%                                   - if the TRANS_SCHEME is a string
%                                     variable
%
%                                   - if the TRANS_SCHEME is supported by
%                                     the current version of the software
%
%
%                           - 3. LTE bandwidth (BANDWIDTH)
%
%                              Function checks if: 
%
%                                   - if the BANDWIDTH field exists
%                                   
%                                   - if the BANDWIDTH is a string variable
%
%                                   - if value of the BANDWIDTH is correct
%                                     according to the LTE standard
%                   
%
%                           - 4. Cyclic Prefix type 
%                                (CYCLIC_PRFX)
%
%                              Function checks if: 
%
%                                   - if the CYCLIC_PRFX field exists
%                                   
%                                   - if the CYCLIC_PRFX is a string variable
%
%                                   - if value of the CYCLIC_PRFX is correct
%                                     according to the LTE standard
%
% 
%                           - 5. Physical-layer cell identity, first number
%                                (N_ID1)
%
%                              Function checks if: 
%
%                                   - if the N_ID1 field exists
%                                   
%                                   - if the N_ID1 is a numeric variable
%
%                                   - if the N_ID1 is an integer
%
%                                   - if value of the N_ID1 is correct
%                                     according to the LTE standard
%
%                           - 6. Physical-layer cell identity, second number
%                                (N_ID2)
%
%                              Function checks if: 
%
%                                   - if the N_ID2 field exists
%                                   
%                                   - if the N_ID2 is a numeric variable
%
%                                   - if the N_ID2 is an integer
%
%                                   - if value of the N_ID2 is correct
%                                     according to the LTE standard
%
%
% %-----------------------------------------------------------------------------
%
% LTE general time parameters:
%
%                           - 7. the number of subframes to be transmitted (N_SF)                               
%
%                              Function checks if: 
%
%                                   - if the N_SF field exists
%                                   
%                                   - if the N_SF is a numeric variable
%
%                                   - if the N_SF is an integer
%
%                                   - if value of the N_SF is equal or
%                                     higher than 1
%
%
%                           - 8. index of the first transmitted subframe 
%                                in a Radio Frame (FIRST_SF)
%
%                              Function checks if: 
%
%                                   - if the FIRST_SF field exists
%                                   
%                                   - if the FIRST_SF is a numeric variable
%
%                                   - if the FIRST_SF is an integer
%
%                                   - if value of the FIRST_SF is equal or
%                                     higher than 1
%
%
%% ------------------------------------------------------------------------
%
% Inputs (1):
%
%       1. sScen:     String with the LTE scenario file name.
%
% ------------------------------------------------------------------------
%
% Outputs (2):
%
%       1. sScen:       Structure with LTE scenario readed from the given file. 
%                       ( in case of the error, 'sScen' structure has an 'bError' field)
%
%       2. strErr:      String with the error message (empty in a case of OK). 
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

function [ sScen strErr ] = chc_Scen_Main(sScen)


   % RESET THE ERROR 
    strErr = ' ';
    
    % -----------------------------------------------------
    
    % READ THE LTE STANDARD FILE    
    sLTE_stand = LTE_stand();
    

    %% CHECK IF 'sScen' IS A STRUCTURE
    if ~isstruct(sScen)
        strErr = 'It does not look like a LTE scenario!';
        clear sScen;
        sScen.bError = 1;
        return;
    end
    
    % -----------------------------------------------------

    %% LTE general parameters: RNTI (The RNTI ident. number)
    
    % CHECK IF THE RNTI IDENT. NUMBER IS SPECIFIED IN THE LTE STRUCTURE ('RNTI' field)
    if ~isfield(sScen,'RNTI')
        strErr = 'The RNTI ident, number (RNTI) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end
    
    % GET THE RNTI NUMBER
    RNTI = sScen.RNTI;
    
    % CHECK IF THE RNTI IDENT. NUMBER IS NUMERIC
    if ~isnumeric(RNTI)
        strErr = 'The RNTI ident, number (RNTI) must be a numeric value!';
        sScen.bError = 1;
        return;
    end
    
    % CHECK IF THE RNTI IDENT. NUMBER IS AN INTEGER
    RNTI_old = RNTI;
    RNTI = round(RNTI);    
    if abs(RNTI - RNTI_old) > 0
        strErr = 'The RNTI ident. number (RNTI) must be an integer!';
        sScen.bError = 1;
        return;    
    end

    % CHECK IF THE RNTI IDENT. NUMBER IS EQUAL OR BIGGER THAN 0
    if RNTI < 0
        strErr = 'The RNTI ident. number (RNTI) must be an integer equal to or bigger than 0!';
        sScen.bError = 1;
        return;    
    end

    
    %% LTE general parameters: TRANS_SCHEME (transmission scheme)
    
    % CHECK IF TRANS_SCHEME IS SPECIFIED IN THE LTE STRUCTURE ('TRANS_SCHEME' field)
    if ~isfield(sScen,'TRANS_SCHEME')
        strErr = 'The transmission scheme (TRANS_SCHEME) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end

    % CHECK IF THE TRANS_SCHEME IS A STRING
    if ~ischar(sScen.TRANS_SCHEME)
        strErr = 'The transmission scheme type (TRANS_SCHEME) must be a string!';
        sScen.bError = 1;
        return;
    end

    % CHECK IF THE TRANS_SCHEME HAS A CORRECT VALUE            
    
    % Get the supported transmission scheme
    cvSuppLTS = sLTE_stand.cvSuppLTS;        

    % Check if the transmission scheme value is supported
    if isempty(strcmp(cvSuppLTS,sScen.TRANS_SCHEME))
        strErr = 'The transmission scheme type (TRANS_SCHEME) is not supported!';
        sScen.bError = 1;
        return;
    end


    %% LTE general parameters: BANDWIDTH
    
    % CHECK IF BANDWIDTH IS SPECIFIED IN THE LTE STRUCTURE ('BANDWIDTH' field)
    if ~isfield(sScen,'BANDWIDTH')
        strErr = 'The bandwidth type (BANDWIDTH) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end

    % CHECK IF THE BANDWIDTH IS A STRING
    if ~ischar(sScen.BANDWIDTH)
        strErr = 'The bandwidth type (BANDWIDTH) must be a string!';
        sScen.bError = 1;
        return;
    end
        
    % CHECK IF THE BANDWIDTH HAS a CORRECT VALUE            
    
    % Get the supported bandwidths
    cvBW_channel = sLTE_stand.cvBW_channel;        
    
    % Check the bandwidth value
    if isempty(strcmp(cvBW_channel,sScen.BANDWIDTH))
        strErr = 'The bandwidth type (BANDWIDTH) is not supported!';
        sScen.bError = 1;
        return;
    end
    
    
    % -----------------------------------------------------    

    %% LTE general parameters: CYCLIC PREFIX
    
    % CHECK IF CYCLIC PREFIX TYPE IS SPECIFIED IN THE LTE STRUCTURE ('CYCLIC_PRFX' field)
    if ~isfield(sScen,'CYCLIC_PRFX')
        strErr = 'The Cyclic Prefix type (CYCLIC_PRFX) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end
    
    
    % CHECK IF THE CYCLIC_PRFX IS A STRING
    if ~ischar(sScen.CYCLIC_PRFX)
        strErr = 'The Cyclic Prefix type (CYCLIC_PRFX) must be a string!';
        sScen.bError = 1;
        return;
    end
        
    % CHECK IF THE CYCLIC_PRFX HAS a CORRECT VALUE            
    
    % Get the supported Cyclic Prefixes
    cvCP = sLTE_stand.cvCP;        
    
    % Check the Cyclic Prefix value
    if isempty(strcmp(cvCP,sScen.CYCLIC_PRFX))
        strErr = 'The Cyclic Prefix type (CYCLIC_PRFX) is not supported!';
        sScen.bError = 1;
        return;
    end
        
    % -----------------------------------------------------    
    
    
    %% LTE general parameters: CELL IDENTITY NUMBER 1
     
    % CHECK IF PHYSICAL LAYER CELL IDENTITY NUMBER 1 IS SPECIFIED IN THE LTE STRUCTURE ('N_ID1' field)
    if ~isfield(sScen,'N_ID1')
        strErr = 'The N_ID1 number is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end
    
    % CHECK IF THIS VALUE IS A NUMERIC VALUE
    if ~isnumeric(sScen.N_ID1)
        strErr = 'The N_ID1 number must be a numeric value!';
        sScen.bError = 1;
        return;        
    end


    % CHECK IF THIS VALUE IS AN INTEGER
    N_ID1_old = sScen.N_ID1;
    N_ID1 = round(sScen.N_ID1);
    
    if abs(N_ID1 - N_ID1_old) > 0
        strErr = 'The N_ID1 number must be an integer!';
        sScen.bError = 1;
        return;        
    end    


    % CHECK IF THE PHYSICAL LAYER CELL IDENTITY NUMBER 1 HAS a CORRECT VALUE
    
    % Get the minimum value of the N_ID1
    N_id1_min = sLTE_stand.N_id1_min;      
    
    % Get the maximum value of the N_ID1
    N_id1_max = sLTE_stand.N_id1_max;          
    
    % Check the value
    if (N_ID1 > N_id1_max || N_ID1 < N_id1_min)
        strErr = 'The N_ID1 number has an incorrect value!';
        sScen.bError = 1;
        return;
    end
        
    % -----------------------------------------------------    
    
    %% LTE general parameters: CELL IDENTITY NUMBER2
    
    % CHECK IF PHYSICAL LAYER CELL IDENTITY NUMBER2 IS SPECIFIED IN THE LTE STRUCTURE ('N_ID2' field)
    if ~isfield(sScen,'N_ID2')
        strErr = 'The N_ID2 number is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end
        
   % CHECK IF THIS VALUE IS A NUMERIC VALUE
    if ~isnumeric(sScen.N_ID2)
        strErr = 'The N_ID2 number must be a numeric value!';
        sScen.bError = 1;
        return;        
    end


    % CHECK IF THIS VALUE IS AN INTEGER
    N_ID2_old = sScen.N_ID2;
    N_ID2 = round(sScen.N_ID2);
    
    if abs(N_ID2 - N_ID2_old) > 0
        strErr = 'The N_ID2 number must be an integer!';
        sScen.bError = 1;
        return;        
    end    


    % CHECK IF THE PHYSICAL LAYER CELL IDENTITY NUMBER 1 HAS a CORRECT VALUE
    
    % Get the minimum value of the N_ID2
    N_id2_min = sLTE_stand.N_id2_min;      
    
    % Get the maximum value of the N_ID2
    N_id2_max = sLTE_stand.N_id2_max;          
    
    % Check the value
    if (N_ID2 > N_id2_max || N_ID2 < N_id2_min)
        strErr = 'The N_ID2 number has an incorrect value!';
        sScen.bError = 1;
        return;
    end    
        
    % -----------------------------------------------------    
  
    
    %% LTE time parameters: THE NUMBER OF SUBFRAMES TO BE GENERATED
        
    % CHECK IF THE NUMBER OF SUBFRAMES IS SPECIFIED IN THE LTE STRUCTURE ('N_SF' field) 
    if ~isfield(sScen,'N_SF')
        strErr = 'The number of Subframes (N_SF) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end    
    
    % CHECK IF THIS VALUE IS A NUMERIC VALUE
    if ~isnumeric(sScen.N_SF)
        strErr = 'The number of Subframes (N_SF) must be a numeric value!';
        sScen.bError = 1;
        return;        
    end
    
    % CHECK IF THIS VALUE IS AN INTEGER
    N_SF_old = sScen.N_SF;
    N_SF = round(sScen.N_SF);
    
    if abs(N_SF - N_SF_old) > 0
        strErr = 'The number of Subframes (N_SF) must be an integer!';
        sScen.bError = 1;
        return;        
    end
    
    % CHECK IF THIS VALUE IS BIGGER or EQ. TO 1
    if N_SF < 1
        strErr = 'The number of Subframes (N_SF) must be higher or equal to 1!';
        sScen.bError = 1;
        return;        
    end
    
    % -----------------------------------------------------      
    
    %% LTE time parameters: INDEX OF THE FIRST TRANSMITTED SUBFRAME
    
    % CHECK IF INDEX OF THE FIRST TRANSMITTED SUBFRAME IN A RADIO SLOT IS SPECIFIED 
    % IN THE LTE STRUCTURE ('FIRST_SF' field) 
    if ~isfield(sScen,'FIRST_SF')
        strErr = 'Index of the first subframe (FIRST_SF) is not specified in this LTE scenario file!';
        sScen.bError = 1;
        return;
    end    

    % CHECK IF THIS VALUE IS A NUMERIC VALUE
    if ~isnumeric(sScen.FIRST_SF)
        strErr = 'Index of the first subframe (FIRST_SF) must be a numeric value!';
        sScen.bError = 1;
        return;        
    end
    
    % CHECK IF THIS VALUE IS AN INTEGER
    FIRST_SF_old = sScen.FIRST_SF;
    FIRST_SF = round(sScen.FIRST_SF);
    
    if abs(FIRST_SF - FIRST_SF_old) > 0
        strErr = 'Index of the first subframe (FIRST_SF) must be an integer!';
        sScen.bError = 1;
        return;        
    end        
    
    % CHECK IF THIS VALUE IS CORRECT
    
    % Get the number of Subframes in a Radio Frame
    N_SFRF = sLTE_stand.N_SFRF;
    
    % Check the value
    if FIRST_SF < 0 || FIRST_SF > (N_SFRF - 1)
        strErr = 'Index of the first subframe (FIRST_SF) has an incorrect value!';
        sScen.bError = 1;
        return;        
    end
    
    % -----------------------------------------------------      
end

