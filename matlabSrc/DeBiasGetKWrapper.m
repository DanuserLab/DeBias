function [] = DeBiasGetKWrapper(fname, isCoOrientation)
%% Wrapper for calculating global and local index
% Input: fname - file or directory name that holds the data, 
%        isCoOrientation - defines specific processing details.
% Output: 
%
% Assaf Zaritsky, January 2017

fnameData = [fname filesep 'data'];
if exist(fnameData,'dir')
    loggerFname = [fname filesep 'output' filesep 'log_k.txt'];
    [Ks] = parseDirectory(fname,isCoOrientation,loggerFname);
    close all;
else
    display('MATLAB ERR: Wrong file / directory');
    error('Wrong file / directory');
end


end

%% go file after file in the directory and parse it, parsing only text, mat and excel files
function [Ks] = parseDirectory(dname, isCoOrientation,loggerFname)

Ks = [];

inputDname = [dname filesep 'data'];
outDname = [dname filesep 'output' filesep];

if ~exist(outDname,'dir')
    mkdir(outDname);
end

filenames = dir(inputDname);
nfiles = length(filenames);

for i = 1 : nfiles
    filename = filenames(i).name;
    
    [pathstr, name, ext] = fileparts(filename);
    
    if (strcmp(ext, '.txt') || strcmp(ext, '.xls') || strcmp(ext, '.xlsx') || strcmp(ext, '.mat'))        
        curK = parseFileK(dname, name, ext, isCoOrientation);        
        Ks = [Ks curK];        
        logger = fopen(loggerFname,'a+');
        fprintf(logger,sprintf('%s: K = %.1f\n',name,curK));
        fclose(logger);
    end    
end
end


%% Parse file to x,y data and save
function [K] = parseFileK(dname, name, ext, isCoOrientation)

fname = [dname filesep 'data' filesep name ext];
if strcmp(ext,'.txt')
    [x,y] = parseTextDeBias(fname);
else if strcmp(ext,'.mat')
        [x,y] = parseMatDeBias(fname);
    else if strcmp(ext,'.xls') || strcmp(ext,'.xlsx')
            [x,y] = parseXlsDeBias(fname);
        end
    end
end

[x,y] = DeBiasSetXY(x,y,isCoOrientation);
colocObs = x - y;

if isCoOrientation
    colocObs = abs(colocObs);
    colocObs(colocObs > 90) = 180 - colocObs(colocObs > 90);
end

[K] = DeBiasGetK(colocObs,isCoOrientation);        

%% generate html file
% genHtml(outDname, name);

end


