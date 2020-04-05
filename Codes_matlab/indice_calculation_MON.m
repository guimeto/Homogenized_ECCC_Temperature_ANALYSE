%% INDICE_CALCULATION_MON
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
%
% Nom: indice_calculation_MON - calculatrice d'indice d'extreme mensuel
% Auteur: Dimitri Parishkura
% Date:  04/07/2005
% Date de revision: 04/07/2005
%
% Dernieres modifications: - Documentation mise a jour par Christian Saad
%                            le 25/10/2010
%
% Ce code permet de calculer les indices d'extremes CDD, SDII, Prcp1, 
% Prec90p, PcpAvg, PcpStd, R3d, Fr/Th Nombre de jours de Gel/Dégel 
% (Tmax>0 et Tmin<=0)  sur une base mensuelle. Une matrice de dimension
% nombre d'annees X 12 mois est donc generer (1ere colonne pour janvier,
% 12eme colonne pour decembre).
%
% Entrees:  - Jan1: Serie temporelle (vecteur) des donnees quotidiennes de
%                   tous les mois de janvier (de chaque annee)
%           - start_year: nombre entier, qui correspond a l'annee du debut
%                         de la serie temporelle;
%           - end_year: nombre entier, qui correspond a l'annee de la fin
%                         de la serie temporelle;
%           - y_length: nombre entier qui correspond au nombre maximal de 
%                       jours par annee pour le type de serie temporelle 
%                       analyse (choix disponible: 366, 365 or 360)
%
% Sortie: - b: Une matrice de dimension nombre d'annees X 12 mois est donc 
%              generer (1ere colonne pour janvier,12eme colonne pour decembre)
%
% Sous-fonction(s)/code(s): NA
%
% Pre-requis: NA
%
% Instruction(s): NA
%
% Note(s):
%        Indice= integer, voir ci-dessous
%    cas 1
%        Indice_name='CDD Nombre maximal de jours secs consecutifs (jours)'
%    cas 2
%        Indice_name='prcp1 Pourcentage de jours avec des precipitations >= 1mm (% de jours)'
%    cas 3
%        Indice_name='Prec90p 90ème centile des Précipitations quotidiennes (mm/jour)'
%    cas 4
%        Indice_name='SDII Index d'intensite simple quotidien (mm/jours de precipitation)'
%    cas 5
%        Indice_name='PrecTOT Precipitation totale'
%    cas 6
%        Indice_name='R3days Quantite de precipitation maximal tombe en 3 jours consecutifs(mm) '
%    cas 7
%        Indice_name='R90N '
%    cas 8
%        Indice_name='mean, moyenne (mm)'
%    cas 9
%        Indice_name='std, ecart-type (mm)'
%    cas 10
%        Indice_name='SKEW '
%    cas 11
%        Indice_name='std, ecart-type des jours humides seulement(mm)'
%    cas 12
%        Indice_name='Fd nombre de jours de gel/degel (jours)'
%
% Contact: christian.saad@mail.mcgill.ca


%% CODE DESCRIPTION
%
% Name: indice_calculation_MON - indice calculator per month
% Author: Dimitri Parishkura
% Date:  04/07/2005
% Revised Date: 04/07/2005
%
% Last update: - Documentation update by Christian Saad on 25/10/2010
%
% Code for calculating extreme indices such as CDD, SDII, Prcp1, Prec90p, 
% PcpAvg, PcpStd, R3d, Fr/Th Number of days in freeze and thaw cycle
% (Tmax>0 et Tmin<=0) on a monthly basis. Returns a matrix of size 
% NUMBER_OF_YEARS x 12(1st column for January, 12th for December).
%
% Input: - Jan1: time serie(a vector) of daily data for all januaries of all years.
%        - start_year: integer, corresponding to the start year of the time series;
%        - end_year: integer, corresponding to the end year of the time series;
%        - y_length: integer of maximum year length (only choices: 366, 365 or 360)
%
% Output: - b:  matrix of dimension: NUMBER_OF_YEARS x 12 (1st column for 
%               January, 12th for December)
%
% Sub-function(s)/code(s): NA
%
% Pre-requisite(s): NA
%
% Instruction(s):
%
% Note(s):
%        Indice= integer, see below
%    case 1
%        Indice_name='CDD Consecutive dry days'
%    case 2
%        Indice_name='Prcp1 Percentage of Wet days'
%    case 3
%        Indice_name='Prec90p 90th percentile of precipitation '
%    case 4
%        Indice_name='SDII Simple daily intensity index'
%    case 5
%        Indice_name='PrecTOT Total precipitation'
%    case 6
%        Indice_name='R3days Maximum de précipitations totales durant 3 jours consécutifs'
%    case 7
%        Indice_name='R90N '
%    case 8
%        Indice_name='MOY '
%    case 9
%        Indice_name='STD '
%    case 10
%        Indice_name='SKEW '
%    case 11
%        Indice_name='STD wet days only '
%    case 12
%        Indice_name='Fd number of frost days'
%
% Contact: christian.saad@mail.mcgill.ca



function b = indice_calculation_MON(Jan1,Feb1,Mar1,Apr1,May1,Jun1,Jul1,Aug1,Sep1,Oct1,Nov1,Dec1, start_year, end_year, y_length, Indice)
curr_year=start_year;

temp_jan=1;
temp_feb=1;
temp_mar=1;
temp_apr=1;
temp_may=1;
temp_jun=1;
temp_jul=1;
temp_aug=1;
temp_sep=1;
temp_oct=1;
temp_nov=1;
temp_dec=1;
i=1;

if(y_length==366)
    while (curr_year<=end_year)
        if ( mod(curr_year, 4)==0 )
            temp_jan1=Jan1(temp_jan:temp_jan+30);
            temp_feb1=Feb1(temp_feb:temp_feb+28);
            temp_mar1=Mar1(temp_mar:temp_mar+30);
            temp_apr1=Apr1(temp_apr:temp_apr+29);
            temp_may1=May1(temp_may:temp_may+30);
            temp_jun1=Jun1(temp_jun:temp_jun+29);
            temp_jul1=Jul1(temp_jul:temp_jul+30);
            temp_aug1=Aug1(temp_aug:temp_aug+30);
            temp_sep1=Sep1(temp_sep:temp_sep+29);
            temp_oct1=Oct1(temp_oct:temp_oct+30);
            temp_nov1=Nov1(temp_nov:temp_nov+29);
            temp_dec1=Dec1(temp_dec:temp_dec+30);

           if(Indice==3)              
                    b(i,1)=CDD(temp_jan1);
                    b(i,2)=CDD(temp_feb1);
                    b(i,3)=CDD(temp_mar1);
                    b(i,4)=CDD(temp_apr1);
                    b(i,5)=CDD(temp_may1);
                    b(i,6)=CDD(temp_jun1);
                    b(i,7)=CDD(temp_jul1);
                    b(i,8)=CDD(temp_aug1);
                    b(i,9)=CDD(temp_sep1);
                    b(i,10)=CDD(temp_oct1);
                    b(i,11)=CDD(temp_nov1);
                    b(i,12)=CDD(temp_dec1);
            elseif(Indice==1)
                    b(i,1)=prcp1(temp_jan1);
                    b(i,2)=prcp1(temp_feb1);
                    b(i,3)=prcp1(temp_mar1);
                    b(i,4)=prcp1(temp_apr1);
                    b(i,5)=prcp1(temp_may1);
                    b(i,6)=prcp1(temp_jun1);
                    b(i,7)=prcp1(temp_jul1);
                    b(i,8)=prcp1(temp_aug1);
                    b(i,9)=prcp1(temp_sep1);
                    b(i,10)=prcp1(temp_oct1);
                    b(i,11)=prcp1(temp_nov1);
                    b(i,12)=prcp1(temp_dec1);
            elseif(Indice==11)
                    b(i,1)=Prec90p(temp_jan1);
                    b(i,2)=Prec90p(temp_feb1);
                    b(i,3)=Prec90p(temp_mar1);
                    b(i,4)=Prec90p(temp_apr1);
                    b(i,5)=Prec90p(temp_may1);
                    b(i,6)=Prec90p(temp_jun1);
                    b(i,7)=Prec90p(temp_jul1);
                    b(i,8)=Prec90p(temp_aug1);
                    b(i,9)=Prec90p(temp_sep1);
                    b(i,10)=Prec90p(temp_oct1);
                    b(i,11)=Prec90p(temp_nov1);
                    b(i,12)=Prec90p(temp_dec1);
            elseif(Indice==2)
                    b(i,1)=SDII(temp_jan1);
                    b(i,2)=SDII(temp_feb1);
                    b(i,3)=SDII(temp_mar1);
                    b(i,4)=SDII(temp_apr1);
                    b(i,5)=SDII(temp_may1);
                    b(i,6)=SDII(temp_jun1);
                    b(i,7)=SDII(temp_jul1);
                    b(i,8)=SDII(temp_aug1);
                    b(i,9)=SDII(temp_sep1);
                    b(i,10)=SDII(temp_oct1);
                    b(i,11)=SDII(temp_nov1);
                    b(i,12)=SDII(temp_dec1);
            elseif(Indice==13)
                    b(i,1)=PrecTOT(temp_jan1);
                    b(i,2)=PrecTOT(temp_feb1);
                    b(i,3)=PrecTOT(temp_mar1);
                    b(i,4)=PrecTOT(temp_apr1);
                    b(i,5)=PrecTOT(temp_may1);
                    b(i,6)=PrecTOT(temp_jun1);
                    b(i,7)=PrecTOT(temp_jul1);
                    b(i,8)=PrecTOT(temp_aug1);
                    b(i,9)=PrecTOT(temp_sep1);
                    b(i,10)=PrecTOT(temp_oct1);
                    b(i,11)=PrecTOT(temp_nov1);
                    b(i,12)=PrecTOT(temp_dec1);
             elseif(Indice==4)
                    b(i,1)=R3d(temp_jan1);
                    b(i,2)=R3d(temp_feb1);
                    b(i,3)=R3d(temp_mar1);
                    b(i,4)=R3d(temp_apr1);
                    b(i,5)=R3d(temp_may1);
                    b(i,6)=R3d(temp_jun1);
                    b(i,7)=R3d(temp_jul1);
                    b(i,8)=R3d(temp_aug1);
                    b(i,9)=R3d(temp_sep1);
                    b(i,10)=R3d(temp_oct1);
                    b(i,11)=R3d(temp_nov1);
                    b(i,12)=R3d(temp_dec1);             
              elseif(Indice==50)
                    b(i,1)=MOY(temp_jan1);
                    b(i,2)=MOY(temp_feb1);
                    b(i,3)=MOY(temp_mar1);
                    b(i,4)=MOY(temp_apr1);
                    b(i,5)=MOY(temp_may1);
                    b(i,6)=MOY(temp_jun1);
                    b(i,7)=MOY(temp_jul1);
                    b(i,8)=MOY(temp_aug1);
                    b(i,9)=MOY(temp_sep1);
                    b(i,10)=MOY(temp_oct1);
                    b(i,11)=MOY(temp_nov1);
                    b(i,12)=MOY(temp_dec1); 
             elseif(Indice==51)
                    b(i,1)=DST(temp_jan1);
                    b(i,2)=DST(temp_feb1);
                    b(i,3)=DST(temp_mar1);
                    b(i,4)=DST(temp_apr1);
                    b(i,5)=DST(temp_may1);
                    b(i,6)=DST(temp_jun1);
                    b(i,7)=DST(temp_jul1);
                    b(i,8)=DST(temp_aug1);
                    b(i,9)=DST(temp_sep1);
                    b(i,10)=DST(temp_oct1);
                    b(i,11)=DST(temp_nov1);
                    b(i,12)=DST(temp_dec1);                
            end

            temp_jan=temp_jan+31;
            temp_feb=temp_feb+29;
            temp_mar=temp_mar+31;
            temp_apr=temp_apr+30;
            temp_may=temp_may+31;
            temp_jun=temp_jun+30;
            temp_jul=temp_jul+31;
            temp_aug=temp_aug+31;
            temp_sep=temp_sep+30;
            temp_oct=temp_oct+31;
            temp_nov=temp_nov+30;
            temp_dec=temp_dec+31;


        else
            temp_jan1=Jan1(temp_jan:temp_jan+30);
            temp_feb1=Feb1(temp_feb:temp_feb+27);
            temp_mar1=Mar1(temp_mar:temp_mar+30);
            temp_apr1=Apr1(temp_apr:temp_apr+29);
            temp_may1=May1(temp_may:temp_may+30);
            temp_jun1=Jun1(temp_jun:temp_jun+29);
            temp_jul1=Jul1(temp_jul:temp_jul+30);
            temp_aug1=Aug1(temp_aug:temp_aug+30);
            temp_sep1=Sep1(temp_sep:temp_sep+29);
            temp_oct1=Oct1(temp_oct:temp_oct+30);
            temp_nov1=Nov1(temp_nov:temp_nov+29);
            temp_dec1=Dec1(temp_dec:temp_dec+30);

             if(Indice==3)              
                    b(i,1)=CDD(temp_jan1);
                    b(i,2)=CDD(temp_feb1);
                    b(i,3)=CDD(temp_mar1);
                    b(i,4)=CDD(temp_apr1);
                    b(i,5)=CDD(temp_may1);
                    b(i,6)=CDD(temp_jun1);
                    b(i,7)=CDD(temp_jul1);
                    b(i,8)=CDD(temp_aug1);
                    b(i,9)=CDD(temp_sep1);
                    b(i,10)=CDD(temp_oct1);
                    b(i,11)=CDD(temp_nov1);
                    b(i,12)=CDD(temp_dec1);
            elseif(Indice==1)
                    b(i,1)=prcp1(temp_jan1);
                    b(i,2)=prcp1(temp_feb1);
                    b(i,3)=prcp1(temp_mar1);
                    b(i,4)=prcp1(temp_apr1);
                    b(i,5)=prcp1(temp_may1);
                    b(i,6)=prcp1(temp_jun1);
                    b(i,7)=prcp1(temp_jul1);
                    b(i,8)=prcp1(temp_aug1);
                    b(i,9)=prcp1(temp_sep1);
                    b(i,10)=prcp1(temp_oct1);
                    b(i,11)=prcp1(temp_nov1);
                    b(i,12)=prcp1(temp_dec1);
            elseif(Indice==11)
                    b(i,1)=Prec90p(temp_jan1);
                    b(i,2)=Prec90p(temp_feb1);
                    b(i,3)=Prec90p(temp_mar1);
                    b(i,4)=Prec90p(temp_apr1);
                    b(i,5)=Prec90p(temp_may1);
                    b(i,6)=Prec90p(temp_jun1);
                    b(i,7)=Prec90p(temp_jul1);
                    b(i,8)=Prec90p(temp_aug1);
                    b(i,9)=Prec90p(temp_sep1);
                    b(i,10)=Prec90p(temp_oct1);
                    b(i,11)=Prec90p(temp_nov1);
                    b(i,12)=Prec90p(temp_dec1);
            elseif(Indice==2)
                    b(i,1)=SDII(temp_jan1);
                    b(i,2)=SDII(temp_feb1);
                    b(i,3)=SDII(temp_mar1);
                    b(i,4)=SDII(temp_apr1);
                    b(i,5)=SDII(temp_may1);
                    b(i,6)=SDII(temp_jun1);
                    b(i,7)=SDII(temp_jul1);
                    b(i,8)=SDII(temp_aug1);
                    b(i,9)=SDII(temp_sep1);
                    b(i,10)=SDII(temp_oct1);
                    b(i,11)=SDII(temp_nov1);
                    b(i,12)=SDII(temp_dec1);
            elseif(Indice==13)
                    b(i,1)=PrecTOT(temp_jan1);
                    b(i,2)=PrecTOT(temp_feb1);
                    b(i,3)=PrecTOT(temp_mar1);
                    b(i,4)=PrecTOT(temp_apr1);
                    b(i,5)=PrecTOT(temp_may1);
                    b(i,6)=PrecTOT(temp_jun1);
                    b(i,7)=PrecTOT(temp_jul1);
                    b(i,8)=PrecTOT(temp_aug1);
                    b(i,9)=PrecTOT(temp_sep1);
                    b(i,10)=PrecTOT(temp_oct1);
                    b(i,11)=PrecTOT(temp_nov1);
                    b(i,12)=PrecTOT(temp_dec1);
             elseif(Indice==4)
                    b(i,1)=R3d(temp_jan1);
                    b(i,2)=R3d(temp_feb1);
                    b(i,3)=R3d(temp_mar1);
                    b(i,4)=R3d(temp_apr1);
                    b(i,5)=R3d(temp_may1);
                    b(i,6)=R3d(temp_jun1);
                    b(i,7)=R3d(temp_jul1);
                    b(i,8)=R3d(temp_aug1);
                    b(i,9)=R3d(temp_sep1);
                    b(i,10)=R3d(temp_oct1);
                    b(i,11)=R3d(temp_nov1);
                    b(i,12)=R3d(temp_dec1);             
              elseif(Indice==50)
                    b(i,1)=MOY(temp_jan1);
                    b(i,2)=MOY(temp_feb1);
                    b(i,3)=MOY(temp_mar1);
                    b(i,4)=MOY(temp_apr1);
                    b(i,5)=MOY(temp_may1);
                    b(i,6)=MOY(temp_jun1);
                    b(i,7)=MOY(temp_jul1);
                    b(i,8)=MOY(temp_aug1);
                    b(i,9)=MOY(temp_sep1);
                    b(i,10)=MOY(temp_oct1);
                    b(i,11)=MOY(temp_nov1);
                    b(i,12)=MOY(temp_dec1); 
             elseif(Indice==51)
                    b(i,1)=DST(temp_jan1);
                    b(i,2)=DST(temp_feb1);
                    b(i,3)=DST(temp_mar1);
                    b(i,4)=DST(temp_apr1);
                    b(i,5)=DST(temp_may1);
                    b(i,6)=DST(temp_jun1);
                    b(i,7)=DST(temp_jul1);
                    b(i,8)=DST(temp_aug1);
                    b(i,9)=DST(temp_sep1);
                    b(i,10)=DST(temp_oct1);
                    b(i,11)=DST(temp_nov1);
                    b(i,12)=DST(temp_dec1);                
            end



            temp_jan=temp_jan+31;
            temp_feb=temp_feb+28;
            temp_mar=temp_mar+31;
            temp_apr=temp_apr+30;
            temp_may=temp_may+31;
            temp_jun=temp_jun+30;
            temp_jul=temp_jul+31;
            temp_aug=temp_aug+31;
            temp_sep=temp_sep+30;
            temp_oct=temp_oct+31;
            temp_nov=temp_nov+30;
            temp_dec=temp_dec+31;


        end

        clear temp_jan1 temp_feb1 temp_mar1 temp_apr1 temp_may1 temp_jun1 temp_jul1 temp_aug1 temp_sep1 temp_oct1 temp_nov1 temp_dec1;
        curr_year=curr_year+1;

        i=i+1;
    end
    if(Indice==7)
        b(i,1)=NaN;b(i,2)=NaN;b(i,3)=NaN;b(i,4)=NaN;b(i,5)=NaN;b(i,6)=NaN;b(i,7)=NaN;b(i,8)=NaN;b(i,9)=NaN;b(i,10)=NaN;b(i,11)=NaN;b(i,12)=NaN;
        i=i+1;
        b(i,1)=Jan_90p;b(i,2)=Feb_90p;b(i,3)=Mar_90p;b(i,4)=Apr_90p;b(i,5)=May_90p;b(i,6)=Jun_90p;b(i,7)=Jul_90p;b(i,8)=Aug_90p;b(i,9)=Sep_90p;b(i,10)=Oct_90p;b(i,11)=Nov_90p;b(i,12)=Dec_90p;
    end
    
elseif(y_length==365)
    while(curr_year<=end_year)
        temp_jan1=Jan1(temp_jan:temp_jan+30);
        temp_feb1=Feb1(temp_feb:temp_feb+27);
        temp_mar1=Mar1(temp_mar:temp_mar+30);
        temp_apr1=Apr1(temp_apr:temp_apr+29);
        temp_may1=May1(temp_may:temp_may+30);
        temp_jun1=Jun1(temp_jun:temp_jun+29);
        temp_jul1=Jul1(temp_jul:temp_jul+30);
        temp_aug1=Aug1(temp_aug:temp_aug+30);
        temp_sep1=Sep1(temp_sep:temp_sep+29);
        temp_oct1=Oct1(temp_oct:temp_oct+30);
        temp_nov1=Nov1(temp_nov:temp_nov+29);
        temp_dec1=Dec1(temp_dec:temp_dec+30);

         if(Indice==3)              
                    b(i,1)=CDD(temp_jan1);
                    b(i,2)=CDD(temp_feb1);
                    b(i,3)=CDD(temp_mar1);
                    b(i,4)=CDD(temp_apr1);
                    b(i,5)=CDD(temp_may1);
                    b(i,6)=CDD(temp_jun1);
                    b(i,7)=CDD(temp_jul1);
                    b(i,8)=CDD(temp_aug1);
                    b(i,9)=CDD(temp_sep1);
                    b(i,10)=CDD(temp_oct1);
                    b(i,11)=CDD(temp_nov1);
                    b(i,12)=CDD(temp_dec1);
            elseif(Indice==1)
                    b(i,1)=prcp1(temp_jan1);
                    b(i,2)=prcp1(temp_feb1);
                    b(i,3)=prcp1(temp_mar1);
                    b(i,4)=prcp1(temp_apr1);
                    b(i,5)=prcp1(temp_may1);
                    b(i,6)=prcp1(temp_jun1);
                    b(i,7)=prcp1(temp_jul1);
                    b(i,8)=prcp1(temp_aug1);
                    b(i,9)=prcp1(temp_sep1);
                    b(i,10)=prcp1(temp_oct1);
                    b(i,11)=prcp1(temp_nov1);
                    b(i,12)=prcp1(temp_dec1);
            elseif(Indice==11)
                    b(i,1)=Prec90p(temp_jan1);
                    b(i,2)=Prec90p(temp_feb1);
                    b(i,3)=Prec90p(temp_mar1);
                    b(i,4)=Prec90p(temp_apr1);
                    b(i,5)=Prec90p(temp_may1);
                    b(i,6)=Prec90p(temp_jun1);
                    b(i,7)=Prec90p(temp_jul1);
                    b(i,8)=Prec90p(temp_aug1);
                    b(i,9)=Prec90p(temp_sep1);
                    b(i,10)=Prec90p(temp_oct1);
                    b(i,11)=Prec90p(temp_nov1);
                    b(i,12)=Prec90p(temp_dec1);
            elseif(Indice==2)
                    b(i,1)=SDII(temp_jan1);
                    b(i,2)=SDII(temp_feb1);
                    b(i,3)=SDII(temp_mar1);
                    b(i,4)=SDII(temp_apr1);
                    b(i,5)=SDII(temp_may1);
                    b(i,6)=SDII(temp_jun1);
                    b(i,7)=SDII(temp_jul1);
                    b(i,8)=SDII(temp_aug1);
                    b(i,9)=SDII(temp_sep1);
                    b(i,10)=SDII(temp_oct1);
                    b(i,11)=SDII(temp_nov1);
                    b(i,12)=SDII(temp_dec1);
            elseif(Indice==13)
                    b(i,1)=PrecTOT(temp_jan1);
                    b(i,2)=PrecTOT(temp_feb1);
                    b(i,3)=PrecTOT(temp_mar1);
                    b(i,4)=PrecTOT(temp_apr1);
                    b(i,5)=PrecTOT(temp_may1);
                    b(i,6)=PrecTOT(temp_jun1);
                    b(i,7)=PrecTOT(temp_jul1);
                    b(i,8)=PrecTOT(temp_aug1);
                    b(i,9)=PrecTOT(temp_sep1);
                    b(i,10)=PrecTOT(temp_oct1);
                    b(i,11)=PrecTOT(temp_nov1);
                    b(i,12)=PrecTOT(temp_dec1);
             elseif(Indice==4)
                    b(i,1)=R3d(temp_jan1);
                    b(i,2)=R3d(temp_feb1);
                    b(i,3)=R3d(temp_mar1);
                    b(i,4)=R3d(temp_apr1);
                    b(i,5)=R3d(temp_may1);
                    b(i,6)=R3d(temp_jun1);
                    b(i,7)=R3d(temp_jul1);
                    b(i,8)=R3d(temp_aug1);
                    b(i,9)=R3d(temp_sep1);
                    b(i,10)=R3d(temp_oct1);
                    b(i,11)=R3d(temp_nov1);
                    b(i,12)=R3d(temp_dec1);             
              elseif(Indice==50)
                    b(i,1)=MOY(temp_jan1);
                    b(i,2)=MOY(temp_feb1);
                    b(i,3)=MOY(temp_mar1);
                    b(i,4)=MOY(temp_apr1);
                    b(i,5)=MOY(temp_may1);
                    b(i,6)=MOY(temp_jun1);
                    b(i,7)=MOY(temp_jul1);
                    b(i,8)=MOY(temp_aug1);
                    b(i,9)=MOY(temp_sep1);
                    b(i,10)=MOY(temp_oct1);
                    b(i,11)=MOY(temp_nov1);
                    b(i,12)=MOY(temp_dec1); 
             elseif(Indice==51)
                    b(i,1)=DST(temp_jan1);
                    b(i,2)=DST(temp_feb1);
                    b(i,3)=DST(temp_mar1);
                    b(i,4)=DST(temp_apr1);
                    b(i,5)=DST(temp_may1);
                    b(i,6)=DST(temp_jun1);
                    b(i,7)=DST(temp_jul1);
                    b(i,8)=DST(temp_aug1);
                    b(i,9)=DST(temp_sep1);
                    b(i,10)=DST(temp_oct1);
                    b(i,11)=DST(temp_nov1);
                    b(i,12)=DST(temp_dec1);                
            end
        temp_jan=temp_jan+31;
        temp_feb=temp_feb+28;
        temp_mar=temp_mar+31;
        temp_apr=temp_apr+30;
        temp_may=temp_may+31;
        temp_jun=temp_jun+30;
        temp_jul=temp_jul+31;
        temp_aug=temp_aug+31;
        temp_sep=temp_sep+30;
        temp_oct=temp_oct+31;
        temp_nov=temp_nov+30;
        temp_dec=temp_dec+31;

        clear temp_jan1 temp_feb1 temp_mar1 temp_apr1 temp_may1 temp_jun1 temp_jul1 temp_aug1 temp_sep1 temp_oct1 temp_nov1 temp_dec1;        
        curr_year=curr_year+1;
        i=i+1;
    end
    if(Indice==7)
        b(i,1)=NaN;b(i,2)=NaN;b(i,3)=NaN;b(i,4)=NaN;b(i,5)=NaN;b(i,6)=NaN;b(i,7)=NaN;b(i,8)=NaN;b(i,9)=NaN;b(i,10)=NaN;b(i,11)=NaN;b(i,12)=NaN;
        i=i+1;
        b(i,1)=Jan_90p;b(i,2)=Feb_90p;b(i,3)=Mar_90p;b(i,4)=Apr_90p;b(i,5)=May_90p;b(i,6)=Jun_90p;b(i,7)=Jul_90p;b(i,8)=Aug_90p;b(i,9)=Sep_90p;b(i,10)=Oct_90p;b(i,11)=Nov_90p;b(i,12)=Dec_90p;
    end
    

elseif(y_length==360)
    while(curr_year<=end_year)
        temp_jan1=Jan1(temp_jan:temp_jan+29);
        temp_feb1=Feb1(temp_feb:temp_feb+29);
        temp_mar1=Mar1(temp_mar:temp_mar+29);
        temp_apr1=Apr1(temp_apr:temp_apr+29);
        temp_may1=May1(temp_may:temp_may+29);
        temp_jun1=Jun1(temp_jun:temp_jun+29);
        temp_jul1=Jul1(temp_jul:temp_jul+29);
        temp_aug1=Aug1(temp_aug:temp_aug+29);
        temp_sep1=Sep1(temp_sep:temp_sep+29);
        temp_oct1=Oct1(temp_oct:temp_oct+29);
        temp_nov1=Nov1(temp_nov:temp_nov+29);
        temp_dec1=Dec1(temp_dec:temp_dec+29);

        if(Indice==3)              
                    b(i,1)=CDD(temp_jan1);
                    b(i,2)=CDD(temp_feb1);
                    b(i,3)=CDD(temp_mar1);
                    b(i,4)=CDD(temp_apr1);
                    b(i,5)=CDD(temp_may1);
                    b(i,6)=CDD(temp_jun1);
                    b(i,7)=CDD(temp_jul1);
                    b(i,8)=CDD(temp_aug1);
                    b(i,9)=CDD(temp_sep1);
                    b(i,10)=CDD(temp_oct1);
                    b(i,11)=CDD(temp_nov1);
                    b(i,12)=CDD(temp_dec1);
            elseif(Indice==1)
                    b(i,1)=prcp1(temp_jan1);
                    b(i,2)=prcp1(temp_feb1);
                    b(i,3)=prcp1(temp_mar1);
                    b(i,4)=prcp1(temp_apr1);
                    b(i,5)=prcp1(temp_may1);
                    b(i,6)=prcp1(temp_jun1);
                    b(i,7)=prcp1(temp_jul1);
                    b(i,8)=prcp1(temp_aug1);
                    b(i,9)=prcp1(temp_sep1);
                    b(i,10)=prcp1(temp_oct1);
                    b(i,11)=prcp1(temp_nov1);
                    b(i,12)=prcp1(temp_dec1);
            elseif(Indice==11)
                    b(i,1)=Prec90p(temp_jan1);
                    b(i,2)=Prec90p(temp_feb1);
                    b(i,3)=Prec90p(temp_mar1);
                    b(i,4)=Prec90p(temp_apr1);
                    b(i,5)=Prec90p(temp_may1);
                    b(i,6)=Prec90p(temp_jun1);
                    b(i,7)=Prec90p(temp_jul1);
                    b(i,8)=Prec90p(temp_aug1);
                    b(i,9)=Prec90p(temp_sep1);
                    b(i,10)=Prec90p(temp_oct1);
                    b(i,11)=Prec90p(temp_nov1);
                    b(i,12)=Prec90p(temp_dec1);
            elseif(Indice==2)
                    b(i,1)=SDII(temp_jan1);
                    b(i,2)=SDII(temp_feb1);
                    b(i,3)=SDII(temp_mar1);
                    b(i,4)=SDII(temp_apr1);
                    b(i,5)=SDII(temp_may1);
                    b(i,6)=SDII(temp_jun1);
                    b(i,7)=SDII(temp_jul1);
                    b(i,8)=SDII(temp_aug1);
                    b(i,9)=SDII(temp_sep1);
                    b(i,10)=SDII(temp_oct1);
                    b(i,11)=SDII(temp_nov1);
                    b(i,12)=SDII(temp_dec1);
            elseif(Indice==13)
                    b(i,1)=PrecTOT(temp_jan1);
                    b(i,2)=PrecTOT(temp_feb1);
                    b(i,3)=PrecTOT(temp_mar1);
                    b(i,4)=PrecTOT(temp_apr1);
                    b(i,5)=PrecTOT(temp_may1);
                    b(i,6)=PrecTOT(temp_jun1);
                    b(i,7)=PrecTOT(temp_jul1);
                    b(i,8)=PrecTOT(temp_aug1);
                    b(i,9)=PrecTOT(temp_sep1);
                    b(i,10)=PrecTOT(temp_oct1);
                    b(i,11)=PrecTOT(temp_nov1);
                    b(i,12)=PrecTOT(temp_dec1);
             elseif(Indice==4)
                    b(i,1)=R3d(temp_jan1);
                    b(i,2)=R3d(temp_feb1);
                    b(i,3)=R3d(temp_mar1);
                    b(i,4)=R3d(temp_apr1);
                    b(i,5)=R3d(temp_may1);
                    b(i,6)=R3d(temp_jun1);
                    b(i,7)=R3d(temp_jul1);
                    b(i,8)=R3d(temp_aug1);
                    b(i,9)=R3d(temp_sep1);
                    b(i,10)=R3d(temp_oct1);
                    b(i,11)=R3d(temp_nov1);
                    b(i,12)=R3d(temp_dec1);             
              elseif(Indice==50)
                    b(i,1)=MOY(temp_jan1);
                    b(i,2)=MOY(temp_feb1);
                    b(i,3)=MOY(temp_mar1);
                    b(i,4)=MOY(temp_apr1);
                    b(i,5)=MOY(temp_may1);
                    b(i,6)=MOY(temp_jun1);
                    b(i,7)=MOY(temp_jul1);
                    b(i,8)=MOY(temp_aug1);
                    b(i,9)=MOY(temp_sep1);
                    b(i,10)=MOY(temp_oct1);
                    b(i,11)=MOY(temp_nov1);
                    b(i,12)=MOY(temp_dec1); 
             elseif(Indice==51)
                    b(i,1)=DST(temp_jan1);
                    b(i,2)=DST(temp_feb1);
                    b(i,3)=DST(temp_mar1);
                    b(i,4)=DST(temp_apr1);
                    b(i,5)=DST(temp_may1);
                    b(i,6)=DST(temp_jun1);
                    b(i,7)=DST(temp_jul1);
                    b(i,8)=DST(temp_aug1);
                    b(i,9)=DST(temp_sep1);
                    b(i,10)=DST(temp_oct1);
                    b(i,11)=DST(temp_nov1);
                    b(i,12)=DST(temp_dec1);                
            end
        temp_jan=temp_jan+30;
        temp_feb=temp_feb+30;
        temp_mar=temp_mar+30;
        temp_apr=temp_apr+30;
        temp_may=temp_may+30;
        temp_jun=temp_jun+30;
        temp_jul=temp_jul+30;
        temp_aug=temp_aug+30;
        temp_sep=temp_sep+30;
        temp_oct=temp_oct+30;
        temp_nov=temp_nov+30;
        temp_dec=temp_dec+30;

        clear temp_jan1 temp_feb1 temp_mar1 temp_apr1 temp_may1 temp_jun1 temp_jul1 temp_aug1 temp_sep1 temp_oct1 temp_nov1 temp_dec1;

        curr_year=curr_year+1;
        i=i+1;
    end
    if(Indice==7)
        b(i,1)=NaN;b(i,2)=NaN;b(i,3)=NaN;b(i,4)=NaN;b(i,5)=NaN;b(i,6)=NaN;b(i,7)=NaN;b(i,8)=NaN;b(i,9)=NaN;b(i,10)=NaN;b(i,11)=NaN;b(i,12)=NaN;
        i=i+1;
        b(i,1)=Jan_90p;b(i,2)=Feb_90p;b(i,3)=Mar_90p;b(i,4)=Apr_90p;b(i,5)=May_90p;b(i,6)=Jun_90p;b(i,7)=Jul_90p;b(i,8)=Aug_90p;b(i,9)=Sep_90p;b(i,10)=Oct_90p;b(i,11)=Nov_90p;b(i,12)=Dec_90p;
    end
    
end
