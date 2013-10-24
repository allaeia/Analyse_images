function bin=lineique(name1,name2,% ?????? )
%------------------------------------------------------
% function image=lineique(name1,name2,bas,haut)
%
% Extraction de reseau routier par morphologie mathematique
%
% Entrees : name1 -> nom de l'image (.ima) a traiter (si l'image a traiter
%                    s'apelle ign1.ima l'appel se fait avec name1='ign1')
%           name2 -> nom pour enregistrer l'image en sortie
%           
%           %%%% Ajoutez les parametres que vous juges necessaires  !!!!!!
%
% Sortie  : bin  -> image binarisee du reseau routier
%------------------------------------------------------

%-- Lecture de l'image de depart
dep = ima2mat(name1);  

% ?????????

% -- Affichage du resultat
Afficher_extraction(dep,bin);

% -- Ecriture du resultat
mat2ima(bin,name2);