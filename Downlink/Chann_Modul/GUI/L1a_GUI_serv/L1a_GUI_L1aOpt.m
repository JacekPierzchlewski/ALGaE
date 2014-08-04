%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_L1aOpt: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                       STACK:  DOWNLINK,
%                                       MODULE: CHANNELS AND MODULATION
%
%                                       GUI SERVICES: PRESS BUTTON 'L1a options'  
%                                 
% File version 1.2 (14th October 2011)
%                                 
%% ------------------------------------------------------------------------
% Input (1):
%
%       1. handles:    Structure with handles to all objects in the GUI.
%
%
% ------------------------------------------------------------------------
% Output:
%
%       no output
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


function L1a_GUI_L1aOpt(handles)


    %% Get the current LTE scenario
    sScen = getappdata(handles.figure1,'sScen');


    %% Check if the scenario file is empty
    if sScen.bEmpty == 1
        waitfor(errordlg('Read the LTE scenario file before running this window!','No LTE Scenario!'));
        return;
    end

    %% Run the options GUI
    waitfor(L1a_Options_GUI(sScen,handles));
    
    %% Store the new sScen structure in the mother window
    
    % Get the current local sScen strucutre
    sScen = getappdata(handles.figure1,'sScen');
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Store the sScen structure
    setappdata(hMother.figure1,'sScen',sScen);
    
end

