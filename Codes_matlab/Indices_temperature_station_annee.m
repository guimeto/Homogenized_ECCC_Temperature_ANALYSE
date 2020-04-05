%% Guillaume Dueymes 11/07/2017
%  Calcul des indices d extremes par annee
%  Donnees de station en entrée
%
%
clear;
warning('OFF') 
fclose('all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree
% repertoire d entree
 ddmin='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmin\';
 ddmax='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmax\';
 ddmoy='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmoy\';
 
out_dir = 'G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_ANNEE\';

% numero des stations a traiter: voir fichier excel 
% id_stat = textread('G:\PROJETS\PROJET_2018\TEMP_ID\CANADA_nom_1948-2017.txt','%s');
id_stat = textread('G:\PROJETS\PROJET_2018\TEMP_ID\CANADA_nom_1961-2010.txt','%s');
% on choisit ici de traiter les trois variables journalieres 
varmin='Tasmin'; %daily min temperature
varmax='Tasmax'; %daily max temperature
varmoy='Tasmoy'; %daily mean temperature

start_year=1971;
end_year=2000;
y_length=366;
nyear=end_year-start_year+1;
num_station=size(id_stat,1);

for s=1:num_station 
% Set name of the DAILY MINIMUM TEMPERATURE input file in 1 column text format
  InFileTmin=strcat(char(id_stat(s)),'_tasmin_',num2str(start_year),'_',num2str(end_year),'.txt'); % observations data series

% Set name of the DAILY MAXIMUM TEMPERATURE input file in 1 column text format
  InFileTmax=strcat(char(id_stat(s)),'_tasmax_',num2str(start_year),'_',num2str(end_year),'.txt'); % observations data series

% Set name of the DAILY MEAN TEMPERATURE input file in 1 column text format
  InFileTmoy=strcat(char(id_stat(s)),'_tasmoy_',num2str(start_year),'_',num2str(end_year),'.txt'); % observations data series

Tmin=dlmread(strcat(ddmin,InFileTmin)); % Chargement de Tmin  
Tmax=dlmread(strcat(ddmax,InFileTmax)); % Chargement de Tmax 
Tmoy=dlmread(strcat(ddmoy,InFileTmoy)); % Chargement de Tmoy  
clear InFileTmin InFileTmax InFileTmoy


 signalmin=annee(start_year,end_year, Tmin(:), y_length);      
 signalmax=annee(start_year,end_year, Tmax(:), y_length); 
 signalmoy=annee(start_year,end_year, Tmoy(:), y_length);
  
 for tt=1:size(signalmin,2)    
IND(tt)=indice_calculation(signalmin(:,tt),50);
 end 
IND2=IND';
if ~exist([out_dir varmin '\MOY\'],'dir')
            mkdir([out_dir varmin '\MOY\']);
end
outmin=strcat(out_dir,varmin,'\MOY\');

    % Enregistrement de l'indice de sortie en tant que vairable MATLAB
   save(strcat(outmin,char(id_stat(s)),'_YEAR_tasmin',num2str(start_year),'_',num2str(end_year),'.dat'),'IND2', '-ASCII'); 
   clear IND IND2 signalmin Tmin
   
for tt=1:size(signalmax,2)    
IND(tt)=indice_calculation(signalmax(:,tt),50);
 end 
IND2=IND';
if ~exist([out_dir varmax '\MOY\'],'dir')
            mkdir([out_dir varmax '\MOY\']);
end
outmax=strcat(out_dir,varmax,'\MOY\');

    % Enregistrement de l'indice de sortie en tant que vairable MATLAB
   save(strcat(outmax,char(id_stat(s)),'_YEAR_tasmax',num2str(start_year),'_',num2str(end_year),'.dat'),'IND2', '-ASCII'); 
   clear IND IND2 signalmax  Tmax
   
for tt=1:size(signalmoy,2)    
IND(tt)=indice_calculation(signalmoy(:,tt),50);
 end 
IND2=IND';
if ~exist([out_dir varmoy '\MOY\'],'dir')
            mkdir([out_dir varmoy '\MOY\']);
end
outmoy=strcat(out_dir,varmoy,'\MOY\');

    % Enregistrement de l'indice de sortie en tant que vairable MATLAB
   save(strcat(outmoy,char(id_stat(s)),'_YEAR_tasmoy',num2str(start_year),'_',num2str(end_year),'.dat'),'IND2', '-ASCII'); 
   clear IND IND2 signalmoy Tmoy 
   
   
   
end
    
% Fin / End