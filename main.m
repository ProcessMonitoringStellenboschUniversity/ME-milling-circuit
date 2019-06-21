%% SAG Mill Simulator
% Based on model described in le Roux et al. (2013), available at
% http://dx.doi.org/10.1016/j.mineng.2012.10.009

% Developed by BJ Wakefield and L Auret, 2015, 2017
% Presented at MEi Comminution, Cape Town, 2016
% Updated by JT McCoy, 2017, 2018
% Paper available at Minerals Engineering, 2018:
% https://doi.org/10.1016/j.mineng.2018.02.007

% Copyright (C) 2015, 2016, 2017, 2018 L Auret, BJ Wakefield, JT McCoy
% Contact: lauret[at]sun.ac.za

% This file is part of the SAG Mill Simulator program.

% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%% main.m
% Main code to load data for faults simulated in MinEng paper, or to
% generate fresh data from the Simulink model

%% Initialise workspace
close all; clear; clc;

%% Select data to load or to run new simulation
% User selects modes:
% 1 - load particle size estimate sensor error data
% 2 - load mill liner wear fault data
% 3 - load fault-free data
% 4 - run Simulink simulation of circuit
loadmode = 4;

% If loadmode == 4, user must also specify simulation modes:

% 1 - simulate particle size estimate sensor error data
% 2 - simulate mill liner wear fault data
% 3 - run simulation with no faults
faultmode = 3;
% User must also specify seed for random walks. This seed determines the
% seeds for random number generators in Simulink. A given seed will always
% generate the same (pseudo)random walks for the model, allowing the user
% to reproduce simulations. The data used in the paper was generated with a
% seed value of 1.
RandomSeedNumber = 1;   % Seed for the random walks

switch loadmode
	case 1
        load DataPSEfault;
        disp('Loading data for PSE fault simulation')
    case 2
        load DataMLWfault;
        disp('Loading data for Mill liner wear fault simulation')
    case 3
        load DataNofault;
        disp('Loading data for fault-free simulation')
    case 4
        run 'generate_data_SAGmill.m'
end

%% Specify time vector units and define indices for data ranges
tout = tout/24; % convert units to [days]

% NOC data - first 30 days
% test data - next 15 days
% fault data - next 15 days

% Indices for Samples before fault starts:
% 45 days x 24 hours per day x 60 minutes per hour x 2 samples per minute
tNOCStart = 1;
tNOCEnd = tNOCStart + 30*24*60*2;
tTestStart = tNOCEnd + 1;
tTestEnd = tNOCEnd + 15*24*60*2;

% Define fault start time
tFaultStart = tTestEnd+1;
tFaultEnd = tTestEnd+10*24*60*2;

%% Plot input and output parameters
% Resample data from Deltat = 0.0083 h/(24 h/day) to Deltat = 1 h
ind = find(rem(tout*24,1)==0);
indf = find(tout(ind)==45);
run 'displaytimeplots.m';

%% Compile data into matrix, specify variable names
% 0-tout,1-CFF,2-MFS,3-SFW,4-SVOL,5-JT,6-Pmill,7-CFD,8-PSE
datagen = horzcat(tout,CFF_out,MFS_out,SFW_out,SVOL_out,JT_out,Pmill_out,CFD_out,PSE_out,MIW_out);
names = {'CFF','MFS','SFW','SVOL','JT','Pmill','CFD','PSE','MIW'};
