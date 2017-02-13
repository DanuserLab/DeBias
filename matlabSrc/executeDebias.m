function [GI,LI] = executeDebias(x,y,isCoOrientation,outDname,name,k,nSimulations)
%% Assesses the contribution of global bias vs. local alignment
% Input: x,y - arrays of matching variables from different sources (e.g., velocity vs. stress, MT vs. VIM)
%        isCoOrientation - input are co-orientation data - true, co-localization data - false
%        outDname - directory for output - default pwd (current working
%        directory). Plots are to be saved in this directory (.eps format) and jpg
%        versions in the 'images' directory within it.
%        name - experiment name - default ''
%        k - number of histogram bins for the distributions (uniform,resampled,observed)
%               default values: 15 (co-orientation), 40 (co-localization)
% Output: GI, LI, output at outDname directory
%
% Assaf Zaritsky, February 2017
%%

close all;

if nargin < 4
    outDname = pwd;
end

if nargin < 5
    name = '';
end

if nargin < 6
    if isCoOrientation
        k = 15;
    else
        k = 40;
    end
end

if nargin < 7
    nSimulations = max(1000000,length(x));
end

[GI,LI] = debias(x,y,k,isCoOrientation,outDname,name,nSimulations);
end
