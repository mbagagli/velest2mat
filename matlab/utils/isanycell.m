function [BOOL,idx]=isanycell(str,cellStr)
%% ISANYCELL: compare string in cell array with strcmpi function.
%   The function return TRUE if any matches are found and relative
%   index/es, False if no-match.
%
%   USAGE:  [BOOL,idx]=isanycell(str,cellStr)
%   AUTHOR: Matteo Bagagli @ ETH-Zurich // 102016
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

%% WORK
log=zeros(length(cellStr),1);
idx=[];
for ii=1:length(cellStr)
    log(ii)=strcmpi(str,cellStr{ii});
    if log(ii)
        idx=[idx,ii];
    end 
end
BOOL=any(log);
%
end%End Main
