%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chc_Scen_DL1a: THE "ALGaE" PACKAGE - CHECK THE SCENARIO STRUCTURE
%
%                                      MODULE: DOWNLINK L1a layer
%
%
% This function checks the LTE scenario structure. Function checks if
% the structure contains correct values which are used in the Downlink 
% L1a layer. 
% 
% The function checks if the following parameters are specified.
% Fields names of the LTE scenario structure are given in brackets:
%
% In the case of a bad scenario structure function adds the 'bError' 
% field to the structure and strError returned value contains description
% of the error.
%
% File version 1.2 (14th October 2011)
%
%
%           PBCH channel parameters:
%
%                           1. index of the first transmitted Radio Frame in 
%                              PBCH TTI (PBCH_RFINX)
%
%                              Function checks if: 
%
%                                   - if the PBCH_RFINX field exists
%                                   
%                                   - if the PBCH_RFINX is a numeric variable
%
%                                   - if the PBCH_RFINX is an integer
%
%                                   - if value of the PBCH_RFINX is correct
%                                     according to the LTE standard
%
%
%
%           PHICH channel parameters:                               
%
%                           2. the Ng coefficient which controls the number 
%                              of PHICH groups (N_g)
%
%                              Function checks if: 
%
%                                   - if the N_g field exists
%                                   
%                                   - if the N_g is a numeric variable
%
%                                   - if value of the N_g is correct
%                                     according to the LTE standard
%
%
%                           
%           PDCCH channel parameters:                               
%
%                           3. vector with formats of PDCCH channels (vPDCCHFor)
%
%                              Function checks if: 
%
%                                   - if the vPDCCHFor field exists
%
%                                   - if the vPDCCHFor is a vector (but not a cell vector)
%
%                                   - if all elements of vPDCCHFor are
%                                     integers
%                                       
%                                   - if all elements of vPDCCHFor are
%                                     correct according to the LTE standard  
%
%
%                           4. The number of PDCCH channels (nPDCCH)
%
%                              Function checks if: 
%
%                                   - if the nPDCCH field exists
%
%                                   - if the nPDCCH is a numeric variable
%
%                                   - if the nPDCCH is an integer
%
%                                   - if the nPDCCH is equal to 1 or higher
%
%
%                           5. The number of symbols in a subframe dedicated 
%                              for PDCCH channels (nPDCCHSym)
%
%                              Function checks if: 
%
%                                   - if the nPDCCHSym field exists
%
%                                   - if the nPDCCHSym is a numeric
%                                     variable                                   
%
%                                   - if the nPDCCHSym is an integer
%
%                                   - if the nPDCCHSym is correct according
%                                     to the LTE standard
%
%           PDSCH channel parameters:
%
%                           6. PDSCH channel modulation order
%
%                              Function checks if: 
%
%                                   - if the iModOrd field exists
%
%                                   - if the iModOrd is a numeric
%                                     variable                                   
%
%                                   - if the iModOrd is an integer
%
%                                   - if the iModOrd is correct according
%                                     to the LTE standard
%
%% ------------------------------------------------------------------------
%
% Input (1):
%
%       1. sScen:       Structure with the current LTE scenario.           
%
%
% ------------------------------------------------------------------------
%
% Outputs (2):
%
%       1. sScen:       Structure with the current LTE scenario. 
%                       ( in a case of error function add an 'bError' field
%                         to the structure)
%
%       2. strErr:      String with the error message (empty in the case of OK).
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


function [ sScen strErr ] = chc_Scen_DL1a(sScen)

    
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
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LAYER 1A: 
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% sL1a STRUCTURE:
    
    % CHECK IF THE sL1a structure exists in the sScen strucutre
    if ~isfield(sScen,'sL1a')
        strErr = 'There is no scenario structure for the L1a module (sL1a structure)';
        sScen.bError = 1;
        return;
    end
    
    % Get the sL1a strucutre 
    sL1a = sScen.sL1a;    
    

        %% PBCH channel parameters:  

        % CHECK IF INDEX OF THE FIRST TRANSMITTED RADIO FRAME IN PBCH TTI IS SPECIFIED
        % IN THE LTE STRUCTURE ('PBCH_RFINX' field) 
        if ~isfield(sL1a,'PBCH_RFINX')
            strErr = 'Index of the first transmitted Radio Frame in a PBCH TTI (PBCH_RFINX) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end


        % CHECK IF INDEX OF THE FIRST TRANSMITTED RADIO FRAME IN PBCH TTI
        % IS A NUMERIC VALUE
        if ~isnumeric(sL1a.PBCH_RFINX)
            strErr = 'Index of the first transmitted Radio Frame in a PBCH TTI (PBCH_RFINX) must be a numeric value!';            
            sScen.bError = 1;
            return;            
        end


        % CHECK IF INDEX OF THE FIRST TRANSMITTED RADIO FRAME IN PBCH TTI
        % IS AN INTEGER
        PBCH_RFINX_old = sL1a.PBCH_RFINX;
        PBCH_RFINX = round(sL1a.PBCH_RFINX);

        if abs(PBCH_RFINX - PBCH_RFINX_old) > 0
            strErr = 'Index of the first transmitted Radio Frame in a PBCH TTI (PBCH_RFINX) must be a string!';            
            sScen.bError = 1;
            return;            
        end


        % CHECK IF INDEX OF THE FIRST TRANSMITTED RADIO FRAME IN PBCH TTI
        % HAS A CORRECT VALUE

        % Get TTI of the PBCH channel (Physical Broadcast Channel)
        iPBCH_TTI = sLTE_stand.iPBCH_TTI;

        if PBCH_RFINX < 0 || PBCH_RFINX > (iPBCH_TTI - 1)
            strErr = 'Index of the first transmitted Radio Frame in a PBCH TTI (PBCH_RFINX) has an incorrect value!';
            sScen.bError = 1;
            return;
        end

        % -----------------------------------------------------    


        %% PHICH channel parameters: 

        % CHECK IF THE Ng COEFFICIENT (THIS COEFFICIENT CONTROLS 
        % THE NUMBER OF PHICH GROUPS) IS SPECIFIED IN THE LTE STRUCTURE ('N_g' field)
        if ~isfield(sL1a,'N_g')
            strErr = 'The Ng coefficient (N_g) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end

        
        % Get the N_g coefficient
        iN_g = sL1a.N_g;

        
        % CHECK IF THE Ng COEFFICIENT IS A NUMERIC VALUE
        if ~isnumeric(sL1a.N_g)
            strErr = 'The Ng coefficient (N_g) must be a numeric value!';            
            sScen.bError = 1;
            return;            
        end
            

        % CHECK IF INDEX OF THE FIRST TRANSMITTED RADIO FRAME IN PBCH TTI
        % HAS A CORRECT VALUE

        % Get the possible values of the N_g coefficient  
        vN_g = sLTE_stand.vN_g;

        if sum(vN_g == iN_g) == 0
            strErr = 'The Ng coefficient (N_g) has an incorrect value!';
            sScen.bError = 1;
            return;
        end        
        
        % -----------------------------------------------------    


        %% PDCCH channel parameters:

        % CHECK IF THE NUMBER OF PDCCH CHANNELS IS SPECIFIED IN THE LTE STRUCTURE ('nPDCCH' field)
        if ~isfield(sL1a,'nPDCCH')
            strErr = 'The number of PDCCH channels (nPDCCH) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end

        % CHECK IF THE NUMBER OF PDCCH CHANNELS IS A NUMERIC VALUE
        if ~isnumeric(sL1a.nPDCCH)
            strErr = 'The number of PDCCH channels (nPDCCH) must be a numeric value!';            
            sScen.bError = 1;
            return;            
        end

        % CHECK IF THE NUMBER OF PDCCH CHANNELS IS AN INTEGER
        nPDCCH_old = sL1a.nPDCCH;
        nPDCCH = round(sL1a.nPDCCH);

        if abs(nPDCCH - nPDCCH_old) > 0
            strErr = 'The number of PDCCH channels (nPDCCH) must be an integer!';
            sScen.bError = 1;
            return;
        end        

        
        % CHECK IF THE NUMBER OF PDCCH CHANNELS IS EQUAL TO ONE OR HIGHER                
        if nPDCCH < 1
            strErr = 'The number of PDCCH channels (nPDCCH) must be equal to one or higher!';
            sScen.bError = 1;
            return;
        end          
        
        % ----------------------------------------------------- 
        
        
        % CHECK IF VECTOR WITH FORMATS OF PDCCH CHANNELS IS SPECIFIED IN THE LTE STRUCTURE ('vPDCCHFor' field)
        if ~isfield(sL1a,'vPDCCHFor')
            strErr = 'Vector with PDCCH formats (vPDCCHFor) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end

        % Get the vPDCCHFor vector from the sL1a structure
        vPDCCHFor = sL1a.vPDCCHFor(:);
                
        % CHECK IF THE LENGHT OF THE VECTOR IS EQUAL TO THE NUMBER OF
        % CHANNELS
        if size(vPDCCHFor,1) ~= nPDCCH
            strErr = 'Vector with PDCCH formats (vPDCCHFor) must be equal to the number of the PDCCH channels!';
            sScen.bError = 1;
            return;            
        end
        
        % CHECK IF vPDCCHFor IS A VECTOR
        if ~isvector(vPDCCHFor) || iscell(vPDCCHFor)
            strErr = 'Vector with PDCCH formats (vPDCCHFor) must be a vector of integers!';
            sScen.bError = 1;
            return;
        end

        % CHECK IF ALL ELEMENTS OF THE vPDCCHFor VECTOR ARE INTEGERS
        if sum(vPDCCHFor - round(vPDCCHFor))
            strErr = 'Elements of the vPDCCHFor vector must be integers!';
            sScen.bError = 1;
            return;
        end

        
        % CHECK IF ALL ELEMENTS OF THE vPDCCHFor VECTOR HAS CORRECT VALUES                                        

        % Get the supported formats of the PDCCH channel from the LTE
        % standard
        vPDCCH_Form = sLTE_stand.vPDCCH_Form;

        % Check all elements
        for inxVal = 1:size(vPDCCHFor,1)
            if sum(vPDCCH_Form == vPDCCHFor(inxVal)) == 0
                strErr = sprintf('Element %d of the vPDCCHFor vector is incorrect according to the standard!',inxVal);
                sScen.bError = 1;                
                return;
            end
        end


        % ----------------------------------------------------- 


        % CHECK IF THE NUMBER OF SYMBOLS IN A SUBFRAME DEDICATED FOR PDDCH CHANNELS 
        % IS SPECIFIED IN THE LTE STRUCTURE ('nPDCCHSym' field)
        if ~isfield(sL1a,'nPDCCHSym')
            strErr = 'The number of symbols dedicated for PDCCH channels (nPDCCHSym) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end
        
        % CHECK IF THE NUMBER OF SYMBOLS IN A SUBFRAME DEDICATED FOR PDDCH CHANNELS IS A NUMERIC VALUE
        if ~isnumeric(sL1a.nPDCCHSym)
            strErr = 'The number of symbols dedicated for PDCCH channels (nPDCCHSym) must be a numeric value!';            
            sScen.bError = 1;
            return;            
        end

        % CHECK IF THE NUMBER OF PDCCH CHANNELS IS AN INTEGER
        nPDCCHSym_old = sL1a.nPDCCHSym;
        nPDCCHSym = round(sL1a.nPDCCHSym);

        if abs(nPDCCHSym_old - nPDCCHSym) > 0
            strErr = 'The number of symbols dedicated for PDCCH channels (nPDCCHSym) must be an integer!';
            sScen.bError = 1;
            return;            
        end        
        
        % CHECK IF THE NUMBER OF SYMBOLS IN A SUBFRAME IS CORRECT
        
        % Get the matrix with supported number of PDCCH symbols from the LTE
        % standard
        mPDCCH_Symb = sLTE_stand.mPDCCH_Symb;

        % Get the cell vector with supported indices
        cvBW_channel = sLTE_stand.cvBW_channel(:);
                
        % Get the index of the current bandwidth
        vInx = 1:size(cvBW_channel,1);
        inxBand = vInx(strcmp(sScen.BANDWIDTH,cvBW_channel));        
                
        % Get the vector with supported number of PDCCH symbols        
        vPDCCH_Symb = mPDCCH_Symb(:,inxBand);
        vPDCCH_Symb = vPDCCH_Symb(:);
                
        if sum(vPDCCH_Symb == nPDCCHSym) == 0
            strErr = 'The number of symbols dedicated for PDCCH channels (nPDCCHSym) is incorrect according to the standard!';
            sScen.bError = 1;
        end
        
        % -----------------------------------------------------


        %% PDSCH channel parameters:
        
        % CHECK IF THE iModOrd COEFFICIENT (PDSCH MODULAION ORDER)
        % IS SPECIFIED IN THE LTE STRUCTURE ('iModOrd' field)
        if ~isfield(sL1a,'iModOrd')
            strErr = 'The PDSCH modulation order (iModOrd) is not specified in this LTE scenario file!';
            sScen.bError = 1;
            return;
        end
        
        % GET THE MODULATION ORDER
        iModOrd = sL1a.iModOrd;
        
        % CHECK IF THE PDSCH CHANNEL MODULATION ORDER IS A NUMERIC VALUE
        if ~isnumeric(iModOrd)
            strErr = 'The PDSCH modulation order (iModOrd) must be a numeric value!';            
            sScen.bError = 1;
            return;            
        end

        % CHECK IF THE PDSCH CHANNEL MODULATION ORDER IS AN INTEGER
        iModOrd_old = iModOrd;
        iModOrd = round(iModOrd);

        if abs(iModOrd_old - iModOrd) > 0
            strErr = 'The PDSCH modulation order (iModOrd) must be an integer!';
            sScen.bError = 1;
            return;            
        end           
        
        % CHECK IF THE PDSCH CHANNEL MODULATION ORDER IS CORRECT
        
        % Get the vector with supported PDSCH modulation order
        vPDSCH_ModOrd = sLTE_stand.vPDSCH_ModOrd;
                    
        if sum(vPDSCH_ModOrd == iModOrd) == 0
            strErr = 'The PDSCH modulation order (iModOrd) is incorrect according to the LTE standard!';
            sScen.bError = 1;
        end
end


