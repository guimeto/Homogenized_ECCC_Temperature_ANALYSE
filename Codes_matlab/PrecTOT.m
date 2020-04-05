% Nom: Moyenne
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Dernier mis a jour: 16/03/09 par Christian Saad
%	Modifications approtees: - documentation adaptee aux normes du 13/03/09
%				 - en-tete ajoute 
%				 - nom des variables modifiees ('s' a 'In', 'm' a 'Out', 'S' a 'In_wout_missval')
%
%
%
% Historique du code: Reviser le 03/09/2004 par Dimitri Parishkura
%
%
% Calcule la valeur moyenne du signal entrant
%
% Sous-fonctions/codes: Aucune fonction complementaire
%
%
% Entree: Signal entrant (In = série temporelle)
%	  Format vectorielle (1 colonne ou 1 ligne) ou matricielle
% Sortie: Moyenne des valeurs entrante (Out = 1 valeur)
%
%
%
% Variable(s) Globale(s): In : Aucune
%
%
%
% Variable(s) Locale(s):  N : taille maximal de la matrice entrante
%		   	  In_wout_missval : Matrice entrante sans les valeurs manquantes
% 		   	  N2 : taille maximal de la matrice entrante sans les valeurs manquantes (In_wout_missval)
%
%
% Temps d'execution: Rapide (ex.:?)

function Out = PrecTOT (In)

% N est defini comme la taille maximal de la matrice entrante
N=max(size(In));

% In_wout_missval est defini comme la matrice entrante mais sans les valeurs manquantes
In_wout_missval=In(In~=-999);

% N2 est defini comme la taille maximal de la matrice entrante sans les valeurs manquantes
N2=max(size(In_wout_missval));
clear In;

% Le bloque suivant calcule la moyenne de la serie temporelle entree si il y au moins 80% des donnees entrantes qui correspondent a des valeurs valides (non-manquantes). Dans les cas ou il y a plus de 20 % de valeurs manquantes, l'indice n'est pas calcule et la variable Out est definie par NaN.
 if ((N2/N)<0.8)
          Out=NaN
 else
%  La moyenne de la serie temporelle entrante est calcule sans les valeurs manquantes et est associe a la variable sortante 'Out'
    Out=nansum(In_wout_missval);
% end



return