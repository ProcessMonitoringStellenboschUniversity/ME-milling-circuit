%% SAG Mill Simulator
% Based on model described in le Roux et al. (2013), available at
% http://dx.doi.org/10.1016/j.mineng.2012.10.009

% Developed by BJ Wakefield and L Auret, 2015, 2017
% Presented at MEi Comminution, Cape Town, 2016
% Updated by JT McCoy, 2017, 2018
% Accepted by Minerals Engineering, 2018

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

%% generate_data_SAGmill.m

% Runs the Simulink mill circuit simulation, and saves the data

% For quick automatic data generation:
%   (1) Specify the faults to be simulated in the 'faults' variable
%   (cell array) (defined in main.m)
%   (2) Specify the time in hours at which the fault manifests in
%   fault_time (default is 104 days).
%   (3) Specify the time in hours at which the simulation ends in
%   stop_time (default is 30 days after fault_time).
%
% Simulation data is stored in the 'data' variable (table). The columns of
% 'data' are time and all the process variabels. Process variables with the
% prefic 'RAW_' are non-sensor values and do not have added sensor noise.
% Note that the 'data' variable is not saved as part of the save file
% generated after each run; if you wish to access the denoised data you
% will have to modify the code for the savefile.
%
% If the simulation crashes it may be due to a bad set of seeds affecting
% process and sensor noise which causes the control system to act too
% aggressively. Rerun the script to generate a new set of seeds.

%% Specify fault, fault time and stop time
faultsvec = {'pse sensor','liner wear','no fault'};
fault = faultsvec(faultmode); % faultmode specified in main.m

fault_time = 24*45; % default 30 days NOC, 15 days NOC test
stop_time = 24*15+fault_time; % default 15 days fault data

%% Run simulation
clear options;

rng(RandomSeedNumber); % use specified random seed
fprintf('Run started at %s\n',datestr(now));

[options,seeds] = params_SAGmill('fault',fault,'fault time',fault_time,'stop time',stop_time);
sim('MillCircuit');

%% Preprocess data

element_list = getElementNames(logsout);
element = logsout.get(element_list{1});
time = element.Values.Time;
idx_del = find(time>=50,1); % Delete 50 hours of start-up data, see params_SAGmill
time = time(idx_del:end)-50;
A = time;
for idx_element = 1:length(element_list)
    element = logsout.get(element_list{idx_element});
    A = cat(2,A,element.Values.Data(idx_del:end));
end
data = array2table(A,'VariableNames',{'time',element_list{:}});
clear A element_list element idx_element time idx_del logsout;

tout = (data.time);
CFF_out = (data.CFF);
MFS_out = (data.MFS);
MIW_out = (data.MIW);
SFW_out = (data.SFW);
SVOL_out = (data.SVOL);
JT_out = (data.JT);
Pmill_out = (data.Pmill);
CFD_out = (data.CFD);
PSE_out = (data.PSE);
alpha_r_out = data.alpha_r;
phi_f_out = data.phi_f;

if strcmp(fault,'pse sensor')
    faultname = 'PSEfault';
elseif strcmp(fault,'liner wear')
    faultname = 'MLWfault';
else
    faultname = 'NoFault';
end

%% Save data
savefile = strcat('SimData',int2str(RandomSeedNumber),faultname);
save(savefile,'tout','CFF_out','MFS_out','SFW_out','SVOL_out','JT_out','Pmill_out','CFD_out','PSE_out','alpha_r_out','phi_f_out','MIW_out');
fprintf('Run completed at %s\n',datestr(now));
