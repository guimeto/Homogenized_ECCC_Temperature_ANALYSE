% Nom: Autocerrelation de mk_opw_mpw.m
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
% Calcul les valeurs de la fonction d'autocorrelation du test de 
% Mann-Kendall tel que modifie par von Storch (1995)
%
% Sous-fonctions/codes: Aucune fonction complementaire
%
%
% Entree: -Signal de précipitations (fy = série temporelle) - Format vectorielle (1 colonne)
%	      -le nombre de valeur dans la serie temporelle (nVal)
%		  -le rang des valeurs de la fonction d'autocorrelation desire (lagCount)
%		  -valeur attribuee au valeur manquante (missval)
%		  -valeur attribuee au valeur non-disponible (naval)
% Sortie: Valeur desire de la fonction d'autocorrelation (Autocorrelation = 1 nombre)
%
%
%
% Variable(s) Globale(s): Aucune
%
%
%
% Variable(s) Locale(s):  
%			   	sum : somme de differentes operations sur les valeurs de la serie temporelle
%		   	   	validCount : compteur des valeur non-manquantes
% 		   	   	xbar : moyenne des valeurs de la serie temporelle
%		   	  	lag : index de boucle servant a calcule le nombres de jours humides (precipitation >= 1.0 mm/jour)
%				c0 : variance de la serie temporelle 
%				sum2 : somme de differentes operations sur les valeurs de la serie temporelle
%				lag : la position de la valeur considere
%				nterms : nombre de termes
%				autoval : valeurs de la fonction d'autocorrelation
%
% Temps d'execution: Rapide

function Autocorrelation = getAutocorrelation(fy,nVal,lagCount,missval,naval)
    % Les donnees d'entrees contiennent deja les valeurs manquantes
    sum = 0;
    validCount = 0;
    for k=1:nVal
        if fy(k)~=missval
            sum = sum + fy(k);
            validCount = validCount+1;
        end
    end
    xbar = sum/validCount;
    sum = 0;
    validCount = 0;
    for k=1:nVal
        if fy(k)~=missval
            sum = sum + (fy(k) -xbar)^2;
            validCount = validCount + 1;
        end
    end
    c0 = sum/validCount;
    nterms = lagCount;
    autoval = lagCount;
    for j=1:lagCount
        lag = j;
        sum2 = 0;
        nterms(j) = 0;
        for k=1:(nVal-lag)
            if fy(k)~=missval && fy(k+lag)~=missval
                sum2 = sum2 + (fy(k)-xbar) * (fy(k+lag)-xbar);
                nterms(j) = nterms(j)+1;
            end
        end
        % La methode de R pour le calcul d'autocorrelation
        autoval(j) = sum2/validCount/c0;
        
        %D'apres Salas et al. (1980), l'autocorrelation est donnees par 
		%autoval(j)=sum2/nterms(j)/c0
		%Cette deuxieme methode peut donne de fausse valeurs (> abs(1)) pour de grandes valeurs de
        %lag, si il y a des valeurs manquantes.
        %Si il y a des valeurs manquantes, la premiere methode peut-etre tres biasee, 
        %particulierement pour des petits echantillions.
        %Pour des petits echantillions, si la premiere (ou les deux premieres) autocorrelation
        %sont requis et si il y a juste une ou deux valeurs manquantes alors la deuxieme method
        %peut-etre un meilleur choix. Donc il y des compromis a considere lors de l'utilisation 
        %d'une ou de l'autres methodes.
    end
    
    Autocorrelation=autoval;
return