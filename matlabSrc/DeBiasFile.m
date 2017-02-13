function [GI, LI] = DeBiasFile(fname,isAngle)
%% Wrapper for calculating global and local index
% Input: fname - file name that holds the data, 
%        isAngle - defines specific processing details.
% Output: execute assessGlobalVsLocalAlignment
%
% Assaf Zaritsky, September 2015

if exist(fname,'file')    
    [GI,LI] = processFile(fname,isAngle);
    close all;
else
    display('MATLAB ERR: no such file name');
    error('MATLAB ERR: no such file name');    
end


end

%% go file after file in the directory and parse it, parsing only text, mat and excel files
function [GI,LI] = processFile(fname,isAngle)

[pathstr, name, ext] = fileparts(fname);

if (strcmp(ext, '.txt') || strcmp(ext, '.xlsx') || strcmp(ext, '.mat'))
    outdir = [pathstr filesep 'output'];
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end   
    
    indir = [pathstr filesep 'data'];
    if ~exist(indir,'dir')
        mkdir(indir);
    end 
    
    imgsdir = [outdir filesep 'images'];
    if ~exist(imgsdir,'dir')
        mkdir(imgsdir);
    end 
    
    [x,y,GI,LI] = parseFile(pathstr, name, ext, isAngle);
    
    loggerFname = [outdir filesep 'log.txt'];
    logger = fopen(loggerFname,'a+');
    fprintf(logger,sprintf('%s: GI = %.2f, %.2f\n',name,GI,LI));
    fclose(logger);
else
    display('MATLAB ERR: wrong file type, only .txt, .xls, .xlsx and .mat files are supported');
    error('MATLAB ERR: wrong file type, only .txt, .xls, .xlsx and .mat files are supported');
end
end



%% Parse file to x,y data and save
function [x,y,GI,LI] = parseFile(dname, name, ext, isAngle)

fname = [dname filesep name ext];
if strcmp(ext,'.txt')
    [x,y] = parseText(fname);
else if strcmp(ext,'.mat')
        [x,y] = parseMat(fname);
    else if strcmp(ext,'.xls') || strcmp(ext,'.xlsx')
            [x,y] = parseXls(fname);
        end
    end
end

outDname = [dname filesep 'output'];

save([outDname filesep name '_xy.mat'],'x','y');

[GI,LI] = globalLocalAnalyticDataDecoupling(x,y,isAngle,outDname,name);        
fprintf(sprintf('%s: GI = %.2f, %.2f\n',name,GI,LI));

%% generate html file
genHtml(outDname, name);

end

%% Parse mat files (must have variables x, y to hold the data)
function [x,y] = parseMat(fname)
load(fname);
if ~exist('x','var') || ~exist('y','var')
    display(sprintf('MATLAB ERR: %s not having x, y variables',fname));
    error('MATLAB ERR: %s not having x, y variables',fname);
end
end

%% Parse txt files of the form: rows observations, coloumns x and y
function [x,y] = parseText(fname)
display('MATLAB ERR: to be implemented');
error('MATLAB ERR: to be implemented');
end

%% Parse excel files
function [x,y] = parseXls(fname)
display('MATLAB ERR: to be implemented');
error('MATLAB ERR: to be implemented');
end
