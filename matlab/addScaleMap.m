function [sbh,sbt]=addScaleMap(unit,lowleft)
%% ADDSCALEMAP: simple function that display a scale bar on current axis.
%   The used function is km2deg, so the first argoument must be indicated
%   in km. It works on current axes.
%       USAGE: [scaleHandle,textHandle]=ADDSCALEMAP(unit,lowleft)
%       AUTHOR: Matteo Bagagli @ ETH-Zurich
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

%% Work
gca
% conversion
unit_trans=km2deg(unit);
hold on
sbh=plot([lowleft(1),lowleft(1)+unit_trans],[lowleft(2),lowleft(2)], ... 
    'k','lineWidth',3);
sbt=text(lowleft(1)+(unit_trans/2),lowleft(2),[num2str(unit),' km'], ...
    'Color','k','FontSize',14,'VerticalAlignment','bottom','HorizontalAlignment','center');
hold off
end
