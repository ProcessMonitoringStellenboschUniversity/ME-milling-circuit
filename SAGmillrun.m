%% SAG Mill Simulator
% Based on model described in le Roux et al. (2013), available at
% http://dx.doi.org/10.1016/j.mineng.2012.10.009

% Developed by BJ Wakefield and L Auret, 2015
% Presented at MEi Comminution, Cape Town, 2016
% Updated by JT McCoy, 2017
% Submitted to Minerals Engineering, 2017

% Copyright (C) 2015, 2016, 2017 L Auret, BJ Wakefield, JT McCoy
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

%% SAGmillrun.m
% Runs the Simulink mill circuit simulation, and saves the data

%% CREATE SAVEDATA DIRECTORY FOR CURRENT RUN
    DateString = datestr(now,'mmmm-dd-HHMM');
    savedir = strcat('/save/',DateString,'/');
    mkdir(strcat('.',savedir));
    diary([pwd strcat(savedir,'commandwindow.txt')]);
    diary on;
    fprintf('Run started at %s\n',datestr(now));
             
%% EXECUTE PROGRAM MODE
run 'loadparameters.m'; % load parameters for simulation

switch mode
	case 1
        disp('Initiating PSE sensor fault simulation. WARNING: May take a while due to large number of data points.');
		PSE_fault = 1;
        
    case 2
        disp('Initiating liner wear fault simulation. WARNING: May take a while due to large number of data points.');
		Linerwear_fault = 1;
        
    otherwise
        disp('Initiating simulation with no active faults.');
end %end switch

%% Run simulation, process data and generate plots
    sim('MillCircuit');

    %RAW DATA PREPROCESSING
    %Preprocesses simulation data, by dividing into data sections
    %and removing initial simulation to steady state.
    startindex = find(tout >= t,1,'first');
    NOCteststart = find(tout >= testtime,1,'first')-startindex;
    Faultstart = find(tout >= faulttime,1,'first')-startindex;

    %Truncate data to remove the run up to steady state
        %TIME
        tout = tout(startindex:end)-t; % Variable 0
        %MONITORED INPUTS
        CFF_out = CFF_out(startindex:end); % Variable 1
        MFS_out = MFS_out(startindex:end); % Variable 2
        SFW_out = SFW_out(startindex:end); % Variable 3
        %CONSTANTS
        MIW_out = MIW_out(startindex:end);
        MFB_out = MFB_out(startindex:end);
        alpha_speed_out = alpha_speed_out(startindex:end);
        %DISTURBANCES
        alpha_r_out = alpha_r_out(startindex:end);
        phi_f_out = phi_f_out(startindex:end);
        %MONITORED OUTPUTS
        SVOL_out = SVOL_out(startindex:end); % Variable 4 
        JT_out = JT_out(startindex:end); % Variable 5
        Pmill_out = Pmill_out(startindex:end); % Variable 6
        CFD_out = CFD_out(startindex:end); % Variable 7
        PSE_out = PSE_out(startindex:end); % Variable 8

%% Save run
    save([pwd strcat(savedir,'workspace.mat')]);
    fprintf('Run completed at %s\nAll data saved to %s\n',datestr(now),savedir);
    diary off;