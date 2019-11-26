function [PlotFig1,PlotFig2]=velest2mat(varargin)                   
%% VELEST2MAT (v1.1.0)
%   Main function for creating an unique figure comprehensive
%   of a VELEST v4.5 Run results. A GUI will appear and ask for the
%   necessary files previously created with the 'velest2mat.sh' script.
%   NB: To work properly this routine needs all the requested files
%
%   INPUTS:   1) Figure Title       (str)
%             2) LowLeft [LAT,LON]  (1x2 vector)
%             3) UpRight [LAT,LON]  (1x2 vector)
%             4) Depths  [MIN,MAX]  (1x2 vector)
%
%   USAGE: [HandleFig1,HandleFig2]=VELEST2MAT(...
%                               FIGTITLE,BOX_LOWLEFT,BOX_UPRIGHT,BOX_DEPTH)
%   AUTHOR: Matteo Bagagli @ ETH-Zurich

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

%% CHECKS + VARS
if nargin~=4
    error('USAGE: velest2mat(FIGTITLE,BOX_LOWLEFT,BOX_UPRIGHT,BOX_DEPTH)')
else
    Title=varargin{1};
    Origin=varargin{2};
    End=varargin{3};
    Depth=varargin{4};
end
Factor=5; % Magnify Factor to plot events magnitude

%% GUI for file selection
[~,StatDelay,EpiFile_OUT,MOD_IN,MOD_OUT,HypoAdj,RMSFile,SHPFile]=myInputGUI( ...
{'Station Delay (*.statcorr)','Earthquake File (*.latlondepmag)','Vel. Model IN (*.mod)', ...
'Vel. Model OUT (*.mod)','Hypocenter Corr. (*.HypoCorr)','Residual File (*.RMS)', ...
'National Boundaries Shapefile. (*.shp)'}, ...
'Title','PLOT VELEST: File Selection','StartDir',pwd,'Position',[0.1 0.1 0.3 0.5]);

if (isempty(StatDelay) || isempty(EpiFile_OUT) || isempty(MOD_IN) || ...
    isempty(MOD_OUT) || isempty(HypoAdj) || isempty(RMSFile))
    % warning("Please FILL ALL the necessary field")
    return
end

%% PLOTS
PlotFig1=figure('Units','Normalized','Position',[0 0 1 1],'Name',Title);
%
ax1=subplot(4,4,[1,2,5,6]);
plotStatEpi('Epi1',EpiFile_OUT,'Factor',Factor, ...
            'Region', [Origin; End], ...
            'ScaleBar', 200, ...
            'PlotMap', ~isempty(SHPFile), ...
            'ShapeFile', SHPFile);  % 'StatFile',StatDelay,
% scatterLegend({'MAG','0.5','1.5','2.5'},[0.5,1.5,2.5],Factor,'ok');
scatterLegend({'MAG','2','3','4'},[2,3,4],Factor,'ok');

% Fix limit if NO MAP is given (otherwise is done inside plotStatEpi funct)
if isempty(SHPFile)
    set(ax1,'xlim',[Origin(2) End(2)],'ylim',[Origin(1) End(1)])
end

%
ax2=subplot(4,4,[3,7]);
plotDistHypo(EpiFile_OUT,'LAT','Region',[Origin(1),Origin(2);End(1),End(2)], ...
    'Depth',Depth,'Factor',Factor)
view([-90 90])
set(ax2,'xaxislocation','bottom')
set(ax2,'xlabel',[])
%
ax3=subplot(4,4,[9,10]);
plotDistHypo(EpiFile_OUT,'LON','Region',[Origin(1),Origin(2);End(1),End(2)], ...
    'Depth',Depth,'Factor',Factor);
set(ax3,'xlabel',[])
%
ax4=subplot(4,4,[4,8,12]);
[~,hl_3,~]=plotVelMod({MOD_IN,MOD_OUT}, ...
    'Depth',Depth,'LineSpecList',{':k','-k'});
set(ax4,'yaxislocation','right')

ax4_pos = ax4.Position;
ax4_aux = axes('Position',ax4_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
[~,hs_3,~]=plotDepthHypo({EpiFile_OUT}, ...
    'MinDepth',Depth(1),'MaxDepth',Depth(2)+0.5,'binsize',0.5,...
    'LineSpecList',{'-r'}); 
    % NB add the binsize value to the MAXDEPTH for plotting reason
set(ax4_aux,'yaxislocation','left')
set(ax4_aux,'xaxislocation','bottom','xlabel',[])
legend([hl_3,hs_3],{'mod.IN','mod.OUT','hypoDistr.out'}, ...
    'Location','southeast');
%
subplot(4,4,11);
histEQ(EpiFile_OUT,'PlotMode','DEP+MAG','BinWidth',[1 0.25]);
%
subplot(4,4,[13,14])
plotHypoAdj(HypoAdj);
%
subplot(4,4,[15,16])
plotRMS(RMSFile);

PlotFig2=figure;
% plotStatCorr(StatDelay,'PlotStatName',0,'Type','color'); v1.1.0

if isempty(SHPFile)
    plotStatCorr(StatDelay,'PlotStatName',0, ...
                 'Type','color','PlotZeroCorr',0)
else          
    plotStatCorr(StatDelay,'PlotStatName',0, ...
                 'Type','color','PlotZeroCorr',0, ...
                 'Region', [Origin; End], ...
                 'PlotMap', 1, 'ScaleBar', 200, 'ShapeFile', SHPFile); %v1.2.0
end

end


