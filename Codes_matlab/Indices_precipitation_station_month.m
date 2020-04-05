%% Guillaume Dueymes 06/06/2017
%  Calcul des indices d extremes par mois
%  Donnees de station en entr�e
%
%
%% INITIALISATION DES PARAMETRES D'ENTREES PAR L'UTILISATEUR
clear;
warning('OFF') 
fclose('all')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree
% repertoire d entree
 dd='K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\';
%   dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\Snow\';
% dd='G:\PROJETS\PROJET_2018\DATA\TIME_SERIES\Rain\';

% repertoire de sortie
 out='K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\'
%   out='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_MON\Snow\'
%  out='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_MON\Rain\'

% numero des stations a traiter: voir fichier excel 
% id_stat = textread('G:\PROJETS\PROJET_2018\PRECIP_ID\CANADA_nom_1948-2017.txt','%s');
id_stat = textread('K:\PROJETS\PROJET_2018\PRECIP_ID\CANADA_nom_1961-2010.txt','%s');

% on choisit ici de traiter les trois variables journalieres 
 curr_var='dt'; %dt for all precipitation
 var='Prec_all';

%  curr_var='ds'; %dt for snow
%  var='Snow';

%  curr_var='dr'; %dt for rain
%  var='Rain';

start_year=1961;
end_year=2010;
y_length=366;
nyear=end_year-start_year+1;
num_station=size(id_stat,1);
List_indice={'MOY'};

for iv = 1:numel(List_indice)  
        Varout = List_indice{iv};
              if (strcmp(Varout,'SDII')==1) 
                     No_Indice=2;
              elseif (strcmp(Varout,'Prcp1')==1)
                     No_Indice=1;
              elseif (strcmp(Varout,'prcp90')==1)
                     No_Indice=11;        
              elseif (strcmp(Varout,'CDD')==1)
                     No_Indice=3;
              elseif (strcmp(Varout,'CWD')==1)
                     No_Indice=69;     
              elseif (strcmp(Varout,'MOY')==1)
                     No_Indice=50; 
              elseif (strcmp(Varout,'PrecTOT')==1)
                     No_Indice=13;     
              end 

for s=1:num_station 
    
 InFile=strcat(char(id_stat(s)),'_',curr_var,'_',num2str(start_year),'_',num2str(end_year),'.dat'); % observations data series

% Lecture du header
fid = fopen(strcat(char(dd),char(InFile)));
%test sur l existence du fichier
if (fid < 0)
    error('file does not exist');
end

%% APPEL DES SOUS-FONCTIONS POUR LE CALCUL D'INDICES
% CALL THE SUB-FUNCTIONS FOR COMPUTING INDICES   
    VAR=dlmread(strcat(dd,InFile)); % Chargement de PR   
    [Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec] = monthenalize(start_year,end_year, VAR, y_length);
  
IND = indice_calculation_MON(Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec, start_year, end_year, 366, No_Indice);
clear Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec VAR
OutFile=strcat(char(id_stat(s)),'_MONTH_',curr_var,'_',Varout,'_',num2str(start_year),'_',num2str(end_year));

if ~exist(['K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\' var '\' Varout '\'],'dir')
            mkdir(['K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\' var '\' Varout '\']);
end

out=strcat('K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\',var,'\',Varout,'\');

tmp1=IND(:,1);
save(strcat(out,OutFile,'_01.dat'),'tmp1', '-ASCII'); 
clear IND1 tmp1

tmp2=IND(:,2);
save(strcat(out,OutFile,'_02.dat'),'tmp2', '-ASCII'); 
clear IND2 tmp2

tmp3=IND(:,3);
save(strcat(out,OutFile,'_03.dat'),'tmp3', '-ASCII'); 
clear IND3 tmp3

tmp4=IND(:,4);
save(strcat(out,OutFile,'_04.dat'),'tmp4', '-ASCII'); 
clear IND4 tmp4

tmp5=IND(:,5);
save(strcat(out,OutFile,'_05.dat'),'tmp5', '-ASCII'); 
clear IND5 tmp5

tmp6=IND(:,6);
save(strcat(out,OutFile,'_06.dat'),'tmp6', '-ASCII'); 
clear IND6 tmp6

tmp7=IND(:,7);
save(strcat(out,OutFile,'_07.dat'),'tmp7', '-ASCII'); 
clear IND7 tmp7

tmp8=IND(:,8);
save(strcat(out,OutFile,'_08.dat'),'tmp8', '-ASCII'); 
clear IND8 tmp8

tmp9=IND(:,9);
save(strcat(out,OutFile,'_09.dat'),'tmp9', '-ASCII'); 
clear IND9 tmp9

tmp10=IND(:,10);
save(strcat(out,OutFile,'_10.dat'),'tmp10', '-ASCII'); 
clear IND10 tmp10

tmp11=IND(:,11);
save(strcat(out,OutFile,'_11.dat'),'tmp11', '-ASCII'); 
clear IND11 tmp11

tmp12=IND(:,12);
save(strcat(out,OutFile,'_12.dat'),'tmp12', '-ASCII'); 
clear IND12 tmp12

clear IND
end
fclose('all')
end
% Fin / End