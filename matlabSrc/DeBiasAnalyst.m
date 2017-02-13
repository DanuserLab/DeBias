%% DeBiasAnalyst: plots (GI,LI) plots for two experimental conditions + statistics
% K = 90 / binWidth for angular data and 2.0/binWidth otherwise
% Input: GIs1,LIs1 - values for first condition
%        GIs2,LIs2 - values for second condition
%        str1,str2 - string representation of experimental conditions (e.g., CTRL, AKT)
%        outdir - output directory to print plot
% Output: p-value (Wilcoxon rank-sum test) for differences in LI or GI
%
% Assaf Zaritsky, January 2017
function [GIpval,LIpval] = DeBiasAnalyst(GIs1,LIs1,GIs2,LIs2,str1,str2,outdir)
close all;

n1 = length(GIs1);
n2 = length(GIs2);

%% Sanity tests
assert(...
length(GIs1) == length(LIs1) &&...
length(GIs2) == length(LIs2));

if (n1 < 3 || n2 < 3 || (n1+n2 < 8))
    warning('DeBiasMetaAnalysis: n too small');
end

%% Statistics
GIpval = ranksum(GIs1,GIs2);
LIpval = ranksum(LIs1,LIs2);

%% Printouts
outStr1 = sprintf('\n *** %s (n = %d) - %s (n = %d) ***\n',str1,length(GIs1),str2,length(LIs1));
outStr2 = sprintf('Cond1: LI = %f (%f), GI = %f (%f)\n',...
    mean(LIs1),std(LIs1),mean(GIs1),std(GIs1));
outStr3 = sprintf('Cond2: LI = %f (%f), GI = %f (%f)\n',...
    mean(LIs2),std(LIs2),mean(GIs2),std(GIs2));
outStr4 = sprintf('GI pval = %f (%f vs. %f)\n',...
    GIpval,mean(GIs1),mean(GIs2));
outStr5 = sprintf('LI pval = %f (%f vs. %f)\n',...
    LIpval,mean(LIs1),mean(LIs2));

fprintf(outStr1);
fprintf(outStr2);
fprintf(outStr3);
fprintf(outStr4);
fprintf(outStr5);
fprintf(outStr6);

%% Plot LI & GI
plotGILI(...
    GIs1,LIs1,...
    GIs2,LIs2,...
    str1,str2,...
    [outdir sprintf('LIGI_%s_%s.eps',str1,str2)]...
    );
end

%% Utility functions

%%
function [] = plotGILI(...
    GI1,LI1,...
    GI2,LI2,...        
    str1,str2,...
    outFname...
    )

colormap jet;
cmap = colormap(hsv(length(legendsStr)));

fontsize = 20;

h = figure;
hold on;
plot(GI1,LI1,'o','MarkerEdgeColor',cmap(1,:),'LineWidth',2,'MarkerSize',8);
plot(GI2,LI2,'o','MarkerEdgeColor',cmap(2,:),'LineWidth',2,'MarkerSize',8);

legend(str1,str2);
xlabel('GI','FontSize',fontsize);
ylabel('LI','FontSize',fontsize);
haxes = get(h,'CurrentAxes');

set(h,'Color','none');
set(haxes,'FontSize',fontsize);

export_fig(outFname);
hold off;
end