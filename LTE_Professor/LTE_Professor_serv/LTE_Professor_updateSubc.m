%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_updateSubc: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                                 MODULE: LTE PROFESSOR
%
%                                                 SERVICE: Update Subcarriers indices
%                                                                                                                            
% File version 1.0 (17th July 2011)
%                                 
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
%       2. inxFrstSub: Index of the first subcarrier.
%
%       3. inxLastSub: Index of the last subcarrier.
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

function LTE_Professor_updateSubc(handles,inxFrstSub,inxLastSub)

    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Calculate the current frequency of shown subcarriers
    
        % Get the needed data from the LTE downlink signal
        % structure (structures: 'sLTE_DL1')

        % Get the LTE bandwidth configuration structure
        sF = sLTE_DL1.sF;


        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
        % Get the needed values from the LTE bandwidth configuration
        % structure (structures: 'sF')
        
        % Get the separation between subcarriers
        Delta_f = sF.Delta_f;
        
        % Get the number of subcarriers
        N_scB = sF.N_scB;        
        
        % -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -       
    

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    % Calculate the current frequency of the first shown subcarrier
    if inxFrstSub <= N_scB/2
        fFrstSub = Delta_f*(-N_scB/2 + inxFrstSub - 1);
    else
        fFrstSub = Delta_f*(inxFrstSub - N_scB/2);
    end


    % Calculate the curren index of the last shown subcarrier
    inxLastSub = inxFrstSub + 24 - 1;
    
    % Calculate the current frequency of the first shown subcarrier
    if inxLastSub <= N_scB/2
        fLastSub = Delta_f*(-N_scB/2 + inxLastSub - 1);
    else
        fLastSub = Delta_f*(inxLastSub - N_scB/2);
    end
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Get the current index of the first symbol
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
        
    %% Set up the subcarriers indices:
    strFrst = num2str(inxFrstSub);  % First
    set(handles.Edit_frstSubc,'String',strFrst);
    
    strLast = num2str(inxLastSub);  % Last
    set(handles.Edit_lastSubc,'String',strLast);
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Set up the frequency values:
    strFrstF = sprintf('%.2f [kHz]',fFrstSub/1e3);  % First
    set(handles.Edit_frstFreq,'String',strFrstF);
    
    strLastF = sprintf('%.2f [kHz]',fLastSub/1e3);  % First
    set(handles.Edit_lastFreq,'String',strLastF);  
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Set up slider value
        
    % Calculate the value of the slider
    iSlidVal = (inxFrstSub-1)/(N_scB-24);
    iSlidVal = 1 - iSlidVal;
    if iSlidVal > 1
        iSlidVal = 1;
    end
    
    if iSlidVal < 0
        iSlidVal = 0;
    end
    set(handles.Slider_subcCoarse,'Value',iSlidVal);    
    
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    
    %% Store the current indices of subcarriers 
    setappdata(handles.figure1,'inxFrstSub',inxFrstSub);
    setappdata(handles.figure1,'inxLastSub',inxLastSub);
    
    %% Store the current frequencies of subcarriers 
    setappdata(handles.figure1,'fFrstSub',fFrstSub);
    setappdata(handles.figure1,'fLastSub',fLastSub);
        
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

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
