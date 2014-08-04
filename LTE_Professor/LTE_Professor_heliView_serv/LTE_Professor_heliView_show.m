%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_heliView_show: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE
%                                                    MODULE: LTE PROFESSOR, 
%                                                            HELICOPTER VIEW ON RESOURCES
%
%                                                    SERVICE: Show the image
%
% File version 1.0 (20th July 2011)
%
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
% ------------------------------------------------------------------------
% Output:
%
%       1. none.
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

function LTE_Professor_heliView_show(handles)

    %% Get the view parameters:
    
    % Get handle to the mother window
    hMother = getappdata(handles.figure1,'hMother');
        
    % Get the current view type
    strVType = getappdata(hMother.figure1,'ViewType');
    
    % Get the current indices of shown symbols
    inxFrstSymb = getappdata(handles.figure1,'inxFrstSymb');
        
    % Get the current indices of shown subcarriers
    inxFrstSub = getappdata(handles.figure1,'inxFrstSub');

    % Get the current number of shown symbols
    subSize = getappdata(handles.figure1,'subSize');    
    
    % Get the current number of shown subcarriers
    symSize = getappdata(handles.figure1,'symSize');

    
    
    %% Get the LTE data structure 
    sLTE_DL1 = getappdata(hMother.figure1,'sLTE_DL1');    


    %----------------------------------------------------------
    % GET THE NEEDED VALUES FROM THE LTE STANDARD
    % (structures: 'sLTE_stand'):

        % Get the number of symbols in the transmission
        N_symbTR = sLTE_DL1.sT.N_symbTR;                
    
        % Get the number of subcarriers
        N_scB = sLTE_DL1.sF.N_scB;

    % ----------------------------------------------------------     



    %% Calculate the index of the last subcarrier and symbols to be shown
        
    % Index of the last symbol
    inxLastSymb = inxFrstSymb + symSize - 1;    
    
    % Check if the current value of the first and last symbol is correct?
    if inxLastSymb > N_symbTR
        
        % Set the last shown symbol index into the last symbol in the
        % transmission
        inxLastSymb = N_symbTR;

        % Calculate the first shown symbol
        inxFrstSymb = inxLastSymb - symSize + 1;
    end

    % Index of the last subcarrier
    inxLastSub = inxFrstSub + subSize - 1;    
    
    % Check if the current value of the first and last symbol is correct?
    if inxLastSub > N_scB
        
        % Set the last shown subcarrier into the number of subcarriers in
        % the spectrum
        inxLastSub = N_scB;
        
        % Calculate the first shown subcarrier
        inxFrstSub = inxLastSub - subSize + 1;
    end
    

    %% Get the correct chunk of resources to show
    switch strVType

        % Values of the Time/Frequency resources 
        case 'Values'

            % Get the currently shown chunk of the resources matrix (signals and channels map)        
            [ mShow mColMap vcColorBar ] = getSigChann(handles,inxFrstSub,inxLastSub,inxFrstSymb,inxLastSymb);
            
            
        % The signals and channels types in the resources     
        case 'SigNChann'

            % Get the currently shown chunk of the resources matrix (signals and channels map)
            [ mShow mColMap vcColorBar ] = getSigChann(handles,inxFrstSub,inxLastSub,inxFrstSymb,inxLastSymb);
            
            
        % The modulation types in the resources
        case 'Modulations'
            
            % Get the currently shown chunk of the resources matrix (Modulations mapping)
            [ mShow mColMap vcColorBar ] = getModul(handles,inxFrstSub,inxLastSub,inxFrstSymb,inxLastSymb);
            
    end


    %% Show the figure
    
    % Clear the figure
    figure(255);clf;
    
    % Show the image
    image(mShow+1); axis([ inxFrstSymb+1 inxLastSymb+1 inxFrstSub inxLastSub]);

    % Put the colormap
    colormap(mColMap);

    % Put the colorbar (color legend)
    colorbar('YTickLabel',vcColorBar);

    % Put the xlabel
    xlabel('Symbols (-1)');
    
    % Put the ylabel
    ylabel('Subcarriers (-1)');
    
end



%% Get signal and channels
function [ mShow mColMap vcColorBar ] = getSigChann(handles,inxFrstSub,inxLastSub,inxFrstSymb,inxLastSymb)
    

    % ---------------------------------------------------
    
    % Get the colored signals/channels matrix
    mSCMapColored = getappdata(handles.figure1,'mSCMapColored');
    
    % ---------------------------------------------------
    % Get the currently shown chunk of the resources matrix (signals and channels map)    
    mShow = mSCMapColored(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);


    % ---------------------------------------------------
    % Put the mShow matrix into the bottom-right corner of the
    % bigger matrix
    mShow_background = zeros(inxLastSub+1,inxLastSymb+1);
    mShow_background(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1) = mShow;
    mShow = mShow_background;    


    % --------------------------------------------------- 
    % Get the colorbar
    vcColorBar = getappdata(handles.figure1,'vcSCColorBar');

    % Get the colormap
    mColMap = getappdata(handles.figure1,'mSCColMap');
    
end


%% Get modulations
function [ mShow mColMap vcColorBar ] = getModul(handles,inxFrstSub,inxLastSub,inxFrstSymb,inxLastSymb)

    % ---------------------------------------------------

    % Get the colored modulation matrix
    mModMapColored = getappdata(handles.figure1,'mModMapColored');

    % ---------------------------------------------------
    % Get the currently shown chunk of the resources matrix (Modulations mapping)
    mShow = mModMapColored(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1);


    % ---------------------------------------------------
    % Put the mShow matrix into the bottom-right corner of the
    % bigger matrix
    mShow_background = zeros(inxLastSub,inxLastSymb);
    mShow_background(inxFrstSub:inxLastSub,inxFrstSymb+1:inxLastSymb+1) = mShow;
    mShow = mShow_background;


    % --------------------------------------------------- 
    % Get the colorbar
    vcColorBar = getappdata(handles.figure1,'vcModColorBar');

    % Get the colormap
    mColMap = getappdata(handles.figure1,'mModColMap');       

end



