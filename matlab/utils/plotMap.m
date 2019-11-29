function [wh]=plotMap(varargin)
%% PLOTMAP: Base Function for plotting regional maps and shapefiles
%   This function should be thinked as initial step for plotting routine,
%   such any geographical information on MATLAB
%
%   Input:
%   - 'ScaleBar',(float,[0])
%       If not 0, plots a scale bar of given km to compare the distance in map.
%   - 'Region',(matrix,[])
%       If not empty it will constrain the plotted area in the region
%        2x2 matrix: lowleft -upright corners (LAT,LON)
%                        LAT | LON                   
%               origin |(1,1)|(1,2)
%                  end |(2,1)|(2,2) 
%   - 'ShapeFile',(str,[])
%       If PlotMap is TRUE, then the given shapefile path will be used
%   - 'HandleFig',(matobj,[])
%       If specified, the map will be plotted there, otherwise a new one is
%       created.
%
%   Out:
%   - wh: map axis handle
%   - wh: map axis handle
%
%   USAGE: PLOTMAP(varargin)
%   AUTHOR: Matteo Bagagli @ ETH-Zurich 1119
%

%    VELEST2MAT: collection of bash-script/Matlab functions for 
%                plotting VELEST v4.5 results.
%    Copyright (C) 2018  Matteo Bagagli
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


%% INPUTS
Def=struct( ...
    'ShapeFile', [], ... % FilePath - If user wants to plot NATIONAL BOUNDS    
    'ScaleBar',[], ...
    'Region',[], ...
    'HandleFig',[] ...
    );
Args=parseArgs(Def,varargin);
%
if isempty(Args.Region)
    error('### plotMap: ERROR !! Please Specify a REGION!!')
end

%% PLOT

if ~isempty(Args.Region)
    minLat=Args.Region(1,1);
    maxLat=Args.Region(2,1);
    minLon=Args.Region(1,2);
    maxLon=Args.Region(2,2);
else
    % Taking into account the +/- degree for map selection
    minLat=1;
    maxLat=89;
    minLon=-175;
    maxLon=175;
end

if isempty(Args.HandleFig)
    figure();
end

hold on
wh = worldmap([minLat maxLat],[minLon maxLon]);
setm(wh, 'ffacecolor', [204 255 255]/255);  % create background color, usually water   
if ~isempty(Args.ShapeFile)
    % Append SHAPEFILE
    % To select the interested region, the map is enlarged of few degress 
    Map_Around = shaperead(Args.ShapeFile, ...
                          'UseGeoCoords', true, ...
                          'Selector',{@(v1,v2) (( v1>= minLon-5)&&( v1<= maxLon+5) && (v2 >= minLat-1) && (v2 <= maxLat+1)),'LON','LAT'});     
    geoshow(Map_Around,'FaceColor',[0.9 0.9 0.9],'EdgeColor',[0.5 0.5 0.5])    
end
hold off

end % Function end






