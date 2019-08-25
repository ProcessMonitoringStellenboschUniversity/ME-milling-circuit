%% Clean workspace
clear;clc

%% Define inputs
var = (-1:0.01:1)';

u2 = var>=0; %Unit Step used for Sump Feed Water (SFW)
u3 = var.*u2; %Ramp used for Sump Water Flow In (Vswi)
u1(1:length(var),1) = 2; %Constant used for Cyclone Feed Flow (CFF)

t = linspace(0,10,length(var))';

%% Plot inputs
plot(t,[u1,u2,u3])
xlabel('Time (sec)')
ylabel('Flow rate (m^3/hr)')
legend({'u1 (CFF)','u2 (SFW)','u3 (Vswi)'})
ylim([0,2.5])