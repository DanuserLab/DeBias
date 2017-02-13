%% Parse txt files of the form: rows observations, coloumns x and y
function [x,y] = parseTextDeBias(fname)

fid = fopen(fname,'r');

formatSpec = '%f %f';
sizeData = [2 inf];

data = fscanf(fid,formatSpec,sizeData)';

fclose(fid);

if size(data,2) ~= 2
    display(sprintf('MATLAB ERR: %s should have exactly two columns with the x,y values',fname));
    error('%s should have exactly two columns with the x,y values',fname);
end

x = data(:,1);
y = data(:,2);

if ~(length(x) == length(y))
    display(sprintf('MATLAB ERR: %s should have same number of x and y values',fname));
    error('%s inconsistency in the number of observations',fname);
end

numbers
end