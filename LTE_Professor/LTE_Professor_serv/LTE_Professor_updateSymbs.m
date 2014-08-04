%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_updateSymbs: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                  MODULE: LTE PROFESSOR
%
%                                                  SERVICE: Update Symbols inidces
%                                                                                                                            
% File version 1.0 (17th July 2011)
%
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
%       2. inxFrstSymb: Index of the first symbol.
%
%       3. inxLastSymb: Index of the last symbol.
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

function LTE_Professor_updateSymbs(handles,inxFrstSymb,inxLastSymb)


    %% Get the LTE data structure 
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
        
        % Get the number of symbols in the Radio Slot
        N_symbDL = sT.N_symbDL;
        
        % Get the number of symbols in the Radio Frame
        N_symbRF = sT.N_symbRF;
        
        % Get the number of samples in Symbols
        vN_SmpsSymb = sT.vN_SmpsSymb;
                
        % Get the number of samples in a Radio Slot
        nSmpsRS = sT.nSmpsRS;
        
        % Get the number of samples in a Radio Frame
        nSmpsRF = sT.nSmpsRF;
        
        % Get the sampling frequency
        fSmp = sT.fSmp;
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -     

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Get the current index of the first subcarrier
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Set up the symbols indices:
    strFrst = num2str(inxFrstSymb);  % First
    set(handles.Edit_frstSymbInx,'String',strFrst);
    
    strLast = num2str(inxLastSymb);  % Last
    set(handles.Edit_lastSymbInx,'String',strLast); 
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - -     
    
    %% Set up slider value
    
    
    % Calculate the value of the slider
    iSlidVal = inxFrstSymb/(N_symbTR-10);    
    if iSlidVal > 1
        iSlidVal = 1;
    end
    
    if iSlidVal < 0
        iSlidVal = 0;
    end
    set(handles.Slider_symbCoarse,'Value',iSlidVal);        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    
    %% Set up the Radio Frame index
    inxFrstRF = floor(inxFrstSymb/N_symbRF); % Frst
    strFrstRF = num2str(inxFrstRF);  
    set(handles.Edit_frstRF,'String',strFrstRF);
    
    inxLastRF = floor(inxLastSymb/N_symbRF); % Last
    strLastRF = num2str(inxLastRF);  
    set(handles.Edit_lastRF,'String',strLastRF);

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    %% Set up the Radio Slot index
    iFrstSymbsLeft = inxFrstSymb - inxFrstRF*N_symbRF; % First
    inxFrstRS = floor(iFrstSymbsLeft / N_symbDL); 
    strFrstRS = num2str(inxFrstRS);  
    set(handles.Edit_frstRS,'String',strFrstRS);

    iLastSymbsLeft = inxLastSymb - inxLastRF*N_symbRF; % Last
    inxLastRS = floor(iLastSymbsLeft / N_symbDL); 
    strLastRS = num2str(inxLastRS);  
    set(handles.Edit_lastRS,'String',strLastRS);    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Set up the Symbols inside the Radio Frame index
    inxFrstSymbsRS = iFrstSymbsLeft - inxFrstRS*N_symbDL; % First    
    strFrstSymbsRS = num2str(inxFrstSymbsRS);  
    set(handles.Edit_frstSymbRS,'String',strFrstSymbsRS);

    inxLastSymbsRS = iLastSymbsLeft - inxLastRS*N_symbDL; % Last    
    strLastSymbsRS = num2str(inxLastSymbsRS);  
    set(handles.Edit_lastSymbRS,'String',strLastSymbsRS);    
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Set up the the time:
    
    % Calculate the time due of symbols
    vt_Symb = vN_SmpsSymb/fSmp;
    
    
    % Calculate the time due of a Radio Slot
    tRS = nSmpsRS/fSmp;
        
    % Calculate the time due of a Radio Frame
    tRF = nSmpsRF/fSmp;
    
    % Calculate the starting moment of the first shown symbol
    tFrst = inxFrstRF*tRF + inxFrstRS*tRS + sum(vt_Symb(1:inxFrstSymbsRS));
    
    % Print the starting moments of the first shown symbol in the text edit
    strtFrst = sprintf('%.2f [us]',tFrst*1e6);
    set(handles.Edit_frstTime,'String',strtFrst);
    
    % Calculate the moment when the last shown symbol finish
    tLast = inxLastRF*tRF + inxLastRS*tRS + sum(vt_Symb(1:inxLastSymbsRS+1));
    
    % Print the moment when the last shown symbol finish in the text edit
    strtLast = sprintf('%.2f [us]',tLast*1e6);
    set(handles.Edit_lastTime,'String',strtLast);
    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       
    %% Store the current indices of symbols
    setappdata(handles.figure1,'inxFrstSymb',inxFrstSymb);
    setappdata(handles.figure1,'inxLastSymb',inxLastSymb);

    % Store the current Radio Frame index
    setappdata(handles.figure1,'inxFrstRF',inxFrstRF);
    setappdata(handles.figure1,'inxLastRF',inxLastRF);
    
    % Store the current Radio Slot index
    setappdata(handles.figure1,'inxFrstRS',inxFrstRS);
    setappdata(handles.figure1,'inxLastRS',inxLastRS);

    % Store the current Symbol in a Radio Slot index
    setappdata(handles.figure1,'inxFrstSymbsRS',inxFrstSymbsRS);
    setappdata(handles.figure1,'inxLastSymbsRS',inxLastSymbsRS);
    
    % Store the current times of symbols
    setappdata(handles.figure1,'tFrst',tFrst);
    setappdata(handles.figure1,'tLast',tLast);
    
    
     %% Show the data 
    
    % Get the data to be shown  [mcShow - matrix with cells]
    mcShow = LTE_Professor_getShownData(handles);
    
    % Change the data
    set(handles.Data_table,'Data',mcShow);    
    
    % Set up the Column Names
    vcColNam = [ {sprintf('%d',inxFrstSymb+0)},...
                 {sprintf('%d',inxFrstSymb+1)},...
                 {sprintf('%d',inxFrstSymb+2)},...
                 {sprintf('%d',inxFrstSymb+3)},...
                 {sprintf('%d',inxFrstSymb+4)},...
                 {sprintf('%d',inxFrstSymb+5)},...
                 {sprintf('%d',inxFrstSymb+6)},...
                 {sprintf('%d',inxFrstSymb+7)},...
                 {sprintf('%d',inxFrstSymb+8)},...
                 {sprintf('%d',inxFrstSymb+9)} ]';
    
    set(handles.Data_table,'ColumnName',vcColNam);    
    
    % Set up the Row Names
    vcRowNam = [ {sprintf('%d',inxFrstSub+0)},...
                 {sprintf('%d',inxFrstSub+1)},...
                 {sprintf('%d',inxFrstSub+2)},...
                 {sprintf('%d',inxFrstSub+3)},...
                 {sprintf('%d',inxFrstSub+4)},...
                 {sprintf('%d',inxFrstSub+5)},...
                 {sprintf('%d',inxFrstSub+6)},...
                 {sprintf('%d',inxFrstSub+7)},...
                 {sprintf('%d',inxFrstSub+8)},...
                 {sprintf('%d',inxFrstSub+9)},...
                 {sprintf('%d',inxFrstSub+10)},...
                 {sprintf('%d',inxFrstSub+11)},...
                 {sprintf('%d',inxFrstSub+12)},...
                 {sprintf('%d',inxFrstSub+13)},...
                 {sprintf('%d',inxFrstSub+14)},...
                 {sprintf('%d',inxFrstSub+15)},...
                 {sprintf('%d',inxFrstSub+16)},...
                 {sprintf('%d',inxFrstSub+17)},...
                 {sprintf('%d',inxFrstSub+18)},...
                 {sprintf('%d',inxFrstSub+19)},...
                 {sprintf('%d',inxFrstSub+20)},...
                 {sprintf('%d',inxFrstSub+21)},...
                 {sprintf('%d',inxFrstSub+22)},...                 
                 {sprintf('%d',inxFrstSub+23)} ]';
    
    set(handles.Data_table,'RowName',vcRowNam);    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       
end
