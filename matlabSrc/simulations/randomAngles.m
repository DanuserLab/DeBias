%% randomAngles
% Draws N random angles from a truncated ([-90,90]) noraml probability and
% correct with alpha (see Fig. 1B in the manuscript)
% distribution for X, Y (each distribution is defined by mean,std)
% Important notes: (1) supports only normal distributions, (2) in the manuscript muX = muY = 0 
function [Xvec,Yvec,Zvec] = randomAngles(muX,sX,muY,sY,alpha,N)

Xvec = getAngles(muX,sX,N);
Yvec = getAngles(muY,sY,N);
Zvec = alpha * ones(N,1);

end

function randAngles = getAngles(muParam,stdParam,N)
minangle = -90; maxangle = 90;
pd = makedist('Normal',muParam,stdParam);
td = truncate(pd,minangle,maxangle);
randAngles = random(td,N,1);
end
