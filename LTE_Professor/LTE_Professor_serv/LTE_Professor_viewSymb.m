%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_viewSymb: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                               MODULE: LTE PROFESSOR
%
%                                               SERVICE: View Symbols in a
%                                                        time domain
%                                                                                                                            
% File version 1.0 (17th July 2011)
%
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
%       2. iSymb:       Index of the symbol.
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

function LTE_Professor_viewSymb(handles,iSymb)


    %% Get the signal to be plotted

    % Get the LTE parameters structure
    sLTE_DL1 = getappdata(handles.figure1,'sLTE_DL1');

    % Get the I and Q signals
    vI = sLTE_DL1.vQ;
    vQ = sLTE_DL1.vI;

    % Load matrix with indices of symbols
    mSymInx = sLTE_DL1.mSymInx;
    
    % Get index of the first symbol shown in the T/F table
    % (index in the whole transmission)
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
    
    % Calculate index of the symbol to be ploted
    % (index in the whole transmission)
    inxSymb = inxFrstSymb + iSymb;
    
    % Get indices of samples to be viewed
    inxS = mSymInx(1,inxSymb);      % First sample
    inxLCP = mSymInx(2,inxSymb);    % Last sample of the CP
    inxF = mSymInx(3,inxSymb);      % Last sample of the symbol

    % Cyclic Prefixex
    vCP_I = vI(inxS:inxLCP);
    vCP_Q = vQ(inxS:inxLCP);
    
    % Symbols
    vSymb_I = vI(inxS:inxF);
    vSymb_Q = vQ(inxS:inxF);

    
    %% Generate the time axes
    
    % Get the time parameters structure
    sT = sLTE_DL1.sT;
    
    % -----------------------------------------------------
    % Get needed values from the time parameters structure
    %
    % (sT)
    
        % The sampling frequency
        fSmp = sT.fSmp;            
        
    % -----------------------------------------------------
    
    % Calcuate time of one sample
    tSmp = 1/fSmp;
    
    % Calculate the start time
    tStrt = inxS/fSmp;
        
    % Calculate CP end moment
    tCP_end = inxLCP/fSmp;    
        
    % Calculate symbol end moment
    tSym_end = inxF/fSmp;
    
    % Generate time axis for CP
    vT_CP = (tStrt:tSmp:tCP_end)';
    
    % Generate time axis for the whole symbol
    vT_Symb = (tStrt:tSmp:tSym_end)';


    %% Show the figure

    % Reset the figure
    figure(10); clf;

    % Plot the I signal
    subplot(2,1,1);    
    plot(vT_Symb*1e6,vSymb_I,'b-',vT_CP*1e6,vCP_I,'k-','LineWidth',3);

    xlabel('Time');
    ylabel('I signal [us]');
    legend('Symbol','Cyclic Prefix');

    % Plot the Q signal
    subplot(2,1,2);
    plot(vT_Symb*1e6,vSymb_Q,'b-',vT_CP*1e6,vCP_Q,'k-','LineWidth',3);

    xlabel('Time [us]');
    ylabel('Q signal');
    legend('Symbol','Cyclic Prefix');
    
    
end

