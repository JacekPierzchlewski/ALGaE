%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_viewPar: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                              MODULE: LTE PROFESSOR, 
%                                                      LTE PARAMETERS INFO GUI
%
% File version 1.2 (16th July 2011) 
%
%% ------------------------------------------------------------------------
% Input:
%       1. varargin:    Variable lenght input argument list.
%
%                   varargin{1}  - handle to the mother window
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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI   -   MAIN FUNCTION
function varargout = LTE_Professor_viewPar(varargin)

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @LTE_Professor_viewPar_OpeningFcn, ...
                       'gui_OutputFcn',  @LTE_Professor_viewPar_OutputFcn, ...
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

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - OPENING FUNCTION

% --- Executes just before LTE_Professor_viewPar is made visible.
function LTE_Professor_viewPar_OpeningFcn(hObject, ~, handles, varargin)

    % Choose default command line output for LTE_Professor_viewPar
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % ---------------------------------------------------------------------
        
    %% GET THE STRUCUTRES GIVEN TO THE FUNCTION
    
    % Get the handle to the mother window
    hMother = varargin{1};
    
    % Load the current LTE scenario structure from the 'mother' handle    
    sScen = getappdata(hMother,'sScen');  
    
    % Read the LTE standard file
    sLTE_stand = LTE_stand();

    % Generate the current LTE bandwidth and time configuration structures    
    [ sF sT ] = LTE_DL1a_res(sScen,sLTE_stand,-1);
    

    %% GET THE NEEDED VALUES FROM THE STRUCTURES                 
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE CURRENT LTE SCENARIO
    % (structures: 'sScen'):

        % Bandwidth type:
        BANDWIDTH       = sScen.BANDWIDTH;
                
        % Cyclic Prefixes type:
        CYCLIC_PRFX    = sScen.CYCLIC_PRFX;
        
        % The number of Subframes:
        N_SF            = sScen.N_SF;
        
        % Index of the first transmitted subframe
        FIRST_SF        = sScen.FIRST_SF;
        
    %----------------------------------------------------------    
    
    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE BANDWIDTH CONFIGURATION STRUCTURE
    % (structures: 'sF'):

        % The number of Resource Blocks
        N_rb    = sF.N_rb;
        
        % The number of subcarriers
        N_scB   = sF.N_scB;
        
        % Size of the IFFT
        N_ifft  = sF.N_ifft;
        
        % Bandwidth ocupied by all subcarriers
        F_fB    = sF.F_fB;
        
    %----------------------------------------------------------

    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE TIME CONFIGURATION STRUCTURE
    % (structures: 'sT'):

        % The sampling frequency
        fSmp        = sT.fSmp;
        
        % The number of symbols in a Radio Slot
        N_symbDL    = sT.N_symbDL;
        
        % The number of symbols in a Subframe
        N_symbSF    = sT.N_symbSF;
        
        % The number of symbols in a Radio Frame
        N_symbRF    = sT.N_symbRF;                
        
        
        % Time lenght of Cyclic Prefixes
        vCP_lengths = sT.vCP_lengths;
                
        % The number of samples in symbols
        vN_SmpsSymb = sT.vN_SmpsSymb;
        
        
        % The number of samples in a Radio Slot
        nSmpsRS     = sT.nSmpsRS;
        
        % The number of samples in a Subframe
        nSmpsSF     = sT.nSmpsSF;
        
        % The number of samples in a Radio Frame
        nSmpsRF     = sT.nSmpsRF;
        

        
    %----------------------------------------------------------
    
    %% Set values in the fields of the window

    % Bandwidth:
    strBand = sprintf('%s MHz',BANDWIDTH);
    set(handles.Bandwidth_edit,'String',strBand);
    
    % No. of Resource Blocks in a bandwidth:
    str_RB = num2str(N_rb);
    set(handles.nRB_edit,'String',str_RB);
    
    % No. of subcarriers:
    str_scB  = num2str(N_scB);
    set(handles.nSubc_edit,'String',str_scB);
        
    % Channel bandwidth occupied by all subcarriers
    str_FfB  = sprintf('%.2f MHz',F_fB/1e6);    
    set(handles.chBand_edit,'String',str_FfB);
    
    % IFFT size:
    str_fIFFT  = num2str(N_ifft);
    set(handles.nIFFT_edit,'String',str_fIFFT);
    
    % Sampling frequency: 
    str_fSmp  = sprintf('%.2f MHz',fSmp/1e6);    
    set(handles.sampFreq_edit,'String',str_fSmp);
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    % Cyclic Prefix type:
    set(handles.CPtype_edit,'String',CYCLIC_PRFX);
        
    % No. of symbols in a Radio Slot:
    set(handles.nSymbsRS_edit,'String',N_symbDL);
    
    % No. of symbols in a Subframe:
    set(handles.nSymbsSF_edit,'String',N_symbSF);
    
    % No. of symbols in a Radio Frame:
    set(handles.nSymbsRF_edit,'String',N_symbRF);
    
    % Time lenght of symbols:
    strCPleng='';
    for inxCP=1:size(vCP_lengths,1)
       strCPleng = sprintf('%s(%d):%.2f us ',strCPleng,inxCP,vCP_lengths(inxCP)*1e6);
    end
    set(handles.tCP_edit,'String',strCPleng);
    
    % No. of samples in Cyclic Prefixes:
    strCPsamps='';
    for inxCP=1:size(vCP_lengths,1)
       strCPsamps = sprintf('%s(%d):%d ',strCPsamps,inxCP,vN_SmpsSymb(inxCP));
    end
    set(handles.nSampsCP_edit,'String',strCPsamps);
    
    
    % No. of samples in a Radio Slot:
    set(handles.nSampsRS_edit,'String',nSmpsRS);
    
    % No. of samples in a Subframe:
    set(handles.nSampsSf_edit,'String',nSmpsSF);
    
    % No. of samples in a Radio Frame:        
    set(handles.nSampsRF_edit,'String',nSmpsRF);
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    
    % No. of Subframes:
    set(handles.nRF_edit,'String',N_SF);
    
    % Index of the first subframe in the transmission:
    set(handles.FIRST_SF_edit1,'String',FIRST_SF);
    
    % The number of full Radio Frames in the transmission:
    if FIRST_SF == 0
        nFR = floor(N_SF/10);
    else
        nFR = floor((N_SF-(10-FIRST_SF))/10);
        if nFR < 0
            nFR = 0;
        end
    end
    
    set(handles.nFullRF_edit,'String',nFR);

    % No. of symbols in the transmission:
    set(handles.nSymbsTR_edit,'String',N_SF*N_symbSF);
    
    % No. of samples in the transmission:
    str_nSmpTR  = sprintf('%d',N_SF*nSmpsSF);    
    set(handles.nSampsTR_edit,'String',str_nSmpTR);
    
    % Time due of the transmission:
    str_fSmp  = sprintf('%.1f ms',nSmpsSF*1/fSmp*N_SF*1e3);    
    set(handles.tTR_edit,'String',str_fSmp);

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - OUTPUT FUNCTION

% --- Outputs from this function are returned to the command line.
function varargout = LTE_Professor_viewPar_OutputFcn(~, ~, handles) 

    % Get default command line output from handles structure
    varargout{1} = handles.output;

end

% ------------------------------------------------------------------------------------




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   BANDWIDTH

function Bandwidth_edit_Callback(~, ~, ~)
    
end


% --- Executes during object creation, after setting all properties.
function Bandwidth_edit_CreateFcn(~, ~, ~)

end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF RESOURCE BLOCKS 

function nRB_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nRB_edit_CreateFcn(hObject, ~, ~)


    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SUBCARRIERS

function nSubc_edit_Callback(~, ~, ~)


end


% --- Executes during object creation, after setting all properties.
function nSubc_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   CHANNEL BANDWIDTH

function chBand_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function chBand_edit_CreateFcn(hObject, ~, ~)


    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
end

% ------------------------------------------------------------------------------------




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE SIZE OF IFFT 

function nIFFT_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nIFFT_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% ------------------------------------------------------------------------------------

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   SAMPLING FREQUENCY

function sampFreq_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function sampFreq_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:    CYCLIC PREFIX TYPE
function CPtype_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function CPtype_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:    THE NUMBER OF SYMBOLS IN A RADIO SLOT

function nSymbsRS_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nSymbsRS_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:    THE NUMBER OF SYMBOLS IN A SUBFRAME

function nSymbsSF_edit_Callback(~, ~, ~)


end


% --- Executes during object creation, after setting all properties.
function nSymbsSF_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:    THE NUMBER OF SYMBOLS IN A RADIO FRAME
function nSymbsRF_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nSymbsRF_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   TIME OF CYCLIC PREFIXES

function tCP_edit_Callback(~, ~, ~)

    % Hints: get(hObject,'String') returns contents of tCP_edit as text
    %        str2double(get(hObject,'String')) returns contents of tCP_edit as a double
end


% --- Executes during object creation, after setting all properties.
function tCP_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SAMPLES IN CYCLIC PREFIXES

function nSampsCP_edit_Callback(~, ~, ~)

end

% --- Executes during object creation, after setting all properties.
function nSampsCP_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SAMPLES IN A RADIO SLOT

function nSampsRS_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nSampsRS_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SAMPLES IN A SUBFRAME

function nSampsSf_edit_Callback(~, ~, ~)
end


% --- Executes during object creation, after setting all properties.
function nSampsSf_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SAMPLES IN A RADIO FRAME

function nSampsRF_edit_Callback(~, ~, ~)

end

% --- Executes during object creation, after setting all properties.
function nSampsRF_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% ------------------------------------------------------------------------------------




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF RADIO FRAMES 

function nRF_edit_Callback(~, ~, ~)

end

% --- Executes during object creation, after setting all properties.
function nRF_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SYMBOLS IN THE TRANSMISSION

function nSymbsTR_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nSymbsTR_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF SAMPLES IN THE TRANSMISSION

function nSampsTR_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function nSampsTR_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   TIME OF THE TRANSMISSION

function tTR_edit_Callback(~, ~, ~)

end


% --- Executes during object creation, after setting all properties.
function tTR_edit_CreateFcn(hObject, ~, ~)
    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   THE NUMBER OF FULL RADIO FRAMES IN THE TRANSMISSION
function nFullRF_edit_Callback(~, ~, ~)

end



% --- Executes during object creation, after setting all properties.
function nFullRF_edit_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI - EDIT TEXT:   INDEX OF THE FIRST TRANSMITTED SUBFRAME
function FIRST_SF_edit1_Callback(~, ~, ~)


end


% --- Executes during object creation, after setting all properties.
function FIRST_SF_edit1_CreateFcn(hObject, ~, ~)

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% ------------------------------------------------------------------------------------
