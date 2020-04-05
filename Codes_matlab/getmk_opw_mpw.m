% Nom:  Test de Mann-Kendall modifie getmk_opw_mpw.m
% Auteur: Naveed Khaliq (adaptŽ du code R en MATLAB par Christian Saad)
% Version: v1
% Date:  ?
%
%
% Dernier mis a jour: 22/01/2010 par Christian Saad. 
% 	Modifications apportees: - documentation adaptee aux normes du 13/03/09
%				 - entete ajoute 
%
%
%
% Historique du code: Version MATLAB valider le 21/12/2009 par Christian
%
%
% Test Statistique de Mann-Kendall tel que modifie par von Storch (1995) en considerant la methode
% Wang et Swail (2001) de preblanchissement afin de prendre en consideration l'effet 
% d'autocorrelation sur les tendances significatives (voir description orginial - en anglais - pour
% plus de detail).
%
% Sous-fonctions/codes: -ktaub.m
%						-getAutocorrelation.m
%						-getsenSlope.m
%
%
%
% Entree: -Signal de précipitations (A = série temporelle) - Format vectorielle (2 colonnes)
%		  -valeur attribuee au valeur manquante (missval)
%		  -valeur attribuee au valeur non-disponible (naval)
%		  -valeur minimal auquel l'effet d'autocorrelation est pris en consideration - depend de 
%		   l'utilisateur - peut etre aussi bas que 0.01 (valeur non conservatrice) (autoThreshold)
%		  -nombre de lag pour la fonction d'autocorrelation (nlags)
%
% Sortie: Valeurs de la fonction d'autocorrelation original et apres preblanchissements 
%		  (si il y a lieu), pente de Sen, pente de la regression lineaire, pente de Sen apres
%		  blanchissment (si il y a lieu), valeur de probabilite du test de Mann-kendall original 
%         avant pre-blanchissement, apres pre-blanchissment original et apres pre-blanchissement 
%		  modifie ainsi que l'index correspondant aux tests enregsitres  (respectivement obsAuto,
%  		  rhoPW, senSlope, lmSlope, slopePW, obsPValue, opwPValue, mpwPValue et numtest)
%
%
%
% Variable(s) Globale(s): Aucune
%
%
%
% Variable(s) Locale(s):  
%			   	y : vecteur qui contient les valeurs de la serie temporelle
%		   	   	y1 : vecteur qui contient les valeurs de la serie temporelle sans les valeur non-disponible 
% 		   	   	y2 : vecteur qui contient les valeurs de la serie temporelle sans les valeur non-disponible
%					 ni les valeurs manquantes aux extremites de la serie temporelle
%		   	  	yWOM : vecteur qui contient les valeurs de la serie temporelle sans les valeur 
%					   non-disponible ni les valeurs manquantes de la serie temporelle complete
%				alpha : niveau critique significatif du test statistique 
%				A1_yWOM: matrice qui contient les valeurs de la serie temporelle sans les valeurs 
%					    non-disponibles ni les valeurs manquantes de la serie temporelle complete et
%						les valeurs des annees de la serie temporelle 
%			    obsMKStat : Score S de Mann-Kendall original
%				obsMKStatVar : Variance de S en considerant tout les valeurs du vecteur d'annees et 
%							   de la serie temporelle du test de Mann-Kendal original
%				obsAuto : premiere valeur de la fonction de correlation
%				yPW : valeurs de la serie temporelle apres les procedures de pre-blanchissement
%				ySR : valeurs de la serie temporelle apres les procedures de pre-blanchissement et 
%					  apres avoir supprimer la pente de Sen calculee a partir de la serie temporelle
%					  pre-blanchie
%				nTrials : nombre d'essaies avant que les conditions de convergence soit rencontrees
%
% Temps d'execution: Rapide
%
% ---------------------------------------------------------------------------------------------------------------------

function [kend]=getmk_opw_mpw(A, missval, naval, autoThreshold, nlags)
    
%% Traitement des donnees

y = A(:,2); % il y a seulement une serie de donnee a analyser qui est sur la colonne 2
y1 = y(find(y~=naval)); % supprimer les valeurs non-disponibles des deux extrmites de la serie de donnees

% Compter le nombre de valeur manquante du debut a la fin de la serie temporelle
countFromStart = 0;
notDone = 0;
count = 0;
while notDone==0
    count = count+1;
    if y1(count)==missval
        countFromStart = countFromStart + 1;
    else
        notDone = 1;
    end
end

countFromEnd = 0;
notDone = 0;
while notDone==0
    if y1(length(y1)-countFromEnd)==missval
        countFromEnd = countFromEnd + 1;
    else
        notDone = 1;
    end
end

y2 = y1((countFromStart+1):length(y1)); % indicateurs des valeurs manquantes sont eliminees du debut
										% de la serie temporelle
y2 = y2(1:(length(y2)-countFromEnd)); % indicateurs des valeurs manquantes sont eliminees de la fin 
									  % de la serie temporelle

% note: y2 contient encore des donnees manquantes a l'interieur de la serie temporelle et celle-ci
% sera utilise plus loin dans l'analyse de tendance 

yWOM = y2(find(y2~=missval)); % supprimer les valeurs manquantes a l'interieur de la serie temporelle
missingCount = length(y2) - length(yWOM);
nonMissingCount = length(yWOM);
obsIndex = nonMissingCount;
count = 0;
count2 = 0;
missingIndex = missingCount;
for k=1:length(y2)
    if y2(k)~=missval
        count = count+1;
        obsIndex(count) = k;
    else
        count2 = count2+1;
        missingIndex(count2) = k;
    end
end

%% Perform Mann-Kendall test

alpha = 0.05; % alpha (niveau critique significatif du test statistique) 
A1_yWOM=cat(2,A(:,1),yWOM); % fusionnement du vecteur d'annees au valeurs de la serie temporelle
[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub(A1_yWOM, alpha, 0);
obsPValue = sig; % valeur de probabilite tel que calcule par sous-fonction ktaub.m
obsMKStat = S; % Score S de Kendall
obsMKStatVar = sigma^2; % Variance de S en considerant tout les valeurs du vecteur d'annees et de la
						% serie temporelle 
numtest=1;


% -----estimation de la fonction d'autocorrelation et retenu de la premiere autocorrelation
resAUTO = getAutocorrelation(y2,length(y2),nlags,missval,naval); %fonction traite valeurs manquantes
obsAuto = resAUTO(1);

% -----estimation de la pente de Sen en utilisant les valeurs de y2
senSlope = getSenSlope(y2,missval); %fonction traite valeurs manquantes


% -----estimation de la pente de la regression lineaire
non_NaN =~isnan(yWOM); % cette commande est un filtre complementaire des valeurs NaN
%display(strcat('yWOM_non_NaN:',num2str(yWOM(non_NaN))))
lmres = polyfit(obsIndex(non_NaN)',yWOM(non_NaN),1);
lmSlope = lmres(1); % le premier element de ce vecteur correspond a la pente, et le deuxieme 
					%a l'intercept

%% Precedure original de pre-blanchissement de Zhang et al. (2000) et suggere par von Storch (1995)
count=0;
for k=2:length(y2)
    if y2(k)~=missval && y2(k-1)~=missval
        count=count+1;
    else
    end
end
yPW=count;
% pre-blanchissement des donnees obsevees de la serie temporelle y2 avec les valeurs manquantes
count=0;
for k=2:length(y2)
    if y2(k)~=missval && y2(k-1)~=missval
        count=count+1;
        yPW(count)=y2(k)-obsAuto*y2(k-1); 
    else
    end
end
% estimation de la tendance
if abs(obsAuto)>=autoThreshold % alors executer le test de Mann-Kendall
    A1_yPW=cat(2,A(2:end,1),yPW'); 
    [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub(A1_yPW, alpha, 0);
    opwPValue = sig; % valeur de probabilite tel que calcule par sous-fonction ktaub.m
    opwMKStat = S; %  Score S de kendall
    numtest=2;
else
    opwPValue=obsPValue;
end

%% procedure modifie de pre-blanchissement de Wang et Swail (2001)
% les estimations finaux semblent etre un peu dependant de la valeur initial de la pente et de
% l'autocorrelation, donc on essaie de minimiser de tel sensibiliter
nTrials=0;
notDone=0;
slopeOld=senSlope;
rhoOld=obsAuto;
ySR=length(y2);

% count=0;
% for k=2:length(y2)
%   if y2(k)~=missval && y2(k-1)~=missval
%       count=count+1;
%   end
% end
% yPW=count;

while notDone==0
    nTrials=nTrials+1;
	% pre-blanchissement des donnees obsevees de la serie temporelle y2 avec les valeurs manquantes
    count=0;
    for k=2:length(y2)
        if y2(k)~=missval && y2(k-1)~=missval
            count=count+1;
            yPW(count)= (y2(k)-rhoOld*y2(k-1))/(1.0-rhoOld);
        else
        end
    end
    % determine pente a partir des donnees pre-blanchies 
    slopeNew=getSenSlope(yPW,missval);
    
    % supprimer la nouvelle pente et reestimer rho (r1)
    for k=1:length(y2)
        if y2(k)~=missval
            ySR(k)=(y2(k)-slopeNew*(k-1));
        else
            ySR(k)=y2(k);
        end
    end
    rhoNew_res=getAutocorrelation(ySR,length(ySR),1,missval,naval);
    rhoNew=rhoNew_res(1);
    
    % les limites de convergence et le nombre d'essais sont arbritraires et peuvent changer au besoin
    if(abs(slopeNew-slopeOld)<=0.00001 && abs(rhoNew-rhoOld)<=0.00001 || nTrials>=100)
        notDone=1;
    else
        slopeOld=slopeNew;
        rhoOld=rhoNew;
    end
end

slopePW=slopeOld;
rhoPW=rhoOld;

if abs(rhoPW)>=autoThreshold % alors executer le test de Mann-Kendall
    count=0;
    for k=2:length(y2)
        if y2(k)~=missval && y2(k-1)~=missval
            count=count+1;
            yPW(count)= (y2(k)-rhoOld*y2(k-1))/(1.0-rhoOld);
        end
    end
    A1_yPW=cat(2,A(2:end,1),yPW');
    [taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3] = ktaub(A1_yPW, alpha, 0);
    mpwPValue = sig; % valeur de probabilite tel que calcule par sous-fonction ktaub.m
    mpwMKStat = S; % Score S de kendall
    numtest=3;
else
    mpwPValue=obsPValue;
end

kend=[obsAuto, rhoPW, senSlope, lmSlope, slopePW, obsPValue, opwPValue, mpwPValue, numtest];
end
% Fin de la fonction