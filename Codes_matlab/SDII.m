%% SDII
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: Index d'intensite simple quotidien
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Dernier mis a jour 16/03/2009 par Christian Saad
%	Modifications apportees: - documentaionnadaptee aux normes du 16/03/2009
%				 - en-tete ajoutee
%				 - nom de variables modifie ('s' a 'In', 'S' a 
%                  'In_wout_missval' et 'n' a 'Out')
%
%
% Historique du code: Reviser le 03/09/2004 par Dimitri Parishkura
%
%
% Calcule l'index d'intensite simple quotidien en mm/jour (valeur moyenne de l'intensite de precipitation pour les jours humides)
%
% Sous-fonctions/codes: NA
%
% Entree: Signal de precipitations (In = serie temporelle)
%
% Sortie: Valeur moyenne de l'intensité de précipitations pour seulement les jours de précipitation (Out = mm/jour)
%
% Variable(s) Globale(s): NA
%
% Variable(s) Locale(s):  N : taille maximal de la matrice entrante
%		  	  In_wout_missval : Matrice entrante sans les valeurs manquantes
%		  	  N2 : taille maximal de la matrice entrante sans les valeurs manquantes (In_wout_missval)
%		  	  SS : Matrice entrante sans les valeurs entrante et les valeurs de precipitation plus petites que 1 mm
%
% Pre-requis: NA
%
% Instruction(s): NA
%
% Temps d'execution: Rapide
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE DESCRIPTION
%
% Name: Simple daily intensity index
% Author: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Last update: 16/03/09 by Christian Saad
%	Modifications made: - documentation adapted to normes set on 13/03/09
%                       - header added
%                       - name of variables modified ('s' to 'In', 'S' to
%                       'In_wout_missval', 'n' to 'Out')
%
%
% Code history: Revised on 03/09/2004 by Dimitri Parishkura
%
%
% Calculates the simple daily intensity of precipitation of the input signal.
%
% Sub-functions/codes: NA
%
% Input: - input signal (In = time serie) 
%
% Output: Simple daily intensity of precipitation (Out = 1 integer)
%
%
% Global Variable(s): NA
%
%
% Local Variable(s) : 
%           - N: maximum size of the input matrix
%		  	- In_wout_missval: input matrix without missing values
%		  	- N2 : maximum size of the input matrix without the missing
%                  values "In_wout_missval"
%           - S2 : Input matrix without missing values and precipitation
%                  values smaller than 1.0mm
%
% Pre-requisite(s): NA
%
% Instruction(s): NA
%
% Time for execution: quick
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE
function Out = SDII(In)

% N is defined as the maximum size of the input matrix
%
% N est defini comme la taille maximal de la matrice entrante
N=max(size(In));

% In_wout_missval is defined as the input signal without missing values
%
% In_wout_missval est defini comme la matrice entrante mais sans les valeurs manquantes
In_wout_missval=In(In>-900);

% N2 is defined as the maximum size of the input matrix without missing values
%
% N2 est defini comme la taille maximal de la matrice entrante sans les valeurs manquantes
N2=max(size(In_wout_missval));
clear In;

% The following if statement calculates the 90th percentile of precipitation
% of the input signal if it contains atleast 80% of non-missing data. In
% the case where there is more than 20 of missing data, the indice is not
% calculated and the Out variable is given an NaN value.
%
% Le bloque suivant calcule l'intensite moyenne de precipitation des jours 
% de precipitation si il y au moins 80% des donnees entrantes qui 
% correspondent a des valeurs valides (non-manquantes et plus de 1mm). Dans
% les cas ou il y a plus de 20 % de valeurs manquantes, l'indice n'est pas 
% calcule et la variable Out est definie par NaN.
if((N2/N)<0.8)
    Out=NaN;
else

    % SS is defined as the input matrix with missing values and with
    % precipitation values above the 1.0mm/day treshold set for humid days
    %
    % SS est defini comme la matrice entrante mes sans les valeurs manquantes 
    % et les valeurs de precipitations plus petite que 1 mm/jours
    SS=In_wout_missval(In_wout_missval>=1);

    % The mean value of the precipitation intensiry of humid days is
    % calculated and associated to the output variable "Out"
    %
    % La valeur moyenne de l'intensite des precipitation des jours humides 
    % est calculee et associee a la variable sortante 'Out'
    Out=mean(SS);
end

return