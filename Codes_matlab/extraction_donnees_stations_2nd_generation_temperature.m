% Formatage des donnees quotidiennes  de deuxieme generation des
% temperatures homogeneisees pour le canada provenant  des Archives
% Nationales d'Environnement Canada (EC) 
%--------------------------------------------------------------------------
%Reference: 
% Vincent, L. A., X. L. Wang, E. J. Milewska, H. Wan, F. Yang, and V. Swail (2012). 
% A second generation of homogenized Canadian monthly surface air temperature 
%for climate trend analysis, J. Geophys. Res., 117, D18110, doi:10.1029/2012JD017859.
%--------------------------------------------------------------------------
%
%  Guillaume Dueymes 15/09/2016
%
% Cet outil MATLAB permet de restructurer les données quotidiennes 
% d'observation sur une periode donnee
%
% Entree : 
%   - Fichier ASCII qui contient les données quotidiennes homogeneisees  
%     d'une station et d'une variable desiree-ATTENTION ce code est uniquement
%     adapte aux donnees de station de deuxieme generation de la version
%     2015
%
% Sortie :
%   - Fichier ASCII formate en une seul colonne pour laquelle chaque ligne
%     represente une valeur quotidienne de la variable traitée. 
%
%NB1: l usager ne doit modifier que la partie 1 du code
%NB2:  il est possible de traiter plusieurs stations en boucle
%      le code extrait automatiquement les informations du header 
%NB3:  Pour identifier la station a traiter (ID), se refererer a l
%inventaire des stations dans le document excel Homog_temperature_stations_v2015
%
%
% Temps d'execution: rapide (quelques secondes)

clear;
%%%%%%%%%%%%%%%%%%     PARTIE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Annee de debut et de fin de la serie temporelle a traiter (Ajuster au
% besoin)
start_year=1990;
end_year=2010;

% definition du nombre maximal de jours par mois
leap_year=[31 29 31 30 31 30 31 31 30 31 30 31];      % Nombre de jours par mois dans une année de 366 jours;
nl_year=[31 28 31 30 31 30 31 31 30 31 30 31];        % Nombre de jours par mois dans une année de 365 jours;

% repertoire d entree
path='K:\DATA\Donnees_Stations\2nd_generation_V2019\Homog_daily_max_temp_v2019\';
% repertoire de sortie
dd='K:\DATA\Donnees_Stations\2nd_generation_V2019\Daily_matlab\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numero des stations a traiter: voir fichier excel 
%% 
id_stat = textread('K:\DATA\Donnees_Stations\2nd_generation_V2019\TEMP_ID\stations_ID_CANADA_1990-2010.txt','%s');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% on choisit ici de traiter les trois variables journalieres 
% max, min et mean
list_var={'dx'}; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%   PARTIE 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  DEBUT DU CODE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_station=size(id_stat,1);
nb_var=size(list_var,2);

for s=1:num_station 
    for v=1:nb_var


FileName=strcat(list_var(v),id_stat(s));

% Lecture du header

fid = fopen(strcat(char(path),char(FileName),'.txt'));
%test sur l existence du fichier
if (fid < 0)
    error('file does not exist');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lecture du header du fichier
%head{5}(1) %nom de la variable dans le header
%head{2}(1) %nom de la station dans le header
%head{1}(1) %numero de la station dans le header
delimiter = ',';
head = textscan(fid,'%s%s%s%s%s%s%s','delimiter',delimiter);
fclose(fid);
if (strcmp(deblank(head{5}(1)),'Homogenized daily minimum temperature')==1)
       curr_var='tasmin';
       out=strcat(dd,'Tasmin\');
elseif  (strcmp(deblank(head{5}(1)),'Homogenized daily maximum temperature')==1)
       curr_var='tasmax';
       out=strcat(dd,'Tasmax\');
elseif  (strcmp(deblank(head{5}(1)),'Homogenized daily mean temperature')==1)
       curr_var='tasmoy';
       out=strcat(dd,'Tasmoy\');      
end
tempo=deblank((head{2}(1)));
name_station=strrep(tempo,' ','_')
clear tempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lecture des donnees 
fid = fopen(strcat(char(path),char(FileName),'.txt'));
% on saute les quatres premieres lignes correspondant au header
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
mat = fscanf(fid,'%4d%3d%8f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c%7f%*c\n',[33 inf]);
fclose(fid);

fid = fopen(strcat(char(path),char(FileName),'.txt'));
% on saute les quatres premieres lignes correspondant au header
fgetl(fid);
fgetl(fid);
fgetl(fid);
fgetl(fid);
flag = fscanf(fid,'%*15c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c\n',[31 inf]);
fclose(fid);

% Formatage pour SDSM: 
r_month=2;r_year=1;                 % les annees sont dans la 1ere rangée et les mois dans la 2eme rangée de la matrice mat
r_data=3;jump=2;                    % les données commencent dans la 3ème rangée de la matrice mat et finissent a la ligne 33 
indice_48=find(mat(1,:)==start_year,1,'first'); %on cherche le numero de colonne correspondant a notre annee de debut de traitement
indice_07=find(mat(1,:)==end_year,1,'last');    %on cherche le numero  de colonne correspondant a notre annee de fin de traitement

% detection des annees incompletes
if(isempty(indice_48) || mat(r_month,indice_48)~=1)
    error('Le fichier devrait contenir les données entre le début de lannee desiree (1er janvier) et la fin de lannée desire (31 decembre)');
   name_station 
elseif(isempty(indice_07) || mat(r_month,indice_07)~=12)
    error('Le fichier devrait contenir les données entre le début de lannee desiree (1er janvier) et la fin de lannée desire (31 decembre)');
   name_station 
end

% Extraction de données quoitidiennes pour la période desiree
for i=indice_48:indice_07
    cur_year=mat(r_year,i);
    cur_month=mat(r_month,i);
    if(mod(cur_year,4)==0)
        days_in_cur_mon=leap_year(cur_month);
    else
        days_in_cur_mon=nl_year(cur_month);   
    end
    TEMP_mat=mat(r_data:days_in_cur_mon+jump,i);
    TEMP_flag=flag(1:days_in_cur_mon,i);
    if(i==indice_48)
        OUT_mat=TEMP_mat;
        OUT_flag=TEMP_flag;
    else
        OUT_mat=[OUT_mat;TEMP_mat]; 
        OUT_flag=[OUT_flag;TEMP_flag];
    end
    clear cur_year;clear cur_month;clear days_in_cur_mon;clear TEMP_mat;clear TEMP_flag;
end

% Données manquantes sont remplacées par -des NaN
[r,c]=size(OUT_mat);
for j=1:r
    if(OUT_mat(j,1)<=-100. || OUT_mat(j,1)>=50)
        OUT_mat(j,1)=NaN;
   end 
end

% OUT_mat correspond a une colonne qui contient toutes les données 
% quoitidiennes pour la periode desiree
save(strcat(out,char(name_station),'_',char(curr_var),'_',num2str(start_year),'_',num2str(end_year),'.txt'),'OUT_mat', '-ASCII');
%clear OUT_mat 
    end
end
% Fin