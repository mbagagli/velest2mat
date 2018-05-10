function [ax,h]=histEQ(FileName,varargin)
%% HISTEQ: plots the magnitude distribution of a *.latlonmagdep file !!
%   A latlonmagdep file is needed, the rest can be input as MATLAB standard syntax   
%   INPUTS:
%       - 'PlotMode' (str,['MAG'],'DEP','DEP+MAG')
%           Define the distribution if magnitude only. depth only or both
%       - 'BinWidth' (float,[0.2])
%           
%   NB: This function uses the newer and better "histogram" function 
%
%   USAGE:  []=HISTEQ(FileName,['ArgName',ARGVALUE])
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
if ~isempty(FileName)
    fid2=fopen(FileName);
    EQ=textscan(fid2,'%f %f %f %f'); % "%*f" --> skip a value
    fclose(fid2);
    %
    EQdep=EQ{3};
    EQmag=EQ{4};
else
    error('### histMAG: ERROR!!! I need at least a file name!!')
end
% Inputs
Def=struct( ...
    'PlotMode','MAG', ... %{['MAG'],'DEP','DEP+MAG'}
    'BinWidth',[] ...
    );
Args=parseArgs(Def,varargin);
% Check 1
if ~isanycell(Args.PlotMode,{'DEP+MAG','MAG','DEP'})
    error('### histMAG: ERROR!!! wrong PlotMode inserted!! {''MAG'',''DEP'',''DEP+MAG''} ...')
end
%

%% WORK
if strcmpi(Args.PlotMode,'MAG')
        if ~isempty(Args.BinWidth)
            BW=Args.BinWidth;
        else
            BW=0.2;
        end
        h=histogram(EQmag,'Normalization','count', ...
            'BinWidth',BW);
        xlabel('Magnitude (Mw)')
        ylabel('Counts')
elseif strcmpi(Args.PlotMode,'DEP')
        if ~isempty(Args.BinWidth)
            BW=Args.BinWidth;
        else
            BW=0.2;
        end
        h=histogram(EQdep,'Normalization','count', ...
            'BinWidth',BW);
        xlabel('Depth (km)')
        ylabel('Counts')
        view([90 90])
        set(gca,'YAxisLocation','right')
elseif strcmpi(Args.PlotMode,'DEP+MAG')
        if ~isempty(Args.BinWidth)
            BW=Args.BinWidth;
        else
            BW=[0.25 0.25];
        end
        h=histogram2(EQdep,EQmag,'Normalization','count', ...
            'BinWidth',BW);
        xlabel('Depth (km)')        
        ylabel('Magnitude (M_w)')
        zlabel('Counts')
end
%
ax=gca;
end % EndMain
