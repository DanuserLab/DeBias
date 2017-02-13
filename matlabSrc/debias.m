function [GI,LI] = debias(x,y,k,isCoOrientation,outDname,name,nSimulations)
%% Assesses the contribution of global bias vs. local alignment
% Input: x,y - arrays of matching variables from different sources (e.g., velocity vs. stress, MT vs. VIM)
%        k - number of histogram bins for the distributions (uniform,resampled,observed)
%        isCoOrientation - input are co-orientation data - true,
%        co-localization data - false
%        outDname - directory for output
%        name - experiment name
% Output: GI, LI, saving output at outDname directory
%
% Assaf Zaritsky, August 2014
% Last revision: January 2017
%%

if nargin < 7
    nSimulations = max(1000000,length(x));
end

[x,y] = DeBiasSetXY(x,y,isCoOrientation);

[GI, LI] = calcGILI(x,y,k,isCoOrientation,nSimulations);

%% -----------------------------------------------------
%% Visualization and output

% Parameters for visualization
if isCoOrientation
    xyLim = [-90,90];    
    xyBinsVis = -88:2:88;
    xyTick = -90:45:90;         
    xyHistBinLim = 0.4;
    xyHistBinStep = 0.1;    
    alignLim = [0,90];
    alignTick = [0,45,90];
    jointBins = -90:5:90;
    jointTick = [1,19,36]; % Assaf: not exactly balanced... (0 is not in hte middle)
    jointTickLabels = [-90,0,90];
    jointCaxisVals = [0,0.01];
else    
    xyLim = [0,1];    
    xyBinsVis = 0.025:0.025:1-0.025;
    xyTick = 0:0.5:1;    
    xyHistBinLim = 0.2;
    xyHistBinStep = 0.1;    
    alignLim = [0,1];
    alignTick = [0,0.5,1];
    jointBins = 0:0.02:1;
    jointTick = [1,26,50];
    jointTickLabels = [0,0.5,1];
    jointCaxisVals = [0,0.01];
end

% bins
if isCoOrientation
    kBinSize = 90 / k;
    alignBins = (0 + kBinSize/2) : kBinSize : (90 - kBinSize/2);
else
    kBinSize = 2 / k;
    alignBins = (-1 + kBinSize/2) : kBinSize : (1 - kBinSize/2);
end


% observed distribution
colocObs = x - y;

if isCoOrientation
    colocObs = abs(colocObs);
    colocObs(colocObs > 90) = 180 - colocObs(colocObs > 90);
end

% resampled distribution
resampledX = randsample(x,nSimulations,true);
resampledY = randsample(y,nSimulations,true);
colocResampled = resampledX - resampledY;

if isCoOrientation
    colocResampled = abs(colocResampled);
    colocResampled(colocResampled > 90) = 180 - colocResampled(colocResampled > 90);
end


%% Outputs
fontsize = 24;
xOutFname = [outDname filesep name '_X'];
yOutFname = [outDname filesep name '_Y'];
jointDistributionOutFname = [outDname filesep name '_joint'];
resampledAlignemntOutFname = [outDname filesep name '_resampled'];
observedAlignemntOutFname = [outDname filesep name '_observed'];

%% define outputs in png format, duyi
imgsDname = [outDname filesep 'images'];
xOutFname2 = [imgsDname filesep name '_X'];                               %% format-1
yOutFname2 = [imgsDname filesep name '_Y'];                               %% format-1
jointDistributionOutFname2 = [imgsDname filesep name '_joint'];           %% format-2
resampledAlignemntOutFname2 = [imgsDname filesep name '_resampled'];      %% format-3
observedAlignemntOutFname2 = [imgsDname filesep name '_observed'];        %% format-3


%% make sure images directory is there!
if ~exist(imgsDname,'dir')
    mkdir(imgsDname);
end

%% end of define outputs in png format, duyi

plotVariableDistribution(x,xyLim,xyBinsVis,xyTick,xyHistBinLim,xyHistBinStep,fontsize,xOutFname,'eps2c');
plotVariableDistribution(y,xyLim,xyBinsVis,xyTick,xyHistBinLim,xyHistBinStep,fontsize,yOutFname,'eps2c');

%% plot outputs in png format-1, duyi
plotVariableDistribution(x,xyLim,xyBinsVis,xyTick,xyHistBinLim,xyHistBinStep,fontsize,xOutFname2,'jpeg');
plotVariableDistribution(y,xyLim,xyBinsVis,xyTick,xyHistBinLim,xyHistBinStep,fontsize,yOutFname2,'jpeg');
%% end of plot outputs in png format-1, duyi

[jointDistribution] = getScatterQuantification(x,y,jointBins,jointBins);
plotJointDistribution(jointDistribution,jointTick,jointTickLabels,jointCaxisVals,fontsize,jointDistributionOutFname,'eps2c');

%% plot outputs in png format-2, duyi
plotJointDistribution(jointDistribution,jointTick,jointTickLabels,jointCaxisVals,fontsize,jointDistributionOutFname2,'jpeg');
%% end of plot outputs in png format-2, duyi

% alignment
plotVariableDistribution(colocResampled,alignLim,alignBins,alignTick,xyHistBinLim,xyHistBinStep,fontsize,resampledAlignemntOutFname,'eps2c');
plotVariableDistribution(colocObs,alignLim,alignBins,alignTick,xyHistBinLim,xyHistBinStep,fontsize,observedAlignemntOutFname,'eps2c');

%% plot outputs in png format-3, duyi
plotVariableDistribution(colocResampled,alignLim,alignBins,alignTick,xyHistBinLim,xyHistBinStep,fontsize,resampledAlignemntOutFname2,'jpeg');
plotVariableDistribution(colocObs,alignLim,alignBins,alignTick,xyHistBinLim,xyHistBinStep,fontsize,observedAlignemntOutFname2,'jpeg');
%% end of plot outputs in png format-3, duyi

end


%% Utility functions
function h = plotJointDistribution(jointDistribution,jointTick,jointTickLabels,jointCaxisVals,fontsize,outFname,imgFormat)
FPosition = [0 0 500 500];
APosition = [0.30 0.30 0.45 0.45];
h = figure;
imagesc(jointDistribution);
hold on;
caxis(jointCaxisVals);
haxes = findobj(h,'type','axes');
set(haxes,'XTick',jointTick);
set(haxes,'YTick',jointTick);
set(haxes,'XTickLabel',jointTickLabels);
set(haxes,'YTickLabel',jointTickLabels(end:-1:1));
set(haxes,'FontSize',fontsize);
xlabel('X','FontSize',fontsize); ylabel('Y','FontSize',fontsize);
hold off;

hColorbar = colorbar;
set(hColorbar,'YTick',jointCaxisVals);
set(hColorbar,'YTickLabel',jointCaxisVals.*100);
set(h,'Color','w','Position',FPosition,'PaperPositionMode','auto');
set(haxes,'Position',APosition,'box','off','XMinorTick','off','TickDir','out','YMinorTick','off','FontSize',fontsize);
set(get(haxes,'XLabel'),'FontSize',fontsize); set(get(haxes,'YLabel'),'FontSize',fontsize);

saveas(h, outFname, imgFormat);
end


function [] = plotVariableDistribution(x,xyLim,xyBinsVis,xyTick,xyHistBinLim,xyHistBinStep,fontsize,outFname,imgFormat)
[nelements, xcenters] = hist(x,xyBinsVis);
xDistribution = nelements ./ sum(nelements);
h = figure;
hold on;
bar(xyBinsVis,xDistribution,'r');
ylabel('Percent','FontSize',fontsize);
haxes = get(h,'CurrentAxes');
set(haxes,'XLim',xyLim);
set(haxes,'XTick',xyTick);
set(haxes,'XTickLabel',xyTick);
set(haxes,'YLim',[0,xyHistBinLim]);
set(haxes,'YTick',0:xyHistBinStep:xyHistBinLim);
set(haxes,'YTickLabel',0:xyHistBinStep:xyHistBinLim);
set(haxes,'FontSize',fontsize);
set(h,'Color','none');
hold off;
saveas(h, outFname, imgFormat);
end
