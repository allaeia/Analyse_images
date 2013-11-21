function dim = photo(name,levels)

% function dim = photo(name,levels)
% This function displays a graylevel image returning
% the size.
% Written by Lars Aurdal/ENST.
% Date: 110195

image(name);
colormap(gray(levels));
axis('image'); axis off;
dim = size(name);
