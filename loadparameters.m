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

%% loadparameters.m
% Loads all the default parameters for the simulation program

%% FITTED MODEL PARAMETERS (Le Roux et al., 2013)
%STATES CLASSIFICATION
%Rocks > 22.4 mm
%Solids <= 22.4 mm
%Fines <= 75 um    

    %Mill module
    alpha_f = 0.055; %Fraction fines in feed ore
    alpha_r = 0.465; %Fraction rocks in feed ore
    alpha_P = 1; %Fractional power reduction per fractional reduction from mill speed
    alpha_speed = 0.712; %Fraction of critical mill speed
    alpha_phif = 0.01; %Fractional change in kW/fines produced per change in fractional filling of mill
    delta_Ps = 0.5; %Power-change parameter for fraction solids in the mill
    delta_Pv = 0.5; %Power-change parameter for volume of mill filled
    DB = 7.85; %Density of steel balls %t/m^3
    DS = 3.2; %Density of feed ore %t/m^3
    eps_sv = 0.6; %Maximum fraction solids in slurry at no flow (vol)
    phi_b = 90.0; %Steel abrasion factor %kWh/t
    phi_f = 29.6; %Power needed per tonne of fines produced %kWh/t
    phi_r = 6.03; %Rock abrasion factor %kWh/t
    rhe_Pmax = 0.57; %Rheology factor at max mill power draw
    P_max = 1662; %Maximum mill motor power draw %kW
    v_mill = 59.12; %Mill volume %m^3
    v_Pmax = 0.34; %Fraction of mill volume filled for maximum power draw
    V_V = 84.0; %Volumetric flow per "flowing volume" driving force %h^-1
    chi_P = 0; %Cross-term for maximum power draw
    
    %Sump module
    SVOL = 5.99; %Sump volume %m^3
    Asump = 1.1*3.2; %Sump crossectional area %m^2

    %Hydrocyclone module
    alpha_su = 0.87; %Related to fraction solids in underflow
    C1 = 0.6; %Constant
    C2 = 0.7; %Constant
    C3 = 4; %Constant
    C4 = 4; %Constant
    eps_c = 129; %Related to coarse split %m^3/h
    
%% INITIAL DATA TAKEN FROM SURVEY 3 (Le Roux et al., 2013)
    MIW = 4.64; %Mill Inlet Water %m^3/hr
    MFS = 65.2; %Mill Feed Solids %t/hr
    MFB = 5.69; %Mill Feed Balls %t/hr
    SFW = 140.5; %Sump Feed Water $m^3/hr
    CFF = 374; %Cyclone Feed Flowrate %m^3/hr
    PSE = 0.67; %Particle Size Estimate
    Pmill = 1183; %Mill Powerdraw %kW
    CFD = 1.6863; %Cyclone feed density %t/m^3
    Xmbs = 8.51; %Mill balls %m^3
    Xmfs = 1.09; %Mill fines %m^3
    Xmrs = 1.82; %Mill rocks %m^3
    Xmss = 4.90; %Mill solids %m^3
    Xmws = 4.85; %Mill water %m^3
    Xsfs = 0.42; %Sump fines %m^3
    Xsss = 1.88; %Sump solids %m^3
    Xsws = 4.11; %Sump water %m^3
    JT = (Xmbs+Xmrs+Xmss+Xmws)/v_mill;
     
%% CONTROL SYSTEMS (PI SINGLE LOOP)
    %Sump volume controller
        SVOLSP = SVOL;        
        K1 = 20;
        TI1 = 0.25;
        tauf1 = 0.02;
    %Mill charge controller
        JTSP = JT;
        K2 = 42.1;
        TI2 = 9.46;
        tauf2 = 0.02;
    %PSE controller
        PSESP = PSE;
        K3 = 928.6; 
        TI3 = 4.54;
        tauf3 = 0.02;
                
%% FAULT DETECTION AND IDENTIFICATION TESTING
    %Set simulation times
        %The simulation requires up to time t hours to go to steady state.
        %The data will be more useful if the initial variation is removed,
        %representing more of normal operation.
        
        %NOCtrain = 90 days; NOCtest = 14 days; FAULT = 30 days
        
        t = 50;
        errortol = 1e-3;
        simtime = 3220 + t; %to end
        testtime = 2160 + t; %to trigger generation of NOCtest data
        faulttime = 2500 + t; %to trigger generation of fault data
        sampletime = 30/3600; %how often data is logged %seconds^-1
        tout = (0:sampletime:simtime)';
    
    %Set noise parameters
        %random walk process noise
            alpha_r_grad = 0.02; %Change in fraction rocks in feed ore
            alpha_r_UB = 1.1*alpha_r; %Upper bound of variation
            alpha_r_LB = 0.9*alpha_r; %Lower bound of variation

            phi_f_grad = 0.4; %Change in power needed per tonne of fines produced
            phi_f_UB = 1.1*phi_f; %Upper bound of variation
            phi_f_LB = 0.9*phi_f; %Lower bound of variation

        %sensor noise
            %inputs
            noise = 0.02; %Percentage variation
            JT_delay = 1/60; %Hours (inferred measurement)
            PSE_delay = 1/60; %Hours (inferred measurement)

    %Fault conditions
            PSE_fault = 0; %Trigger PSE sensor fault
            PSE_bias = 0.05; %Percentage bias lower than expected output
            Linerwear_fault = 0; %Trigger mill liner wear fault
            Linerwear_powerloss = 0.15; %Percentage decrease in power transfer to rock consumption