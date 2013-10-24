function his=hysteresis(ima,bas,haut)
%----------------------------------------------------
% function his=hysteresis(ima,bas,haut)
%
% Realise un seuillage par hysteresis de l'image ima avec les seuils haut
% et bas
%----------------------------------------------------
% Written by Xavier Descombes, INRIA

% -- Dimensions de l'image
dimension    = size(ima);

% -- Initialisation
his = ima;

% -- Extraction des pixels de niveau superieur au seuil haut (le px est dans P1)
for i = 1 : dimension(1)
    for j = 1 : dimension(2)
        if ima(i,j) < haut
            his(i,j) = 0;
        else
            his(i,j) = 255;
        end
    end
end

compt = 1;
while (compt ~= 0)    
    compt = 0;
    for i = 2 : dimension(1)-1
        for j = 2 : dimension(2)-1
            % -- Test si le niveau du pixel (i,j) est entre les seuils bas et
            % haut (i.e le px est dans P2)
            if ( his(i,j) == 0 && ima(i,j) >= bas) 
                % -- Si oui on regarde si un pixel de son vosinage est
                % dans P1
                if (his(i-1,j-1) == 255 || his(i-1,j) == 255 ||  his(i-1,j+1) == 255 || his(i,j-1) == 255 || his(i,j+1) == 255 || his(i+1,j-1) == 255 ||  his(i+1,j) == 255 || his(i+1,j+1) == 255 )
                    % -- Si oui on ajoute le px (i,j) dans P1
                    his(i,j) = 255;
                    compt = 1; 
                end
            end
        end
    end
    % -- Si des modifs on etees faites (compt==1) on recommence
end
