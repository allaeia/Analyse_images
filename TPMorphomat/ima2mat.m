function image = ima2mat(name)

% function image = ima2mat(name)
% This function is used to read binary input files of the type .ima.
% Written by Lars Aurdal, ENST.

% Open, read and close dimension file.
a=[name, '.dim']
dimfid = fopen([name, '.dim'], 'r');
if ~(dimfid > 2)
  disp('Failed to open the dimension file corresponding to requested .ima file')
else
  dim = fscanf(dimfid,'%d', 4);
  disp(['Dimension: (' int2str(dim(1)) ', ' int2str(dim(2)) ')']);
  if length(dim)==2
    % old .ima type
    type = 'uchar';
    disp('The type is "uchar", 8 bits.');
  else 
    % tivoli type
    dimz = dim(3);
    t = dim(4);
    if ~(dimz == 1)
       disp('Oops... this file contains several slices...I''ll read only the first one.');
    end;
    if t==10
       type = 'uchar';
       disp('The type is "uchar", 8 bits.');
    elseif t==20
       type = 'ushort';
       disp('The type is "ushort", 16 bits.');
    elseif t==800
       type = 'double';
       disp('The type is "double", 64 bits.');
    else
       disp('I cannot determine the type...I quit.');
       %break;
    end;
  end;
  dimstat = fclose(dimfid);
  if ~(dimstat == 0)
    disp('Failed to close the dimension file corrsponding to requested .ima file')
  end
end

% Open, read and close image file.

imafid = fopen([name '.ima'], 'r');
if ~(imafid > 2)
  disp('Failed to open the requested .ima file')
else
  image = fread(imafid,[dim(1),dim(2)],type);
  imastat = fclose(imafid);
  if ~(imastat == 0)
    disp('Failed to close the requested .ima file.')
  else
    disp('File read!')
    image = image';
  end
end