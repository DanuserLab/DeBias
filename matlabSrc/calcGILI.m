function [GI, LI] = calcGILI(x,y,k,isCoOrientation,nSimulations)
%% Calculates GI, LI for colocalization data
% Input: x,y - arrays of matching variables. Values normalized to the range 0-1 (co-localization) or in the range -90-90 (co-orientation).
% Output: GI, LI
%
% Assaf Zaritsky, January 2017
%%

assert(length(x) == length(y));

if isCoOrientation
    kBinSize = 90 / k;
    kBins = (0 + kBinSize/2) : kBinSize : (90 - kBinSize/2);
else
    kBinSize = 2 / k;
    kBins = (-1 + kBinSize/2) : kBinSize : (1 - kBinSize/2);
end

if nargin < 5    
    nSimulations = max(100000,length(x));
end

%% uniform (random) distribution
uniformDist = ones(1,k) .* (1/k);

%% observed distribution
colocObs = x - y;

if isCoOrientation
    colocObs = abs(colocObs);
    colocObs(colocObs > 90) = 180 - colocObs(colocObs > 90);
end

nelements = hist(colocObs,kBins);
obsDist = nelements./sum(nelements);

%% resampled distribution
resampledX = randsample(x,nSimulations,true);
resampledY = randsample(y,nSimulations,true);
colocResampled = resampledX - resampledY;

if isCoOrientation
    colocResampled = abs(colocResampled);
    colocResampled(colocResampled > 90) = 180 - colocResampled(colocResampled > 90);
end

[nelements, xcenters] = hist(colocResampled,kBins);
resampledDist = nelements./sum(nelements);

%% Calculate GI, LI
GI = EMD(resampledDist,uniformDist);
obsEMD = EMD(obsDist,uniformDist);

LI = obsEMD - GI;
end