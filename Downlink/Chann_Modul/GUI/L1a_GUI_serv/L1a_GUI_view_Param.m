%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_view_Param:  THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                  STACK:  DOWNLINK,
%                                  MODULE: CHANNELS MODULATION
%
%                                  GUI SERVICE: RUN WINDOW 'View LTE parameters'
%                                                                                      
% File version 1.0 (14th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input (1):
%
%       1  handles:     Structure with handles to all objects in the GUI.
%
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

function L1a_GUI_view_Param(handles)
    

    %% Get the current LTE scenario
    sScen = getappdata(handles.figure1,'sScen');
    
    
    %% Check if the scenario is not empty
    if sScen.bEmpty == 1        
        waitfor(errordlg('Read the scenario file before running this window!','No LTE Scenario!'));
        return; 
    end

    %% Run the LTE Parameters window
    LTE_Professor_viewPar(handles.figure1);
    
end
