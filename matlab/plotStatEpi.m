function [ch,ah]=plotStatEpi(StatFile,varargin)
%% PLOTSTATEPI: function for plot Station // Epicenter data.
%   Look into the function to see different plot possibilities.
%   - 'Epi1',(str,[]) FileName of *.latlondepmag
%   - 'Epi2',(str,[]) FileName of *.latlondepmag (plotted only if
%                                                 'Connect' TRUE)
%   - 'Connect',(bool,[0]) Plot a line connecting the same epicenter
%   - 'NameEpi',(misc,[0]) 
%       0 no naming / 'all' all numbered/ [vector] only explicit fields 
%   - 'Caxis',(vector,[])
%       Define the depth range to be mapped by the colormap (based on event depts)
%   - 'Factor',(float,[1])
%       Gain factor for scatter-plot, type 'help scatterLegend' for info
%   - 'ScaleBar',(float,[0])
%       If not 0, plots a scale bar of given km to compare the distance in map.
%   - 'Region',(matrix,[])
%       If not empty it will constrain the plotted area in the region
%        2x2 matrix: lowleft -upright corners (LAT,LON)
%                        LAT | LON                   
%               origin |(1,1)|(1,2)
%                  end |(2,1)|(2,2) 
%   - 'RefVsAll',(int,[])
%        If not empty will plot the first nth events in a different
%        color to mark them
%   Out:
%   - ch: colorbar handle
%   - ah: axis handle
%
%   USAGE: PLOTSTATEPI(StatFile, ...)
%   AUTHOR: Matte Bagagli @ ETH-Zurich 0916
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
    'Epi1',[], ...
    'Epi2',[], ... % plotted only if ConnectEpi ON
    'Connect',0, ... % 0-1 True/False
    'NameEpi',0, ... % 0 no naming / 'all' all numbered/ [vector] only those fields 
    'Caxis',[], ...
    'Factor',1, ... % Factor for increase/decrease scatterplot
    'ScaleBar',0, ...
    'Region',[], ...
    'RefVsAll',[] ... 
    );
Args=parseArgs(Def,varargin);
%
if Args.Connect && isempty(Args.Epi2)
    error('### plotStatEpi: ERROR !! With ''Connect'' option, I need a second file !!!')
end

%% LOAD
fid1=fopen(StatFile);
STAT=textscan(fid1,'%s %f %f %*d %*d %*d %f %f %*d %*d'); % "%*f" --> skip a value
fclose(fid1);

statNAME=upper(STAT{1});
statLAT=STAT{2};
statLON=STAT{3};
%%%%%
if ~isempty(Args.Epi1)
    fid2=fopen(Args.Epi1);
    EPI1=textscan(fid2,'%f %f %f %f'); % "%*f" --> skip a value
    fclose(fid2);

    Epi1LAT=EPI1{1};
    Epi1LON=EPI1{2};
    Epi1DEP=EPI1{3};
    Epi1MAG=EPI1{4};
end
%
if ~isempty(Args.Epi2)
    fid3=fopen(Args.Epi2);
    EPI2=textscan(fid3,'%f %f %f %f'); % "%*f" --> skip a value
    fclose(fid3);

    Epi2LAT=EPI2{1};
    Epi2LON=EPI2{2};
    Epi2DEP=EPI2{3};
    Epi2MAG=EPI2{4};
end

%% PLOT
% ----------------------------------------------------------- Connect plot
hold on % initialize plot and start to append layering
if Args.Connect && ~isempty(Args.Epi1) && ~isempty(Args.Epi2)
    epi1h=plot(Epi1LON,Epi1LAT,'ok');
    epi2h=plot(Epi2LON,Epi2LAT,'+b');
    OUT=[Epi1LON,Epi1LAT];
    IN=[Epi2LON,Epi2LAT];
    legend([epi1h,epi2h],{'Epi1 file','Epi2 file'})
    for ii=1:size(IN,1)
        plot([IN(ii,1);OUT(ii,1)],[IN(ii,2),OUT(ii,2)],'k');
        if Args.NameEpi
            if strcmpi(Args.NameEpi,'all')
                text(IN(ii,1),IN(ii,2),num2str(ii),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');
            else
                text(IN(Args.NameEpi,1),IN(Args.NameEpi,2),num2str(Args.NameEpi),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');                
            end
        end
    end
    % ----------------------------------------------------------- Normal Plot
elseif ~Args.Connect && ~isempty(Args.Epi1) && isempty(Args.RefVsAll)
    sh=scatter(Epi1LON,Epi1LAT,(Epi1MAG.^2)*Args.Factor,Epi1DEP,'filled'); % 3pt=magnitude 1 (sz= sqrt(num))
    sh.MarkerEdgeColor='k';
    if Args.NameEpi
        if strcmpi(Args.NameEpi,'all')
            for ii=1:length(Epi1LON)
                text(Epi1LON(ii),Epi1LAT(ii),num2str(ii),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');
            end
        else
            for ii=1:length(Args.NameEpi)
                text(Epi1LON(Args.NameEpi(ii)),Epi1LAT(Args.NameEpi(ii)),num2str(Args.NameEpi(ii)),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');
            end
        end
    end
elseif ~Args.Connect && ~isempty(Args.Epi1) && ~isempty(Args.RefVsAll)
%     cptcmap('GMT_cool','nCol',70)
    sh1=scatter(Epi1LON(1:Args.RefVsAll),Epi1LAT(1:Args.RefVsAll), ...
        (Epi1MAG(1:Args.RefVsAll).^2)*Args.Factor,'b','filled'); % 3pt=magnitude 1 (sz= sqrt(num))
    sh2=scatter(Epi1LON(Args.RefVsAll+1:end),Epi1LAT(Args.RefVsAll+1:end), ...
        (Epi1MAG(Args.RefVsAll+1:end).^2)*Args.Factor,'w','filled'); % 3pt=magnitude 1 (sz= sqrt(num))
    sh1.MarkerEdgeColor='k';
    sh2.MarkerEdgeColor='k';
    if Args.NameEpi
        if strcmpi(Args.NameEpi,'all')
            for ii=1:length(Epi1LON)
                text(Epi1LON(ii),Epi1LAT(ii),num2str(ii),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');
            end
        else
            for ii=1:length(Args.NameEpi)
                text(Epi1LON(Args.NameEpi(ii)),Epi1LAT(Args.NameEpi(ii)),num2str(Args.NameEpi(ii)),'HorizontalAlignment','center', ...
                    'VerticalAlignment','bottom');
            end
        end
    end
else
    error('### plotStatEpi: Something''s wrong with Connect Option ...')
end

% Stations
plot(statLON,statLAT,'^r','MarkerSize',12,'LineWidth',3)
text(statLON,statLAT,statNAME,'HorizontalAlignment','center');
grid on
hold off

%% DECORATOR
% Region
if ~isempty(Args.Region)
    ylim([Args.Region(1,1) Args.Region(2,1)])
    xlim([Args.Region(1,2) Args.Region(2,2)])
end
axis image

% Plot Scale Matlab
if Args.ScaleBar
    PosX=get(gca,'xlim');
    PosX=PosX(1)+((PosX(2)-PosX(1))*0.05);
    PosY=get(gca,'ylim');
    PosY=PosY(1)+((PosY(2)-PosY(1))*0.15);
    addScaleMap(Args.ScaleBar,[PosX PosY]);
end
% Legend
if ~Args.Connect && isempty(Args.RefVsAll)
    ch=colorbar;
    set(ch,'Units','normalized', ...
        'Position',[0.155 0.80 0.013 0.07],'Location','westoutside');
        xlabel(ch,'Depth (km)');
    set(ch,'Direction','reverse');
else
    ch=[];
end
%
if ~isempty(Args.Caxis)
    caxis(Args.Caxis)
end
%
xlabel('Longitude (Dec.Deg.)')
ylabel('Latitude (Dec.Deg.)')
set(gca,'yaxislocation','right')
ah=gca;
end % End Main
