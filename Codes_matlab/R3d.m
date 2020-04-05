%% R3D
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: Maximum de precipitation totales en 3 jours consecutifs (R3d)
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Dernier mis a jour: 16/03/09 par Christian Saad
%	Modifications apportees: - documentation adaptee aux normes du 13/03/09
%				 - en-tete ajoute 
%				 - nom des variables modifiees ('s' a 'In', 'S' a 'In_wout_missval')
%				 - la variable max_n a ete remplacer par R3days
%
% Historique du code: Reviser le 03/09/2004 par Dimitri Parishkura
%
% Calcule la valeur maximal de precipitation totale durant 3 jours consecutifs (en mm) pour la serie temporelle entrante
%
% Sous-fonction/codes: Aucune fonction complementaire
%
% Entree: Signal de precipitation entrant (In = série temporelle)
%
% Sortie: Valeur maximal de precipitation totale durant 3 jours consecutifs (R3days = 1 valeur en mm)
%
% Global variable: NA
%
% Local variable:  
%          - N : taille maximal de la matrice entrante
%		   - In_wout_missval : Matrice entrante sans les valeurs manquantes
% 		   - N2 : taille maximal de la matrice entrante sans les valeurs manquantes (In_wout_missval)
%		   - R3days : valeur maximal de precipitation totale durant 3 jours consecutifs
%		   - temp: valeur temporaire de la precipitation totale durant 3 jours consecutifs
%		   - i : index d'iteration
%
% Pre-requis: NA
%
% Instruction(S): NA
%
% Temps d'execution: Rapide
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE DESCRIPTION
%
% Name: Maximum total precipitation cumulated in 3 consecutive days
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
% Calculates the maximum total precipitation cumulated in 3 consecutive days (mm).
%
% Sub-functions/codes: NA
%
% Input: - input precipitation signal (In = time serie) 
%
% Output: Maximum total precipitation cumulated in 3 consecutive days (mm) 
%         (Out = 1 integer)
%
% Global Variable(s): NA
%
% Local Variable(s) : 
%           - N: maximum size of the input matrix
%		  	- In_wout_missval: input matrix without missing values
%		  	- N2 : maximum size of the input matrix without the missing
%                  values (In_wout_missval)
%		  	- temp : temporary value of cumulated precipitation in 
%                    consecutive days
%		  	- R3days : Maximum total precipitation cumulated in 3
%                      consecutive days
%		  	- i : index for iteration
%
% Pre-requisite(s): NA
%
% Instruction(s): NA
%
% Time for execution: quick
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE
function R3days = R3d(In)

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
clear In_wout_missval;

% The following if statement calculates the 90th percentile of precipitation
% of the input signal if it contains atleast 80% of non-missing data. In
% the case where there is more than 20 of missing data, the indice is not
% calculated and the Out variable is given an NaN value.
%
% Le bloque suivant calcule l'index R3days de la serie temporelle entree si
% il y au moins 80% des donnees entrantes qui correspondent a des valeurs 
% valides (non-manquantes). Dans les cas ou il y a plus de 20 % de valeurs 
% manquantes, l'indice n'est pas calcule et la variable R3days est definie 
% par NaN.
if((N2/N)<0.8)
    R3days=NaN;
else
    
    % initialisation of variables
    %
    % initialisation de temp et R3days
    temp=0;
    R3days=0;
    
    % loop that treats all values of the input time series "In"
    %
    % boucle qui traite toute les valeurs de la serie temporelle entrante (In)
    for i=1:N-2
        
        % if 3 consecutive days contain only valid values, temp is
        % calculated by taking the sum of the precipitation for these 3
        % days
        %
    	% si 3 jours consecutifs contiennent que des valeurs valides, temp 
        % est calcule comme en prenant la somme des precipitations pour ces
        % 3 jours
        if(In(i)~=-999 && In(i+1)~=-999 && In(i+2)~=-999)
            temp=In(i)+In(i+1)+In(i+2);
        end
        
        % if the temporary value "temp" of cumulated precipitation in those
        % 3 days is larger than the previously calculated R3days value, the
        % new value of R3days is given by "temp"
        %
    	% si la valeur temporaire "temp" de la precipitation total en ces 3
        % jours consecutifs est plus grande que la valeur R3days, R3days prend
        % la valeur de temp
        if(R3days<temp)
            R3days=temp;
        end
    end
end

return