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
% Code Modifie par Guillaume Dueymes 18 Juillet 2013 
% Code original: Christian Saad 4 Mai 2010.
%
% Cet outil MATLAB permet de restructurer les donn�es quotidiennes 
% d'observation 
%
% Entree : 
%   - Fichier ASCII qui contient les donn�es quotidiennes homogeneisees  
%     d'une station et d'une variable desiree-ATTENTION ce code est uniquement
%     adapte aux donnees de station de deuxieme generation
%
% Sortie :
%   - Fichier ASCII formate en une seul colonne pour laquelle chaque ligne
%     represente une valeur quotidienne de la variable trait�e. 
%
%NB1: l usager ne doit modifier que la partie 1 du code
%NB2:  il est possible de traiter plusieurs stations en boucle
%      le code extrait automatiquement les informations du header 
%
%
% Temps d'execution: rapide (quelques secondes)

clear;
%%%%%%%%%%%%%%%%%%     PARTIE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Annee de debut et de fin de la serie temporelle a traiter (Ajuster au
% besoin)
start_year=1961;
end_year=2010;

% definition du nombre maximal de jours par mois
leap_year=[31 29 31 30 31 30 31 31 30 31 30 31];      % Nombre de jours par mois dans une ann�e de 366 jours;
nl_year=[31 28 31 30 31 30 31 31 30 31 30 31];        % Nombre de jours par mois dans une ann�e de 365 jours;

% repertoire d entree
 path='K:\DATA\Donnees_Stations\2nd_generation_V2018\Adj_Daily_Total_v2017\';
 
% numero des stations a traiter: voir fichier excel 
id_stat = textread('K:\PROJETS\PROJET_2018\PRECIP_ID\CANADA_ID_1961-2010.txt','%s');

% on choisit ici de traiter les trois variables journalieres 
%  list_var={'dt','ds','dr'};
 list_var={'dt'};
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
if  (strcmp(deblank(head{5}(1)),'Daily adjusted rainfall')==1)
       curr_var='dr';
       dd='K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\';
elseif  (strcmp(deblank(head{5}(1)),'Daily adjusted precipitation')==1)
       curr_var='dt';
       dd='K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\';
elseif  (strcmp(deblank(head{5}(1)),'Daily adjusted snowfall')==1)
       curr_var='ds';
       dd='K:\DATA\Donnees_Stations\2nd_generation_V2018\MATLAB_TEST\';
       
       
end
tempo=deblank((head{2}(1)));
name_station=strrep(tempo,' ','_');
clear tempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lecture des donnees 
fid = fopen(strcat(char(path),char(FileName),'.txt'));
% on saute la premiere ligne correspondant au header
fgetl(fid);
mat = fscanf(fid,'%4d%3d%9f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c%8f%*c\n',[33 inf]);
fclose(fid);

fid = fopen(strcat(char(path),char(FileName),'.txt'));
% on saute les deux premieres lignes correspondant au header
fgetl(fid);
flag = fscanf(fid,'%*15c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c%*7c%c\n',[31 inf]);
fclose(fid);

% Formatage pour SDSM: 
r_month=2;r_year=1;                 % les annees sont dans la 2eme rang�e et les mois dans la 3eme rang�e de la matrice mat
r_data=3;jump=2;                    % les donn�es commencent dans la 3�me rang�e de la matrice mat et finissent a la ligne 33 
indice_48=find(mat(1,:)==start_year,1,'first'); %on cherche le numero de colonne correspondant a notre annee de debut de traitement
indice_07=find(mat(1,:)==end_year,1,'last');    %on cherche le numero  de colonne correspondant a notre annee de fin de traitement

% detection des annees incompletes
if(isempty(indice_48) || mat(r_month,indice_48)~=1)
    error('Le fichier devrait contenir les donn�es entre le d�but de lannee desiree (1er janvier) et la fin de lann�e desire (31 decembre)');
elseif(isempty(indice_07) || mat(r_month,indice_07)~=12)
    error('Le fichier devrait contenir les donn�es entre le d�but de lannee desiree (1er janvier) et la fin de lann�e desire (31 decembre)');
end

% Extraction de donn�es quoitidiennes pour la p�riode desiree
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

% Donn�es manquantes sont remplac�es par -des NaN
[r,c]=size(OUT_mat);
for j=1:r
    if(OUT_mat(j,1)<=-100. )
        OUT_mat(j,1)=NaN;
   end 
end

% OUT_mat correspond a une colonne qui contient toutes les donn�es 
% quoitidiennes pour la periode desiree

save(strcat(dd,strrep(char(name_station),'/','_'),'_',char(curr_var),'_',num2str(start_year),'_',num2str(end_year),'.dat'),'OUT_mat', '-ASCII');
%clear OUT_mat 
    end
end
% Fin