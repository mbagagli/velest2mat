function []=plotStatCorr(FileName,varargin)
%% PLOTSTATCORR: plot station correction out from velest run.
%   This function plots the station correction in map.
%   The argument can be specified with classical MATLAB syntax (Arg Name,value)
%   INPUTS: - FileName (str): obtained from ''vel2mat.sh'' script
%           - 'Region',(matrix,[])
%               If not empty it will constrain the plotted area in the region
%               2x2 matrix: lowleft -upright corners (LAT,LON)
%                                LAT | LON                   
%                       origin |(1,1)|(1,2)
%                          end |(2,1)|(2,2) 
%           - 'PlotStatName' (bool,[0]/1): to plot the STATION LABEL
%           - 'Type' (str,['geom']/'color'): colormap or symbol size
%           - 'Caxis' (float [-0.5 0.5]): interval for plotted values
%           - 'PlotZeroCorr' (bool,0/[1]): will plot the STATIONS with 
%                                          corrections equal to zero.
%           - 'PlotMap' (bool, [0]): if true, plot the data in a MAP
%           - 'ShapeFile' (str, []): if PlotMap is true, plot the given shp
%           - 'ScaleBar',(float,[0]): if true, plots a scale bar of 
%                                     given km to compare the distance in map.
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

%% PARSING
Def=struct( ...
    'PlotStatName',0, ... %[0/1]
    'Type','geom', ... % 'geom'/'color'
    'Region',[], ...
    'Caxis',[-0.5 0.5], ...
    'PlotZeroCorr', 1, ...
    'PlotMap',0, ...
    'ScaleBar',[], ...
    'ShapeFile',[] ...
    );
Args=parseArgs(Def,varargin);

%% LOAD and VARS
fid1=fopen(FileName);
STAT=textscan(fid1,'%s %f %f %*d %*d %*d %f %f %*d %*d'); % "%*f" --> skip a value
fclose(fid1);

if Args.Region
    minLat=Args.Region(1,1);
    maxLat=Args.Region(2,1);
    minLon=Args.Region(1,2);
    maxLon=Args.Region(2,2);
end


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
figure
if ~Args.PlotMap
    hold on
    % --- StatCorr_P
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
        if ~isempty(idx_zero) && Args.PlotZeroCorr
            hs_zero=plot(LON(idx_zero),LAT(idx_zero),'square','MarkerSize',10, ...
                'MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor','k');
        end

    elseif strcmpi(Args.Type,'color')
        %%% SCATTER FUNCTION ---> by color
        if ~Args.PlotZeroCorr
            nzidx=(PTCOR(:,1)~=0);
            hs=scatter(LON(nzidx), ...
                       LAT(nzidx), ...
                       (2^8), ...
                       PTCOR(nzidx),'filled');    
        else
           hs=scatter(LON,LAT,(2^8),PTCOR,'filled'); 
        end

        hs.Marker='v';
        hs.MarkerEdgeColor='k';
    end

    % --- Names
    if Args.PlotStatName
        for ii=1:length(NAME)
            if ~Args.PlotZeroCorr && PTCOR(ii)==0.0
                continue
            else
                text(LON(ii),LAT(ii),NAME{ii},'VerticalAlignment','top');
            end
        end
    end

    % --- Closing plot
    if Args.Region
        xlim([minLon maxLon])
        ylim([minLat maxLat])
    end
    grid on;
    hold off
    axis image % axis EQUAL also fine
    
else
    %%% Plot MAP
    if isempty(Args.ShapeFile) || isempty(Args.Region)
        error('PlotMap set to TRUE but NO SHAPEFILE OR NO REGION limits given')
    end
    
    % --- Create MAP
    Map_Around = shaperead(Args.ShapeFile, ...
                           'UseGeoCoords', true, ...
                           'Selector',{@(v1,v2) (( v1>= minLon-5)&&( v1<= maxLon+5) && (v2 >= minLat-1) && (v2 <= maxLat+1)),'LON','LAT'}); % slezione nazioni (allargare per stare tranquilli che se cambio latlon di plot, le nazioni sono plottate)
    wh = worldmap([minLat maxLat],[minLon maxLon]);
    setm(wh, 'ffacecolor', [204 255 255]/255);  % create background color 
    geoshow(Map_Around,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.5 0.5 0.5])
    
    % --- StatCorr_P
    hold on
    if strcmpi(Args.Type,'geom')
        %%% SCATTER FUNCTION ---> by geometry
        if ~isempty(idx_min)
            hs_min=scatterm(LAT(idx_min),LON(idx_min), ...
                abs(PTCOR(idx_min))*(2^10),'vb'); % abs for minor
        end
        if ~isempty(idx_maj)
            hs_max=scatterm(LAT(idx_maj),LON(idx_maj), ...
                PTCOR(idx_maj)*(2^10),'^r');
        end
        if ~isempty(idx_zero) && Args.PlotZeroCorr
            hs_zero=plotm(LAT(idx_zero),LON(idx_zero),'square','MarkerSize',10, ...
                'MarkerFaceColor',[0.9 0.9 0.9],'MarkerEdgeColor','k');
        end

    elseif strcmpi(Args.Type,'color')
        %%% SCATTER FUNCTION ---> by color
        if ~Args.PlotZeroCorr
            nzidx=(PTCOR(:,1)~=0);
            hs=scatterm(LAT(nzidx), ...
                        LON(nzidx), ...
                        (2^8), ...
                        PTCOR(nzidx),'filled', ...
               'MarkerEdgeColor','k','Marker','v');                    
        else
           hs=scatterm(LAT,LON,(2^8),PTCOR,'filled', ...
               'MarkerEdgeColor','k','Marker','v');
        end
    end

    % --- Stations Names
    if Args.PlotStatName
        for ii=1:length(NAME)
            if ~Args.PlotZeroCorr && PCOR(ii)==0.0
                continue
            else
                textm(LAT(ii),LON(ii),NAME{ii},'VerticalAlignment','top');
            end
        end
    end
    hold off
end

%% DECORATOR

ch=colorbar('Units','normalized', ...
    'Location','NorthOutside');
if ~isempty(Args.Caxis)
    caxis(Args.Caxis)
end
xlabel(ch,'Stat. Delays (s)');

if Args.ScaleBar
    AxHandle=gca;
    if ~Args.PlotMap
        PosX=get(AxHandle,'xlim');
        PosX=PosX(1)+((PosX(2)-PosX(1))*0.05);
        PosY=get(AxHandle,'ylim');
        PosY=PosY(1)+((PosY(2)-PosY(1))*0.15);
        addScaleMap(AxHandle,Args.ScaleBar,[PosX PosY]); % v1.2.0
    else
        addScaleMap(AxHandle,Args.ScaleBar,[Args.Region(1,2)+1.5 ...
                                            Args.Region(1,1)+1],1); % v1.2.0
    end
end


xlabel('Longitude (Dec.Deg.)')
ylabel('Latitude (Dec.Deg.)')

end % End Main

