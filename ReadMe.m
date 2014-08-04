% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ALGaE >>>
% "ALGaE" A toolbox to generate LTE signals.
%
%  Toolbox Version:     0.14r2    released 5-Sep-2012 (Stable)
%  ReadMe.m version:    0.1       released 5-Oct-2011 
%
%% -------------------------------------------------------------------------
% 
%   TABLE OF CONTENTS:
%
%       1. What is "ALGaE"?
%
%       2. Running the generator.
%
%           A. Adding the toolbox directories.
%
%           B. Running the main GUI.
%               
%           C. LTE Downlink L1a layer.
%
%               i.   Running the console based generator.
% 
%               ii.  Running the console based generator (examples).
%
%
%       3. Copyright (Copyleft) and Licensing.
%
%       4. Versioning.
%
%
%% =========================================================================
% 1. WHAT IS "ALGaE"?
%
%   "ALGaE" (Aalborg LTE GEnerator) is a software which is able to generate 
%   LTE signals. It is developed entirely in Matlab. In the current
%   version (0.14r2) it has the following modules:
%
%   AlGaE LTE generator. The implemented LTE Stack modules are:
%              
%       1. L1a downlink layer (Physicall and Channels Modulation).
%
%
%   Auxillary modules:   
%
%       2. LTE Professor module (LTE signal analyzer and viewer). 
%
%       3. ALGaE Generator GUI.
%
%
%   "ALGaE" (Aalborg LTE GEnerator) was created and is still developed at 
%   Aalborg University in Aalborg, Denmark. 
%
%   You can read more about AAU:        http://www.aau.dk
%   
%   You can read more about Aalborg:    http://en.wikipedia.org/wiki/Aalborg
%
%
%% =========================================================================
% 2. RUNNING THE GENERATOR:
%    
%   a. Adding the toolbox directories:
%   
%       >> readpath                    <- add all toolbox paths to the Matlab 
%                                         path (run it only once at one Matlab 
%                                         session)
%
%---------------------------------------------------------------------------
%                                                                      
%   b. Running the main GUI:
%        
%      It is recommended to run all GUI programms in the toolbox via the
%      main toolbox GUI:
%
%       >> ALGaE_GUI               <- run the main toolbox GUI
%
%---------------------------------------------------------------------------
%
%    c. LTE Downlink L1a layer:
%          
%       i.  Running the console based L1a module generator.
%
%           To run the console based L1a module generator type in the MATLAB console:
%           
%           >> LTE_DL1a( 1. LTEScen [string/structure], 2. Codewords [string/structure], 3. strRepFil [string], 4. bGUI_Off [int] )
%               
%               Input arguments:
%                       
%                   1. LTEScen. (REQUIRED)
%                      This arguments contains LTE scenario used by the generator. 
%                      It can be a correct LTE scenario MATLAB structure or a
%                      path to correct MATLAB .m file with LTE scenario
%                      structure.
%                          
%                   2. Codewords. (OPTIONAL)
%                      This arguments contains codewords used by the L1a
%                      module. It can be a MATLAB structure or a path to
%                      MATLAB .mat file with codewords. 
%                      This argument is optional, if it is not specified
%                      (equal to '') the L1a downlink module will use 
%                      random codewords.
%
%
%                   3. strRepFil. (OPTIONAL)
%                      This arguments contains a name of the report file.
%
%                      This argument is optional, if it is not specified
%                      (equal to '') the L1a downlink module will not
%                      produce report.
%
%
%                   4. bGUI_Off. (REQUIRED)
%                      This arguments switch on graphical widgets (progress
%                      bar).
%
%
%       ii. Running the console based generator (examples):
%
%           >> LTE_DL1a('LTE_scenario14.m','','',0)           <- run the signal generator with the
%                                                                'LTE_scenario14' LTE scenario file
%                                                                without physical channel passed,
%                                                                with report file off, with GUI Bar off
%                                                                
%
%           >> sLTE_DL1 = LTE_DL1a('LTE_scenario5.m','','Report.txt',1);     <- run the signal generator with the
%                                                                               'LTE_scenario5' LTE scenario file 
%                                                                               without physical channel passed, 
%                                                                               with report file on, with GUI Bar on.
%
%                                                            
%
%% =========================================================================
%
% 3. COPYRIGHT (COPYLEFT) AND LICENSING:
%
% Copyright (c) 2010 - 2012 Jacek Pierzchlewski,
%                           AALBORG UNIVERSITY, Denmark
%                           Technology Platforms Section (AAU TPS)
%                           Email:    jap@es.aau.dk (Jacek)
%                              
%                           Comments and bug reports are very welcome!
%
% =========================================================================
%
% Licensing:
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the 
%   Free Software Foundation version 3.
%
%   This program is distributed in the hope that it will be useful, 
%   but WITHOUT ANY WARRANTY; ithout even the implied warranty of 
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%   See the GNU General Public License for more details.
%
%   The GNU General Public License can be found at: 
%   <a href="matlab:web('http://www.gnu.org/licenses/')">The GNU Web site</a>
%
%% =========================================================================
%
% 4. VERSIONING:
%
% This file is a part of the "ALGaE Package 0.14r2" (Stable). 
% ALGaE 0.14r2 released: 5th September 2012
%
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ALGaE <<<

