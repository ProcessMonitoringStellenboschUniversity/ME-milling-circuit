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

%% main_MMM2019workshop.m
% Main code to load data for soft sensor workshop at MMM 2019 and plot the
% variables

%% Initialise workspace
close all; clear; clc;

%% Load struct of data
load('MMM2019_training_data.mat');

run 'displaytimeplots_MMM.m';