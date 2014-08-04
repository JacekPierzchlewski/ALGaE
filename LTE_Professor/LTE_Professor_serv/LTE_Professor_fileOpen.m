%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LTE_Professor_fileOpen: THE "ALGaE" PACKAGE - GRAPHICAL USER INTERFACE,
%                                               MODULE: LTE PROFESSOR
%                  
%                                               SERVICE: Opening new file
%
% File version 1.0 (17th July 2011)
%
%% ------------------------------------------------------------------------
% Input:
%       1. handles:     Structure with handles to the GUI objects.
%
% ------------------------------------------------------------------------
% Output:
%
%       1. no output
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

function LTE_Professor_fileOpen(handles)

    % Run the open file dialog
    [ strFile strPath ] = uigetfile();

    % Check if the cancel button was pressed. 
    % If yes, abort this service
    if isnumeric(strFile) && isnumeric(strPath)
        fprintf('Cancel\n');
        return;
    end 

    strFileName = strcat(strPath,strFile);

    %% Check if the file contains correct LTE signal:            
    
    % Reset the 'file OK' flag 
    bFilOK = 0;
    
    % Run this loop until the correct file is not found
    while bFilOK == 0

        % Split the file name into directory + filename + extension
        [ ~ , ~, strExt ] = fileparts(strFileName);
        
        % Check if the file has a correct extension
        if strcmp(strExt,'.mat')
        
            % Open the file:
            sWrapp = open(strFileName); 

            % Check if the LTE structure is inside?
            if isfield(sWrapp,'sLTE_DL1')

                % Take the LTE structure
                sLTE_DL1 = sWrapp.sLTE_DL1;
                clear sWrapp;

                % Check if the LTE signal data fields are inside?
                if isfield(sLTE_DL1,'vI')  && isfield(sLTE_DL1,'vQ') && ...
                   isfield(sLTE_DL1,'sF')  && isfield(sLTE_DL1,'sT') && ...
                   isfield(sLTE_DL1,'mTF') && isfield(sLTE_DL1,'mModMap') && ...
                   isfield(sLTE_DL1,'mSCMap')
                
                   % If everything is OK, set the OK flag
                   bFilOK = 1;   
                end                                                            
            end

            % If the OK flag is not set, run the error dialog box            
            if bFilOK == 0
                waitfor(errordlg('This file does not contain LTE signal!','Wrong file'));
            end
        else
            % If the file has a wrong extension, run the error dialog box            
            waitfor(errordlg('It is not a .mat file!','Wrong file'));
        end
        
        % If something went wrong, run the file browser to open the file
        if bFilOK == 0
            
            % Run the open file dialog
            [ strFile strPath ] = uigetfile();

            % Check if the cancel button was pressed. 
            % If yes, abort this service
            if isnumeric(strFile) && isnumeric(strPath)
                fprintf('Cancel\n');
                return;
            end
            
            % Create the ful name of the file
            strFileName = strcat(strPath,strFile);                                
        end
    end

    
    %% Read the file    
    if LTE_Professor_funOpn(handles,{strFileName}) == 1                        
        return;
    end
    
end

