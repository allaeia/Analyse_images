function dil=Dilatation(dep,x,y)
%--------------------------------------
% Entrees : dep   -> image initiale
%           x, y -> parametres de l'element structurant
% Sortie :  dil  -> resultat de la dilatation
%--------------------------------------

% ?????????
s=size(dep);
rows=s(2);
cols=s(1);
xx=2*x;
yy=2*y;
tmp = zeros([cols+x*2,rows+y*2]);
tmp(x+1:x+cols,y+1:y+rows)=dep;
for(i=1:cols)
   for(j=1:rows)
       max=tmp(i,j);
       for(k=i:i+xx)
           for(l=j:j+yy)
               val = tmp(k,l);
               if(val>max)
                   max=val;
               end
           end
       end
       dil(i,j)=max;
   end
end


% -- Affichage
figure;
photo(dil,256);
title('Dilatation');
end

