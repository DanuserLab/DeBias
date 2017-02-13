%% Earth Movers Distance similarity measure
% assumes x, y are distributions
function similarity= EMD(x,y)
similarity = sum(abs(cumsum(x)-cumsum(y)));
end