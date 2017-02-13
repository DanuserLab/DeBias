function [xout,yout] = DeBiasSetCoLocalizationData(x,y)
%% Normalize x, y to [0,1] - exclude extreme values
% Assaf Zaritsky, January 2017

% Normalize data 5 - 95 percentile (TODO: make it a parameter!)
lowPctg = 5;
highPctg = 100 - lowPctg;
pxLow = prctile(x,lowPctg); pxHigh = prctile(x,highPctg);
pyLow = prctile(y,lowPctg); pyHigh = prctile(y,highPctg);
indsInRange = (x >= pxLow) & (x <= pxHigh) & (y >= pyLow) & (y <= pyHigh);
xNorm = (x - pxLow) ./ (pxHigh - pxLow);
yNorm = (y - pyLow) ./ (pyHigh - pyLow);
xout = xNorm(indsInRange);
yout = yNorm(indsInRange);
end
