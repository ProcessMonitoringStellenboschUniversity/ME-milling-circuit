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

%% params_SAGmill

% Loads simulation parameters for the SAG milling circuit.

% Some options may be set inside the function call by specifying
% name-value pairs. These are:
%       'seeds' - seed values for process and sensor noise (18x1 double)
%       'fault' - fault selection ('none','pse sensor','liner wear')
%       'fault time' - time after which fault manifests
%       'stop time' - time at which simulation ends
% 
% NOTE: The simulation requires up to 50 hours (simulation time) to reach
% steady state. No noise is added during this time. The first 50 hours of
% simulation time must be removed. The remaining data will be stationary
% state up to the fault manifestation time.
% 
% Edit this file or the 'options' variable to change parameters in the
% simulation such as sensor noise, process noise, fault severity, etc.

%% Start function
function [options,seeds] = params_SAGmill(varargin)

seeds = randi(100,18,1);
fault = 'none';
fault_time = 50;
stop_time = 50;

args = varargin;
nargs = length(args);
if ~isempty(args)
    for i = 1:2:nargs
        switch args{i}
            case 'seeds'
                seeds = args{i+1};
            case 'fault'
                fault = args{i+1};
            case 'fault time'
                fault_time = args{i+1}+50;
            case 'stop time'
                stop_time = args{i+1}+50;
            otherwise
                error('Invalid argument: %s',args{i});
        end
    end
end

options = struct('model_params',struct(),'initial_state',struct(),...
                'control_system',struct(),'process_noise',struct(),...
                'sensor_noise',struct(),'faults',struct(),...
                'simulation',struct());

%FITTED MODEL PARAMETERS (Le Roux et al., 2013)
    % STATES CLASSIFICATION
    % Rocks > 22.4 mm
    % Solids <= 22.4 mm
    % Fines <= 75 um
%Mill module
options.model_params.alpha_f = 0.055; %Fraction fines in feed ore
options.model_params.alpha_r = 0.465; %Fraction rocks in feed ore
options.model_params.alpha_P = 1; %Fractional power reduction per fractional reduction from mill speed
options.model_params.alpha_speed = 0.712; %Fraction of critical mill speed
options.model_params.alpha_phif = 0.01; %Fractional change in kW/fines produced per change in fractional filling of mill
options.model_params.delta_Ps = 0.5; %Power-change parameter for fraction solids in the mill
options.model_params.delta_Pv = 0.5; %Power-change parameter for volume of mill filled
options.model_params.DB = 7.85; %Density of steel balls %t/m^3
options.model_params.DS = 3.2; %Density of feed ore %t/m^3
options.model_params.eps_sv = 0.6; %Maximum fraction solids in slurry at no flow (vol)
options.model_params.phi_b = 90.0; %Steel abrasion factor %kWh/t
options.model_params.phi_f = 29.6; %Power needed per tonne of fines produced %kWh/t
options.model_params.phi_r = 6.03; %Rock abrasion factor %kWh/t
options.model_params.rhe_Pmax = 0.57; %Rheology factor at max mill power draw
options.model_params.P_max = 1662; %Maximum mill motor power draw %kW
options.model_params.v_mill = 59.12; %Mill volume %m^3
options.model_params.v_Pmax = 0.34; %Fraction of mill volume filled for maximum power draw
options.model_params.V_V = 84.0; %Volumetric flow per "flowing volume" driving force %h^-1
options.model_params.chi_P = 0; %Cross-term for maximum power draw
%Sump module
options.model_params.SVOL = 5.99; %Sump volume %m^3
options.model_params.Asump = 1.1*3.2; %Sump crossectional area %m^2
%Hydrocyclone module
options.model_params.alpha_su = 0.87; %Related to fraction solids in underflow
options.model_params.C1 = 0.6; %Constant
options.model_params.C2 = 0.7; %Constant
options.model_params.C3 = 4; %Constant
options.model_params.C4 = 4; %Constant
options.model_params.eps_c = 129; %Related to coarse split %m^3/h

%INITIAL DATA TAKEN FROM SURVEY 3 (Le Roux et al., 2013)
options.initial_state.MIW = 4.64; %Mill Inlet Water %m^3/hr
options.initial_state.MFS = 65.2; %Mill Feed Solids %t/hr
options.initial_state.MFB = 5.69; %Mill Feed Balls %t/hr
options.initial_state.SFW = 140.5; %Sump Feed Water $m^3/hr
options.initial_state.CFF = 374; %Cyclone Feed Flowrate %m^3/hr
options.initial_state.PSE = 0.67; %Particle Size Estimate
options.initial_state.Pmill = 1183; %Mill Powerdraw %kW
options.initial_state.CFD = 1.6863; %Cyclone feed density %t/m^3
options.initial_state.Xmbs = 8.51; %Mill balls %m^3
options.initial_state.Xmfs = 1.09; %Mill fines %m^3
options.initial_state.Xmrs = 1.82; %Mill rocks %m^3
options.initial_state.Xmss = 4.90; %Mill solids %m^3
options.initial_state.Xmws = 4.85; %Mill water %m^3
options.initial_state.Xsfs = 0.42; %Sump fines %m^3
options.initial_state.Xsss = 1.88; %Sump solids %m^3
options.initial_state.Xsws = 4.11; %Sump water %m^3
options.initial_state.JT = (options.initial_state.Xmbs + options.initial_state.Xmrs ...
                            + options.initial_state.Xmss + options.initial_state.Xmws) ...
                            / options.model_params.v_mill; %Mill charge fraction

%CONTROL SYSTEM (PI SINGLE LOOPS from Wakefield et al., 2017)
%Sump volume controller
options.control_system.SVOL_SP = options.model_params.SVOL;        
options.control_system.K1 = 20;
options.control_system.TI1 = 0.25;
options.control_system.tauf1 = 0.02;
%Mill charge controller
options.control_system.JT_SP = options.initial_state.JT;
options.control_system.K2 = 42.1;
options.control_system.TI2 = 9.46;
options.control_system.tauf2 = 0.02;
%PSE controller
options.control_system.PSE_SP = options.initial_state.PSE;
% options.control_system.K3 = 928.6; 
options.control_system.K3 = 0;
options.control_system.TI3 = 4.54;
options.control_system.tauf3 = 0.02;

%PROCESS NOISE (RANDOM WALK)
%ON/OFF times
options.process_noise.time_on = 50;
options.process_noise.time_off = stop_time;
%Mill inlet water
options.process_noise.gradient_MIW = 0; 
options.process_noise.MIW_randomwalk = 1; % set to 0 for initial walk, set to >0 for steady state (and therefore a manipulatable variable)
options.process_noise.seed_MIW = seeds(1); %Random seed
options.process_noise.sample_MIW = 0.5; %Period for gradient changes (hours)
options.process_noise.UB_MIW = 1.05*options.initial_state.MIW; %Upper bound of variation
options.process_noise.LB_MIW = 0.95*options.initial_state.MIW; %Lower bound of variation
%Mill feed balls
options.process_noise.gradient_MFB = 0; 
options.process_noise.seed_MFB = seeds(2); %Random seed
options.process_noise.sample_MFB = 1; %Period for gradient changes
options.process_noise.UB_MFB = 1.05*options.initial_state.MFB; %Upper bound of variation
options.process_noise.LB_MFB = 0.95*options.initial_state.MFB; %Lower bound of variation
%Fraction rocks in feed ore
options.process_noise.gradient_alpha_r = 0.002; %Change in fraction rocks in feed ore
options.process_noise.seed_alpha_r = seeds(3); %Random seed
options.process_noise.sample_alpha_r = 2.5; %Period for gradient changes (hours)
options.process_noise.UB_alpha_r = 1.1*options.model_params.alpha_r; %Upper bound of variation
options.process_noise.LB_alpha_r = 0.9*options.model_params.alpha_r; %Lower bound of variation
%Mill speed
options.process_noise.gradient_alpha_speed = 0; 
options.process_noise.seed_alpha_speed = seeds(4); %Random seed
options.process_noise.sample_alpha_speed = 0.5; %Period for gradient changes (hours)
options.process_noise.UB_alpha_speed = 1.05*options.model_params.alpha_speed; %Upper bound of variation
options.process_noise.LB_alpha_speed = 0.95*options.model_params.alpha_speed; %Lower bound of variation
%Power needed per tonne of fines produced
options.process_noise.gradient_phi_f = 0.2; %Change in power needed per tonne of fines produced
options.process_noise.seed_phi_f = seeds(5); %Random seed
options.process_noise.sample_phi_f = 1; %Period for gradient changes (hours)
options.process_noise.UB_phi_f = 1.05*options.model_params.phi_f; %Upper bound of variation
options.process_noise.LB_phi_f = 0.95*options.model_params.phi_f; %Lower bound of variation

%SENSOR NOISE
%ON/OFF times
options.sensor_noise.time_on = 50;
options.sensor_noise.time_off = stop_time;
%Gaussian noise standard deviation (STDEV = FRAC*PV)
options.sensor_noise.global_frac = 0.01; %Fraction of measured variable
%Seeds
options.sensor_noise.seed_MIW = seeds(6);
options.sensor_noise.seed_MFS = seeds(7);
options.sensor_noise.seed_MFB = seeds(8);
options.sensor_noise.seed_alpha_r = seeds(9);
options.sensor_noise.seed_phi_f = seeds(10);
options.sensor_noise.seed_alpha_speed = seeds(11);
options.sensor_noise.seed_JT = seeds(12);
options.sensor_noise.seed_Pmill = seeds(13);
options.sensor_noise.seed_SFW = seeds(14);
options.sensor_noise.seed_CFF = seeds(15);
options.sensor_noise.seed_SVOL = seeds(16);
options.sensor_noise.seed_CFD = seeds(17);
options.sensor_noise.seed_PSE = seeds(18);
%Measurement delays(inferred measurements)
options.sensor_noise.delay_phi_f = 1/60; %Hours
options.sensor_noise.delay_JT = 1/60; %Hours
options.sensor_noise.delay_PSE = 1/60; %Hours

%FAULTS
%PSE sensor bias
options.faults.PSE_sensor = 0; 
options.faults.PSE_time_on = stop_time;
options.faults.PSE_time_off = stop_time;
    if strcmp(fault,'pse sensor')
        options.faults.PSE_sensor = 1; %Activate fault
        options.faults.PSE_time_on = fault_time; %Set fault start time
    end
options.faults.PSE_sensor_bias = -0.05; %Fraction bias in sensor reading
%Mill liner wear (power transfer to rock consumption)
options.faults.liner = 0;
options.faults.liner_time_on = stop_time;
options.faults.liner_time_off = stop_time;
    if strcmp(fault,'liner wear')
        options.faults.liner = 1; %Activate fault
        options.faults.liner_time_on = fault_time; %Set fault start time
    end
options.faults.liner_powerloss = 0.25; %Maximal loss in power transfer to charge 
options.faults.liner_powerloss_gradient = 1/(24*30*1); %Increase in fraction of maximal powerloss per hour (default maximal powerloss in 1 months)

%SIMULATION OPTIONS
options.simulation.errortol = 1e-5; %Error tolerance
options.simulation.stoptime = stop_time; %Time to end simulation
options.simulation.sampling = 30/3600; %Sensor sampling rate (default 1 sample every 30 sec)
end