function [] = debiasWrapper(dname,k, isCoOrientation)
%% Wrapper for calculating global and local index
% Input: dname: directory name that holds the data (in a folder labeld data), 
%        k: number of alignment histogram bins for the EMD
%        isCoOrientation: true (co-orientation), false (co-localization)
% Output: execute debias for each file
%
% Assaf Zaritsky, August 2014
% Last revision: February 2017

fnameData = [dname filesep 'data'];
if exist(fnameData,'dir')
    loggerFname = [dname filesep 'output' filesep 'log.txt'];
    [GIs,LIs] = parseDirectory(dname, k, isCoOrientation,loggerFname);
    close all;
else
    display('MATLAB ERR: Directory does not exists');
    error('Directory does not exists');
end

end

%% go file after file in the directory and parse it, parsing only text, mat and excel files
function [GIs,LIs] = parseDirectory(dname, k, isCoOrientation,loggerFname)

GIs = [];
LIs = [];

inputDname = [dname filesep 'data' filesep];
outDname = [dname filesep 'output' filesep];
outImageDname = [dname filesep 'output' filesep 'images'];

if ~exist(outDname,'dir')
    mkdir(outDname);
end

if ~exist(outImageDname,'dir')
    mkdir(outImageDname);
end

filenames = dir(inputDname);
nfiles = length(filenames);

for i = 1 : nfiles
    filename = filenames(i).name;
    
    [pathstr, name, ext] = fileparts(filename);
    
    if (strcmp(ext, '.txt') || strcmp(ext, '.xls') || strcmp(ext, '.xlsx') || strcmp(ext, '.mat'))        
        [x,y,GI,LI] = parseFile(dname, name, ext, k, isCoOrientation);        
        GIs = [GIs GI];
        LIs = [LIs LI];
        logger = fopen(loggerFname,'a+'); 
        fprintf(logger,sprintf('%s: GI = %.2f, %.2f\n',name,GI,LI));
        fclose(logger);
    end    
end
end


%% Parse file to x,y data and save
function [x,y,GI,LI] = parseFile(dname, name, ext, k, isCoOrientation)
fname = [dname filesep 'data' filesep name ext];
if strcmp(ext,'.txt')
    [x,y] = parseTextDeBias(fname);
else if strcmp(ext,'.mat')
        [x,y] = parseMatDeBias(fname);
    else if strcmp(ext,'.xls') || strcmp(ext,'.xlsx')
            [x,y] = parseXlsDeBias(fname);globalLocalAnalyticDataDecoupling
        end
    end
end

outDname = [dname filesep 'output'];

save([outDname filesep name '_xy.mat'],'x','y');

[GI,LI] = debias(x,y,k,isCoOrientation,outDname,name);        
fprintf(sprintf('%s: GI = %.2f, LI = %.2f\n',name,GI,LI));

%% generate html file
genHtml(outDname, name);

end
