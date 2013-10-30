function bin=lineique(name1,name2)
close all;
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
disp(name1);
%dep = ima2mat('ign1');
dep = ima2mat(name1);
% ?????????
%tmp=dep;
bin=zeros(size(dep));
%figure;imshow(tmp/255);
bin1 = morphofil(dep,1,0);
bin2 = morphofil(dep,0,1);
bin = bitor(hysteresis(bin1,40,140),hysteresis(bin2,40,140));
bin1 = morphofil(dep,2,0);
bin2 = morphofil(dep,0,2);
bin = bitor(bin ,bitor(hysteresis(bin1,50,150),hysteresis(bin2,50,150)));
%bin1 = morphofil(dep,3,0);
%bin2 = morphofil(dep,0,3);
%bin = bitor(bin ,bitor(hysteresis(bin1,80,150),hysteresis(bin2,80,150)));
%tmp=bitand(tmp,bin);

%bin


%bin =;%filtr vert et filtre horizontal

% -- Affichage du resultat
%figure;imshow(tmp);
%figure;
Afficher_extraction(dep,bin);

% -- Ecriture du resultat
mat2ima(bin,name2);

