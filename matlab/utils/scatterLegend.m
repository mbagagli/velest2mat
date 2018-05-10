function [hleg,hobj]=scatterLegend(TextCell,SizeDim,Factor,LinSpec)
%% SCATTERLEGEND: workaround for R2016a and later for scatter plot legend.
%   This function aims to simplify the creation for scatter plot legend for
%   MATLAB R2016a and later releases.
%   The function will plot a legend on current axis with the right
%   markersize proportion.
%   
%   Inputs:   - TextCell: a cell array containing the legend-entry text.
%               WARNING: THE FIRST CELL IS THE TITLE !!!
%             - SizeDim: the ''MarkerSize'' dimension for each entry.
%               WARNING: length(SizeDim)==length(TextCell)-1 !!!
%             - Factor: normaling factor for enlarge the marker size in
%                       a linear way. (MarkerSize*sqrt(Factor)
%             - LinSpec: specify the marker-string.
% 
%   EXAMPLE: -----------------------------------------------------
%             Factor=1.5;
%             A=[1,1,1;
%                2,2,2;
%                3,3,3;
%                4,4,4;
%                5,5,5;
%                6,6,6;
%                7,7,7;
%                8,8,8;
%                9,9,9;
%                10,10,10];
% 
%             sh=scatter(A(:,1),A(:,2),(A(:,3).^2)*Factor,'ok');
%             scattersize==MarkerSize*sqrt(Factor)pt)
%             leg=SCATTERLEGEND({'SIZE','1','2','3','4','5', ...
%                 '6','7','8','9','10'},[1:1:10],Factor,'ok');
%             leg.Location='NorthWest'; axis([0,11,0,11])
%            -----------------------------------------------------
% 
%   AUTHOR: Matteo Bagagli - ETH-Zurich // Oct. 2016
%   MAIL:   matteo.bagagli@erdw.ethz.ch
%   SITE:   https://it.mathworks.com/matlabcentral/fileexchange/59425-legend-scatter

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

%% FAKE PLOTS
hold on
hplt=zeros(length(TextCell),1)';
for ii=1:length(TextCell)
    hplt(ii)=plot(NaN,NaN,LinSpec);
end
hold off

%% WORK
[hleg,hobj]=legend(hplt,TextCell,'Units','points');
drawnow % For update the figure and the legend
idx=(length(TextCell)+4):2:length(hobj); % Skip text and TITLE MARKER
% Title
hobj(1).FontWeight='bold';
ActPos=hobj(1).Position;
hobj(1).Position=[0.5,ActPos(2),ActPos(3)];
hobj(1).HorizontalAlignment='center';
hobj(1).FontSize=11;
hobj(length(TextCell)+2).Marker='none';
% Body
for ii=1:length(idx)
    hobj(idx(ii)).MarkerSize=SizeDim(ii)*sqrt(Factor);
end
%
hleg.Location='northwest';
end % EndMain