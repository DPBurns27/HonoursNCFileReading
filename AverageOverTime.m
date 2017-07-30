%function [] = AverageOverTime(loc)
clear
clc
close all

% Averages the time out of panoply exported files producing a map of
% whatever data was exported
loc = '/Volumes/Iron/CCAM_Data/tbot.txt';

% Number of lat, long points
n = 451;
% Number of time points
t = 744;
totalpoints = n*n*t;
% Column of interest
c = 4;

mapdata = zeros(n,n);
f = fopen(loc);

%lat = y
%lon = x

%Read first line for the headings
tline = fgetl(f);

for i = 1:t
    for y = 1:n
        for x = 1:n
            
            % Read the line
            tline = fgetl(f);
            % Split the line up
            tlinesplit = strsplit(tline);
            % Add the final number in the line to the right location in the
            % map matrix
            mapdata(x,y) = mapdata(x,y) + str2double(tlinesplit{c});
            
        end
    end
    
    % Display percentage complete
    disp((i*n*n/totalpoints)*100)

end
mapdata = mapdata./t;
fclose(f);
save('/Volumes/Iron/CCAM_Data/mapdata.mat','mapdata')