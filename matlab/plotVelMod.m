function [MOD_mat,hl,legendName]=plotVelMod(cellName,varargin)
%% PLOTVELMOD: plot velest 1D velocity profile model
%   Input file: VELEST *.mod files.
%   If plotting more than 2 models, the 'LineSpecList' parameter is mandatory.
%   INPUTS:
%      - cellName (cellarray)  List of filenames to plot
%      - 'Depth',(vector,[])   Min and Max depth for the plot axis
%      - 'Param',(bool,[])     If true,plots the gradient over the stair
%      - 'LineSpecList',(cellarray,[{':b','-b'}])
%           Define the linespec for the input series plots
%
%   USAGE:  PLOTVELMOD({'File1.mod','File2.mod',...}, varargin)
%   AUTHOR: Matteo Bagagli @ ETH-Zurich 0916
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
    'Depth',[], ... %[min max]
    'Param',[],  ...
    'LineSpecList',[] ...
    );
Args=parseArgs(Def,varargin);

%% LOAD
iter=length(cellName);
for ii=1:iter
    %read the file
    fid=fopen(cellName{ii});
    MOD=textscan(fid,' %f %f %*f ','headerLines',2); % "%*f" --> skip a value
    fclose(fid);
    % Create matrix of depth-vel points
    MOD_mat{ii}=[MOD{2},MOD{1}];
end

%% PLOT
% To have a nice plot stair, we need to invert x and y.
% Plot must be stairs(VELOCITIES,DEPTH);view([-270 90])
% The next steps for decoration comes simple...

if ~isempty(Args.LineSpecList)
    cmap=Args.LineSpecList;
else
    cmap={':b','-b'};
end
hold on
hl=[];
for ii=1:iter
    h=stairs(MOD_mat{ii}(:,1),MOD_mat{ii}(:,2),cmap{ii});
    hl=[hl,h];
end
hold off
% Add Parametrization 18/07/2017
if ~isempty(Args.Param)
    hold on
    plot(MOD_mat{ii}(:,1),MOD_mat{ii}(:,2))
    hold off
end

%% DECORATOR
% Nice Lim
MIN_depth=[];
MAX_depth=[];
MIN_vel=[];
MAX_vel=[];
for ii=1:length(MOD_mat)
    MIN_vel=[MIN_vel,min(MOD_mat{ii}(:,2))];
    MAX_vel=[MAX_vel,max(MOD_mat{ii}(:,2))];
    MIN_depth=[MIN_depth,min(MOD_mat{ii}(:,1))];
    MAX_depth=[MAX_depth,max(MOD_mat{ii}(:,1))];
end
xlim([min(MIN_depth) max(MAX_depth)*1.1])
ylim([min(MIN_vel)*0.8 max(MAX_vel)*1.1])
%
view([-270 90])
xlabel('Depth (km)')
if ~isempty(Args.Depth)
    xlim([Args.Depth(1) Args.Depth(2)])
end
ylabel('Velocities (km/s)')
grid on
set(gca,'yaxislocation','right')
for ii=1:length(cellName)
    [~,f,e]=fileparts(cellName{ii});
    legendName{ii}=[f,e];
end
% legend(hl,legendName,'Location','northeast')
% legend('off')
% legend('show')
%
end % End Main
