function Afficher_extraction(im,bin)
%------------------------------------------------
% function Afficher_extraction(im,bin)
%
% Affiche l'extraction binaire et superposee a l'image initiale
%
% Input : im  -> image initiale
%         bin -> image binaire de l'extraction
%------------------------------------------------

% -- Image binaire de l'extraction 
figure;
photo(bin,256);
title('Resultat d''extraction');

% -- Image avec la detection en rouge
figure;
im=im/max(im(:));
bin=bin/max(bin(:));
im_color=zeros([size(im),3]);
im_color(:,:,1)=im.*(1-bin)+bin;
im_color(:,:,2)=im.*(1-bin);
im_color(:,:,3)=im.*(1-bin);
image(im_color); axis image; axis off;
title('Resultat d''extraction');

end

