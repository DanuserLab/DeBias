function [globalColocalizationIndex, localColocalizationIndex, localColocalizationIndexValidation] = assessGlobalVsLocalColocalization(x,y,nSimulations)
%% Assesses the contribution of global bias vs. local colocalization
% Input: x,y - arrays of matching intensities from different fluorescent
% channels. Values normalized to the range 0-1.
% Output: globalColocalizationIndex, localColocalizationIndex - relative contribution
%           localColocalizationIndexValidation - to be compared with localColocalizationIndex
%
% Assaf Zaritsky, June 2015
%%

assert(length(x) == length(y));

if nargin < 3
    %     nSimulations = max(1000000,length(x));
    nSimulations = max(100000,length(x));
end


xycenters = 0.025:0.025:1-0.025;
colocalCenters = -1+0.05:0.05:1-0.05;

nelements = hist(x,xycenters);
xDistribution = nelements./sum(nelements);

nelements = hist(y,xycenters);
yDistribution = nelements./sum(nelements);

alignment = x-y;

nxycenters = length(colocalCenters);
randomColocalizationDistribution = ones(1,nxycenters) .* (1/nxycenters);

nelements = hist(alignment,colocalCenters);
alignmentDistribution = nelements./sum(nelements);

resampledColocalizationDistribution = resampleColocalization(xDistribution, yDistribution,xycenters,colocalCenters,nSimulations);

globalColocalizationIndex = EMD(resampledColocalizationDistribution,randomColocalizationDistribution);
observedColocalizationIndex = EMD(alignmentDistribution,randomColocalizationDistribution);

localColocalizationIndex = observedColocalizationIndex - globalColocalizationIndex;

localColocalizationIndexValidation = EMD(alignmentDistribution,resampledColocalizationDistribution);
if (observedColocalizationIndex - globalColocalizationIndex) < 0
    localColocalizationIndexValidation = -localColocalizationIndexValidation;
end

end