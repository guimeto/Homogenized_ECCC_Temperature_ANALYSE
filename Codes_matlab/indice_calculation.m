%% TEMP_PERCENT
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: Calculateur d'indice par saison (hiver, printemps, ete, automne)
%
% Note(s): Chaque Indice est associer a un nombre entier, voir liste suivante:
%    	cas 1
%    	    Indice='prcp1 Pourcentage de jours avec des precipitations >= 1mm (% de jours)'
%    	cas 2
%    	    Indice='SDII Index d'intensite simple quotidien (mm/jours de precipitation)'
%    	cas 3
%           Indice='CDD Nombre maximal de jours secs consecutifs (jours)'
%    	cas 4
%           Indice='R3days Quantite de precipitation maximal tombe en 3 jours consecutifs(mm) '
%    	cas 9
%           Indice='Tmax90p 90?me centile de Temperature maximal (degr?s Celcius)'
%    	cas 10
%           Indice='Tmin10p 10?me centile de Temperature mininmal (degr?s Celcius)'
%    	cas 11
%           Indice='Prec90p 90?me centile des Pr?cipitations quotidiennes (mm/jour)'
%    	cas 13
%           Indice='PrecTOT Pr?cipitation totale (mm)'
%       cas 14
%           Indice='Tmax10p' 10eme centile de Temperature maximal (degres Celcius)'
%       cas 15
%           Indice='Tmin90p' 90eme centile de Temperature minimal (degres Celcius)'
%    	cas 50
%           Indice='mean, moyenne (mm)'
%    	cas 51
%           Indice='std, ecart-type (mm)'
%    	cas 99
%           Indice='mid, Manquant %'
%       cas 13
%           Indice='PrecTOT, mm'
%       cas 69
%           Indice='CWD, Nombre maximal de jours humides consecutifs (jours)'
%       cas 70
%           Indice='max, Valeur maximale de la temperature maximale'
%       cas 71
%           Indice='min, Valeur minimale de la temperature maximale'
%
%% CODE
function b = indice_calculation(sig, Indice)

           
            %Code
            if(Indice==1)
                b=prcp1(sig);
            elseif(Indice==2)
                b=SDII(sig);
            elseif(Indice==3)
                b=CDD(sig);
            elseif(Indice==4)
                b=R3d(sig);
            elseif(Indice==9)
                b=Tmax90p(sig);
            elseif(Indice==10)
                b=Tmin10p(sig);
            elseif(Indice==14)
                b=Tmax10p(sig);
            elseif(Indice==15)
                b=Tmin90p(sig);
            elseif(Indice==11)
                b=Prec90p(sig);
            elseif(Indice==12)
                b=R90N(sig);
            elseif(Indice==50)
                b=nanmean(sig);
            elseif(Indice==51)
                b=std(sig);
            elseif(Indice==13)
                b=PrecTOT(sig);
            elseif(Indice==69)
                b=CWD(sig);
            elseif(Indice==70)
                b=max(sig);  
            elseif(Indice==71)
                b=min(sig);  
            end

end

        
% Fin / End