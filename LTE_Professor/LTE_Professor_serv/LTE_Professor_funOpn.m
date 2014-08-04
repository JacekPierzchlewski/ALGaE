%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_funOpn: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                             MODULE: LTE PROFESSOR
%                                                      
%                                             SERVICE: Opening function 
%                                                                                                                            
% File version 1.0 (17th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
%       2. strFileName: Cell with an input file name.
%
% ------------------------------------------------------------------------
% Output:
%
%       1. iErr :       Error inidication (1 - error occured.)
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

function iErr = LTE_Professor_funOpn(handles, strFileName)


        %% Get the name of the input file        
        strFileName = strFileName{1};        

        
        %% Check the input file
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Check if the file has a correct extension
        [ ~, ~, strExt ] = fileparts(strFileName);
        if ~strcmp(strExt,'.mat')
            errordlg('The input file must a .mat file!','Wrong file!');
            close(handles.figure1);
            iErr = 1;
            return;
        end
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Check if the file exists
        if exist(strFileName,'file') ~= 2
            errordlg('The given input file does not exist','File error!');
            close(handles.figure1);
            iErr = 1;
            return;
        end
                       
        % Read the file
        sWrap = load(strFileName);
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Check if the file contains LTE data strucutre
        if ~isfield(sWrap,'sLTE_DL1')
            errordlg('The given input does not contain LTE downlink signal!','File error!');
            close(handles.figure1);
            iErr = 1;
            return;
        end


        %% Store the LTE data structure and the input file name
        
        % Get the LTE data structure
        sLTE_DL1 = sWrap.sLTE_DL1;
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Check if the LTE data structure is correct
        if ~isfield(sLTE_DL1,'vI')  || ~isfield(sLTE_DL1,'vQ') || ...
                   ~isfield(sLTE_DL1,'sF')  || ~isfield(sLTE_DL1,'sT') || ...
                   ~isfield(sLTE_DL1,'mTF') || ~isfield(sLTE_DL1,'mModMap') || ...
                   ~isfield(sLTE_DL1,'mSCMap')
               
            errordlg('The given input does not contain LTE downlink signal!','File error!');
            close(handles.figure1);
            iErr = 1;
            return;               
        end
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Store the name of the input file
        setappdata(handles.figure1,'strFileName',strFileName);                
                
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Store the LTE data stucture
        setappdata(handles.figure1,'sLTE_DL1',sLTE_DL1);


        %% Set the initial values in the GUI
        
        
        % Read the LTE standard
        sLTE_stand = LTE_stand();
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
            
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Get the needed data from the LTE downlink signal
            % structure (structures: 'sLTE_DL1')
                
            % Get the LTE bandwidth configuration structure
            sF = sLTE_DL1.sF;
            
            % Get the LTE time configuration structure
            sT = sLTE_DL1.sT;
            

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Set up the sliders step and position (symbols sliders):
        
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Get the needed values from the LTE time configuration
            % structure (structures: 'sT')
    
            % Get the number of symbols in the transmission
            N_symbTR = sT.N_symbTR;                        
                        
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            
        vSteps = [ 1/(N_symbTR-10) 1/(N_symbTR-10) ];
        set(handles.Slider_symbCoarse,'SliderStep',vSteps);
        set(handles.Slider_symbCoarse,'Value',1/N_symbTR);            
            
            
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Set up the sliders step and position (subcarriers sliders):
        
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
            % Get the needed values from the LTE bandwidth configuration
            % structure (structures: 'sF')
    
            % Get the number of subcarriers
            N_scB = sF.N_scB;
            % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
                
        vSteps = [ 1/(N_scB-24) 1/(N_scB-24) ];
        set(handles.Slider_subcCoarse,'SliderStep',vSteps);
        set(handles.Slider_subcCoarse,'Value',1-1/N_scB);                        

        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Show the data in the table

        % Get first 14 symbols and 24 subcarriers
        mShow = sLTE_DL1.mTF(1:24,1:10);
                
        % Set the data
        set(handles.Data_table,'Data',mShow);
        
        % Set the sizes of columns
        set(handles.Data_table,'ColumnWidth',...
            {108,108,108,108,108,108,108,108,108,108,108,108,108,108});
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
        % Set the total number of subframes in the transmission
        
            % Get the total number of subframes
            N_SF     = sT.N_SF;        
        
        set(handles.Edit_noSubf,'String',num2str(N_SF));
        
        % - - - - - - - - - - - - - - - - - 
        
        % Set the time of the transmission
        
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
        set(handles.Edit_TotTime,'String',strMsg); 

        % - - - - - - - - - - - - - - - - - 
        
        % Set the bandwidth
        
            % Get the bandwidth
            F_fB     = sF.F_fB;
            
        strMsg = sprintf('%.2f [MHz]',F_fB/1e6);
        set(handles.Edit_Bandwidth,'String',strMsg);
        
        % - - - - - - - - - - - - - - - - - 
        
        % Set the type of CP
            
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
            set(handles.Edit_CPType,'String','Unknown');
        else
            set(handles.Edit_CPType,'String',cell2mat(cvCP(iCP)));
        end
        
        % - - - - - - - - - - - - - - - - - 
        
        
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Store the current indices of subcarriers 
        setappdata(handles.figure1,'inxFrstSub',1);
        setappdata(handles.figure1,'inxLastSub',24);


        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        % Store the current view type to 'Values
        setappdata(handles.figure1,'ViewType','Values');
        
        
        %% Run the 'update' functions
        
        % Update symbols values
        LTE_Professor_updateSymbs(handles,0,9);
                
        % Update subcarriers values
        LTE_Professor_updateSubc(handles,1,24);
        
        
        %% Report no error
        iErr = 0;

end
