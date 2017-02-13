%% generateColocSimulationData - 
% muX,sX - mean and std of X (normal distribution)
% muY,sY - mean and std of Y (normal distribution)
% alpha (the interaction, see Fig. 1B in the manuscript)
% N - number of simulated observations
% The bias is set of 0 in the manuscript (muX = muY = 0)
function[X,Y] =...
    generateCoOrientSimulationData(muX,sX,muY,sY,alpha,N)

    
    %drawing random numbers according to the parameters
    [Xvec,Yvec,Zvec]=...
        randomAngles(muX,sX,muY,sY,alpha,N);
    
    signZ_Y = nan(N,1);
    
    
    alignmentGlobal = Yvec-Xvec;
    
    signZ_Y(abs(alignmentGlobal) > 90) = sign(alignmentGlobal(abs(alignmentGlobal) > 90));
    signZ_Y(abs(alignmentGlobal) <= 90) = -sign(alignmentGlobal(abs(alignmentGlobal) <= 90));
    
    % Just to compare later to alignment to validate the correction
    alignmentGlobal = abs(alignmentGlobal);
    alignmentGlobal(alignmentGlobal > 90) = 180 - alignmentGlobal(alignmentGlobal > 90);
    
    Zvec = Zvec .* alignmentGlobal;
    YLvec = Yvec; XLvec = Xvec;
    indsY = rand(1,N) > 0.5;
    
    YLvec(indsY)=Yvec(indsY)+Zvec(indsY).*signZ_Y(indsY);
    XLvec(~indsY)=Xvec(~indsY)+Zvec(~indsY).*(-1).*signZ_Y(~indsY);
    
    YLvec(YLvec > 90) = YLvec(YLvec > 90) - 180; YLvec(YLvec < -90) = YLvec(YLvec < -90) + 180;
    XLvec(XLvec > 90) = XLvec(XLvec > 90) - 180; XLvec(XLvec < -90) = XLvec(XLvec < -90) + 180;
    
    assert(isempty([find(YLvec < -90,1),find(YLvec > 90,1),find(XLvec < -90,1),find(XLvec > 90,1)]));    
    
    X = XLvec;
    Y = YLvec;    
end