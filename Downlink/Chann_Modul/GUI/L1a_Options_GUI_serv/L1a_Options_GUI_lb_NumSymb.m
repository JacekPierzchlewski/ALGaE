%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L1a_Options_GUI_lb_NumSymb: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                         STACK:  DOWNLINK,
%                                         MODULE: CHANNELS AND MODULATION,
%                                                 OPTIONS
%
%                                         GUI SERVICES: LIST BOX 'The number of 
%                                                                 symbols for PDCCH channel'
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
%                           - 'Create' (list box 'The number of symbols')
%
%                           - 'Initialize' (list box 'The number of symbols')
%
%                           - 'Callback' (list box 'The number of symbols')
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

function L1a_Options_GUI_lb_NumSymb(hObject, handles, strServ)
    
    % Run the correct service
    switch strServ
        
        % Create the list box 'The number of symbols'
        case 'Create'
            lb_NumSymb_create(hObject);
            
        % Initialize the list box 'The number of symbols'
        case 'Initialize'
            lb_NumSymb_init(handles);

        % Callback the list box 'The number of symbols'
        case 'Callback'
            lb_NumSymb_callback(hObject, handles);
    end
end


%% Service: create GUIlb_NumSymb_PDCCH object (list box 'The number of symbols')
function lb_NumSymb_create(hObject)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
        
end


%% Service: initialize GUIlb_NumSymb_PDCCH object (list box 'The number of symbols')
function lb_NumSymb_init(handles)


    %% SET THE LIST IN THE LIST BOX

    % Get the index of the bandwidth from the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Get the correct index of the bandwidth
    iBand = get(hMother.GUIlb_band,'Value');
    
    % ---------------------------------------    
    
    % Read the LTE standard
    sLTE_stand = LTE_stand();

    % Get the possible number of symbols 
    mPDCCH_Symb = sLTE_stand.mPDCCH_Symb;
    vPDCCH_Symb = mPDCCH_Symb(:,iBand); % <- vector with the possible number of symbols
    
    % Create the cell with possible number of symbols        
    for inxNoSym=1:size(vPDCCH_Symb,1)
        cNSym{inxNoSym} = num2str(vPDCCH_Symb(inxNoSym)); %#ok<AGROW>
    end
    cNSym = cNSym';
    
    % Set the possible number of symbols in the list box
    set(handles.GUIlb_NumSymb_PDCCH,'String',cNSym);

    % ---------------------------------------   
    
    
    %% SET THE CORRECT POSITION ON THE LIST
    
    % Get the sScen structure
    sScen = getappdata(handles.figure1,'sScen');
    
    % Get the sL1a strucutre
    sL1a = sScen.sL1a;
    
    % Get the number of symbols in a subframe dedicated for 
    % PDCCH channels
    nPDCCHSym = sL1a.nPDCCHSym;
    
    % Get the correct index
    vInx = (1:size(vPDCCH_Symb,1));
    iInx = vInx(vPDCCH_Symb == nPDCCHSym);    
    
    % Check if the current number of symbols is on the current list
    if isempty(iInx)
        
        % Put the error dialogs
        waitfor(warndlg('The number of symbols for PDCCH does not fit to the current bandwidth. It was automatically changed.','Warning'));
        
        % Set the correct position on the list
        iInx = vInx(vPDCCH_Symb == 2);        
        
        % Store the default number of symbols
        sScen.sL1a.nPDCCHSym = 2;
        
        % Get the handle to the mother window
        hMother = getappdata(handles.figure1,'hMother');
        
        % Store the current LTE scenario locally
        setappdata(handles.figure1,'sScen',sScen);
        
        % Store the current LTE scenario in the mother window
        setappdata(hMother.figure1,'sScen',sScen);

    end

    % Set the correct position on the list
    set(handles.GUIlb_NumSymb_PDCCH,'Value',iInx);


    % ---------------------------------------   
end


%% Service: callback GUIlb_NumSymb_PDCCH object (list box 'The number of symbols')
function lb_NumSymb_callback(hObject, handles)

    % Get the current value from the list box
    iVal = get(hObject,'Value');

    % Get the list from the list box
    cNSym = get(hObject,'String');

    % Change the cell into a numeric value
    cNSym = cNSym(iVal);
    iN = str2double(cell2mat(cNSym));

    % ---------------------------------------------------
    
    % Get the current LTE scenario
    sScen = getappdata(handles.figure1,'sScen');
    
    % Set the value in the LTE scenario (locally)
    sScen.sL1a.nPDCCHSym = iN;
    setappdata(handles.figure1,'sScen',sScen);
    
    % ---------------------------------------------------
    
    % Get the handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
    
    % Set the value in the LTE scenario (mother window)
    setappdata(hMother.figure1,'sScen',sScen);

end

