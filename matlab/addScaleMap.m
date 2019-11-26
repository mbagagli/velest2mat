function [sbh,sbt]=addScaleMap(axhandle,unit,lowleft,varargin)
%% ADDSCALEMAP: simple function that display a scale bar on current axis.
%   The used function is km2deg, so the first argoument must be indicated
%   in km. It works on current axes. Note that the function will open/close
%   the HOLD function for plotting internally.

%   INPUTS:   1) axhandle (float)
%               - axis handle where the scale will be plot
%             2) unit (float)
%               - the number of km units
%             3) lowleft [x,y] or [lon,lat] (1x2 float vector)
%               - The starting point of the scale            
%             4) plotonmap (bool [0])
%               - if true, the plotting figure is a MAP plot instance
%
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

%% ---- Extract INPUTS
if ~isempty(varargin)
    plotonmap=varargin{1};
else
    plotonmap=0;
end
unit_trans=km2deg(unit);

%% ---- Plot

if ~plotonmap
    
    hold(axhandle,'on')
    sbh=plot([lowleft(1),lowleft(1)+unit_trans],[lowleft(2),lowleft(2)], ... 
        'k','lineWidth',3);
    sbt=text(lowleft(1)+(unit_trans/2),lowleft(2),[num2str(unit),' km'], ...
        'Color','k','FontSize',14,'VerticalAlignment','bottom', ...
        'HorizontalAlignment','center','Parent',axhandle);
   hold(axhandle,'off')
    
else
    
    hold(axhandle,'on')
    sbh=plotm([lowleft(2),lowleft(2)],[lowleft(1),lowleft(1)+unit_trans], ... 
        'k','lineWidth',3);
    sbt=textm(lowleft(2),lowleft(1)+(unit_trans/2),[num2str(unit),' km'], ...
        'Color','k','FontSize',14,'VerticalAlignment','bottom', ...
        'HorizontalAlignment','center','Parent',axhandle);    
    hold(axhandle,'off')
    
end
