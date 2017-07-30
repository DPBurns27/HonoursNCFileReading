clear
clc
close all

%% Parameters

ncvariablename = 'tbot';

%% Loading data

% Gets the directory of the script
scriptloc = fileparts(mfilename('fullpath'));

% Opens the matrix of data
loadedmat = load([scriptloc,'/MatFiles/',ncvariablename,'.mat']);
% How do i refer to this variable without knowing the name of it?
ncmat = loadedmat{1};
load([scriptloc, '/MatFiles/lon.mat']);
load([scriptloc, '/MatFiles/lat.mat']);

% Grab the start and end points of the domain
latlim = [lat(end) lat(1)];% Do I need to adjust this to include the whole edge of the 
lonlim = [lon(1) lon(end)];% domain? This will only give the centre points

% Opens up the gshhs file to import high definition coastal data: _i is
% medium res, _f is full resolution
S = gshhs('gshhs_i.b', latlim, lonlim);
% Pulls out the different levels of the map ie, coastline, rivers, etc
levels = [S.Level];
% Picks out just the coastal data
L1 = S(levels == 1);

% Gets the directory of the script
%loc = fileparts(mfilename('fullpath'));

% Load in the Great Barrier Reef coordinates
[GBRlong, GBRlat] = GBRCoords();
% Cut off the coastline section of the reef
GBRlong = GBRlong(1:8);
GBRlat = GBRlat(1:8);

%% Plot the nc data

figure
hold on

% Sets the projection type, and axis limits of the map
axesm('mercator', 'MapLatLimit', latlim, 'MapLonLimit',lonlim)
gridm; mlabel; plabel
% Changes the distance between subdivisions of the grid
setm(gca, 'MLineLocation', 5, 'MLabelLocation', 5, 'PLineLocation', 5, 'PLabelLocation', 5)

% Sets the image location
R = georasterref('RasterSize',size(interppdf),...
    'Latlim',latlim, 'Lonlim', lonlim);
% Plots the pdf onto the map defined above
geoshow(interppdf, R, 'DisplayType', 'texturemap')
%geoshow(Y,X)

% Sets the colormap for the pdf
mycmap = (flipud(gray(visLevels-1)));
colormap(mycmap)

% Force the colormap to use preset min and max values
caxis([cmin,cmax])

% Plots the coastal data on the map
geoshow([L1.Lat], [L1.Lon], 'Color', 'blue')

% Plots the GBR on the map
geoshow(GBRlat, GBRlong, 'Color', 'red')

% Plots the contour lines of the pdf
%contourlines = linspace(min(min(interppdf)),max(max(interppdf)),visLevels);
contourlines = linspace(cmin,cmax,visLevels);
contplot = contourm(interppdf,R,contourlines(2:end),'Color','black');

tightmap

cbar = colorbar;
cbar.Label.String = 'Fraction of trajectory points';

set(gcf,'Renderer','zbuffer')

hold off

