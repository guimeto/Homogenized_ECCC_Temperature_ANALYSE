%% MONTHENALIZE
%
% An english version will follow.
%
%% DESCRIPTION DU CODE
% 
% Auteur: Dimitri Parishkura
% Date: 03/09/2004
% Date de revision: 03/09/2004
%
% Cette fonction permet de decouper une serie temporelle en signal mensuel
%
% Entrees: - start_year : nombre entier qui correspond a l'annee du debut de
%                        la serie temporelle entrante;
%          - end_year : nombre entier qui correspond a l'annee de la fin de
%                      la serie temporelle entrante;
%          - Sig: vecteur des donnees quotidiennes entrantes de la serie 
%                  temporelle 
%          - y_length: "nombre de jours par annee maximal" (366 pour
%                       observation ou 365 pour donnees de CGCM1 ou 360 pour donnees
%                       de HadCM3)
% Sorties: - 12 vecteurs correspondant aux valeurs quotidiennes de Jan(tous
%            les janviers, pareillement pour les autres mois),Feb,Mar,Apr,
%            May,Jun,Jul,Aug,Sep,Oct,Nov et Dec.
%
%
%% CODE DESCRIPTION
%
% Autor: Dimitri Parishkura
% Date:  03/09/2004
% Revised Date: 03/09/2004
%
% Function taking a timeserie and cutting it into monthly signals.
%
% Inputs:   - start_year: integer, corresponding to the start year of the time serie;
%           - end_year: integer, corresponding to the end year of the time serie;
%           - Sig: vector of daily generated values for (start_year,end_year) period.
%           - y_length: maximum number of days in a year, ex. 366 for observations, or
%             365 for SDSM CGCM1 based scenario or 360 for SDSM HADCM3 based scenario.
%
% Output:   - 12 vectors corresponding to daily values of Jan(all januaries,
%             same for other months),Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov and Dec.
%
% Sub-functions/Codes: NA
%
% Pre-requisites: NA
%
% Instructions: NA
%
% Contact: christian.saad@mail.mcgill.ca


function [Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec] = monthenalize(start_year, end_year, S, y_length)

curr_year=start_year;
temp=1;

Ja=1; Fe=1; Ma=1; Ap=1; My=1; Ju=1; Jl=1; Au=1; Se=1; Oc=1; No=1; De=1;

if(y_length==366)
    while (curr_year<=end_year)
        if ( mod(curr_year, 4)==0 )
            for j=temp:temp+365
                if(j<=(temp+30))                   %       Janvier = 31 jours / January = 31 days
                    Jan(Ja)=S(j);
                    Ja=Ja+1;
                
            
                elseif((temp+30)<j && j<=(temp+59))       %     Fevrier =29 jours / February = 29 days
                    Feb(Fe)=S(j);
                    Fe=Fe+1;
                
                elseif(temp+59<j && j<=temp+90)           % Mars = 31 jours / March  = 31 days 
                    Mar(Ma)=S(j);
                    Ma=Ma+1;
                
                elseif(temp+90<j && j<=temp+120)                 % Avril = 30 jours / April = 30 days
                    Apr(Ap)=S(j);
                    Ap=Ap+1;
                
                elseif(temp+120<j && j<=temp+151)               %Mai = 31 jours / May = 31 days
                    May(My)=S(j);
                    My=My+1;
                
                elseif(temp+151<j && j<=temp+181)                % Juin = 30 jours / June = 30 days
                    Jun(Ju)=S(j);
                    Ju=Ju+1;
                
                elseif(temp+181<j && j<=temp+212)               % Juillet = 31 jours / July = 31 days
                    Jul(Jl)=S(j);
                    Jl=Jl+1;
                
                elseif(temp+212<j && j<=temp+243)              % Aout = 31 jours / August = 31 days
                    Aug(Au)=S(j);
                    Au=Au+1;
                    
                elseif(temp+243<j && j<=temp+273)               % Septembre = 30 jours / September = 30 days
                    Sep(Se)=S(j);
                    Se=Se+1;
                
                elseif(temp+273<j && j<=temp+304)               % Octobre = 31 jours / October = 31 days
                    Oct(Oc)=S(j);
                    Oc=Oc+1;
                
                elseif(temp+304<j && j<=temp+334)                    % Novembre = 30 jours / November = 30 days
                    Nov(No)=S(j);
                    No=No+1;
                
                elseif(temp+334<j && j<=temp+365)                  % Decembre = 31 jours / December = 31 days
                    Dec(De)=S(j);
                    De=De+1;
                end
            end
            temp=temp+366;
        else
            for j=temp:temp+364
                if(j<=temp+30)                   %       Janvier / January
                    Jan(Ja)=S(j);
                    Ja=Ja+1;
                
                elseif(temp+30<j && j<=temp+58)         %      Fevrier = 28 jours / February = 28 days
                    Feb(Fe)=S(j);
                    Fe=Fe+1;
                
                elseif(temp+58<j && j<=temp+89)           % Mars / March   
                    Mar(Ma)=S(j);
                    Ma=Ma+1;
                
                elseif(temp+89<j && j<=temp+119)                 % Avril / April
                    Apr(Ap)=S(j);
                    Ap=Ap+1;
                
                elseif(temp+119<j && j<=temp+150)               % Mai / May
                    May(My)=S(j);
                    My=My+1;
                
                elseif(temp+150<j && j<=temp+180)                % Juin / June
                    Jun(Ju)=S(j);
                    Ju=Ju+1;
                    
                elseif(temp+180<j && j<=temp+211)               % Juillet / July
                    Jul(Jl)=S(j);
                    Jl=Jl+1;
                
                elseif(temp+211<j && j<=temp+242)              % Aout / August
                    Aug(Au)=S(j);
                    Au=Au+1;
                
                elseif(temp+242<j && j<=temp+272)               % Septembre / September
                    Sep(Se)=S(j);
                    Se=Se+1;
                
                elseif(temp+272<j && j<=temp+303)               % Octobre / October
                    Oct(Oc)=S(j);
                    Oc=Oc+1;
                
                elseif(temp+303<j && j<=temp+333)                    % Novembre / November
                    Nov(No)=S(j);
                    No=No+1;
                
                elseif(temp+333<j && j<=temp+364)                  % Decembre / December
                    Dec(De)=S(j);
                    De=De+1;
                end
            end
            temp=temp+365;
        end
        curr_year=curr_year+1;
    end
    
elseif(y_length==365)
    while (curr_year<=end_year)
        for j=temp:temp+364
            if(j<=temp+30)                   %       Janvier / January
                Jan(Ja)=S(j);
                Ja=Ja+1;
                
            elseif(temp+30<j && j<=temp+58)         %      Fevrier = 28 jours / February = 28 days
                Feb(Fe)=S(j);
                Fe=Fe+1;
                
            elseif(temp+58<j && j<=temp+89)           % Mars / March   
                Mar(Ma)=S(j);
                Ma=Ma+1;
                
            elseif(temp+89<j && j<=temp+119)                 % Avril / April
                Apr(Ap)=S(j);
                Ap=Ap+1;
                
            elseif(temp+119<j && j<=temp+150)               % Mai / May
                May(My)=S(j);
                My=My+1;
                
            elseif(temp+150<j && j<=temp+180)                % Juin / June
                Jun(Ju)=S(j);
                Ju=Ju+1;
                
            elseif(temp+180<j && j<=temp+211)               % Juillet / July
                Jul(Jl)=S(j);
                Jl=Jl+1;
                
            elseif(temp+211<j && j<=temp+242)              % Aout / August
                Aug(Au)=S(j);
                Au=Au+1;
                
            elseif(temp+242<j && j<=temp+272)               % Septembre / September
                Sep(Se)=S(j);
                Se=Se+1;
                
            elseif(temp+272<j && j<=temp+303)               % Octobre / October
                Oct(Oc)=S(j);
                Oc=Oc+1;
                
            elseif(temp+303<j && j<=temp+333)                    % Novembre / November
                Nov(No)=S(j);
                No=No+1;
                
            elseif(temp+333<j && j<=temp+364)                  % Decembre / December
                Dec(De)=S(j);
                De=De+1;
            end
        end
        temp=temp+365;
        curr_year=curr_year+1;
    end
    
elseif(y_length==360)
    while (curr_year<=end_year)
        for j=temp:temp+359
            if(j<=temp+29)                   %       Janvier / January
                Jan(Ja)=S(j);
                Ja=Ja+1;
                
            elseif(temp+29<j && j<=temp+59)         %      Fevrier = 28 jours / February = 28 days
                Feb(Fe)=S(j);
                Fe=Fe+1;
                
            elseif(temp+59<j && j<=temp+89)           % Mars / March   
                Mar(Ma)=S(j);
                Ma=Ma+1;
                
            elseif(temp+89<j && j<=temp+119)                 % Avril / April
                Apr(Ap)=S(j);
                Ap=Ap+1;
                
            elseif(temp+119<j && j<=temp+149)               % Mai / May
                May(My)=S(j);
                My=My+1;
                
            elseif(temp+149<j && j<=temp+179)                % Juin / June
                Jun(Ju)=S(j);
                Ju=Ju+1;
                
            elseif(temp+179<j && j<=temp+209)               % Juillet / July
                Jul(Jl)=S(j);
                Jl=Jl+1;
                
            elseif(temp+209<j && j<=temp+239)              % Aout / August
                Aug(Au)=S(j);
                Au=Au+1;
                
            elseif(temp+239<j && j<=temp+269)               % Septembre / September
                Sep(Se)=S(j);
                Se=Se+1;
                
            elseif(temp+269<j && j<=temp+299)               % Octobre / October
                Oct(Oc)=S(j);
                Oc=Oc+1;
                
            elseif(temp+299<j && j<=temp+329)                    % Novembre / November
                Nov(No)=S(j);
                No=No+1;
                
            elseif(temp+329<j && j<=temp+359)                  % Decembre / December
                Dec(De)=S(j);
                De=De+1;
            end
        end
        temp=temp+360;
        curr_year=curr_year+1;
    end
    
end
        
    