%% PREC90P
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: 90ieme percentile de precipitation 
% Auteur: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Dernier mis a jour: 16/03/09 par Christian Saad
%	Modifications apportees: 
%                - documentation adaptee aux normes du 17/03/09
%				 - en-tete ajoute 
%				 - nom des variables modifiees ('s' a 'In', 'S' a 'In_wout_missval')
%				 - "k=1" a ete efface car n'est jamais utiliser
%				 - le seuil significatif de prec90p a ete changer d'un 
%                  minimum de 10 valeurs a un minimum de 15 valeurs
%
% Historique du code: Reviser le 03/09/2004 par Dimitri Parishkura
%
% Calcule le 90ieme percentile de precipitation en mm/jour.
%
% Sous-fonctions/codes: Aucune fonction complementaire
%
% Entree: Signal de precipitation entrant (In = série temporelle)
%
% Sortie: 90ieme percentile des precipitations (Out = 1 valeur)
%
%
% Variable(s) Globale(s): NA
%
% Variable(s) Locale(s):  
%             - N : taille maximal de la matrice entrante
%		   	  - In_wout_missval : Matrice entrante sans les valeurs manquantes
% 		   	  - N2 : taille maximal de la matrice entrante sans les valeurs manquantes (In_wout_missval)
%		   	  - SS : Matrice entrante sans les valeurs manquantes et sans les valeurs plus petite que 1 mm
%		   	  - SS_size : taille maximal de la matrice entrante sans les valeurs manquantes et les valeurs sous le seuil de 1 mm
%		   	  - In_sorted : Matrice entrante sans les valeurs manquantes et sans les valeurs plus petites que le seuil de 1mm/jour arrange en ordre ascendant
%		   	  - m : Le rang qui sert a extraire la valeur du 90eme percentile de precipitation a apartir de la matrice entrante traitee (In_sorted)
%		   	  - m_floor : le plus proche nombre entier inferieur a m, qui sert a calcule la valeur du 90eme percentile de precipitation si le rang m n'est pas un nombre entier
%		   	  - m_ceil : le plus proche nombre entier superieur a m, qui sert a calcule la valeur du 90eme percentile de precipitation si le rang m n'est pas un nombre entier
%		   	  - slope : pente calcule apartir des valeurs entourants le rang 'm' si ce dernier n'est pas un nombre entier, qui sert a calcule le 90eme percentile de precip
%		
% Pre-requis: NA
%
% Instruction(s): NA
%
% Temps d'execution: Rapide (ex.:?)
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE DESCRIPTION
%
% Name: 90th percentile of precipitation
% Author: Dimitri Parishkura
% Version: v1
% Date:  03/09/2004
%
% Last update: 13/03/2009 by Christian Saad
%	Modifications made: - documentation adapted to normes set on 13/03/09
%                       - header added
%                       - name of variables modified ('s' to 'In', 'S' to
%                       'In_wout_missval')
%                       - "k=1" was erased since never used
%                       - the significant treshold of prec90p was changed
%                         from a minimal sample size of 15 instead of 10
%                         values
%
% Code history: Revised on 03/09/2004 by Dimitri Parishkura
%
%
% Calculates the 90th percentile of precipitation (mm/day).
%
% Sub-functions/codes: NA
%
% Input: - precipitation signal (In = time serie) 
%
% Output: 90th percentile of precipitation (Out = 1 integer)
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
%           - SS : Input matrix without missing values and daily
%                  precipitation values smaller then 1.0 mm
%		   	- SS_size : maximum size of matrix 
%		    - In_sorted : Input matrix without missing values and daily
%		                  precipitation values lower then 1.0mm arranged in
%                         ascending order
%		 	- m : rank used to extract the value assicuated to the 90th
%                 percentile of precipitation via treated input matrix (In_sorted)
%		    - m_floor : the closest integer inferior to m, used to
%                       calculate the 90th percentile value of precipitation 
%                       if the rank m is not an integer 
%		 	- m_ceil : the closest integer superior to m, used to
%                      calculate the 90th percentile value of precipitation 
%                      if the rank m is not an integer 
%		    - slope : slope calculated via values surrounding the rank m if
%                     the latter is not an integer; ths value is used to 
%                     calculate the 90th percentile of daily precipitation
%
% Pre-requisite(s): NA
%
% Instruction(s): NA
%
% Time for execution: quick
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE
function Prec_90p = Prec90p(In)

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
% Le bloque suivant calcule le 90ieme percentile de la serie temporelle 
% entree si il y au moins 80% des donnees entrantes qui correspondent a des 
% valeurs valides (non-manquantes). Dans les cas ou il y a plus de 20 
% de valeurs manquantes, l'indice n'est pas calcule et la variable Prec_90p
% est definie par NaN.
if ((N2/N)<0.8)
    Prec_90p=NaN;
else

    SS=In_wout_missval(In_wout_missval>=1);

    SS_size=max(size(SS));

    % In order for the Prec90p indice to be significant, it needs to be
    % calculated with atleast 15 values. Hence, a minimum of 15 daily
    % non-missing values above the 1.0mm treshold are necessary to
    % calculate the Prec90p variable; else Prec90p is associated to NaN
    %
    % afin que l'index Prec90p soit significatif, il faut qu'il soit 
    % calcule avec au moins 15 valeurs; donc un minimun de 15 valeurs 
    % quotidiennes valides sont necessaires pour le calcule de l'index 
    % sinon la variable Precp_90p est associe a NaN
    if(SS_size<15) 
        Prec_90p=NaN;
    else
        % The values within the input matrix (without missing values and 
        % values below 1.0mm) are arranged in ascending order in the
        % variable "In_sorted"
        %
    	% Les valeurs de la matrice entrante sans les valeurs manquantes et
        % les valeurs plus petites que 1 mm sont arranges en ordre 
        % ascendant dans la variable "In_sorted"
        In_sorted=sort(SS);
        
        % the rank "m" is calculated from the semi-empirical probability
        % formula of Cunnane (1978)
        %
        % le rang 'm' est calcule apartir de la formule semi-empirique de 
        % probabilite de Cunnane (1978)
        m=(SS_size+0.2)*0.9 +0.4;

        % if rank "m" is not an integer, we have to perform a lineare
        % interpolation
        %
        % si le rang 'm' n'est pas un nombre entier, ils faut poursuivre avec
        % une interpolation lineaire
        if(mod(m,1)~=0) 
            
            % round to the nearest integer smaller then rank "m"
            %
            % arrondir au plus proche nombre entier plus petit que rang "m"
            m_floor=floor(m); 
            
            % round up to the nearest integer larger then rank "m"
            %
            % arrondir au plus proche nombre entier plus grand que rang "m"
            m_ceil=ceil(m); 

            % the slope is calculated via the values of "m_floor" and
            % "m_ceil" and with the treated input matrix
            %
            % la pente est calcule a l'aide des index "m_floor" et "m_ceil"
            % puis avec la matrice entrante traitee 
            slope=(In_sorted(m_ceil)-In_sorted(m_floor))/(m_ceil-m_floor);

            % Prec90p is calculated from a value extracted from the treated
            % input matrix, which is added to the product of the slope by
            % the difference between the rank and the nearest smaller
            % integer of the rank
            %
            % l'index Prec90p est calcule apartir d'une valeur extrait de 
            % la matrice entrante traitee qui est additionee au produit de 
            % la pente et la difference entre le rang et le plus proche 
            % nombre entier plus petit que le rang
            Prec_90p=In_sorted(m_floor)+slope*(m-m_floor);

        else    % if the rank "m" is an integer, it is directly used as an
                % index to determine the value of the 90th percentile of 
                % daily precpitation via the treated input matrix "In_sorted"
                %
                % si le rang 'm' est un nombre entier, il est directement
                % utilise comme index afin de definir la valeur du 90eme 
                % percentile de precipitation apartir de la matrice 
                % entrante traitee (In_sorted)
                Prec_90p=In_sorted(m);
        end
    end
end

return