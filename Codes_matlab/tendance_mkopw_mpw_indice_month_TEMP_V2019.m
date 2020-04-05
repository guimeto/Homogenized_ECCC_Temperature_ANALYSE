% Nom: Tendance sur les indices climatiques avec le test de Mann-kendall 
% modifie par von Storch (1995) ainsi que Wang et Swail (2001) pour la 
% periode 1981-2011.
% Auteur: Guillaume Dueymes
% Date:  15/09/2016
%  Adaptation sur fichier Netcdf 
%
%
%
% Dernier mise a jour: - 04/09/2012 adapte par Christian Saad
% 	Modifications apportees: - pour analyser les donnees observees 
%                              1981-2011 des 28 stations météorologiques et
%                              des 6 variables (tmin,tmax,tmoy,pcptot,
%                              pcpliq,pcpsol) du bassin versant de la
%                              riviere Richelieu.
%                            - conversion de degree Celcius en kelvin est
%                              supprimer; la tendance est calcule
%                              directement sur les anomalies interannuelles
%                              standardisees (1981-2010) des moyennes
%                              mensuelles et saisonnieres de chaque variable.
%                            - selection du pvalue assignee a la matrice 
%                              sortante selon l'index du test de
%                              mann-kendal applique
%
% Historique du code:   - 04/08/2011 adapte par christian saad
%                         pour analyse mensuelle et saisonniere des
%                         variables de base Tmin, Tmax, Prcp, Snow
%                         pour les stations d'observation du projet
%                         riviere Richelieu et pour la periode
%                         1981-2011
%
%                       - 17/03/2010 adapte par Christian Saad
%                         pour 4 saisons distinctes et indices
%                         additionnels
%                       - Documentation adaptee aux nomes du 13/03/09 le 
%                         22/01/2010 par Christian Saad.
%                       - Adapter le 21/12/09 par Dimitri Parishkura
%
%
% Analyse de tendance sur les variables Tmin, Tmax, Prcp, Snow avec le test 
% de Mann-Kendall modifie tel que von Storch (1995) ainsi que Wang et Swail
% (2001) sur les stations couvrant la periode de 1981 a 2011 et en prenant 
% en consideration 4 saisons distinctes et 12 mois.
%
% Sous-fonctions/codes: - getmk_opw_mpw.m
%
%
% Entree: Signal de précipitations (Alldata = série temporelle)
%	      
% Sortie: Fichier ASCII (.csv avec separateur: "," ) qui contient les valeurs des pentes de la 
%		  regression lineaires et de Sen ainsi que la valeur de probabilite (p-value) et l'index 
%		  identifiant le test statistique execute sur chacune des stations
%		  pour tous les mois et saisons.
%
% Variable(s) Globale(s): Aucune
%
% Variable(s) Locale(s):  
% 		   	  b : vecteurs qui contient les valeurs des indices calcules pour les 4 saisons 
%			  A : matrice [nbre d'annees X 2(annee, valeur saisonniere de l'indice)] qui contient les annees correspondantes aux valeurs 
%				  calculees de "b"
%		   	  OUT : Matrice qui contient les valeurs calculees par le test de Mann-Kendall modifie
%					(respectivement les valeurs des pentes de la regression lineaire et de Sen ainsi  
%					que la valeur de probabilite (p-value) et l'index identifiant le test  
%					statistique execute sur chacune des stations)
%
%
% Temps d'execution: Rapide (ex.:approximativement 10 secondes)
%
% Instruction(s): 1. Specifier le nom du fichier entrant
%                 2. Specifier le repertoire principal qui contient les
%                    donnees entrantes et sortantes
%				  3. Specifier les annees de debut (start_year) et fin (end_year) de serie.
%                 4. Executer le code
%
% Contact: christian.saad@mail.mcgill.ca

%% Initialisation des parametres de base
clear;
warning('OFF') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialisation des parametres d entree
%

start_year=1990;
end_year=2019;
dd = strcat('K:\DATA\Donnees_Stations\2nd_generation_V2019\INDICES\INDICES_MONTH\ANOMALY_STD\Tasmax\MOY\',num2str(start_year),'_',num2str(end_year),'\');
out='K:\DATA\Donnees_Stations\2nd_generation_V2019\INDICES\INDICES_MONTH\TENDANCES_ANO_STD\Tasmax\MOY\';

month={'01','02','03','04','05','06','07','08','09','10','11','12'};
list_domaine={'CANADA'};

curr_var='Tasmax';
confiance='90p';
indice=0.1;
nyear=end_year-start_year+1;
Annee=(start_year:end_year)';

for d=1:length(list_domaine)
    
    fid = fopen(strcat('K:\DATA\Donnees_Stations\2nd_generation_V2019\TEMP_ID\stations_noms_CANADA_',num2str(start_year),'-',num2str(end_year),'.txt'));    
    ltlg = csvread(strcat('K:\DATA\Donnees_Stations\2nd_generation_V2019\TEMP_ID\stations_latlon_CANADA_',num2str(start_year),'-',num2str(end_year),'.csv'),1,1);
    name_stat=textscan(fid,'%s','delimiter',' ');
    fclose(fid);        
    nb_stat=size(name_stat{1},1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colonne=(1:nb_stat)';

for  mon=1:length(month) % Boucle mensuelle
for s=1:size(name_stat{1},1)
    


File=strcat(char(name_stat{1}{s}),'_ANO_STD_MONTH_',char(curr_var),'_MOY_',num2str(start_year),'_',num2str(end_year),'_',char(month(mon)),'.csv');
filename = strcat(dd,File); 
T = readtable(filename, 'HeaderLines',0);
variable=T.var;

missval=NaN;      % valeur indicative de donnees manquante
naval=NaN;          % valeur indicative de donnees non-disponible 
nlags=1;            % le rang des valeurs de la fonction d'autocorrelation desire
autoThreshold=0.1; % valeur minimal auquel l'effet d'autocorrelation est pris en consideration 
					% (depend de l'utilisateur) ex.: >0.01 (valeur nonconservatrice)
%% Detection et Quantification de tendance
        
 Var = variable(:);
 b=Var;
 b(~any(~isnan(Var), 2),:)=[]; %on supprime les NaN du vecteur
 % si le vecteur est vide , on saute le calcul de la tendance 
 if isempty(b)
 END_S=NaN;
 else
 A=cat(2,Annee,Var(:));
%  if isnan(max(Var))==0 
                    temp_kendall=getmk_opw_mpw(A, missval, naval, autoThreshold, nlags);
                    %display(strcat('temp_kendall: ',num2str(temp_kendall)))
                    OUT_L=temp_kendall(1,4); % pente par une regression lineaire de moindres carres
                    OUT_S=temp_kendall(1,3); % pente de Sen
                    OUT_P=temp_kendall(1,5+temp_kendall(1,9)); % P-value tel que calcule par le test de kendall modifie mk, mk_opw ou mk_mpw
                    OUT_I=temp_kendall(1,9); % Index correspondant au test executer: mk original = 1, mk opw =2 et mk mpw=3;
                    clear temp_kendall A Var;
 if OUT_P <= indice 
 %END_S=OUT_S*nyear;
 END_S=OUT_S*10;
 else END_S=NaN;  
 end
 end
 outvar(s,1)=ltlg(s,1);
 outvar(s,2)=ltlg(s,2);
 outvar(s,3)=END_S;
 clear OUT_P OUT_S OUT_L END_S b A
%  else outvar(s,v)=NaN;
%  end
 
end  % boucle sur les rstations
mat_final=cat(2,colonne,outvar);
save(strcat(out,'\INDICES_MOY_',curr_var,'_',char(month(mon)),'_CANADA_',num2str(start_year),'_',num2str(end_year),'_',char(confiance),'.dat'),'mat_final', '-ASCII');
clear outvar mat_final

end % boucle sur les mois
end % boucle sur les domaines
