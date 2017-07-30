clc
clear
close all

%% Parameters

% Name of the variable to be extracted
variablename = 'tbot';
% Where to start in the dimensions of the file (lat, lon, plev, time)
varstart = [1 1 1];
% Where to end in the dimensions of the file (lat, lon, plev, time)
varend = [Inf Inf Inf];
% Which variable to calculate the mean for
meanovervar = 3;

%% Read, average and output variables from nc file

% Bring in the variable from file
ncdata = ncread(['Data/ccam_',variablename,'.nc'], variablename, varstart, varend);

% Calculate the mean over one of the dimensions
ncdata = mean(ncdata, meanovervar);

% Output to mat file
save(['MatFiles/',variablename,'.mat'],'ncdata')

% Quick visualisation
imagesc(ncdata)
