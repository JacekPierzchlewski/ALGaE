%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_subcSlider: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                 MODULE: LTE PROFESSOR
%                                                      
%                                                 SERVICE: SLIDER 'Subcarriers'
%                                                 (GUI object: 'Slider_subcCoarse')
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
%                           - 'Create' (slider 'Subcarriers')
%
%                           - 'Movement' (slider 'Subcarriers')
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

function LTE_Professor_subcSlider(hObject, handles, strServ)

     % Run the correct service
    switch strServ

        % Create
        case 'Create'
            subcSlider_create(hObject);

        % Movement
        case 'Movement'
            subcSlider_movement(hObject,handles);
    end
end

%% Service: create 'Slider_subcCoarse' object
function subcSlider_create(hObject)

    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
end

%% Service: move 'Slider_subcCoarse' object
function subcSlider_movement(hObject,handles)
    
     % Get the coarse slider value
    iSlidVal = 1-get(hObject,'Value');
    
    % Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
    
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE bandwidth configuration structure
        sF = sLTE_DL1.sF;
        

        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE bandwidth configuration
        % structure (structures: 'sF')

        % Get the number of subcarriers
        N_scB = sF.N_scB;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -   
        
    % Calculate the current index of first shown subcarrier    
    inxFrstSub = round((N_scB-24)*iSlidVal)+1;
    if inxFrstSub < 1
        inxFrstSub = 1;
    end
            
    % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
    
    % Calculate the current index of last shown subcarrier
    inxLastSub = inxFrstSub + 23;
    if inxLastSub > N_scB;
        inxLastSub = N_scB;
    end
    
    % Update the subcarriers
    LTE_Professor_updateSubc(handles,inxFrstSub,inxLastSub);

end
