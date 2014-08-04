% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ALGaE >>>
% "ALGaE"    A toolbox to generate LTE signals.
%
% Version:     0.14r2      released 5-Sept-2012 (Stable)
%
%
% =========================================================================
% TOOLBOX CONTENTS: 
%
%   -------------------------------------------------------------------------
%
%   A) ./ : ROOT DIR
%
%                .    ReadMe.m      <- Package Manual  
%                     Version 0.1
%
%                .    Contents.m    <- This file 
%                     Version 0.14r2
%
%                .    readpath.m    <- Path configuration file 
%                     Version 0.14r2
%
%
%   -------------------------------------------------------------------------
%
%   B) ./LTE_Standard: DIR. WITH FILES WITH PARAMETERS OF THE LTE STANDARD 
%
%               4.     LTE_stand.m  <- File with LTE standard constant parameters
%                      Version 1.0
%
%   -------------------------------------------------------------------------
%
%   C) ./Downlink : DIR. WITH LTE DOWNLINK LAYERS
%                  
%               ./Chann_Module     : SUBDIR. WITH LTE DOWNLINK L1a (PHY CHANNELS AND MODULATION) MODULE
%
%                       ./Auxiliary    : DIR. WITH ADDITIONAL SERVICE FUNCTIONS       
%
%                       ./BasebandSig  : DIR. WITH LTE BASEBAND SIGNAL GENERATORS
%                                        (OFDM GENERATORS)
%
%                       ./Channels     : DIR. WITH LTE DOWNLINK CHANNELS MODULATION                       
%                                        AND CHANNELS TO RESOURCE MAPPERS  
%
%                       ./Core         : DIR. WITH LTE L1A DOWNLINK CORE
%
%
%                       ./GUI          : DIR. WITH LTE L1A DOWNLINK GUI FILES 
%                                        GUI Version 0.14
%
%                       ./Signals      : SUBDIR. WITH LTE DOWNLINK SIGNALS GENERATORS
%                                        AND SIGNALS TO RESOURCE MAPPERS                                      
%                                     
%
%               ./Radio        : SUBDIR. WITH RADIO UPCONVERSION
%
%   -------------------------------------------------------------------------
%               
%   D) ./LTE_Professor : DIR. WITH LTE PROFESSOR
%
%
%   -------------------------------------------------------------------------
%
%   E) ./Main_GUI : DIR. WITH THE MAIN GUI
%
%
%   -------------------------------------------------------------------------
%
%   F) ./Auxiliary : DIR. WITH AUXILIARY FILES
%
%
%   -------------------------------------------------------------------------
%
%   G) ./Scenarios : DIR WITH LTE SCEANRIO FILES
%
%
%   -------------------------------------------------------------------------
%
%% =========================================================================
%
% Copyright (c) 2010 - 2012 Jacek Pierzchlewski,
%                           AALBORG UNIVERSITY, Denmark
%                           Technology Platforms Section (AAU TPS)
%                           Email:    jap@es.aau.dk (Jacek)
%                              
%                           Comments and bug reports are very welcome!
%
% -------------------------------------------------------------------------
%
% Licensing:
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the 
%   Free Software Foundation version 3.
%
%   This program is distributed in the hope that it will be useful, 
%   but WITHOUT ANY WARRANTY; without even the implied warranty of 
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
%   See the GNU General Public License for more details.
%
%   The GNU General Public License can be found at: 
%   <a href="matlab:web('http://www.gnu.org/licenses/')">The GNU Web site</a>
%
% -------------------------------------------------------------------------
%
% This file is a part of the "ALGaE Package 0.14r2" (Stable). 
% ALGaE 0.14r2 released: 5th September 2012
%
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ALGaE <<<

