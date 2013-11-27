function res=recuit(name1,name2,name3,beta,tempe0,decrease,NIT)
%----------------------------------------------------------
% function res=recuit(name1,name2,name3,beta,tempe,decrease,NIT)
%
% Inputs : name1 -> Nom de l'image (.ima) à segmenter (si l'image a traiter
%                   s'apelle test.ima l'appel se fait avec name1='test')
%          name2 -> Nom du fichier texte contenant la définition des
%                   classes utilisée pour la segmentation
%          name3 -> Nom pour enregistrer l'image en sortie
%          beta  -> Paramètre du modèle de Potts
%          tempe0 -> Température initiale
%          decrease -> Coefficient de décroissance de la température
%          NIT -> Nombre d'itérations
%
% Output : res -> Résultat de segmentation
%-----------------------------------------------------------


	%if(j>1&&(res(j-1,k) ~= val))
%		e = e + beta;
%	end
%	if(k>1&&(res(j,k-1) ~= val))
%		e = e + beta;
%	end
%	if(j<dim(1)&&(res(j+1,k) ~= val))
%		e = e + beta;
%	end
%	if(k<dim(2)&&(res(j,k+1) ~= val))
%		e = e + beta;
%	end

%tab_dif = zeros(1000,1000);
  % tic;    bitor(tab_dif,tab_dif);toc
  % tic;    tab_dif|tab_dif;toc


BN = 1;
BS = 2;
BE = 4;
BO = 8;

BNE = 5;
BNO = 9;
BSE = 6;
BSO = 10;

%-- Lecture de l'image à segmenter
dep = ima2mat(name1);
dim = size(dep);

%-- Affichage de l'image
figure;
photo(dep,256);
title('Image initiale');

%-- Lecture des parametres des classes
fid = fopen(name2, 'r'); % ouverture du fichier 

% -- Initialisation température
tempe=tempe0;

% initialisation du nombre de classes
n_classe=0;
while (~feof(fid)) % tant qu'on est pas à la fin du fichier
   n_classe = n_classe + 1;
   moy(n_classe) = fscanf(fid,'%f',1);
   var(n_classe) = fscanf(fid,'%f',1);
end;
fclose(fid); % fermeture du fichier





%-- Pre-calcul des potentiels de classes
for i = 1 : n_classe
    for j = 0 : 255
        V1(i,j+1) = (j-moy(i))*(j-moy(i))/(2.*var(i))+log(var(i));
    end
end

%-- Initialisation aleatoire
for i = 1 : dim(1)
    for j = 1 : dim(2)
        res(i,j) = floor(n_classe * rand); % peut prendre les valeurs 0/1/.../n_classe
        if (res(i,j) == n_classe) % si valeur n_classe on retire
            j = j-1;
        end
    end
end


tab_border = zeros(dim(1),dim(2));
tab_border(1,:) = bitor(tab_border(1,:),BN);
tab_border(dim(1),:) = bitor(tab_border(dim(1),:),BS);
tab_border(:,1) = bitor(tab_border(:,1),BO);
tab_border(:,dim(2)) = bitor(tab_border(:,dim(2)),BE);%%because bitwise operation in one number is VERY slow in MATLAB

%-- Boucle principale
for i = 1 : NIT  % Boucle sur le nombre d'itérations
    disp(i);
    for j = 1 : dim(1)
        for k = 1 : dim(2)
            border = tab_border(j,k);
            
            valeur_courante = res(j,k);  % Numéro de la classe associé au pixel (j,k)
            valeur_nouvelle = n_classe;  % Atribution d'une nouvelle classe (tirage uniforme, on répète le tirage si égal à n_classe)
            while (valeur_nouvelle == n_classe)
                valeur_nouvelle = floor(n_classe * rand);
            end
            
            
            
            % - Energie due a la vraisemblance
            energie_courante = V1(valeur_courante+1,dep(j,k)+1);
            energie_nouvelle = V1(valeur_nouvelle+1,dep(j,k)+1);
            
            % - Energie du modele a priori
            % A prior 4-connexe
           
            value_around = ones(1,8) * -1;
            switch(border)
                case 0%%order by the number of occurnece because the switch not replace by array of ptr of function
                    value_around(1) = res(j-1,k-1);
                    value_around(2) = res(j-1,k);
                    value_around(3) = res(j-1,k+1);
                    value_around(4) = res(j,k+1);
                    value_around(5) = res(j+1,k+1);
                    value_around(6) = res(j+1,k);
                    value_around(7) = res(j+1,k-1);
                    value_around(8) = res(j,k-1);
                case BN
                    value_around(4) = res(j,k+1);
                    value_around(5) = res(j+1,k+1);
                    value_around(6) = res(j+1,k);
                    value_around(7) = res(j+1,k-1);
                    value_around(8) = res(j,k-1);
                case BE
                    value_around(1) = res(j-1,k-1);
                    value_around(2) = res(j-1,k);
                    value_around(6) = res(j+1,k);
                    value_around(7) = res(j+1,k-1);
                    value_around(8) = res(j,k-1);
                case BS
                    value_around(1) = res(j-1,k-1);
                    value_around(2) = res(j-1,k);
                    value_around(3) = res(j-1,k+1);
                    value_around(4) = res(j,k+1);
                    value_around(8) = res(j,k-1);
                case BO
                    value_around(2) = res(j-1,k);
                    value_around(3) = res(j-1,k+1);
                    value_around(4) = res(j,k+1);
                    value_around(5) = res(j+1,k+1);
                    value_around(6) = res(j+1,k);
                case BSO
                    value_around(2) = res(j-1,k);
                    value_around(3) = res(j-1,k+1);
                    value_around(4) = res(j,k+1);
                case BSE
                    value_around(1) = res(j-1,k-1);
                    value_around(2) = res(j-1,k);
                    value_around(8) = res(j,k-1);
                case BNE
                    value_around(6) = res(j+1,k);
                    value_around(7) = res(j+1,k-1);
                    value_around(8) = res(j,k-1);
                case BNO
                    value_around(4) = res(j,k+1);
                    value_around(5) = res(j+1,k+1);
                    value_around(6) = res(j+1,k);
            end
            
            %matlab ne sait pas faire d'operation bit a bit avec une
            %vitesse convenable
%             value_around = -1 * ones(1,8);
%             if(bitand(border,BN)==0)
%                 if(bitand(border,BO)==0)
%                     value_around(1) = res(j-1,k-1);
%                     value_around(8) = res(j,k-1);
%                 end
%                 value_around(2) = res(j-1,k);
%                 if(bitand(border,BE)==0)
%                     value_around(3) = res(j-1,k+1);
%                     value_around(4) = res(j,k+1);
%                 end
%             end
%             
%             if(bitand(border,BS)==0)
%                 if(bitand(border,BO)==0)
%                     value_around(5) = res(j+1,k+1);
%                 end
%                 value_around(6) = res(j+1,k);
%                 if(bitand(border,BE)==0)
%                     value_around(7) = res(j+1,k-1);
%                 end
%             end
           



           %%%%%4-connexe
           energie_courante = energie_courante + beta * sum(valeur_courante ~= value_around([2,4,6,8]));
           energie_nouvelle = energie_nouvelle + beta * sum(valeur_nouvelle ~= value_around([2,4,6,8]));
        
        
           %%%%%8-connexe
%             tab_dif=(valeur_courante~=value_around');
%             tmp_tri = tab_dif([2,4,6,8])|tab_dif([4,6,8,2]);
%             energie_courante = energie_courante + beta*(sum(tab_dif + (tab_dif | circshift(tab_dif,1))) + sum(tmp_tri + (tmp_tri | tab_dif([3,5,7,1]))));
%            
%             tab_dif=(valeur_nouvelle~=value_around');
%             tmp_tri = tab_dif([2,4,6,8])|tab_dif([4,6,8,2]);
%             energie_nouvelle = energie_nouvelle + beta*(sum(tab_dif + (tab_dif | circshift(tab_dif,1))) + sum(tmp_tri + (tmp_tri | tab_dif([3,5,7,1]))));
%             

            if(energie_nouvelle<=energie_courante || (rand<exp(-(energie_nouvelle-energie_courante)/tempe)))
                res(j,k)=valeur_nouvelle;
            end
           % disp(exp(-(energie_nouvelle-energie_courante)/tempe));
        end
    end
    % -- Décroissance de la température
    tempe = tempe * decrease;
end


% -- Affichage du resultat
figure
photo(res+1,n_classe);
title(['Segmentation : \beta=',num2str(beta),' / T=',num2str(tempe0),' / decrease=',num2str(decrease),' / NIT=',num2str(NIT)]);

% -- Ecriture du resultat
mat2ima(res,name3);

%%%tester avec le cerveau

end
