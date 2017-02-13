function genHtml(outDname, fname)
  htmlFname = [outDname filesep fname '.html'];
  fid = fopen(htmlFname, 'a+');

  fprintf(fid, ['<!DOCTYPE html>']);
  fprintf(fid, ['\n<html>']);
    fprintf(fid, ['\n<head>']);
      fprintf(fid, ['\n<title>' fname '</title>']);
      fprintf(fid, ['\n<meta charset="utf-8"></meta>']);
      fprintf(fid, ['\n<meta http-equiv="X-UA-Compatible" content="IE=9,9,10,11`"></meta>']);
      fprintf(fid, ['\n<meta name="author" content="biohpc.swmed.edu"></meta>']);
      fprintf(fid, ['\n<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">']);
    fprintf(fid, ['\n</head>']);

    fprintf(fid, ['\n<body>']);
      fprintf(fid, ['\n<div class="container">']);
        fprintf(fid, ['\n<div class="row">']);
          fprintf(fid, ['\n<div class="col-lg-12">']);
            fprintf(fid, ['\n<div class="page-header" align="center">']);
              fprintf(fid, ['\n<h2>Experiment ' fname '</h2>']);
              fprintf(fid, ['\n<h3>LI=xx, GI=xx</h3>']);
              fprintf(fid, ['\n<div class="page-body">']);
              fclose(fid);
              
                %% printf X
                genSingleImage(outDname, fname, 'X', 'X');
                %% printf Y
                genSingleImage(outDname, fname, 'Y', 'Y');
                %% printf Alignment
                genSingleImage(outDname, fname, 'Alignment', 'observed');
                %% printf joint distribution
                genSingleImage(outDname, fname, 'Joint Distribution', 'joint');

              fid = fopen(htmlFname, 'a+');
              fprintf(fid, ['\n</div>']);
            fprintf(fid, ['\n</div>']);
          fprintf(fid, ['\n</div>']);
        fprintf(fid, ['\n</div>']);
      fprintf(fid, ['\n</div>']);
    fprintf(fid, ['\n</body>']);
  fprintf(fid, ['\n</html>']);

  fclose(fid);
end

function genSingleImage(outDname, fname, iname, isource)
  htmlFname = [outDname filesep fname '.html'];
  fid = fopen(htmlFname, 'a+');
  fprintf(fid, ['\n<div class="panel panel-default">']);
    fprintf(fid, ['\n<div class="panel-heading">']);
      fprintf(fid, ['\n<h3 align="center">' iname '</h3>']);
    fprintf(fid, ['\n</div>']);
    fprintf(fid, ['\n<div class="panel-body">']);
      fprintf(fid, ['\n<img align="center" src="images/' fname '_' isource '.jpg" alt="' iname '">']);
    fprintf(fid, ['\n</div>']);
  fprintf(fid, ['\n</div>']);
  fclose(fid);
end
