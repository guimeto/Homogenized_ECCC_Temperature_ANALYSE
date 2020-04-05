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
function b = season_calculation(win,spr,sum,aut, start_year, end_year, y_length, Indice)

if(mod(start_year,4)==0 && y_length==366)
    temp_wi=61;
elseif(y_length==360)
    temp_wi=61;    
else
    temp_wi=60;
end

curr_year=start_year+1;
b(1,1)=NaN;
w=2;

%% HIVER / WINTER

% If the maximum umber of days per year of the input time serie is 366
%
% Si le nombre maximum de jour par annee pour cette serie temporelle est
% 366
if(y_length==366)
    while (curr_year<=end_year)
        
        if ( mod(curr_year, 4)==0 )
            temp_winter=win(temp_wi:temp_wi+90);
            
            %Code
            if(Indice==1)
                b(w,1)=prcp1(temp_winter);
            elseif(Indice==2)
                b(w,1)=SDII(temp_winter);
            elseif(Indice==3)
                b(w,1)=CDD(temp_winter);
            elseif(Indice==4)
                b(w,1)=R3d(temp_winter);
            elseif(Indice==9)
                b(w,1)=Tmax90p(temp_winter);
            elseif(Indice==10)
                b(w,1)=Tmin10p(temp_winter);
            elseif(Indice==14)
                b(w,1)=Tmax10p(temp_winter);
            elseif(Indice==15)
                b(w,1)=Tmin90p(temp_winter);
            elseif(Indice==11)
                b(w,1)=Prec90p(temp_winter);
            elseif(Indice==12)
                b(w,1)=R90N(temp_winter,Win_90p);
            elseif(Indice==50)
                b(w,1)=nanmean(temp_winter);
            elseif(Indice==51)
                b(w,1)=std(temp_winter);
            elseif(Indice==13)
                b(w,1)=PrecTOT(temp_winter);
            elseif(Indice==69)
                b(w,1)=CWD(temp_winter);
            elseif(Indice==70)
                b(w,1)=nanmax(temp_winter);  
            elseif(Indice==71)
                b(w,1)=nanmin(temp_winter);  
            end
            
            temp_wi=temp_wi+91;
        
        else
            temp_winter=win(temp_wi:temp_wi+89);
            
            %Code
            if(Indice==1)
                b(w,1)=prcp1(temp_winter);
            elseif(Indice==2)
                b(w,1)=SDII(temp_winter);
            elseif(Indice==3)
                b(w,1)=CDD(temp_winter);
            elseif(Indice==4)
                b(w,1)=R3d(temp_winter);
            elseif(Indice==9)
                b(w,1)=Tmax90p(temp_winter);
            elseif(Indice==10)
                b(w,1)=Tmin10p(temp_winter);
            elseif(Indice==14)
                b(w,1)=Tmax10p(temp_winter);
            elseif(Indice==15)
                b(w,1)=Tmin90p(temp_winter);
            elseif(Indice==11)
                b(w,1)=Prec90p(temp_winter);
            elseif(Indice==12)
                b(w,1)=R90N(temp_winter,Win_90p);
            elseif(Indice==50)
                b(w,1)=mean(temp_winter);
            elseif(Indice==51)
                b(w,1)=std(temp_winter);    
            elseif(Indice==13)
                b(w,1)=PrecTOT(temp_winter);
            elseif(Indice==69)
                b(w,1)=CWD(temp_winter);
            elseif(Indice==70)
                b(w,1)=max(temp_winter);  
            elseif(Indice==71)
                b(w,1)=min(temp_winter); 
            end
            
            temp_wi=temp_wi+90;
        
        end
        curr_year=curr_year+1;
        
        w=w+1;
    end

% If the maximum number of days per year of the input time series is 365
%
% Si le nombre maximum de jour par annee pour cette serie temporelle est
% 365    
elseif(y_length==365)
    while(curr_year<=end_year)
        
        
        temp_winter=win(temp_wi:temp_wi+89);
            
            %Code
            if(Indice==1)
                b(w,1)=prcp1(temp_winter);
            elseif(Indice==2)
                b(w,1)=SDII(temp_winter);
            elseif(Indice==3)
                b(w,1)=CDD(temp_winter);
            elseif(Indice==4)
                b(w,1)=R3d(temp_winter);
            elseif(Indice==9)
                b(w,1)=Tmax90p(temp_winter);
            elseif(Indice==10)
                b(w,1)=Tmin10p(temp_winter);
            elseif(Indice==14)
                b(w,1)=Tmax10p(temp_winter);
            elseif(Indice==15)
                b(w,1)=Tmin90p(temp_winter);
            elseif(Indice==11)
                b(w,1)=Prec90p(temp_winter);
            elseif(Indice==12)
                b(w,1)=R90N(temp_winter,Win_90p);
            elseif(Indice==50)
                b(w,1)=mean(temp_winter);
            elseif(Indice==51)
                b(w,1)=std(temp_winter);
            elseif(Indice==13)
                b(w,1)=PrecTOT(temp_winter);
            elseif(Indice==69)
                b(w,1)=CWD(temp_winter);
            elseif(Indice==70)
                b(w,1)=max(temp_winter);  
            elseif(Indice==71)
                b(w,1)=min(temp_winter); 
            end
            
            
        temp_wi=temp_wi+90;
        
        curr_year=curr_year+1;
        w=w+1;
    end

% If the maximum number of days per year of the input time series is 360
%
% Si le nombre maximum de jour par annee pour cette serie temporelle est
% 360
elseif(y_length==360)
    while(curr_year<=end_year)
                
        temp_winter=win(temp_wi:temp_wi+89);
            
            %Code
            if(Indice==1)
                b(w,1)=prcp1(temp_winter);
            elseif(Indice==2)
                b(w,1)=SDII(temp_winter);
            elseif(Indice==3)
                b(w,1)=CDD(temp_winter);
            elseif(Indice==4)
                b(w,1)=R3d(temp_winter);
            elseif(Indice==9)
                b(w,1)=Tmax90p(temp_winter);
            elseif(Indice==10)
                b(w,1)=Tmin10p(temp_winter);
            elseif(Indice==14)
                b(w,1)=Tmax10p(temp_winter);
            elseif(Indice==15)
                b(w,1)=Tmin90p(temp_winter);
            elseif(Indice==11)
                b(w,1)=Prec90p(temp_winter);
            elseif(Indice==12)
                b(w,1)=R90N(temp_winter,Win_90p);
            elseif(Indice==50)
                b(w,1)=mean(temp_winter);
            elseif(Indice==51)
                b(w,1)=std(temp_winter);
            elseif(Indice==13)
                b(w,1)=PrecTOT(temp_winter);
            elseif(Indice==69)
                b(w,1)=CWD(temp_winter);
            elseif(Indice==70)
                b(w,1)=max(temp_winter);  
            elseif(Indice==71)
                b(w,1)=min(temp_winter); 
                
            end 
            
        temp_wi=temp_wi+90;
        
        curr_year=curr_year+1;
        w=w+1;
    end
    
    
end


%% Autres saisons (Printemps, ETE, Automne) / Other seasons (Spring,Summer, Autumn)

curr_year=start_year;
temp_sp=1;
temp_su=1;
temp_aut=1;
i=1;


if(y_length==366)
    while (curr_year<=end_year)
        
        if ( mod(curr_year, 4)==0 )
            
            temp_spring=spr(temp_sp:temp_sp+91);
            temp_summer=sum(temp_su:temp_su+91);
            temp_autumn=aut(temp_aut:temp_aut+90);
            
            
            %Code
            if(Indice==1)
                
                b(i,2)=prcp1(temp_spring);
                b(i,3)=prcp1(temp_summer);
                b(i,4)=prcp1(temp_autumn);
            elseif(Indice==2)
                
                b(i,2)=SDII(temp_spring);
                b(i,3)=SDII(temp_summer);
                b(i,4)=SDII(temp_autumn);
            elseif(Indice==3)
                
                b(i,2)=CDD(temp_spring);
                b(i,3)=CDD(temp_summer);
                b(i,4)=CDD(temp_autumn);
            elseif(Indice==4)
               
                b(i,2)=R3d(temp_spring);
                b(i,3)=R3d(temp_summer);
                b(i,4)=R3d(temp_autumn);
            elseif(Indice==9)
                
                b(i,2)=Tmax90p(temp_spring);
                b(i,3)=Tmax90p(temp_summer);
                b(i,4)=Tmax90p(temp_autumn);
            elseif(Indice==10)
               
                b(i,2)=Tmin10p(temp_spring);
                b(i,3)=Tmin10p(temp_summer);
                b(i,4)=Tmin10p(temp_autumn);
            elseif(Indice==14)
                
                b(i,2)=Tmax10p(temp_spring);
                b(i,3)=Tmax10p(temp_summer);
                b(i,4)=Tmax10p(temp_autumn);
            elseif(Indice==15)
               
                b(i,2)=Tmin90p(temp_spring);
                b(i,3)=Tmin90p(temp_summer);
                b(i,4)=Tmin90p(temp_autumn);
                
            elseif(Indice==11)
                b(i,2)=Prec90p(temp_spring);
                b(i,3)=Prec90p(temp_summer);
                b(i,4)=Prec90p(temp_autumn);
            elseif(Indice==12)
                b(i,2)=R90N(temp_spring,Spr_90p);
                b(i,3)=R90N(temp_summer,Sum_90p);
                b(i,4)=R90N(temp_autumn,Aut_90p);
            elseif(Indice==50)
                b(i,2)=mean(temp_spring);
                b(i,3)=mean(temp_summer);
                b(i,4)=mean(temp_autumn);
            elseif(Indice==51)
                b(i,2)=std(temp_spring);
                b(i,3)=std(temp_summer);
                b(i,4)=std(temp_autumn);
             elseif(Indice==13)
                b(i,2)=PrecTOT(temp_spring);
                b(i,3)=PrecTOT(temp_summer);
                b(i,4)=PrecTOT(temp_autumn);   
             elseif(Indice==69)
                b(i,2)=CWD(temp_spring);
                b(i,3)=CWD(temp_summer);
                b(i,4)=CWD(temp_autumn);
             elseif(Indice==70)
                b(i,2)=max(temp_spring);
                b(i,3)=max(temp_summer);
                b(i,4)=max(temp_autumn);
             elseif(Indice==71)
                b(i,2)=min(temp_spring);
                b(i,3)=min(temp_summer);
                b(i,4)=min(temp_autumn);
            
                
            end
            
            
            temp_sp=temp_sp+92;
            temp_su=temp_su+92;
            temp_aut=temp_aut+91;
        
        else
            
            temp_spring=spr(temp_sp:temp_sp+91);
            temp_summer=sum(temp_su:temp_su+91);
            temp_autumn=aut(temp_aut:temp_aut+90);
            
            
            %Code
            if(Indice==1)
                
                b(i,2)=prcp1(temp_spring);
                b(i,3)=prcp1(temp_summer);
                b(i,4)=prcp1(temp_autumn);
            elseif(Indice==2)
               
                b(i,2)=SDII(temp_spring);
                b(i,3)=SDII(temp_summer);
                b(i,4)=SDII(temp_autumn);
            elseif(Indice==3)
               
                b(i,2)=CDD(temp_spring);
                b(i,3)=CDD(temp_summer);
                b(i,4)=CDD(temp_autumn);
            elseif(Indice==4)
                
                b(i,2)=R3d(temp_spring);
                b(i,3)=R3d(temp_summer);
                b(i,4)=R3d(temp_autumn);
            elseif(Indice==9)
                
                b(i,2)=Tmax90p(temp_spring);
                b(i,3)=Tmax90p(temp_summer);
                b(i,4)=Tmax90p(temp_autumn);
            elseif(Indice==10)
                
                b(i,2)=Tmin10p(temp_spring);
                b(i,3)=Tmin10p(temp_summer);
                b(i,4)=Tmin10p(temp_autumn);
            elseif(Indice==14)
                
                b(i,2)=Tmax10p(temp_spring);
                b(i,3)=Tmax10p(temp_summer);
                b(i,4)=Tmax10p(temp_autumn);
            elseif(Indice==15)
                
                b(i,2)=Tmin90p(temp_spring);
                b(i,3)=Tmin90p(temp_summer);
                b(i,4)=Tmin90p(temp_autumn);
            elseif(Indice==11)
                b(i,2)=Prec90p(temp_spring);
                b(i,3)=Prec90p(temp_summer);
                b(i,4)=Prec90p(temp_autumn);
            elseif(Indice==12)
                b(i,2)=R90N(temp_spring,Spr_90p);
                b(i,3)=R90N(temp_summer,Sum_90p);
                b(i,4)=R90N(temp_autumn,Aut_90p);
            elseif(Indice==50)
                b(i,2)=mean(temp_spring);
                b(i,3)=mean(temp_summer);
                b(i,4)=mean(temp_autumn);
            elseif(Indice==51)
                b(i,2)=std(temp_spring);
                b(i,3)=std(temp_summer);
                b(i,4)=std(temp_autumn);
            elseif(Indice==13)
                b(i,2)=PrecTOT(temp_spring);
                b(i,3)=PrecTOT(temp_summer);
                b(i,4)=PrecTOT(temp_autumn); 
            elseif(Indice==69)
                b(i,2)=CWD(temp_spring);
                b(i,3)=CWD(temp_summer);
                b(i,4)=CWD(temp_autumn);
            elseif(Indice==70)
                b(i,2)=max(temp_spring);
                b(i,3)=max(temp_summer);
                b(i,4)=max(temp_autumn);
             elseif(Indice==71)
                b(i,2)=min(temp_spring);
                b(i,3)=min(temp_summer);
                b(i,4)=min(temp_autumn);
       
            end
                    
            
            temp_sp=temp_sp+92;
            temp_su=temp_su+92;
            temp_aut=temp_aut+91;
            
        
        end
        curr_year=curr_year+1;
        
        i=i+1;
    end
    
elseif(y_length==365)
    while(curr_year<=end_year)
              
        
        temp_spring=spr(temp_sp:temp_sp+91);
        temp_summer=sum(temp_su:temp_su+91);
        temp_autumn=aut(temp_aut:temp_aut+90);
        
            %Code
            if(Indice==1)
                
                b(i,2)=prcp1(temp_spring);
                b(i,3)=prcp1(temp_summer);
                b(i,4)=prcp1(temp_autumn);
            elseif(Indice==2)
                
                b(i,2)=SDII(temp_spring);
                b(i,3)=SDII(temp_summer);
                b(i,4)=SDII(temp_autumn);
            elseif(Indice==3)
               
                b(i,2)=CDD(temp_spring);
                b(i,3)=CDD(temp_summer);
                b(i,4)=CDD(temp_autumn);
            elseif(Indice==4)
                
                b(i,2)=R3d(temp_spring);
                b(i,3)=R3d(temp_summer);
                b(i,4)=R3d(temp_autumn);
            elseif(Indice==9)
               
                b(i,2)=Tmax90p(temp_spring);
                b(i,3)=Tmax90p(temp_summer);
                b(i,4)=Tmax90p(temp_autumn);
            elseif(Indice==10)
               
                b(i,2)=Tmin10p(temp_spring);
                b(i,3)=Tmin10p(temp_summer);
                b(i,4)=Tmin10p(temp_autumn);
            elseif(Indice==14)
               
                b(i,2)=Tmax10p(temp_spring);
                b(i,3)=Tmax10p(temp_summer);
                b(i,4)=Tmax10p(temp_autumn);
            elseif(Indice==15)
               
                b(i,2)=Tmin90p(temp_spring);
                b(i,3)=Tmin90p(temp_summer);
                b(i,4)=Tmin90p(temp_autumn);
            elseif(Indice==11)
                
                b(i,2)=Prec90p(temp_spring);
                b(i,3)=Prec90p(temp_summer);
                b(i,4)=Prec90p(temp_autumn);
            elseif(Indice==12)
                b(i,2)=R90N(temp_spring,Spr_90p);
                b(i,3)=R90N(temp_summer,Sum_90p);
                b(i,4)=R90N(temp_autumn,Aut_90p);
            elseif(Indice==50)
                b(i,2)=mean(temp_spring);
                b(i,3)=mean(temp_summer);
                b(i,4)=mean(temp_autumn);
            elseif(Indice==51)
                b(i,2)=std(temp_spring);
                b(i,3)=std(temp_summer);
                b(i,4)=std(temp_autumn);
            elseif(Indice==13)
                b(i,2)=PrecTOT(temp_spring);
                b(i,3)=PrecTOT(temp_summer);
                b(i,4)=PrecTOT(temp_autumn);
            elseif(Indice==69)
                b(i,2)=CWD(temp_spring);
                b(i,3)=CWD(temp_summer);
                b(i,4)=CWD(temp_autumn);
            elseif(Indice==70)
                b(i,2)=max(temp_spring);
                b(i,3)=max(temp_summer);
                b(i,4)=max(temp_autumn);
             elseif(Indice==71)
                b(i,2)=min(temp_spring);
                b(i,3)=min(temp_summer);
                b(i,4)=min(temp_autumn);
            end
                        
        
        temp_sp=temp_sp+92;
        temp_su=temp_su+92;
        temp_aut=temp_aut+91;
        
        curr_year=curr_year+1;
        i=i+1;
    end
  

elseif(y_length==360)
    while(curr_year<=end_year)
               
        
        temp_spring=spr(temp_sp:temp_sp+89);
        temp_summer=sum(temp_su:temp_su+89);
        temp_autumn=aut(temp_aut:temp_aut+89);
        
            %Code
            if(Indice==1)
                
                b(i,2)=prcp1(temp_spring);
                b(i,3)=prcp1(temp_summer);
                b(i,4)=prcp1(temp_autumn);
            elseif(Indice==2)
                
                b(i,2)=SDII(temp_spring);
                b(i,3)=SDII(temp_summer);
                b(i,4)=SDII(temp_autumn);
            elseif(Indice==3)
               
                b(i,2)=CDD(temp_spring);
                b(i,3)=CDD(temp_summer);
                b(i,4)=CDD(temp_autumn);
            elseif(Indice==4)
                
                b(i,2)=R3d(temp_spring);
                b(i,3)=R3d(temp_summer);
                b(i,4)=R3d(temp_autumn);
            elseif(Indice==9)
               
                b(i,2)=Tmax90p(temp_spring);
                b(i,3)=Tmax90p(temp_summer);
                b(i,4)=Tmax90p(temp_autumn);
            elseif(Indice==10)
               
                b(i,2)=Tmin10p(temp_spring);
                b(i,3)=Tmin10p(temp_summer);
                b(i,4)=Tmin10p(temp_autumn);
                
            elseif(Indice==14)
               
                b(i,2)=Tmax10p(temp_spring);
                b(i,3)=Tmax10p(temp_summer);
                b(i,4)=Tmax10p(temp_autumn);
            elseif(Indice==15)
               
                b(i,2)=Tmin90p(temp_spring);
                b(i,3)=Tmin90p(temp_summer);
                b(i,4)=Tmin90p(temp_autumn);
                
            elseif(Indice==11)
                b(i,2)=Prec90p(temp_spring);
                b(i,3)=Prec90p(temp_summer);
                b(i,4)=Prec90p(temp_autumn);
            elseif(Indice==12)
                b(i,2)=R90N(temp_spring,Spr_90p);
                b(i,3)=R90N(temp_summer,Sum_90p);
                b(i,4)=R90N(temp_autumn,Aut_90p);
            elseif(Indice==50)
                b(i,2)=mean(temp_spring);
                b(i,3)=mean(temp_summer);
                b(i,4)=mean(temp_autumn);
            elseif(Indice==51)
                b(i,2)=std(temp_spring);
                b(i,3)=std(temp_summer);
                b(i,4)=std(temp_autumn);
           elseif(Indice==13)
                b(i,2)=PrecTOT(temp_spring);
                b(i,3)=PrecTOT(temp_summer);
                b(i,4)=PrecTOT(temp_autumn);
           elseif(Indice==69)
                b(i,2)=CWD(temp_spring);
                b(i,3)=CWD(temp_summer);
                b(i,4)=CWD(temp_autumn);
            elseif(Indice==70)
                b(i,2)=max(temp_spring);
                b(i,3)=max(temp_summer);
                b(i,4)=max(temp_autumn);
             elseif(Indice==71)
                b(i,2)=min(temp_spring);
                b(i,3)=min(temp_summer);
                b(i,4)=min(temp_autumn);
        
            end
                        
        
        temp_sp=temp_sp+90;
        temp_su=temp_su+90;
        temp_aut=temp_aut+90;
        
        curr_year=curr_year+1;
        i=i+1;
    end

        
end
        
% Fin / End