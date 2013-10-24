function mtdt=morphofil(dep,x,y)
%--------------------------------------------------------------------------
% function mtdt=morphofil(dep,x,y)
%
% Max entre le Top hat de l'image name1 et son dual
%
% Entrees : dep   -> image de depart
%           x,y   -> pour definir l'element structurant plan (rectangle de
%                    dimension (2x+1)x(2y+1) centre en 0)
%
% Sortie : mtdt  -> max entre top hat et son dual
%--------------------------------------------------------------------------

% ???????

% -- Affichage
figure;
photo(mtdt,256);
title('Max entre top hat et son dual');
end