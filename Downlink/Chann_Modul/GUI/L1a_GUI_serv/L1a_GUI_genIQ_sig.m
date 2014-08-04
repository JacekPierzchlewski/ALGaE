%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_genIQ_sig: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                STACK:  DOWNLINK,
%                                MODULE: CHANNELS AND MODULATION
%
%                                GUI SERVICES: PRESS BUTTON 'Generate IQ signal'
%                                                                                              
% File version 1.0 (14th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input (1):
%
%       1. handles:    Structure with handles to all objects in the GUI.
%
% ------------------------------------------------------------------------
% Output:
%
%       no output
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

%% Service: press the GUIpb_gen object (press button 'Generate IQ signal)
function L1a_GUI_genIQ_sig(handles)


    %% GET THE LTE SCENARIO
    
    % Load the current LTE scenario structure from the 'handle.figure1' handle    
    sScen = getappdata(handles.figure1,'sScen');        
    % ------------------------------------------------------------------------


    %% GET THE OUTPUT FILE NAME 
        
    % Check if the output file is specified
    if ~isfield(sScen,'strOutFil')

        % Run the error info service                        
        waitfor(errordlg('Output file is not specified!','No output file'));
        return;
    end
    strOutFile = sScen.strOutFil;


    %% GET THE CODWORDS FILE NAME
    
    % Load the handle to the mother window
    strPHYChan = getappdata(handles.figure1,'strPHYChan');
    

    %% OPEN THE REPORT FILE

    % ------------------------------------------------------------------------
    % Create the report file name:
    [ strPath, strNam,  ~ ] = fileparts(strOutFile);
    strRepFil = strcat(strPath,'/',strNam,'_report.txt');

    % ------------------------------------------------------------------------


    %% RUN THE LTE DOWNLINK LAYER 1a SIGNAL GENERATOR
    sLTE_DL1 = LTE_DL1a(sScen, strPHYChan, strRepFil, 1); %#ok<NASGU>


    %% SAVE THE STRUCTURE WITH LTE DOWNLINK SIGNAL
    save(strOutFile,'sLTE_DL1');


    %% Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle

    % Set the 'bGenerated' flag to 1, to indicate that the signal was
    % generated
    sScen.bGenerated = 1;

    % Save the 'sScen' structure
    setappdata(handles.figure1,'sScen',sScen);

end


