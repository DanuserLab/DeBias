%% Parse mat files (must have variables x, y to hold the data)
function [x,y] = parseMatDeBias(fname)
load(fname);
if ~exist('x','var') || ~exist('y','var')
    display(sprintf('MATLAB ERR: %s not having x, y variables',fname));
    error('%s not having x, y variables',fname);
end
end