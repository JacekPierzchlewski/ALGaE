%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                      MODULE: LTE PROFESSOR
%
% File version 0.2 (13th October 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. varargin:    Variable lenght input argument list.
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

%% Main function
function varargout = LTE_Professor(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @LTE_Professor_OpeningFcn, ...
                       'gui_OutputFcn',  @LTE_Professor_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);

    if nargin && ischar(varargin{1})        
        gui_State.gui_Callback = str2func(varargin{1});            
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT

end


%% --- Executes just before LTE_Professor is made visible.
function LTE_Professor_OpeningFcn(hObject, ~, handles, varargin)
    
    % Choose default command line output for LTE_Professor
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes LTE_Professor wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    % -----------------------------------------------------------------------
    
    % Run the opening service, if it is the first run of the function.
    % 
    % 'strFileName' field in the 'handles' strucutre indicates 
    % if it is not the first run.
    %
    
    % Store the current view type to 'Values'
    setappdata(handles.figure1,'ViewType','Values');    
    
    % If the opening serivce finish with an error, it returns 1
    if ~isappdata(handles.figure1,'strFileName')
        strFileName = varargin{1};        
        if LTE_Professor_funOpn(handles,strFileName) == 1                                    
            return;
        end
    end
end

%% --- Outputs from this function are returned to the command line.
function varargout = LTE_Professor_OutputFcn(~, ~, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
end


%% Symbols slider (object 'Slider_symbCoarse'):

% --- Executes during object creation, after setting all properties.
function Slider_symbCoarse_CreateFcn(hObject, ~, handles)

    % Run the 'Symbols slider' serivce with 
    % the 'Create' functionality
    LTE_Professor_symbSlider(hObject, handles,'Create');

end

% --- Executes on 'Symbols' slider movement.
function Slider_symbCoarse_Callback(hObject, ~, handles)

    % Run the 'Symbols slider' serivce with
    % the 'Movement' functionality
    LTE_Professor_symbSlider(hObject, handles,'Movement');

end


%% Edit box with the first symbol index (object 'Edit_frstSymbInx'):

% --- Executes during object creation, after setting all properties.
function Edit_frstSymbInx_CreateFcn(hObject, ~, handles)

    % Run the 'First Symbol index' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editFrstSymb(hObject, handles,'Create');
end

% --- Executes when object is edited (First Symbol, Index)
function Edit_frstSymbInx_Callback(hObject, ~, handles)

    % Run the 'First Symbol index' serivce with 
    % the 'Callback' functionality    
    LTE_Professor_editFrstSymb(hObject, handles,'Callback');
end


%% Edit box with the first symbol time start (object 'Edit_frstTime'):

% --- Executes during object creation, after setting all properties.
function Edit_frstTime_CreateFcn(hObject, ~, handles)

    % Run the 'First Symbol time start' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editFrstTime(hObject, handles,'Create');

end

% --- Executes when object is edited (First Symbol, Time moment)
function Edit_frstTime_Callback(hObject, ~, handles)

    % Run the 'First Symbol time start' serivce with 
    % the 'Callback' functionality    
    LTE_Professor_editFrstTime(hObject, handles,'Callback');
    
end

%% Edit box with the first symbol radio frame index (object 'Edit_frstRF'):

% --- Executes during object creation, after setting all properties.
function Edit_frstRF_CreateFcn(hObject, ~, handles)

    % Run the 'First symbol radio frame index' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editFrstRF(hObject, handles,'Create');
    
end

% --- Executes when object is edited (First Symbol, Radio Frame Index)
function Edit_frstRF_Callback(hObject, ~, handles)

    % Run the 'First symbol radio frame index' serivce with 
    % the 'Callback' functionality 
    LTE_Professor_editFrstRF(hObject, handles,'Callback');

end

%% Edit box with the first symbol radio slot index (object 'Edit_frstRS'):

% --- Executes during object creation, after setting all properties.
function Edit_frstRS_CreateFcn(hObject, ~, handles)

    % Run the 'First symbol radio slot index' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editFrstRS(hObject, handles,'Create');
    
end


% --- Executes when object is edited (First Symbol, Radio Slot Index)
function Edit_frstRS_Callback(hObject, ~, handles)

    % Run the 'First symbol radio slot index' serivce with 
    % the 'Callback' functionality  
    LTE_Professor_editFrstRS(hObject, handles,'Callback');

end

%% Edit box with the first symbol,symbol in radio slot index (object 'Edit_frstSymbRS'):

% --- Executes during object creation, after setting all properties.
function Edit_frstSymbRS_CreateFcn(hObject, ~, handles)

    % Run the 'First symbol, symbol in radio slot index' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editFrstSymbRS(hObject, handles,'Create');
        
end


% --- Executes when object is edited (First Symbol, Symbol in Radio Slot Index)
function Edit_frstSymbRS_Callback(hObject, ~, handles)

    % Run the 'First symbol, symbol in radio slot index' serivce with 
    % the 'Callback' functionality  
    LTE_Professor_editFrstSymbRS(hObject, handles,'Callback');
    
end


%% Edit box with the last symbol index (object 'Edit_lastSymbInx'):

% --- Executes during object creation, after setting all properties.
function Edit_lastSymbInx_CreateFcn(hObject, ~, handles)

    % Run the 'Last symbol index' serivce with 
    % the 'Create' functionality  
    LTE_Professor_editLastSymb(hObject, handles,'Create');
 
end

% --- Executes when object is edited (Last Symbol, Index)
function Edit_lastSymbInx_Callback(hObject, ~, handles)

    % Run the 'Last symbol index' serivce with 
    % the 'Callback' functionality  
    LTE_Professor_editLastSymb(hObject, handles,'Callback');

end

%% Edit box with the last symbol time end (object 'Edit_lastTime'):

% --- Executes during object creation, after setting all properties.
function Edit_lastTime_CreateFcn(hObject, ~, handles)

    % Run the 'Last Symbol time end' serivce with 
    % the 'Create' functionality 
    LTE_Professor_editLastTime(hObject, handles, 'Create');

end

% --- Executes when object is edited (Last Symbol, Time Moment)
function Edit_lastTime_Callback(hObject, ~, handles)

    % Run the 'Last Symbol time end' serivce with 
    % the 'Callback' functionality 
    LTE_Professor_editLastTime(hObject, handles, 'Callback');

end

%% Edit box with the last symbol radio frame index (object 'Edit_lastRF'):

% --- Executes during object creation, after setting all properties.
function Edit_lastRF_CreateFcn(hObject, ~, handles)
    
    % Run the 'Last Symbol Radio Frame Index' service with 
    % the 'Create' functionality 
    LTE_Professor_editLastRF(hObject, handles, 'Create');
end

% --- Executes when object is edited (Last Symbol, Radio Frame)
function Edit_lastRF_Callback(hObject, ~, handles)
    
    % Run the 'Last Symbol Radio Frame Index' service with 
    % the 'Callback' functionality 
    LTE_Professor_editLastRF(hObject, handles, 'Callback');

end


%% Edit box with the last symbol radio slot index (object 'Edit_lastRS'):

% --- Executes during object creation, after setting all properties.
function Edit_lastRS_CreateFcn(hObject, ~, handles)

    % Run the 'Last Symbol Radio Slot Index' service with 
    % the 'Create' functionality 
    LTE_Professor_editLastRS(hObject, handles, 'Create');

end


% --- Executes when object is edited (Last Symbol, Radio Slot)
function Edit_lastRS_Callback(hObject, ~, handles)

    % Run the 'Last Symbol Radio Slot Index' service with 
    % the 'Callback' functionality 
    LTE_Professor_editLastRS(hObject, handles, 'Callback');

end

%% Edit box with the last symbol radio, symbol in radio slot index (object 'Edit_lastSymbRS'):

% --- Executes during object creation, after setting all properties.
function Edit_lastSymbRS_CreateFcn(hObject, ~, handles)

    % Run the 'Last Symbol, Symbol in Radio Slot Index' service with 
    % the 'Create' functionality 
    LTE_Professor_editLastSymbRS(hObject, handles, 'Create');
    
end

% --- Executes when object is edited (Last Symbol, Symbol in Radio Slot Index)
function Edit_lastSymbRS_Callback(hObject, ~, handles)
    
    % Run the 'Last Symbol, Symbol in Radio Slot Index' service with 
    % the 'Callback' functionality 
    LTE_Professor_editLastSymbRS(hObject, handles, 'Callback');
end


%% Subcarriers slider (object 'Slider_subcCoarse'):

% --- Executes during object creation, after setting all properties.
function Slider_subcCoarse_CreateFcn(hObject, ~, handles)

    % Run the 'Subcarriers slider' serivce with 
    % the 'Create' functionality    
    LTE_Professor_subcSlider(hObject, handles,'Create');
        
end


% --- Executes on slider movement. (Subcarriers, Coarse)
function Slider_subcCoarse_Callback(hObject, ~, handles)

    % Run the 'Subcarriers slider' serivce with 
    % the 'Movement' functionality    
    LTE_Professor_subcSlider(hObject, handles,'Movement');

end


%% Edit box with the first subcarriers index (object 'Edit_frstSubc'):

% --- Executes during object creation, after setting all properties.
function Edit_frstSubc_CreateFcn(hObject, ~, handles)

    % Run the 'First Subcarrier Index' service with 
    % the 'Create' functionality 
    LTE_Professor_editFrstSubc(hObject, handles, 'Create');

end

% --- Executes when object is edited (First subcarrier)
function Edit_frstSubc_Callback(hObject, ~, handles)

    % Run the 'First Subcarrier Index' service with 
    % the 'Callback' functionality 
    LTE_Professor_editFrstSubc(hObject, handles, 'Callback');

end



%% Edit box with the first subcarriers frequency (object 'Edit_frstFreq'):

% --- Executes during object creation, after setting all properties.
function Edit_frstFreq_CreateFcn(hObject, ~, handles)

    % Run the 'First Subcarrier Frequency' service with 
    % the 'Create' functionality 
    LTE_Professor_editFrstFreq(hObject, handles, 'Create'); 

end

% --- Executes when object is edited (Frequency of the first subcarrier)
function Edit_frstFreq_Callback(hObject, ~, handles)

    % Run the 'First Subcarrier Frequency' service with 
    % the 'Callback' functionality 
    LTE_Professor_editFrstFreq(hObject, handles, 'Callback');

end

%% Edit box with the last subcarriers index (object 'Edit_lastSubc'):

% --- Executes during object creation, after setting all properties.
function Edit_lastSubc_CreateFcn(hObject, ~, handles)

    % Run the 'Last Subcarrier Index' service with 
    % the 'Create' functionality 
    LTE_Professor_editLastSubc(hObject, handles, 'Create');
 
end

% --- Executes when object is edited (Last subcarrier)
function Edit_lastSubc_Callback(hObject, ~, handles)

    % Run the 'Last Subcarrier Index' service with 
    % the 'Callback' functionality 
    LTE_Professor_editLastSubc(hObject, handles, 'Callback');

end


%% Edit box with the last subcarriers frequency (object 'Edit_lastFreq'):

% --- Executes during object creation, after setting all properties.
function Edit_lastFreq_CreateFcn(hObject, ~, handles)

    % Run the 'Last Subcarrier Frequency' service with 
    % the 'Create' functionality 
    LTE_Professor_editLastFreq(hObject, handles, 'Create');
    
end

% --- Executes when object is edited (Frequency of the last subcarrier)
function Edit_lastFreq_Callback(hObject, ~, handles)

    % Run the 'Last Subcarrier Frequency' service with 
    % the 'Callback' functionality 
    LTE_Professor_editLastFreq(hObject, handles, 'Callback');

end


%% --- Executes on button press in PB_viewREval. (View RE values)
function PB_viewREval_Callback(~, ~, handles)

        % Store the current view type to 'Values'
        setappdata(handles.figure1,'ViewType','Values');
        
        % Update the shown data
        inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb)          
end

%% --- Executes on button press in PB_viewChan. (View Channels)
function PB_viewChan_Callback(~, ~, handles)

        % Store the current view type to 'SigNChann'
        setappdata(handles.figure1,'ViewType','SigNChann');
        
        % Update the shown data
        inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb)        
        
end
 
%% --- Executes on button press in PB_viewModul. (View Modulations)
function PB_viewModul_Callback(~, ~, handles)

        % Store the current view type to 'Modulations'
        setappdata(handles.figure1,'ViewType','Modulations');
        
        % Update the shown data
        inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb)
end


%% --- Executes on button press in PB_heliView.
function PB_heliView_Callback(~, ~, handles)

    % Run the 'Helicopter view' service 
    LTE_Professor_heliView(handles);
end


%% --- Executes on button press in PB_openFile. (Open File)
function PB_openFile_Callback(~, ~, handles)

    % Run the 'Open new file' service 
    LTE_Professor_fileOpen(handles);

end




%% --- Executes when entered data in editable cell(s) in Data_table.
function Data_table_CellEditCallback(~, ~, handles)
% hObject    handle to Data_table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
   
        % Update the shown data
        inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        inxLastSymb = getappdata(handles.figure1,'inxLastSymb');
        LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb)

end


%% Edit box with the number of subframes (object 'Edit_noSubf'):

% --- Executes during object creation, after setting all properties.
function Edit_noSubf_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes when object is edited (The number of subcarriers)
function Edit_noSubf_Callback(~, ~, handles)

        % Get the LTE parameters structure
        sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
        
        % Get the time parameters strucutre
        sT = sLTE_DL1.sT;
        
        % Get the total number of subframes
        N_SF = sT.N_SF;
        
        % Set the total number of subframes in the transmission
        set(handles.Edit_noSubf,'String',num2str(N_SF));
end


%% Edit box with the total time (object 'Edit_TotTime'):

% --- Executes during object creation, after setting all properties.
function Edit_TotTime_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% --- Executes when object is edited (Total time of the transmission)
function Edit_TotTime_Callback(hObject, ~, handles)

    % Get the LTE parameters structure
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % Get the time parameters strucutre
    sT = sLTE_DL1.sT;

    % Get the number of samples in the transmisssion
    nSmpsTR     = sT.nSmpsTR;

    % Get the sampling frequency
    fSmp        = sT.fSmp;

    % Calculate the time
    tTR     = nSmpsTR / fSmp;

    % Check the unit

    % [us]
    if tTR < 1e-3
        tTR = tTR * 1e6;
        strU = '[ us ]';

    else
        % [ms]
        if tTR < 1               
            tTR = tTR * 1e3;
            strU = '[ ms ]';
        else
            % [s]
            strU = '[ s ]';
        end
    end

    strMsg = sprintf('%.2f %s',tTR,strU);
    set(hObject,'String',strMsg); 


end


%% Edit box with the bandwidth (object 'Edit_TotTime'):

% --- Executes during object creation, after setting all properties.
function Edit_Bandwidth_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes when object is edited (Bandwidth)
function Edit_Bandwidth_Callback(hObject, ~, handles)

        % Get the LTE parameters structure
        sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
        
        % Get the frequency parameters strucutre
        sF = sLTE_DL1.sF;
        
        % Get the bandwidth
        F_fB     = sF.F_fB;

        % Create the message
        strMsg = sprintf('%.2f [MHz]',F_fB/1e6);

        % Set the message
        set(hObject,'String',strMsg);
end


%% Edit box with type of the CP (object 'Edit_CPType'):

% --- Executes during object creation, after setting all properties.
function Edit_CPType_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes when object is edited ( CP Type )
function Edit_CPType_Callback(hObject, ~, handles)

        % Read the LTE standard
        sLTE_stand = LTE_stand();

        % Set the type of CP
            
            % Get the LTE parameters structure
            sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
        
            % Get the time parameters strucutre
            sT = sLTE_DL1.sT;        
        
            % Get the number of symbols in the subframe
            N_symbDL = sT.N_symbDL;
            
            % Get the number of symbols in different CP
            vN_symbDL = sLTE_stand.vN_symbDL(:);
            
            % Get the name of the CP
            cvCP = sLTE_stand.cvCP;
        
        % Create an auxillary vector    
        vI = 1:size(vN_symbDL,1);
        
        % Get the correct CP index
        iCP = vI(vN_symbDL == N_symbDL);
        
        % Set the correct string
        if isempty(iCP)
            set(hObject,'String','Unknown');
        else
            set(hObject,'String',cell2mat(cvCP(iCP)));
        end
end


%% --- Executes on button press in pb_ViewTimePar. (View time / frequency parameters)
function pb_ViewTimePar_Callback(~, ~, handles)

        % Get the LTE parameters structure
        sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

        % Get the scenario strucutre
        sScen = sLTE_DL1.sScen;   

        % Save this scenario structure
        setappdata(handles.figure1,'sScen',sScen);
                
        %% Run the View LTE Parameters window
        LTE_Professor_viewPar(handles.figure1);

end


%% --- Executes on button press in pb_viewS1. ( View Symbol #1 )
function pb_viewS1_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles,1);

end


%% --- Executes on button press in pb_viewS2. ( View Symbol #2 )
function pb_viewS2_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 2);

end


%% --- Executes on button press in pb_viewS3. ( View Symbol #3 )
function pb_viewS3_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 3);

end

%% --- Executes on button press in pb_viewS4. ( View Symbol #4 )
function pb_viewS4_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 4);

end


%% --- Executes on button press in pb_viewS5. ( View Symbol #5 )
function pb_viewS5_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 5);

end

%% --- Executes on button press in pb_viewS6. ( View Symbol #6 )
function pb_viewS6_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 6);

end

%% --- Executes on button press in pb_viewS7. ( View Symbol #7 )
function pb_viewS7_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 7);

end

%% --- Executes on button press in pb_viewS8. ( View Symbol #8 )
function pb_viewS8_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 8);
end


%% --- Executes on button press in pb_viewS9. ( View Symbol #9 )
function pb_viewS9_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 9);

end

%% --- Executes on button press in pb_viewS10. ( View Symbol #10 )
function pb_viewS10_Callback(~, ~, handles)

    % Run the view symbols function
    LTE_Professor_viewSymb(handles, 10);
end
