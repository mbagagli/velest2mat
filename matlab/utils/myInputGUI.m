function [H,varargout]=myInputGUI(edits,varargin)
%% MYINPUTGUI: create a figure where user can select file with UIGETFILE
%   Initially created as a workaround for MAC uigetfile bug (R2016a) ...
%   varargin: - see inside function!!
%
%   USAGE: [Paths, handles]=myInputGUI(varargin)
%   AUTHOR: Matteo Bagagli @ ETH-Zurich // 0916
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
if nargin<1
    error('### myInputGUI: ERROR!! I need at least one edit field [cell] !!!')
end
if nargout>1 && (nargout-1)~=length(edits)
    error('### myInputGui: nargout ~= nargin !! Remember that first out is the GUI struct !!')
end
%
Def=struct( ...
    'Title','myInputGUI', ...
    'Position',[.05 .4 .2 .3], ... % Position Normalized with windows
    'StartDir', '/Users/matteo/' ...
    );
Args=parseArgs(Def,varargin);

% ---- Measure
BLOCKS=length(edits)+1; % (edits+ OK-Cancel button)
BLOCK_heigth=1/BLOCKS;
BLOCK_width=1/3;

%% GUI
H.main=figure('units','normalized','menubar','none','tag','main',...
    'NumberTitle','off','Name',Args.Title,'position',Args.Position, ...
    'CloseRequestFcn','close all force');

for jj=1:length(edits)
    % Create title, edit and push button
    H.title{jj}=uicontrol('Parent',H.main,'units','normalized', ...
        'style','text','string',edits{jj},'horizontalalignment','left', ...
        'fontsize',16, ...
        'position',[0 (1-(jj*BLOCK_heigth))+BLOCK_heigth/2 ...
        BLOCK_width*2 BLOCK_heigth/2]);
    H.edit{jj}=uicontrol('Parent',H.main,'units','normalized', ...
        'style','edit','string','','horizontalalignment','center', ...
        'fontsize',12, ...
        'position',[0 (1-(jj*BLOCK_heigth)) ...
        BLOCK_width*2 BLOCK_heigth/2]);
    H.button{jj}=uicontrol('Parent',H.main,'units','normalized', ...
        'style','pushbutton','string','CHOOSE','horizontalalignment','center', ...
        'fontsize',16, ...
        'position',[BLOCK_width*2 (1-(jj*BLOCK_heigth)) ...
        BLOCK_width BLOCK_heigth/2], ...
        'callback',{@setPath,Args.StartDir,H.edit{jj}});
end

H.OKbtn=uicontrol('units','normalized','style','pushbutton', ...
    'string','OK','horizontalalignment','left', ...
    'fontsize',16, ...
    'position',[0 0 BLOCK_width BLOCK_heigth], ...
    'callback',{@OKbtn,H});

H.CANCbtn=uicontrol('units','normalized','style','pushbutton', ...
    'string','Cancel','horizontalalignment','left', ...
    'fontsize',16, ...
    'position',[BLOCK_width 0 BLOCK_width BLOCK_heigth], ...
    'callback',{@exitUI,H});

H.exitStat=0;
uiwait(H.main)
%% EXIT
% h=guidata(h.main); %---> to be put at the beginnning of callback functions
% guidata(obj,h)  %---> to be put at the end of callback functions
H=guidata(H.main);
if (nargout-1)==length(edits) && ~H.exitStat
    for oo=1:length(H.edit)
        varargout{oo}=get(H.edit{oo},'string');
    end
    close(H.main)
elseif (nargout-1)==length(edits) && H.exitStat
    for oo=1:length(H.edit)
        varargout{oo}=[];
    end
    close(H.main)
end

%% NESTED FUNCTION
    function [ArgsOut]=parseArgs(Defaults,InputArgs)
        %% PARSEARGS : Utility function for parsing Name-Values inputs
        %   A simple function that allows the user to set the "varargin" variable
        %   of a personal function, in the classical MATLAB form Name-Value pair.
        %   The function compares the line input command, with a default given one,
        %   and returns a structure array. If a field given in default's array is
        %   not present in the input one, the default value for that field is used.
        %   Obiouvsly the order is not important, but the function is case sensitive !!
        %
        %   USAGE: [ArgsOut]=PARSEARGS(Defaults,InputArgs)
        %
        %   INPUT:
        %           Defaults  --->  A structure array with the field's names
        %                           and the respective DEFAULT VALUE [char/real]
        %           InputArgs --->  The cell array typical of the user input
        %                           varargin funcion
        %   OUTPUT:
        %           ArgsOut   --->  A structure array containing the final values.
        %
        %   AUTHOR:
        %           Matteo BAGAGLI 03/2015 @ INGV.PI
        
        %% Work
        DefaultsFields=fieldnames(Defaults);
        InputFields=InputArgs(1:2:end);
        % ---- Checking Errors -----
        for ii=1:length(InputFields)
            if ~ischar(InputFields{ii})
                error(sprintf(['parseArgs: ERROR inserting values.','\n', ...
                    'Fieldtypes must be character !!!']));
            end
        end
        if mod(length(InputArgs),2) ~= 0
            error(sprintf(['parseArgs: ERROR inserting values.','\n', ...
                'Missing fieldtype or value !!!']));
        end
        % --------------------------
        for ii=1:length(DefaultsFields)
            val = DefaultsFields{ii};
            test=strcmpi(val,InputFields);
            if ~isempty(find(test == 1, 1))      % Searching for values
                index=find(test == 1);
                ArgsOut.(val)=InputArgs{index*2};
            else                                 % Using Default instead
                ArgsOut.(val)=Defaults.(val);
            end
            
        end
        
        %% Old Version still working
        % for ii=1:length(DefaultsFields)
        %     val = DefaultsFields{ii};
        %     if ~isempty(strmatch(val,InputFields))      % Searching for values
        %         index=strmatch(val,InputFields);
        %         ArgsOut.(val)=InputArgs{index*2};
        %     else                                        % Using Default instead
        %         ArgsOut.(val)=Defaults.(val);
        %     end
        % end
    end
%
    function setPath(obj,event,varargin)
        StartPath=varargin{1};
        EditUI=varargin{2};
        %
        [a,b]=uigetfile([StartPath,'/*.*']);
        if ~isequal(a,0) && ~isequal(b,0) % User hit cancel
            outStr=fullfile(b,a);
            set(EditUI,'string',outStr);
        end
    end
%
    function OKbtn(obj,event,h)
        h.exitStat=0;
        guidata(obj,h)
        uiresume(h.main)
    end
%
    function []=exitUI(obj,event,h)
        h.exitStat=1;
        guidata(obj,h)
        uiresume(h.main)
    end
%
end % End Main