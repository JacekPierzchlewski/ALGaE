%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% chc_ScenFil_Main: THE "ALGaE" PACKAGE - CHECK A FILE WITH LTE DOWNLINK
%                                         SCENARIO STRUCTURE   
%
%                                         MODULE: Main module
%
%
% This function checks if a file with LTE structure is OK. Function returns 
% structure readed from the given file. Routine from 'chc_Scen_Main' file is
% used by this function.
%
% In a case of a bad scenario structure function adds the 'bError' field 
% to the readed LTE structure.
%                                            
% File version 1.0 (14th October 2011)
%                                 
%% ------------------------------------------------------------------------
%
% Inputs (2):
%
%       1. strFile:     String with LTE scenario file name.
%
%       2. strPath:     String with a path to directory with the LTE scenario file.
%
%
% ------------------------------------------------------------------------
%
% Outputs (2):
%
%       1. sScen:       Structure with LTE scenario readed from the given file. 
%                       ( in case of the error, 'sScen' structure has an 'bError' field)
%
%       2. strErr:      String with the error message (empty in a case of OK scenario file).
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


function [ sScen strErr ] = chc_ScenFil_Main(strFile,strPath)

  
    %% ADD THE 'strPath' PATH TO THE MATLAB PATH
    addpath(strPath);

    
    %% GET THE LTE SCENARIO STRUCTURE
    
    % Remove the file extnesion from the filename
    [ ~, strFile, ~ ] = fileparts(strFile);

    % Changle the file name into the function handle
    funLTEscne = str2func(strFile);
    
    % Run the function
    sScen = funLTEscne();


    %% CHECK THE sScen STRUCTURE    
    [ sScen strErr ] = chc_Scen_Main(sScen);
    
end


