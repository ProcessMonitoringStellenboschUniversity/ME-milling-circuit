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

%% displayplots.m
% Displays figures of the simulation results with respect to time.

%% PROCESS INPUTS
figure;
%Cyclone feed flow rate
subplot(6,1,1);
hold on
plot(tout(ind(1:indf)),CFF_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),CFF_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 300 500]);
xlabel('t [days]'), ylabel('CFF [m^3/h]');

%Mill feed solids
subplot(6,1,2);
hold on
plot(tout(ind(1:indf)),MFS_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),MFS_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 55 75]);
xlabel('t [days]'), ylabel('MFS [t/h]');

%Sump feed water
subplot(6,1,3);
hold on
plot(tout(ind(1:indf)),SFW_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),SFW_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 100 250]);
xlabel('t [days]'), ylabel('SFW [m^3/h]');

%Fraction rocks in feed ore
subplot(6,1,4);
hold on
plot(tout(ind(1:indf)),alpha_r_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),alpha_r_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 0.4 0.55]);
xlabel('t [days]'), ylabel('\alpha_r [Fract]');

%Power needed per tonne of fines produced
subplot(6,1,5);
hold on
plot(tout(ind(1:indf)),phi_f_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),phi_f_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 25 35]);
xlabel('t [days]'), ylabel('\phi_f [kWh/t]');

%Mill inlet water
subplot(6,1,6);
hold on
plot(tout(ind(1:indf)),MIW_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),MIW_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 3 8]);
xlabel('t [days]'), ylabel('MIW [m^3/h]');

%% PROCESS OUTPUTS
figure;
%Sump volume
subplot(5,1,1);
hold on
plot(tout(ind(1:indf)),SVOL_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),SVOL_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 5 8]);
xlabel('t [days]'), ylabel('SVOL [m^3]');

%Mill charge
subplot(5,1,2);
hold on
plot(tout(ind(1:indf)),JT_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),JT_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 0.25 0.45]);
xlabel('t [days]'), ylabel('JT [Fract]');

%Mill power draw
subplot(5,1,3);
hold on
plot(tout(ind(1:indf)),Pmill_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),Pmill_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 1100 1250]);
xlabel('t [days]'), ylabel('P_m_i_l_l [kW]');

%Cyclone feed density
subplot(5,1,4);
hold on
plot(tout(ind(1:indf)),CFD_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),CFD_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 1.6 1.8]);
xlabel('t [days]'), ylabel('CFD [t/m^3]');

%Particle size estimate
subplot(5,1,5);
hold on
plot(tout(ind(1:indf)),PSE_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),PSE_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 0.6 0.85]);
xlabel('t [days]'), ylabel('PSE [Fract]');