clear all
% figure;

confiance='90p';
% listper={'1961_2010','1971_2010','1981_2010'}; 
listper={'1948_2017','1988_2017'}; 

IND='MOY';
%ana='1961-2010';
ana='1948-2017';

listvar={'tasmin','tasmax','tasmoy'}; 
domaine={'domaine1','domaine2','domaine3','domaine4'};
out='G:\PROJETS\PROJET_2018\DATA\figures\tendances\YEAR\';
for p=1:length(listper)
    per=listper(p);
for v=1:length(listvar)
    
  var=listvar(v);

if (strcmp(char(var),'tasmin')==1)
path='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_ANNEE\Tasmin\TENDANCES';
elseif (strcmp(char(var),'tasmax')==1)
path='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_ANNEE\Tasmax\TENDANCES';
elseif (strcmp(char(var),'tasmoy')==1)
path='G:\PROJETS\PROJET_2018\DATA\CANADA\INDICES_ANNEE\Tasmoy\TENDANCES';
end

worldmap('Canada');
load coast;
plotm(lat,long);

latlim(1:size(lat,1),1)=58;
lonlim=sort(long(:,1));
plotm(latlim,lonlim,'black','LineWidth',1)

lonlim2(1:size(long,1),1)=-100;
latlim2=sort(lat(:,1));
plotm(latlim2,lonlim2,'black','LineWidth',1)

for d=1:4
tendance=load(strcat(char(path),'\INDICES_',char(IND),'_',char(var),'_',char(domaine(d)),'_',char(per),'_',char(confiance),'.dat'));
 lalon=load(strcat('G:\PROJETS\PROJET_2018\TEMP_ID\stations_latlon_',char(domaine(d)),'_',char(ana),'.txt'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prétraitement des données
%on va détecter les valeurs positives et negatives
%
 tmp=tendance(:,2); 
positif=find(tmp>0);
negatif=find(tmp<0);
stat_positif(d)=(length(positif)/length(tmp))*100;
stat_negatif(d)=(length(negatif)/length(tmp))*100;

   for t=1:size(positif,1)
    scatterm(lalon(positif(t),1),lalon(positif(t),2),350,tmp(positif(t)),'^','filled');
   end
   for t=1:size(negatif,1)
    scatterm(lalon(negatif(t),1),lalon(negatif(t),2),350,tmp(negatif(t)),'v','filled');
   end
clear tmp positif negatif tendance   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%debut du graphique
 lp1=strcat(num2str(round(stat_positif(1))),'%');
 lp2=strcat(num2str(round(stat_positif(2))),'%');
 lp3=strcat(num2str(round(stat_positif(3))),'%');
 lp4=strcat(num2str(round(stat_positif(4))),'%');
 ln1=strcat(num2str(round(stat_negatif(1))),'%');
 ln2=strcat(num2str(round(stat_negatif(2))),'%');
 ln3=strcat(num2str(round(stat_negatif(3))),'%');
 ln4=strcat(num2str(round(stat_negatif(4))),'%');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

textm(43,-59,lp4,'Color','red','FontSize',14,'LineWidth',4, 'fontweight', 'bold')
textm(45,-57.25,ln4,'Color','blue','FontSize',14,'LineWidth',4, 'fontweight', 'bold')

textm(60,-59,lp2,'Color','red','FontSize',14,'LineWidth',4, 'fontweight', 'bold')
textm(62,-55,ln2,'Color','blue','FontSize',14,'LineWidth',4, 'fontweight', 'bold')

textm(43,-104,lp3,'Color','red','FontSize',14,'LineWidth',4, 'fontweight', 'bold')
textm(45,-105,ln3,'Color','blue','FontSize',14,'LineWidth',4, 'fontweight', 'bold')

textm(60,-105,lp1,'Color','red','FontSize',14,'LineWidth',4, 'fontweight', 'bold')
textm(62,-106,ln1,'Color','blue','FontSize',14,'LineWidth',4, 'fontweight', 'bold')
clear   lp1 lp2 lp3 lp4 ln1 ln2 ln3 ln4 

contourcmap('jet',[-2:0.5:2],'colorbar','on','location','horizontal','FontSize',30) ;
set(gca,'FontSize',20);
set(gcf,'units','normalized','outerposition',[0 0 1 1])  
if (strcmp(char(var),'tasmax')==1)
           SAVE_file=[strcat(out,'Decadal_trend_of_tasmax_YEAR_mean_',char(per),'_',char(confiance))];  
          export_fig(SAVE_file)      
          
   elseif (strcmp(char(var),'tasmin')==1)
            SAVE_file=[strcat(out,'Decadal_trend_of_tasmin_YEAR_mean_',char(per),'_',char(confiance))];  
         export_fig(SAVE_file)   
     elseif (strcmp(char(var),'tasmoy')==1)
            SAVE_file=[strcat(out,'Decadal_trend_of_tasmoy_YEAR_mean_',char(per),'_',char(confiance))];  
         export_fig(SAVE_file)         
        
end
close(gcf);
end
end
