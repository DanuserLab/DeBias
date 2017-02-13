%% Parse excel files
function [x,y] = parseXlsDeBias(fname)
% display('MATLAB ERR: to be implemented');
% error('to be implemented');

[numbers strings misc] = xlsread(fname);

if ~(isempty(strings) && (size(numbers,2) == 2))
    display(sprintf('MATLAB ERR: %s should have exactly two columns with the x,y values',fname));
    error('%s should have exactly two columns with the x,y values',fname);
end

x = numbers(:,1);
y = numbers(:,2);

if ~(length(x) == length(y))
    display(sprintf('MATLAB ERR: %s should have same number of x and y values',fname));
    error('%s inconsistency in the number of observations',fname);
end

end
