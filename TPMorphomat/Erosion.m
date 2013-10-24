function ero=Erosion(dep,x,y)
%--------------------------------------
% Entrees : dep   -> image initiale
%           x, y -> parametres de l'element structurant
% Sortie :  ero  -> resultat de l'erosion
%--------------------------------------

% ???????????
s=size(dep);
rows=s(2);
cols=s(1);
xx=2*x;
yy=2*y;
tmp = ones([cols+x*2,rows+y*2])*255;
tmp(x+1:x+cols,y+1:y+rows)=dep;
for(i=1:cols)
   for(j=1:rows)
       min=tmp(i,j);
       for(k=i:i+xx)
           for(l=j:j+yy)
               val = tmp(k,l);
               if(val<min)
                   min=val;
               end
           end
       end
       ero(i,j)=min;
   end
end
% -- Affichage
figure;
photo(ero,256);
title('Erosion');
end

