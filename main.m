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
% 30 days x 24 hours per day x 60 minutes per hour x 2 samples per minute
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

% %% Compile data into matrix, specify variable names
% % 0-tout,1-CFF,2-MFS,3-SFW,4-SVOL,5-JT,6-Pmill,7-CFD,8-PSE
% datagen = horzcat(tout,CFF_out,MFS_out,SFW_out,SVOL_out,JT_out,Pmill_out,CFD_out,PSE_out,MIW_out);
% names = {'CFF','MFS','SFW','SVOL','JT','Pmill','CFD','MIW','PSE'};

%% Introduce a mini shutdown and start up by ramping all values:
t_shut_start = 5*24*60*2; % 5 days x 24 hours per day x 60 minutes per hour x 2 samples per minute
t_ramp = 12*60*2; % 12 hours x 60 minutes per hour x 2 samples per minute
t_shut = 2*24*60*2; % 1 day x 24 hours per day x 60 minutes per hour x 2 samples per minute

% calculate ramp parameters:
mask = ones(length(tout),1);
for i = t_shut_start:t_shut_start+t_ramp
    val = 1-(i-t_shut_start)/(t_ramp);
    mask(i) = val;
end

for i = t_shut_start+t_ramp:t_shut_start+t_ramp+t_shut
    mask(i) = 0;
end

for i = t_shut_start+t_ramp+t_shut:t_shut_start+t_ramp+t_shut+t_ramp
    val = (i-(t_shut_start+t_ramp+t_shut))/(t_ramp);
    mask(i) = val;
end

% apply mask to each variable:
CFF_out = CFF_out.*mask;
MFS_out = MFS_out.*mask;
SFW_out = SFW_out.*mask;
SVOL_out = SVOL_out.*mask;
JT_out = JT_out.*mask;
Pmill_out = Pmill_out.*mask;
CFD_out = CFD_out.*mask;
MIW_out = MIW_out.*mask;
PSE_out = PSE_out.*mask;

%% Introduce random outliers and missing values to measured variables

missing_rate = 0.5; % of values missing (replaced with NaN)

outlier_rate = 0.5; % of values replaced with an outlier
outlier_max = 30; % max outlier value is 30% error
outlier_min = 60; % min outlier value is 60% of actual value

% creat data dictionary object
dict.names = {'CFF','MFS','SFW','SVOL','JT','Pmill','CFD','MIW','PSE'};
dict.t = tout;
dict.CFF = CFF_out;
dict.MFS = MFS_out;
dict.SFW = SFW_out;
dict.SVOL = SVOL_out;
dict.JT = JT_out;
dict.Pmill = Pmill_out;
dict.CFD = CFD_out;
dict.MIW = MIW_out;
dict.PSE = PSE_out;
dict.test.alpha_r = alpha_r_out;
dict.test.phi_f = phi_f_out;

fields = fieldnames(dict);

outliercols = {'CFF','MFS','SFW','SVOL','JT','Pmill','CFD','MIW'};

for field = 1:length(fields)
    % check if this field is in the columns to add outliers/missing values:
    if any(strcmp(outliercols,fields{field}))
        field_values = getfield(dict,fields{field});
        
        % add some outliers:
        % only apply to outlier_rate% of values:
        outlier_rand = rand(size(field_values));
        outlier_mask = outlier_rand <= outlier_rate/100;
        
        OldMin = 0;
        OldMax = 1;
        NewMin = outlier_min/100;
        NewMax = 1 + outlier_max/100;
        OldRange = (OldMax - OldMin);
        NewRange = (NewMax - NewMin);
        outlier_range = rand(size(field_values(outlier_mask)));
        outlier_range = (outlier_range - OldMin).*NewRange./OldRange + NewMin;
        
        field_values(outlier_mask) = field_values(outlier_mask).*outlier_range;
        
        % add some random nan values:
        % only apply to missing_rate% of values:
        missing_rand = rand(size(field_values));
        missing_mask = missing_rand <= missing_rate/100;
        
        field_values(missing_mask) = nan;
        
        dict = setfield(dict, fields{field}, field_values);
    end
end

missing_mask = isnan(dict.SFW);
tvals = 1:length(dict.SFW);

% figure;
% hold on;
% plot(tvals,dict.SFW,'b');
% plot(tvals,SFW_out,'g');
% plot(tvals(missing_mask),SFW_out(missing_mask),'xr');
% hold off;

%% Subsample PSE to one value per shift
PSE_original = PSE_out;
dict.test.PSE = PSE_original;
PSE_temp = zeros(size(PSE_out));

% sampling frequency
PSE_f = 4*60*2; % 8 hours x 60 minutes per hour x 2 samples per minute

% assume grab sample consists of average of PSE over last hour of shift
PSE_window = 1*60*2; % 1 hours x 60 minutes per hour x 2 samples per minute

PSE_idx = PSE_f:PSE_f:length(PSE_out);

for i = PSE_idx
    PSE_temp(i) = mean(PSE_out(i-PSE_window:i));
end

dict.PSE = PSE_temp;

% figure;
% hold on;
% plot(PSE_out)
% plot(PSE_idx,PSE_temp(PSE_idx),'o')
% hold off;

%% Save outputs to a .mat file:
if RandomSeedNumber == 1
    save('MMM2019_training_data.mat','dict');
else
    save('MMM2019_test_data.mat','dict');
end