function mat2ima(var,filename)

% function mat2ima(var,filename)
% This function is used to write binary files of the type .ima.
% Written by Lars Aurdal, ENST.

% Calculate size of matrix to output.

dim    = size(var');

% Flip and rotate matrix to output.

var = flipud(var);
var = rot90(var,-1);

% Open, write and close dimension file.

dimfid = fopen([filename '.dim'], 'w');
if ~(dimfid > 2)
  disp('Failed to open the dimension file corresponding to requested .ima file')
else
  fprintf(dimfid,'%-6d%-6d',dim);
  dimstat = fclose(dimfid);
  if ~(dimstat == 0)
    disp('Failed to close the dimension file corrsponding to requested .ima file')
  end
end

% Open, write and close image file.

imafid = fopen([filename '.ima'], 'w');
if ~(imafid > 2)
  disp('Failed to open the requested .ima file')
else
  fwrite(imafid,var,'uchar');
  imastat = fclose(imafid);
  if ~(imastat == 0)
    disp('Failed to close the requested .ima file.')
  else
    disp('File created!')
  end
end
