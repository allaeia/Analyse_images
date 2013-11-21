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
% Written by Xavier Descombes, INRIA

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

%-- Boucle principale
for i = 1 : NIT  % Boucle sur le nombre d'itérations
    for j = 1 : dim(1)
        for k = 1 : dim(2)
            
            valeur_courante = res(j,k);  % Numéro de la classe associé au pixel (j,k)
            valeur_nouvelle = n_classe;  % Atribution d'une nouvelle classe (tirage uniforme, on répète le tirage si égal à n_classe)
            while (valeur_nouvelle == n_classe)
                valeur_nouvelle = floor(n_classe * rand);
            end
            
            % - Energie due a la vraisemblance
            energie_courante = ???????? ;
            energie_nouvelle = ???????? ;
            
            % - Energie du modele a priori
            % A prior 4-connexe
            
            ????????????????
            
            % A prior 8-connexe
            
            ????????????????
            
            % - Dynamique de Metropolis  
            
            ????????????????
            
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



