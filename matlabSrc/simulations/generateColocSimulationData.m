%% generateColocSimulationData - 
% sX - std X
% sZ - std Z
% N - number of simulated observations
% fracColoc - optional. If true than (1-fracColoc) of Y are to be sampled
% independently from N(muX,sX)
function[X,Y]=generateColocSimulationData(sX,sZ,N,fracColoc)
muX = 0.5; 
muZ = 1;

minVal=0;maxVal=1;

xProbDist = makedist('Normal',muX,sX);
truncateX = truncate(xProbDist,minVal,maxVal);
X0 = random(truncateX,1,N);

zProbDist = makedist('Normal',muZ,sZ);
Z = random(zProbDist,1,N);

Y0 = X0 .* Z; % this might go above / below [0,1]
inds = (Y0 >= 0) & (Y0  <= 1);
X = X0(inds);
Y = Y0(inds);

if nargin == 4
    curN = length(X);
    nNoColac = round(curN*(1-fracColoc));
    Ytmp = random(truncateX,1,nNoColac);
    inds = randsample(curN,nNoColac);
    Y(inds) = Ytmp;
end

end