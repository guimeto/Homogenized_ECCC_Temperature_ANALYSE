% Nom: Pente de Sen de mk_opw_mpw.m
% Auteur: Naveed Khaliq (adaptŽ du code R en MATLAB par Christian Saad)
% Version: v1
% Date:  ?
%
%
% Dernier mis a jour: 22/01/2010 par Christian Saad. 
% 	Modifications apportees: - documentation adaptee aux normes du 13/03/09
%				 - entete ajoute 
%
%
%
% Historique du code: Version MATLAB valider le 21/12/2009 par Christian
%
%
% Calcul la pente de Sen 
%
% Sous-fonctions/codes: Aucune fonction complementaire
%
%
% Entree: -Signal de précipitations (fy = série temporelle) - Format vectorielle (1 colonne)
%		  -valeur attribuee au valeur manquante (missval)
% Sortie: Median des pentes calculees correspondant a la pente de Sen (senSlope = 1 nombre)
%
%
%
% Variable(s) Globale(s): Aucune
%
%
%
% Variable(s) Locale(s):  
%			   	nval : nombre de valeurs non-manquantes de la serie temporelle
%		   	   	work : les valeurs de pente 
% 		   	   	nserial : vecteur de position
%		   	  	work2 : les valeurs de pente reorganise de facon ascendantes
%
% Temps d'execution: Rapide

function senSlope = getSenSlope(fy,missval)
    % Les donnees d'entrees contiennent deja les valeurs manquantes
    nval = 0;
    work = (length(fy)*(length(fy)-1)/2); % Nombre maximal d'evaluations
    nserial = 1:length(fy);
    for k=1:(length(fy)-1)
        for j=k+1:length(fy)
            if fy(j)~=missval && fy(k)~=missval
                nval = nval+1;
                work(nval) = (fy(j) - fy(k)) / (nserial(j) - nserial(k));
            end
        end
    end
    work2 = nval; % due aux donnees manquantes, utilise une matrice differente de taille exacte
    for k=1:nval
        work2(k) = work(k);
    end
    work2 = sort(work2);
    senSlope = nanmedian(work2); % l'utilisation de la fonction nanmedian est necessaire afin  
								 % de traite les valeurs NaN correctement
return