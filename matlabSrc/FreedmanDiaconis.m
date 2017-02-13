%% Freedman Diaconis ruleto estimate histogram width
% (Q3 - Q1)/power(n,1/3)
function binWidth = FreedmanDiaconis(data)
n = length(data);
q1 = prctile(data,25);
q3 = prctile(data,75);
nroot3 = nthroot(n,3);

binWidth = (q3-q1)/nroot3;
end