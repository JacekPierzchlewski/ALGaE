%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readpath: THE "ALGaE" PACKAGE - PATHS CONFIGRUATION FILE
%                       File version 0.14r2
%
% This is the path configuration file for version 0.14r2 (Stable) of the
% "Aalborg LTE GEnerator (ALGaE)" Package.
%
% Function adds all paths in the "ALGaE" toolbox to the MATLAB 
% environment. 
% 
% Files added by this file are listed in the 'Contents.m' file in the main 
% directory of the Package. 
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

    %% ADD DIRECTORY WITH LTE STANDARD PARAMETERS
    addpath('./LTE_Standard');

    %% ADD DOWNLINK FILES:
    addpath('./Downlink');        

    
        % -------------------------------------------------------------------
        %
        % CHANNELS & MODULATION MODULE:
    
        % ADD CHANNELS & MODULATION MODULE
        addpath('./Downlink/Chann_Modul');        

            % ADD THE CORE
            addpath('./Downlink/Chann_Modul/Core');
                
            % ADD BASEBAND SIGNAL GENERATION
            addpath('./Downlink/Chann_Modul/BasebandSig');

            % ADD CHANNELS MAPPER
            addpath('./Downlink/Chann_Modul/Channels');
            
            % ADD SIGNALS MAPPER
            addpath('./Downlink/Chann_Modul/Signals');
            
            % ADD CHANNELS & MODULATION MODULE AUXILIARY FILES
            addpath('./Downlink/Chann_Modul/Auxiliary');
            
            % ADD CHANNELS & MODULATION MODULE GUI
            addpath('./Downlink/Chann_Modul/GUI');
            
                % ADD CHANNELS & MODULATION MODULE GUI INTERNAL SERVICES
                addpath('./Downlink/Chann_Modul/GUI/L1a_GUI_serv');

                % ADD CHANNELS & MODULATION MODULE GUI OPTIONS INTERNAL SERVICES
                addpath('./Downlink/Chann_Modul/GUI/L1a_Options_GUI_serv');

        % -------------------------------------------------------------------
        %
        % RADIO MODULE:

        % ADD RADIO MODULE
        addpath('./Downlink/Radio');        


    %% ADD LTE STANDARD FILES
    addpath('./LTE_Standard');


    %% ADD LTE SCENARIOS FILES
    addpath('./Scenarios');


    %% ADD LTE PROFESSOR FILES
    addpath('./LTE_Professor');
        addpath('./LTE_Professor/LTE_Professor_serv');
        addpath('./LTE_Professor/LTE_Professor_heliView_serv');



    %% ADD MAIN GUI FILES
    addpath('./Main_GUI');
        addpath('./Main_GUI/ALGaE_GUI_serv');
        addpath('./Main_GUI/ALGaE_AdvOpt_GUI_serv');

        
    %% ADD AUXILIARY 
    addpath('./Auxiliary');        
        
        
    %% PRINT THE MESSAGE
    fprintf('\n "Aalborg LTE GEnerator (ALGaE) 0.14r2" toolbox subdirectories added to Matlab paths!\n\n');


