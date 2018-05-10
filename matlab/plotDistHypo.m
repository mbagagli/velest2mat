function [ax,s]=plotDistHypo(EQFile,opt,varargin)
%% PLOTDISTHYPO: Simple function that creates a section LAT//LON - depth.
%   - Input file must be a in *.latlondepmag format (''vel2mat.sh'')
%   INPUTS:
%   - opt, str({'LAT','LON'})
%       Define the section direction
%   - 'Scale',(bool,[1])
%       Put x and y in real ratio for comparison
%   - 'Region',(matrix,[])
%       If not empty it will constrain the plotted area in the region
%        2x2 matrix: lowleft -upright corners (LAT,LON)
%                        LAT | LON                   
%               origin |(1,1)|(1,2)
%                  end |(2,1)|(2,2) 
%   - 'Depth',(vector,[])
%       If not empty is constraining the depth of the plotted area
%   - 'NameEpi', (bool,[0]) 
%       If true, plots the relative number
%   - 'Factor',(float,[1])
%       Gain factor for scatter-plot, type 'help scatterLegend' for info
%   - 'RefVsAll',(int,[])
%        If not empty will plot the first nth events in a different
%        color to mark them
%
%   USAGE: plotDistHypo(FILE,opt,['ArgName',ARGVALUE])
%   AUTHOR: Matteo Bagagli @ ETH -Zurich
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
    'Scale',1, ...
    'Region',[], ... 
    'Depth',[], ...
    'NameEpi',0, ...
    'Factor',1, ... % Factor for scatterplot
    'RefVsAll',[] ...
    );
Args=parseArgs(Def,varargin);
%
if nargin<2
    error('### plotDistHypo: I need a file in *cnv format + ''LAT''-''LON'' opt.')
end
if Args.Scale
    depth2degree=1;
else
    depth2degree=0;
end

%% LOAD
fid=fopen(EQFile);
EQ=textscan(fid,'%f %f %f %f'); % "%*f" --> skip a value
fclose(fid);
LAT=EQ{1};
LON=EQ{2};
DEP=EQ{3};
MAG=EQ{4};
GLOBAL=[LAT,LON,DEP,MAG];
% Define data in region
if ~isempty(Args.Region)
    idx=find(GLOBAL(:,1)>Args.Region(1,1) & GLOBAL(:,1)<Args.Region(2,1) & ...
        GLOBAL(:,2)>Args.Region(1,2) & GLOBAL(:,2)<Args.Region(2,2));
    GLOBAL=GLOBAL(idx,:);
    LAT=GLOBAL(:,1); LON=GLOBAL(:,2); DEP=GLOBAL(:,3); MAG=GLOBAL(:,4);
end
% Conversion
if depth2degree
    DEP=km2deg(DEP);
end

%% PLOT
hold on
if strcmpi(opt,'LAT')
    if isempty(Args.RefVsAll)
        s=scatter(LAT,DEP,(MAG.^2)*Args.Factor,'w','filled');
        s.MarkerEdgeColor='k';
    else
        s1=scatter(LAT(1:Args.RefVsAll),DEP(1:Args.RefVsAll),(MAG(1:Args.RefVsAll).^2)*Args.Factor,'b','filled');
        s2=scatter(LAT(Args.RefVsAll+1:end),DEP(Args.RefVsAll+1:end),(MAG(Args.RefVsAll+1:end).^2)*Args.Factor,'w','filled');
        s1.MarkerEdgeColor='k';     s2.MarkerEdgeColor='k';
    end
    % Enumerate EQ
    if Args.NameEpi
        hold on
        for ii=1:length(DEP)
            text(LAT(ii),DEP(ii),num2str(ii),'HorizontalAlignment','center', ...
                'VerticalAlignment','bottom');
        end
        hold off
    end
    xlabel('Latitude (Dec.Deg.)')
elseif strcmpi(opt,'LON')
    if isempty(Args.RefVsAll)
        s=scatter(LON,DEP,(MAG.^2)*Args.Factor,'w','filled');
        s.MarkerEdgeColor='k';
    else
        s1=scatter(LON(1:Args.RefVsAll),DEP(1:Args.RefVsAll),(MAG(1:Args.RefVsAll).^2)*Args.Factor,'b','filled');
        s2=scatter(LON(Args.RefVsAll+1:end),DEP(Args.RefVsAll+1:end),(MAG(Args.RefVsAll+1:end).^2)*Args.Factor,'w','filled');
        s1.MarkerEdgeColor='k';     s2.MarkerEdgeColor='k';
    end
    % Enumerate EQ
    if Args.NameEpi
        hold on
        for ii=1:length(DEP)
            text(LON(ii),DEP(ii),num2str(ii),'HorizontalAlignment','center', ...
                'VerticalAlignment','bottom');
        end
        hold off
    end
    xlabel('Longitude (Dec.Deg.)')
else
    error('### plotDistHypo: ERROR !!! Wrong input component ... {''LAT'',''LON''}')
end
hold off

%% DECORATOR
set(gca,'ygrid','on','xaxislocation','top')
ylabel('Depth (km)')
% Change limit
if depth2degree
    DepthTickMark=km2deg(0:5:deg2km(max(DEP)+5));
    for ii=1:length(DepthTickMark)
        DepthTickLabel{ii}=num2str(deg2km(DepthTickMark(ii)));
    end
    set(gca,'yticklabel',DepthTickLabel,'ytick',DepthTickMark);
    axis ij equal tight
end
% Xlim
if ~isempty(Args.Region)
    % Xlim
    if strcmpi(opt,'LAT')
        xlim([Args.Region(1,1) Args.Region(2,1)])
    elseif strcmpi(opt,'LON')
        xlim([Args.Region(1,2) Args.Region(2,2)])
    end
end
% Ylim
if ~isempty(Args.Depth)
    if depth2degree
        ylim(km2deg(Args.Depth))
    else
        ylim(Args.Depth)
    end
end
%% OUT
ax=gca;
if ~isempty(Args.RefVsAll)
    s=[s1,s2];
end
%
end % End Main


