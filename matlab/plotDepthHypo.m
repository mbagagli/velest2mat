function [MOD_plot,hs,legendName]=plotDepthHypo(cellName,varargin)
%% PLOTDEPTHHYPO: plot velest 1D velocity profile model
%   Input file: velest *.latlonmagdep files (created by 'vel2mat.sh')
%   INPUTS:
%     - cellName (cellarray)  List of filenames to plot
%     - 'MinDepth',(float,[-1])
%     - 'MaxDepth',(float,[25])
%     - 'BinSize',(float,[0.1])
%           Define the size of the depth histogram
%     - 'Subplot',(vector,[gca])
%     - 'LineSpecList',(cellarray,[{':k','-k'}])
%           Define the linespec for the input series plots
%
%   USAGE:  PLOTDEPTHHYPO({'File1.latlondepmag','File2.latlondepmag',...},['ArgName',ARGVALUE])
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

%% INPUTS
Def=struct( ...
    'MinDepth',-1,...
    'MaxDepth',25,...
    'BinSize',0.1, ...
    'Subplot',[], ...
    'LineSpecList',[] ...
    );
Args=parseArgs(Def,varargin);

%% LOAD + WORK
edges=Args.MinDepth:Args.BinSize:Args.MaxDepth;
iter=length(cellName);
for ii=1:iter
    MOD=load(cellName{ii});
    MODdep=MOD(:,3);
    COUNTS=histcounts(MODdep,edges);
    MOD_plot{ii}=[edges(1:end-1)',COUNTS'];
end

%% PLOT
if ~isempty(Args.Subplot)
    subplot(Args.Subplot(1),Args.Subplot(2),Args.Subplot(3))
else
    gca
end

hold on
if ~isempty(Args.LineSpecList)
    colors=Args.LineSpecList;
else
    colors={':k','-k'};
end

hs=[];
for ii=1:iter
    h=stairs(MOD_plot{ii}(:,1),MOD_plot{ii}(:,2), ...
        colors{ii},'DisplayName',cellName{ii});
    hs=[hs,h];
end
xlim([Args.MinDepth Args.MaxDepth])
hold off

view([-270 90])
xlabel('Depth (km)')
ylabel('Counts')
for ii=1:length(cellName)
    [~,f,e]=fileparts(cellName{ii});
    legendName{ii}=[f,e];
end
axis tight