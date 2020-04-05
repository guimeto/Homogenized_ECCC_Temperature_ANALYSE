%% Prcp1
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: Pourcentage de jours humides
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
%
% Dernier mis a jour: 13/03/2009 par Christian Saad. 
% 	Modifications apportees: - documentation adaptee aux normes du 13/03/09
%				 - entete ajoute 
%				 - nom de variables modifier(s a In, n a Out, S a In_wout_missval)
%
%
%
% Historique du code: Reviser le 03/09/2004 par Dimitri Parishkura
%
%
% Calcule le pourcentage des jours de précipitations (%) [seuil de 1.0mm]
%
% Sous-fonctions/codes: Aucune fonction complementaire
%
%
% Entree: Signal de précipitations (In = série temporelle)
%
% Sortie: Pourcentage des jours de precipitations (Out = 1 nombre)
%
% Variable(s) Globale(s): NA
%
% Variable(s) Locale(s):  
%             - N : taille maximal de la matrice entrante
%		   	  - In_wout_missval : Matrice entrante sans les valeurs manquantes
% 		   	  - N2 : taille maximal de la matrice entrante sans les valeurs manquantes (In_wout_missval)
%		   	  - i : index de boucle servant a calcule le nombres de jours humides (precipitation >= 1.0 mm/jour)
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
% Name: Percentage of humid days
% Author: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Last update: 13/03/2009 by Christian Saad
%	Modifications made: - documentation adapted to normes set on 13/03/09
%                       - header added
%                       - name of variables modified ('s' to 'In', 'S' to
%                       'In_wout_missval')
%
%
% Code history: Revised on 03/09/2004 by Dimitri Parishkura
%
%
% Calculates the percentage of humid days (%) [1.0mm treshold]
%
% Sub-functions/codes: NA
%
% Input: - precipitation signal (In = time serie) 
%
% Output: Percentage of humid days (Out = 1 integer)
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
%           - i : loop index used to calculate the number of humid days
%
% Pre-requisite(s): NA
%
% Instruction(s): NA
%
% Time for execution: quick
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE
function Out = prcp1(In)

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

% The following if statement calculates the percentage of humid days
% of the input signal if it contains atleast 80% of non-missing data. In
% the case where there is more than 20 % of missing data, the indice is not
% calculated and the Out variable is given an NaN value.
%
% Le bloque suivant calcule le pourcentage des jours de pluie si il y au 
% moins 80% de donnees entrantes qui correspondent a des valeurs valides 
% (non-manquantes). Si il y a plus que 20 % de valeurs manquantes, l'indice
% prcp1 n'est pas calcule et la variable Out est definie par NaN.
if((N2/N)<0.8)
    Out=NaN;
else
    Out=0;
    % Loop used to calculate the number of humid days (with precipitation
    % higher then 1mm)
    %
    % Boucle servant a calcule le nombre de jours humides (avec precipitation de plus de 1 mm) 
    for i=1:N2
        if (In_wout_missval(i)>=1.0)
            Out=Out+1;
        end
    end
    
% Out is calculated as the percentage of days with precipitation above
% 1.0mm for the input time serie
%
% Out est calculee comme le pourcentage de jours de precipitation pour la 
% serie temporelle en question.
Out=100*(Out/N2);
end

return