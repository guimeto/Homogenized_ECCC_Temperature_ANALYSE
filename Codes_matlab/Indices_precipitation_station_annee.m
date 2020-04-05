%% Guillaume Dueymes 11/07/2017
%  Calcul des indices d extremes par annee
%  Donnees de station en entrée
%
%

clear;
%% INITIALISATION DES PARAMETRES D'ENTREES PAR L'UTILISATEUR
clear;
warning('OFF') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree

% repertoire d entree
dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\Prec_all\';
% dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\Snow\';
%dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\Rain\';

% repertoire de sortie
  out_dir='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_ANNEE\';
% numero des stations a traiter: voir fichier excel 
%  id_stat = textread('G:\PROJETS\PROJET_2018\PRECIP_ID\CANADA_nom_1948-2017.txt','%s');
 id_stat = textread('G:\PROJETS\PROJET_2018\PRECIP_ID\CANADA_nom_1961-2010.txt','%s');

% on choisit ici de traiter les trois variables journalieres 
curr_var='dt'; %dt for all precipitation
var='Prec_all';

%   curr_var='ds'; %dt for snow
%   var='Snow';

%  curr_var='dr'; %dt for rain
%  var='Rain';


List_varout = {'prcp1','SDII','PrecTOT','MOY'};
start_year=1971;
end_year=2000;
y_length=366;
num_station=size(id_stat,1);

for s=1:num_station 
    
    
% Set name of the DAILY PRECIPITATION input file in 1 column text format
  InFile=strcat(char(id_stat(s)),'_',curr_var,'_',num2str(start_year),'_',num2str(end_year),'.dat'); % observations data series


%% APPEL DES SOUS-FONCTIONS POUR LE CALCUL D'INDICES
% CALL THE SUB-FUNCTIONS FOR COMPUTING INDICES 
    
    VAR=dlmread(strcat(dd,InFile)); % Chargement de PR   

    signal=annee(start_year,end_year, VAR(:), y_length); 
       
for iv = 1:numel(List_varout) 
    Varout = List_varout{iv};
    if (strcmp(Varout,'SDII')==1) 
          No_Indice=2;
          long_name='Precipitation intensity';
          unite='mm/day';
    elseif (strcmp(Varout,'prcp1')==1)
        No_Indice=1;
          long_name='Number of wet days';
          unite='%';
    elseif (strcmp(Varout,'prcp90')==1)
        No_Indice=11;
          long_name='90e quantile of daily precipitation';
          unite='mm/day';
    elseif (strcmp(Varout,'CDD')==1)
          long_name='Maximum of consecutive dry days';
          unite='nb';
          No_Indice=3;
     elseif (strcmp(Varout,'CWD')==1)
          long_name='Maximum of consecutive wet days';
          unite='nb';
          No_Indice=69;     
     elseif (strcmp(Varout,'MOY')==1)
          long_name='Mean precipitation';
          unite='mm/day';
          No_Indice=50; 
      elseif (strcmp(Varout,'PrecTOT')==1)
          long_name='Total precipitation';
          unite='mm';   
          No_Indice=13; 
       
    end 
for tt=1:size(signal,2)    
IND(tt)=indice_calculation(signal(:,tt),No_Indice);
end

final=IND';
if ~exist([out_dir var '\' Varout '\'],'dir')
            mkdir([out_dir var '\' Varout '\']);
end

out=strcat(out_dir,var,'\',Varout,'\');

    save(strcat(out,char(Varout),'_',char(id_stat(s)),'_YEAR_',num2str(start_year),'_',num2str(end_year),'.dat'),'final', '-ASCII'); 


clear IND
end %boucle sur les variables
end %boucle sur les stations
% Fin / End