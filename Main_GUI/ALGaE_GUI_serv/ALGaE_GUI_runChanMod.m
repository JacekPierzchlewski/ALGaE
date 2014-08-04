%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ALGaE_GUI_runChanMod: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                             MODULE: MAIN GUI
%                                            
%                                             GUI SERVICES: PRESS BUTTON 'Channels Modulation (L1a)'
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

function ALGaE_GUI_runChanMod(hObject,handles)
    
        
    %% Switch off the parent window until the child GUI is not closed

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
    set(handles.GUIpb_ChanMod,'Visible','off');

    % Main settings button
    set(handles.GUIpb_MainSettings,'Visible','off');

    % Radio upconversion button
    set(handles.GUIpb_Radio,'Visible','off');
    
                   
    %% Switch on the parent window until the child GUI is not closed
    waitfor(L1a_GUI(handles));


    %% Switch on the parent window until the child GUI is not closed
    
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
    set(handles.GUIpb_ChanMod,'Visible','on');

    % Main settings button
    set(handles.GUIpb_MainSettings,'Visible','on');

    % Radio upconversion button
    set(handles.GUIpb_Radio,'Visible','on');    
    
    
    %% Get the sScen structure
    sScen = getappdata(handles.figure1,'sScen');
    
    
    %% Set up the path to a Scenario File 
    %  (it could change in the Chann_Modul_GUI)    
    if isfield(sScen,'strScenFil')        
        set(handles.GUIedit_scenario,'String',sScen.strScenFil);
        guidata(hObject, handles);

    else
        set(handles.GUIedit_scenario,'String','No scenario file!');
        guidata(hObject, handles);
    end

    %% Set up the path to a Output File
    %  (it could change in the Chann_Modul_GUI)
    if isfield(sScen,'strOutFil')        
        set(handles.GUIedit_output,'String',sScen.strOutFil);
        guidata(hObject, handles);
    else
        set(handles.GUIedit_output,'String','No output file!');
        guidata(hObject, handles);
    end

    
    %% Set up the path to a Codewords File
    %  (it could change in the Chann_Modul_GUI)
    if isfield(sScen,'strCodeFil')        
        set(handles.GUIedit_codewords,'String',sScen.strCodeFil);
        guidata(hObject, handles);
    else
        set(handles.GUIedit_codewords,'String','No codewords file - random data');
        guidata(hObject, handles);
    end
end

