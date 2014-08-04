%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_GUI_lb_cp: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                            STACK:  DOWNLINK,
%                            MODULE: CHANNELS MODULATION
%
%                            GUI SERVICE: LIST BOX 'Cyclic Prefix'
%                                                                                      
% File version 1.0 (14th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input (3):
%
%       1. hObject:     Handle to the current object.
%
%       2  handles:     Structure with handles to all objects in the GUI.
%
%       3. strServ:     String with the name of service.
%                       Possible service:
%
%                           - 'Create' (list box 'Cyclic Prefix')
%
%                           - 'Callback' (list box 'Cyclic Prefix')
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

function L1a_GUI_lb_cp(hObject,handles,strServ)

    % Run the correct service
    switch strServ
        
        % Create
        case 'Create'
            lb_cp_create(hObject);
        
        % Callback
        case 'Callback'
            lb_cp_callback(hObject,handles);
            
    end
end


%% Service: create GUIlb_cp object
function lb_cp_create(hObject)
    
    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    % =========================================================================
    % LOAD THE LTE SCENARIO AND PUT FIELDS INTO THE LIST
    
    % Read the LTE Standard file
    sLTE_stand = LTE_stand();    
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD
    % (structures: 'sLTE_stand'):
        
        % The cell with cyclic prefix configuration names
        cvCP    = sLTE_stand.cvCP;
            
    %----------------------------------------------------------
    
    % Set the cell with cyclic prefix configuration names
    set(hObject,'String',cvCP);
    set(hObject,'Value',1);
  
end


%% Service: callback GUIlb_cp object
function lb_cp_callback(hObject,handles)

    % Get the current selection
    iVal = get(hObject,'Value');
    
    
    % Read the LTE Standard file
    sLTE_stand = LTE_stand();    
    
    
    % Load the current LTE scenario structure from the 'handle.figure1' handle    
    sScen = getappdata(handles.figure1,'sScen');
    
    
    % Get the correct cyclic prefix type name
    sScen.CYCLIC_PRFX = sLTE_stand.cvCP{iVal};
    
    
    % --------------------------------------------------

    % Save the LTE scenario locally:    
    
    % Save the LTE scenario structure in the 'sScen' field in 
    % the 'handle.figure1' handle
    setappdata(handles.figure1,'sScen',sScen);    

    % --------------------------------------------------
    
    % Save the LTE scenario in the parent window

    % Get the handle to the parent window    
    hMother = getappdata(handles.figure1,'hMother');    
   
    % Store the LTE scenario in the mother window
    setappdata(hMother.figure1,'sScen',sScen);

    % --------------------------------------------------    
        
end
