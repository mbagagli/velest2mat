function []=plotStatCorr(FileName,varargin)
%% PLOTSTATCORR: plot station correction out from velest run.
%   This function plots the station correction in map.
%   The argument can be specified with classical MATLAB syntax (Arg Name,value)
%   INPUTS: - FileName (str): obtained from ''vel2mat.sh'' script
%           - 'PlotStatName' (bool,[0]/1): to plot the STATION LABEL
%           - 'Type' (str,['geom']/'color'): colormap or symbol size
%           - 'Caxis' (float [-0.5 0.5]): interval for plotted values
%
%   USAGE:  []=PLOTSTATCORR(FileName,['ArgsName',ARGSVALUE])
%   AUTHOR: Matteo Bagagli @ ETH-Zurich
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

%% LOAD
Def=struct( ...
    'PlotStatName',0, ... %[0/1]
    'Type','geom', ... % 'geom'/'color'
    'Caxis',[-0.5 0.5] ...
    );
Args=parseArgs(Def,varargin);
%

%% LOAD
fid1=fopen(FileName);
STAT=textscan(fid1,'%s %f %f %*d %*d %*d %f %f %*d %*d'); % "%*f" --> skip a value
fclose(fid1);

%% EXTRACT
NAME=STAT{1};
LAT=STAT{2};
LON=STAT{3};
PTCOR=STAT{4};
STCOR=STAT{5}; % unused for now
%
idx_maj=find(PTCOR>0);
idx_min=find(PTCOR<0);
idx_zero=find(PTCOR==0);

%% PLOT
hold on
% StatCorr_P
if strcmpi(Args.Type,'geom')
    %%% SCATTER FUNCTION ---> by geometry
    if ~isempty(idx_min)
        hs_min=scatter(LON(idx_min),LAT(idx_min), ...
            abs(PTCOR(idx_min))*(2^10),'vb'); % abs for minor
    end
    if ~isempty(idx_maj)
        hs_max=scatter(LON(idx_maj),LAT(idx_maj), ...
            PTCOR(idx_maj)*(2^10),'^r');
    end
    if ~isempty(idx_zero)
        hs_zero=plot(LON(idx_zero),LAT(idx_zero),'square','MarkerSize',10, ...
            'MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor','k');
    end
    
else strcmpi(Args.Type,'color')
    %%% SCATTER FUNCTION ---> by color
    hs=scatter(LON,LAT,(2^8),PTCOR,'filled');
    hs.Marker='v';
    hs.MarkerEdgeColor='k';
    ch=colorbar('Units','normalized', ...
        'Location','NorthOutside');
    if ~isempty(Args.Caxis)
        caxis(Args.Caxis)
    end
    xlabel(ch,'Stat. Delays (s)');
end

%%% Names
if Args.PlotStatName
    for ii=1:length(NAME)
        text(LON(ii),LAT(ii),NAME{ii},'VerticalAlignment','top');
    end
end

%% DECORATOR
grid on; hold off  % axis IMAGE also fine
axis equal
set(gca,'xlim',[min(LON)-min(LON)*0.01 max(LON)+max(LON)*0.01], ...
      'ylim',[min(LAT)-min(LAT)*0.001 max(LAT)+max(LAT)*0.001]);
xlabel('Longitude (Dec.Deg.)')
ylabel('Latitude (Dec.Deg.)')
end % End Main

