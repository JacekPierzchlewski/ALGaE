%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_Options_GUI_lb_NumChan: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                         STACK:  DOWNLINK,
%                                         MODULE: CHANNELS AND MODULATION,
%                                                 OPTIONS
%
%                                         GUI SERVICES: LIST BOX 'The number of channels'
%
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
%                           - 'Create' (list box 'The number of channels')
%
%                           - 'Initialize' (list box 'The number of channels')
%
%                           - 'Callback' (list box 'The number of channels')
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

function L1a_Options_GUI_lb_NumChan(hObject, handles, strServ)
    
    % Run the correct service
    switch strServ
        
        % Create the list box 'The number of channels'
        case 'Create'
            lb_NumChann_create(hObject);
            
        % Initialize the list box 'The number of channels'
        case 'Initialize'
            lb_NumChann_init(handles);
            
        % Callback the list box 'The number of channels'
        case 'Callback'
            lb_NumChann_callback(hObject, handles);
    end
end


%% Service: create GUIlb_NumChan_PDCCH object (list box 'The number of channels')
function lb_NumChann_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
        
end


%% Service: initialize GUIlb_NumChan_PDCCH object (list box 'The number of channels')
function lb_NumChann_init(handles)
    
    % GET THE sScen STRUCTURE
    sScen = getappdata(handles.figure1,'sScen');

    % GET THE sL1a SUBSTRUCTURE FROM THE SCENARIO STRUCTURE
    sL1a = sScen.sL1a;
    
    % Get the number of PDCCH channels
    nCh = sL1a.nPDCCH;
    
    % Check if the number of channels is higher than 8
    if nCh > 8
        
        % Make the number of channels equal to 8
        nCh = 8;
        
        % Show the warning
        waitfor(warndlg('This GUI supports up to 8 PDCCH channels! Use text editor for the PDCCH channels settings!', 'Ups...'));
    end
    
    % Set the correct value
    set(handles.GUIlb_NumChan_PDCCH,'Value',nCh);

end



%% Service: callback GUIlb_NumChan_PDCCH object (list box 'The number of channels')
function lb_NumChann_callback(hObject, handles)
    

    %% GET THE sScen STRUCUTRE
    sScen = getappdata(handles.figure1,'sScen');
    

    %% GET THE GIVEN VALUE
    
    % Set the correct value
    iVal = get(hObject,'Value');

    
    %% SHADOW THE PDCCH CHANNELS FORMATS FIELDS
    
    % Get the number of channels
    nCh = iVal;
    
    % Get the vector with formats of PDCCH channel
    vPDCCHFor = sScen.sL1a.vPDCCHFor;
    
    % Get the current size of the vPDCCHFor vector
    % (It denotes the previous number of channels)
    nCh_old = size(vPDCCHFor,1);
    
    % Shadow edit field: Format of the 8th Channel
    if nCh < 8

        % Shadow the text and edit fields
        set(handles.GUIedit_for8_PDCCH,'Visible','off');
        set(handles.GUItext_for8_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector        
        if nCh_old >= 7
            vPDCCHFor = vPDCCHFor(1:7);
        end
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for8_PDCCH,'Visible','on');
        set(handles.GUItext_for8_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for8_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for8_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(8) = 0;  
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(8) = str2double(get(handles.GUIedit_for8_PDCCH,'String'));                                                 
        end
    end
    % ---------------------------------------
    
    % Shadow edit field: Format of the 7th Channel
    if nCh < 7

        % Shadow the text and edit fields
        set(handles.GUIedit_for7_PDCCH,'Visible','off');
        set(handles.GUItext_for7_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector
        if nCh_old >= 6
            vPDCCHFor = vPDCCHFor(1:6);
        end
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for7_PDCCH,'Visible','on');
        set(handles.GUItext_for7_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for7_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for7_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(7) = 0;  
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(7) = str2double(get(handles.GUIedit_for7_PDCCH,'String'));                                     
        end        
    end
    % ---------------------------------------
    
    % Shadow edit field: Format of the 6th Channel
    if nCh < 6

        % Shadow the text and edit fields
        set(handles.GUIedit_for6_PDCCH,'Visible','off');
        set(handles.GUItext_for6_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector
        if nCh_old >= 5
            vPDCCHFor = vPDCCHFor(1:5);
        end
        
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for6_PDCCH,'Visible','on');
        set(handles.GUItext_for6_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for6_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for6_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(6) = 0;
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(6) = str2double(get(handles.GUIedit_for6_PDCCH,'String'));                         
        end        
    end
    % ---------------------------------------
    
    % Shadow edit field: Format of the 5th Channel
    if nCh < 5

        % Shadow the text and edit fields
        set(handles.GUIedit_for5_PDCCH,'Visible','off');
        set(handles.GUItext_for5_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector
        if nCh_old >= 4
            vPDCCHFor = vPDCCHFor(1:4);
        end    
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for5_PDCCH,'Visible','on');
        set(handles.GUItext_for5_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for5_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for5_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(5) = 0;                        
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(5) = str2double(get(handles.GUIedit_for5_PDCCH,'String'));             
        end        
    end
    % ---------------------------------------
    
    % Shadow edit field: Format of the 4th Channel
    if nCh < 4

        % Shadow the text and edit fields
        set(handles.GUIedit_for4_PDCCH,'Visible','off');
        set(handles.GUItext_for4_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector
        if nCh_old >= 3
            vPDCCHFor = vPDCCHFor(1:3);
        end
                
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for4_PDCCH,'Visible','on');
        set(handles.GUItext_for4_PDCCH,'Enable','on');

        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for4_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for4_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(4) = 0;                        
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(4) = str2double(get(handles.GUIedit_for4_PDCCH,'String')); 
        end
    end
    % ---------------------------------------
    
    % Shadow edit field: Format of the 3rd Channel
    if nCh < 3

        % Shadow the text and edit fields
        set(handles.GUIedit_for3_PDCCH,'Visible','off');
        set(handles.GUItext_for3_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector        
        if nCh_old >= 2
            vPDCCHFor = vPDCCHFor(1:2);
        end
                
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for3_PDCCH,'Visible','on');
        set(handles.GUItext_for3_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for3_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for3_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(3) = 0;
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(3) = str2double(get(handles.GUIedit_for3_PDCCH,'String'));              
        end        
    end
    % ---------------------------------------    

    % Shadow edit field: Format of the 2nd Channel
    if nCh < 2

        % Shadow the text and edit fields
        set(handles.GUIedit_for2_PDCCH,'Visible','off');
        set(handles.GUItext_for2_PDCCH,'Enable','off');
        
        % Cut the vPDCCHFor vector
        vPDCCHFor = vPDCCHFor(1);
                
    else
        % Unshadow the text and edit fields
        set(handles.GUIedit_for2_PDCCH,'Visible','on');
        set(handles.GUItext_for2_PDCCH,'Enable','on');
        
        % Check if it was the first unshadow of this field.
        % If it was the first time, initialize the value to 0.
        if strcmp(get(handles.GUIedit_for2_PDCCH,'String'),' ')
            
            % Set the value to 0
            set(handles.GUIedit_for2_PDCCH,'String','0');
            
            % Set the value in the vector with formats of the PDCCH
            vPDCCHFor(2) = 0;  
        else
            % If it was not the first time, restore the value of the vector
            vPDCCHFor(2) = str2double(get(handles.GUIedit_for2_PDCCH,'String'));  
        end
    end
    % ---------------------------------------


    %% CHANGE THE VALUES IN THE sScen STRUCTURE
    
    % ------------------------------------------
    % Locally:
    
    % Assign the correct values in the sScen structure    
    sScen.sL1a.nPDCCH = iVal;
    sScen.sL1a.vPDCCHFor = vPDCCHFor(:);
    
    % Store the sScen structure locally
    setappdata(handles.figure1,'sScen',sScen);
            
    % ------------------------------------------
    % In the main window:
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Store the sScen structure in the mother window
    setappdata(hMother.figure1,'sScen',sScen);
    
end

