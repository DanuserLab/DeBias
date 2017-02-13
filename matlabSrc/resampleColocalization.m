%% Resample colocalization no spatial relation
% Assume x,y and in the 0-1 range
% Assaf June, 2015

function [resampledColocalizationDistribution] = resampleColocalization(xDistribution,yDistribution,xycenters,colocalCenters,nSimulations)
tossesX = rand(1,nSimulations);
tossesY = rand(1,nSimulations);

simulatedX = zeros(1,nSimulations);
simulatedY = zeros(1,nSimulations);

nBins = length(xDistribution);

xSumDistribution = zeros(1,nBins);
ySumDistribution = zeros(1,nBins);
for i = 1 : nBins
    xSumDistribution(i) = sum(xDistribution(1:i));
    ySumDistribution(i) = sum(yDistribution(1:i));
    
    if i == 1
        indsMotion = (tossesX < xSumDistribution(i));
        indsStress = (tossesY < ySumDistribution(i));        
    else
        indsMotion = (tossesX < xSumDistribution(i)) & (tossesX > xSumDistribution(i-1));
        indsStress = (tossesY < ySumDistribution(i)) & (tossesY > ySumDistribution(i-1));
    end
    simulatedX(indsMotion) = xycenters(i);
    simulatedY(indsStress) = xycenters(i);
end

diffSimulated = simulatedX-simulatedY;
[nelements, xcenters] = hist(diffSimulated,colocalCenters);
resampledColocalizationDistribution = nelements./sum(nelements);
end