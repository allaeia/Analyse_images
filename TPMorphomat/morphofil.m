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
    function img = close(f,x,y)
        img = Erosion(Dilatation(f,x,y),x,y);
    end
    function img = open(f,x,y)
        img = Dilatation(Erosion(f,x,y),x,y);
    end
    function img = top_hat(f,x,y)
        img = f-open(f,x,y)
    end
    function img = top_hat_dual(f,x,y)
        img = close(f,x,y) - f;
    end
    mtdt = max(top_hat(dep,x,y),top_hat_dual(dep,x,y));
% -- Affichage
figure;
photo(mtdt,256);
title('Max entre top hat et son dual');
end