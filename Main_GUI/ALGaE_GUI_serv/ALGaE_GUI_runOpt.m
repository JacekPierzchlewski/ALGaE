%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_GUI_runOpt: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                         MODULE: MAIN GUI
%                                            
%                                         GUI SERVICES: PRESS BUTTON 'Main Options'
%
% File version 1.0 (14th October 2011)
%
%
%
%% ------------------------------------------------------------------------
% Input:
%
%       1.  handles:     Structure with handles to all objects in the GUI.
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

function ALGaE_GUI_runOpt(handles)

    % Get the current scenario structure 
    sScen = getappdata(handles.figure1,'sScen');
    
    if sScen.bEmpty == 1
        
        % Run the error service
        waitfor(errordlg('You have to specify the current scenario!','No scenario'));
        
    else

        % -----------------------------------------
        % Run the main options GUI     
        
        % Switch off the parent window until the child GUI is not closed
        
        % Scenario file
        set(handles.GUIpb_brwsScen,'Enable','off');
        set(handles.GUIedit_scenario,'Enable','off');
                        
        % Codewords file
        set(handles.GUIpb_codewords,'Enable','off');
        set(handles.GUIedit_codewords,'Enable','off');
        
        % Output file
        set(handles.GUIpb_output,'Enable','off');
        set(handles.GUIedit_output,'Enable','off');
                
        % Channels/ Modulation button
        set(handles.GUIpb_ChanMod,'Visible','off')
        
        % Main settings button
        set(handles.GUIpb_MainSettings,'Visible','off')
        
        % Radio upconversion button
        set(handles.GUIpb_Radio,'Visible','off')
        
        
        % Run the Advanced Options GUI
        waitfor(ALGaE_AdvOpt_GUI(sScen,handles));        
        
        
        % Switch on the parent window until the child GUI is not closed
        % Scenario file
        set(handles.GUIpb_brwsScen,'Enable','on');
        set(handles.GUIedit_scenario,'Enable','on');
                        
        % Codewords file
        set(handles.GUIpb_codewords,'Enable','on');
        set(handles.GUIedit_codewords,'Enable','on');
        
        % Output file
        set(handles.GUIpb_output,'Enable','on');
        set(handles.GUIedit_output,'Enable','on');
                
        % Channels/ Modulation button
        set(handles.GUIpb_ChanMod,'Visible','on')
        
        % Main settings button
        set(handles.GUIpb_MainSettings,'Visible','on')
        
        % Radio upconversion button
        set(handles.GUIpb_Radio,'Visible','on')        

        % -----------------------------------------
    end        
end

    