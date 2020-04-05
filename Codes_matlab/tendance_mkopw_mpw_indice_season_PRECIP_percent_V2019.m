%% Initialisation des parametres de base
clear;
warning('OFF') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree
%
dd = 'K:\DATA\Donnees_Stations\2nd_generation_V2018\INDICES_SEASON\Prec_all\';
out='K:\DATA\Donnees_Stations\2nd_generation_V2018\TENDANCES\SEASON\Prec_all\';

type = 'Prec_all';
month={'JJA','SON','MAM','DJF'};

% list_var={'Prcp1','SDII','PrecTOT','MOY'};
list_var={'Prcp1','SDII','PrecTOT'};

start_year=1988;
end_year=2017;
confiance='90p';
indice=0.1;
ref='1971_2000';
nyear=end_year-start_year+1;
Annee=(start_year:end_year)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(strcat('K:\DATA\Donnees_Stations\2nd_generation_V2018\PRECIP_ID\stations_noms_CANADA_',num2str(start_year),'-',num2str(end_year),'.txt'));   

name_stat=textscan(fid,'%s','delimiter',' ');
fclose(fid);
nb_stat=size(name_stat{1},1);
colonne=(1:nb_stat)';  
    
for  mon=1:length(month) % Boucle mensuelle
for v=1:length(list_var)    
for s=1:size(name_stat{1},1)       
curr_var=char(list_var(v));
File=strcat(char(name_stat{1}{s}),'_SEASON_',char(type),'_',char(curr_var),'_',num2str(start_year),'_',num2str(end_year),'_',char(month(mon)),'.csv');
filename = strcat(dd,curr_var,'\',num2str(start_year),'_',num2str(end_year),'\',File); 
T = readtable(filename, 'HeaderLines',1);
variable=round(T.Var3);
variable(variable<0) = NaN;

ltlg = csvread(strcat('K:\DATA\Donnees_Stations\2nd_generation_V2018\PRECIP_ID\stations_latlon_CANADA_',num2str(start_year),'-',num2str(end_year),'.csv'),1,1);       

Fileref=strcat(char(name_stat{1}{s}),'_SEASON_',char(type),'_',char(curr_var),'_1971_2000_',char(month(mon)),'.csv');
filenamre = strcat(dd,curr_var,'\1971_2000\',Fileref); 
if exist(filenamre)== 2
     % File exists.
     Tref = readtable(filenamre, 'HeaderLines',1);
     vref=round(T.Var3);
     vref(vref<0) = NaN;
     clim_ref = nanmean(vref(:));
     Var = variable(:);
else
    
    clim_ref = NaN;
    Var(1:nyear) = NaN;
end

missval=NaN;      % valeur indicative de donnees manquante
naval=NaN;          % valeur indicative de donnees non-disponible 
nlags=1;            % le rang des valeurs de la fonction d'autocorrelation desire
autoThreshold=0.1; % valeur minimal auquel l'effet d'autocorrelation est pris en consideration 
					% (depend de l'utilisateur) ex.: >0.01 (valeur nonconservatrice)

%% Detection et Quantification de tendance
          
 A=cat(2,Annee,Var(:));
if (isnan(A(1,2)) == 1)
     OUT_I=NaN;
     OUT_L=NaN;
     OUT_S=NaN;
     OUT_P=NaN;
 elseif (isnan(A(1)) == 0)
                    temp_kendall=getmk_opw_mpw(A, missval, naval, autoThreshold, nlags);
                    %display(strcat('temp_kendall: ',num2str(temp_kendall)))
%                     OUT_L=temp_kendall(1,4); % pente par une regression lineaire de moindres carres
                    OUT_S=temp_kendall(1,3); % pente de Sen
                    OUT_P=temp_kendall(1,5+temp_kendall(1,9)); % P-value tel que calcule par le test de kendall modifie mk, mk_opw ou mk_mpw
%                     OUT_I=temp_kendall(1,9); % Index correspondant au test executer: mk original = 1, mk opw =2 et mk mpw=3;
                    clear temp_kendall A Var;
end

outvar(s,1)=ltlg(s,1);
outvar(s,2)=ltlg(s,2);

 if OUT_P <= indice
    outvar(s,3)=(OUT_S*10/clim_ref)*100;
 else outvar(s,3)=NaN;  
 end 
 clear OUT_P OUT_S OUT_L END_S variable variable_ref clim_ref
end % boucle sur les stations
mat_final=cat(2,colonne,outvar);
save(strcat(out,curr_var,'\INDICES_',type,'_',curr_var,'_',char(month(mon)),'_CANADA_',num2str(start_year),'_',num2str(end_year),'_',char(confiance),'.dat'),'mat_final', '-ASCII');
clear outvar mat_final
end % boucle sur les variables
end % boucle sur les mois

