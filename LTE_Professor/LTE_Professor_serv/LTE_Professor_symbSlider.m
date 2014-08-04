%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_symbSlider: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                 MODULE: LTE PROFESSOR
%                                                      
%                                                 SERVICE: SLIDER 'Symbols'
%                                                 (GUI object: 'Slider_symbCoarse')
%
% File version 1.0 (17th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. hObject:     Handle to the current object.
%
%       2  handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create' (slider 'Symbols')
%
%                           - 'Movement' (slider 'Symbols')
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

function LTE_Professor_symbSlider(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            symbSlider_create(hObject);

        % Movement
        case 'Movement'
            symbSlider_movement(hObject,handles);
    end
end

%% Service: create 'Slider_symbCoarse' object
function symbSlider_create(hObject)

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end

%% Service: move 'Slider_symbCoarse' object
function symbSlider_movement(hObject,handles)
    
    % Get the coarse slider value
    iSlidVal = get(hObject,'Value');
    
    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE bandwidth configuration structure
        sT = sLTE_DL1.sT;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE time configuration
        % structure (structures: 'sT')
    
        % Get the number of symbols in the transmission
        N_symbTR = sT.N_symbTR;
            
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -        
        
    % Calculate the current index of first shown subcarrier    
    inxFrstSymb = round((N_symbTR-10)*iSlidVal);
    if inxFrstSymb < 0
        inxFrstSymb = 0;
    end
            
    % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    
    % Calculate the current index of last shown subcarrier
    inxLastSymb = inxFrstSymb + 9;

    % Update the symbols
    LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb); 
end
