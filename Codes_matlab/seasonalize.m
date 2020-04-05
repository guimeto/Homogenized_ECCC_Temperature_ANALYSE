%% SEASONALLIZE
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
% Ce code permet de decouper une serie temporelle en saison
%
% Historique du code: 
%             - Code developpe et revise par Dimitri Parishkura le 03/09/2004
%             - mise a jour par Christian Saad le 1 mars 2010.
%
% Entree:    - start_year="nombre entier" (annee de debut de la serie temporelle)
%            - end_year="nombre entier" (annee de fin de la serie temporelle)
%            - Sig="vecteur des donnees quotidiennes observées ou d'une simulation 
%              pour la periode definie par start_year et end_year"
%            - y_lenght="nombre de jours par annee maximal" (366 pour
%                        observation ou 365 pour donnees de CGCM1 ou 360 pour donnees
%                        de HadCM3)
%             
% Sortie:   - 4 vecteurs (1 par saison) Win (hiver), Spr (Printemps), Sum
%             (ete) et Aut (Automne)
%             
%
% Sous-fonctions/codes:  NA
%
% Pre-requis:     NA
%
% Instructions:     NA
%
% Contact: christian.saad@mail.mcgill.ca

%% CODE DESCRIPTION
% This code divides a single timeserie into seasonal signals
%
% Last update: 25/10/2010 by Christian Saad
%                   - Documentation translated in english
%
% Code History: 
%           - Code developped and revised by Dimitri Parishkura on 03/09/2004
%           - Code updated by Christian Saad on 01/03/2010
%
% Input:    - start_year: Integer corresponding to the start year of the
%                         time serie to be analysed
%           - end_year: Integer corresponding to the end year of the
%                         time serie to be analysed
%           - Sig: vector of daily observed data
%           - y_length: Maximum number of dats in a year for the input
%             timeseries(366 for observations, 365 for CGCM1 simulated data
%             or 360 for HadCM3 simulated data.
%
% Sortie:   - 4 vectors ) 1 per season; Win (Winter), Spr (Spring), Sum
%             (summer) and Aut (Autumn)
%
% Sub-function/codes: NA
%
% Pre-requisites: NA
%
% Instructions:  NA
%
% Contact: christian.saad@mail.mcgill.ca


function [Win,Spr,Sum,Aut]=seasonalize(start_year, end_year, Sig, y_length)

curr_year=start_year;
temp=1;

Wi=1; Sp=1; Su=1; Au=1;

if(y_length==366)
    while (curr_year <= end_year)
        if ( mod(curr_year, 4)==0 )
            for j=temp:temp+365
                if(j<=temp+59 || j>=temp+335)                   %    Hiver/Winter
                    Win(Wi)=Sig(j);
                    Wi=Wi+1;
                elseif(j>=temp+60 && j<=temp+151)               %    Printemps/Spring
                    Spr(Sp)=Sig(j);
                    Sp=Sp+1;
                elseif(j>=temp+152 && j<=temp+243)                %  Ete/Summer
                    Sum(Su)=Sig(j);
                    Su=Su+1;
                elseif(j>=temp+244 && j<=temp+334)             % Automne/Autumn
                    Aut(Au)=Sig(j);
                    Au=Au+1;
                end
            end
            temp=temp+366;
        else
            for j=temp:temp+364
                if(j<=temp+58 || j>=temp+334)                   %      Hiver/Winter
                    Win(Wi)=Sig(j);
                    Wi=Wi+1;
                elseif(j>=temp+59 && j<=temp+150)               %     Printemps/Spring
                    Spr(Sp)=Sig(j);
                    Sp=Sp+1;
                elseif(j>=temp+151 && j<=temp+242)              %    Ete/Summer
                    Sum(Su)=Sig(j);
                    Su=Su+1;
                elseif(j>=temp+243 && j<=temp+333)             % Automne/Autumn
                    Aut(Au)=Sig(j);
                    Au=Au+1;
                end
            end
            temp=temp+365;
        end
        curr_year=curr_year+1;
    end
    
elseif(y_length==365)
    while (curr_year <= end_year)
        for j=temp:temp+364
            if(j<=temp+58 || j>=temp+334)                   %       Hiver/Winter
                Win(Wi)=Sig(j);
                Wi=Wi+1;
            elseif(j>=temp+59 && j<=temp+150)               %     Printemps/Spring
                Spr(Sp)=Sig(j);
                Sp=Sp+1;
            elseif(j>=temp+151 && j<=temp+242)              %    ETE/Summer
                Sum(Su)=Sig(j);
                Su=Su+1;
            elseif(j>=temp+243 && j<=temp+333)             % Automne/Autumn
                Aut(Au)=Sig(j);
                Au=Au+1;
            end
        end
        temp=temp+365;
        curr_year=curr_year+1;
    end
    
elseif(y_length==360)
    while (curr_year <= end_year)
        for j=temp:temp+359
            if(j<=temp+59 || j>=temp+330)                   %       Hiver/Winter
                Win(Wi)=Sig(j);
                Wi=Wi+1;
            elseif(j>=temp+60 && j<=temp+149)               %     Printemps/Spring
                Spr(Sp)=Sig(j);
                Sp=Sp+1;
            elseif(j>=temp+150 && j<=temp+239)              %    Ete/Summer
                Sum(Su)=Sig(j);
                Su=Su+1;
            elseif(j>=temp+240 && j<=temp+329)             % Automne/Autumn
                Aut(Au)=Sig(j);
                Au=Au+1;
            end
        end
        temp=temp+360;
        curr_year=curr_year+1;
    end
end
        
