tout = dict.t;
CFF_out = dict.CFF;
MFS_out = dict.MFS;
SFW_out = dict.SFW;
SVOL_out = dict.SVOL;
JT_out = dict.JT;
Pmill_out = dict.Pmill;
CFD_out = dict.CFD;
MIW_out = dict.MIW;
PSE_out = dict.PSE;
alpha_r_out = dict.test.alpha_r;
phi_f_out = dict.test.phi_f;

% Indices for Samples before fault starts:
% 30 days x 24 hours per day x 60 minutes per hour x 2 samples per minute
tNOCStart = 1;
tNOCEnd = tNOCStart + 30*24*60*2;
tTestStart = tNOCEnd + 1;
tTestEnd = tNOCEnd + 15*24*60*2;

% Define fault start time
tFaultStart = tTestEnd+1;
tFaultEnd = tTestEnd+10*24*60*2;

% Resample data from Deltat = 0.0083 h/(24 h/day) to Deltat = 1 h
ind = find(rem(tout*24,1)==0);
indf = find(tout(ind)==45);

%% PROCESS INPUTS
figure;
%Cyclone feed flow rate
subplot(4,1,1);
hold on
plot(tout(ind(1:indf)),CFF_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),CFF_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 300 500]);
xlabel('t [days]'), ylabel('CFF [m^3/h]');

%Mill feed solids
subplot(4,1,2);
hold on
plot(tout(ind(1:indf)),MFS_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),MFS_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 55 75]);
xlabel('t [days]'), ylabel('MFS [t/h]');

%Sump feed water
subplot(4,1,3);
hold on
plot(tout(ind(1:indf)),SFW_out(ind(1:indf)),'k')
plot(tout(ind(indf:end)),SFW_out(ind(indf:end)),'Color',[0.5 0.5 0.5])
hold off
axis([0 tout(end) 100 250]);
xlabel('t [days]'), ylabel('SFW [m^3/h]');

%Mill inlet water
subplot(4,1,4);
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
plot(tout(dict.PSE > 0),PSE_out(dict.PSE > 0),'.k')
hold off
axis([0 tout(end) 0.6 0.85]);
xlabel('t [days]'), ylabel('PSE [Fract]');