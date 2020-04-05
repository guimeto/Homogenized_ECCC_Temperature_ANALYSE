%% Guillaume Dueymes 06/06/2017
%  Calcul des indices d extremes par mois
%  Donnees de station en entrée
%
%
%% INITIALISATION DES PARAMETRES D'ENTREES PAR L'UTILISATEUR
clear;
warning('OFF') 
fclose('all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree
% repertoire d entree

%  dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmin\';
%  dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmax\';
dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\tasmoy\';

% numero des stations a traiter: voir fichier excel 
% id_stat = textread('G:\PROJETS\PROJET_2018\TEMP_ID\CANADA_nom_1948-2017.txt','%s');
id_stat = textread('G:\PROJETS\PROJET_2018\TEMP_ID\CANADA_nom_1961-2010.txt','%s');

% on choisit ici de traiter les trois variables journalieres 
% curr_var='tasmin'; %daily min temperature
%  curr_var='tasmax'; %daily max temperature
  curr_var='tasmoy'; %daily mean temperature

% var='Tasmin';
%  var='Tasmax';
var='Tasmoy';
start_year=1971;
end_year=2000;
y_length=366;

nyear=end_year-start_year+1;
num_station=size(id_stat,1);
List_indice={'MOY'};

for iv = 1:numel(List_indice) 
        Varout = List_indice{iv};  
              if (strcmp(Varout,'MOY')==1)
                     No_Indice=50;        
              end 
for s=1:num_station 
    
  InFile=strcat(char(id_stat(s)),'_',curr_var,'_',num2str(start_year),'_',num2str(end_year),'.txt'); % observations data series
  
% Lecture du header
fid = fopen(strcat(char(dd),char(InFile)));
%test sur l existence du fichier
if (fid < 0)
    error('file does not exist');
end

%% APPEL DES SOUS-FONCTIONS POUR LE CALCUL D'INDICES
% CALL THE SUB-FUNCTIONS FOR COMPUTING INDICES   
VAR=dlmread(strcat(dd,InFile)); % Chargement du fichier   
    [Winter,Spring,Summer,Automn]=seasonalize(start_year,end_year, VAR, y_length);
IND = season_calculation(Winter, Spring, Summer, Automn, start_year, end_year, 366, No_Indice);

clear Win Spr Sum Aut;
winter1=IND(:,1);
spring1=IND(:,2);
summer1=IND(:,3);
automn1=IND(:,4);


if ~exist(['G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_SEASON\' var '\' Varout '\'],'dir')
            mkdir(['G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_SEASON\' var '\' Varout '\']);
end
season_dir=strcat('G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_SEASON\',var,'\',Varout,'\');

save(strcat(season_dir,char(Varout),'_',char(id_stat(s)),'_DJF_',num2str(start_year),'_',num2str(end_year),'.dat'),'winter1', '-ASCII'); 
save(strcat(season_dir,char(Varout),'_',char(id_stat(s)),'_MAM_',num2str(start_year),'_',num2str(end_year),'.dat'),'spring1', '-ASCII'); 
save(strcat(season_dir,char(Varout),'_',char(id_stat(s)),'_JJA_',num2str(start_year),'_',num2str(end_year),'.dat'),'summer1', '-ASCII');
save(strcat(season_dir,char(Varout),'_',char(id_stat(s)),'_SON_',num2str(start_year),'_',num2str(end_year),'.dat'),'automn1', '-ASCII');


clear winter1 spring1 summer1 automn1 IND



end
fclose('all')
end
% Fin / End