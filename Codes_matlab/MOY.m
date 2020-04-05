%% MOY/PcpAvg
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: Moyenne
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Dernier mis a jour: 16/03/09 par Christian Saad
%	Modifications approtees: - documentation adaptee aux normes du 13/03/09
%				 - en-tete ajoute 
%				 - nom des variables modifiees ('s' a 'In', 'm' a 'Out', 
%                  'S' a 'In_wout_missval')
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
%
% Sortie: Moyenne des valeurs entrante (Out = 1 valeur)
%
% Variable(s) Globale(s): In : Aucune
%
% Variable(s) Locale(s):  N : taille maximal de la matrice entrante
%		   	  In_wout_missval : Matrice entrante sans les valeurs manquantes
% 		   	  N2 : taille maximal de la matrice entrante sans les valeurs 
%                  manquantes (In_wout_missval)
%
% Pre-requis: NA
%
% Instructions: NA
%
% Temps d'execution: Rapide
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE DESCRIPTION
%
% Name: Mean
% Author: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Last update: 16/03/09 by Christian Saad
%	Modifications made: - documentation adapted to normes set on 13/03/09
%                       - header added
%                       - name of variables modified ('s' to 'In', 'S' to
%                       'In_wout_missval')
%
%
% Code history: Revised on 03/09/2004 by Dimitri Parishkura
%
%
% Calculates the mean of the input signal.
%
% Sub-functions/codes: NA
%
% Input: - input signal (In = time serie) 
%
% Output: Mean (Out = 1 integer)
%
%
% Global Variable(s): NA
%
%
% Local Variable(s) : 
%           - N: maximum size of the input matrix
%		  	- In_wout_missval: input matrix without missing values
%		  	- N2 : maximum size of the input matrix without the missing
%                  values (In_wout_missval)
%
% Pre-requisite(s): NA
%
% Instruction(s): NA
%
% Time for execution: quick
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE
function Out = MOY (In)

% N is defined as the maximum size of the input matrix
%
% N est defini comme la taille maximal de la matrice entrante
N=max(size(In));

% In_wout_missval is defined as the input signal without missing values
%
% In_wout_missval est defini comme la matrice entrante mais sans les valeurs manquantes
In_wout_missval=In(In~=-999);

% N2 is defined as the maximum size of the input matrix without missing values
%
% N2 est defini comme la taille maximal de la matrice entrante sans les valeurs manquantes
N2=max(size(In_wout_missval));
clear In;

% The following if statement calculates the mean daily precipitation
% of the input signal if it contains atleast 80% of non-missing data. In
% the case where there is more than 20 % of missing data, the indice is not
% calculated and the Out variable is given an NaN value.
%
% Le bloque suivant calcule la moyenne de la serie temporelle entree si il 
% y au moins 80% des donnees entrantes qui correspondent a des valeurs 
% valides (non-manquantes). Dans les cas ou il y a plus de 20 % de valeurs 
% manquantes, l'indice n'est pas calcule et la variable Out est definie par NaN.
if ((N2/N)<0.8)
    Out=NaN;
else
    % The mean of the input time serie is calculated without
    % any missing value and is associated to the output variable "Out"
    % 
    % La moyenne de la serie temporelle entrante est calcule sans les 
    % valeurs manquantes et est associe a la variable sortante 'Out'
    Out=nanmean(In_wout_missval);
end

return