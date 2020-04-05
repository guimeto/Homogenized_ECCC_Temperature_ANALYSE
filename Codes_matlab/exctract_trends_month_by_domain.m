%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------------Guillaume  Dueymes  31/10/2016---------------------------%
%                                                                         %
% Programme qui extrait une sous region  d un fichier Netcdf 2D           %                                                                  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all ;
main_dir='G:\PROJETS\PROJET_CORDEX\CORDEX-NAM44\TENDANCES_MOIS\';
out_dir='G:\PROJETS\PROJET_2018\TENDANCES_RCMs\MONTH\';

list_domaine={'Domaine1','Domaine2','Domaine3','Domaine4'};
list_station={'domaine1','domaine2','domaine3','domaine4'};

List_mon = {'01','02','03','04','05','06','07','08','09','10','11','12'};
period1='2011-2040';
period2='2041-2070';
period3='2071-2100';
ref='1971-2000';
var1='Mean_tasmoy';
var2='tasmoy';

%%%%%%%%%%%%%%%%%%%%%%%%%%
scenario={'rcp45','rcp85'};
%%%%%%%%%%%%%%%%%%%%%%%%%%
for d=1:4 %boucle sur les domaines a extraire
     domaine=list_domaine(d);
     station=list_station(d);
       if strcmpi(domaine,'Domaine1')
            %%%%DOMAINE 1 
            LatSouth=58;            %degres Nord
            LatNorth=83;            %degres Nord
            LonWest=-140;            %degres Est 
            LonEast=-100;            %degres Est  
        elseif strcmpi(domaine,'Domaine2')
            %%%%DOMAINE 2 
            LatSouth=58;            %degres Nord
            LatNorth=83;            %degres Nord
            LonWest=-100;            %degres Est 
            LonEast=-52;            %degres Est 
        elseif strcmpi(domaine,'Domaine3')
           %%%%DOMAINE 3 
            LatSouth=42;            %degres Nord
            LatNorth=58;            %degres Nord
            LonWest=-140;            %degres Est 
            LonEast=-100;            %degres Est 
         elseif strcmpi(domaine,'Domaine4')
            %%%%DOMAINE 4 
            LatSouth=42;            %degres Nord
            LatNorth=58;            %degres Nord
            LonWest=-100;            %degres Est 
            LonEast=-52;            %degres Est 
       end     
    for tt=1:12  %Boucle sur les mois
            mois=List_mon(tt);  
        
          scen=scenario(1);
              if strcmpi(scen,'rcp45')   
                  PATHM={'CANRCM4_CanESM2_rcp45', ...          
                         'CRCM5-v1_CCCma-CanESM2_rcp45', 'CRCM5-v1_MPI-M-MPI-ESM-LR_rcp45' ,...  
                         'HIRHAM5_ICHEC-EC-EARTH_rcp45', ... 
                         'RCA4.v1_CCCma-CanESM2_rcp45','RCA4.v1_ICHEC-EC-EARTH_rcp45'}; 
                  MODEL_LIST={'CANRCM4_NAM-44_ll_CanESM2_rcp45', ...            
                         'CRCM5-v1_NAM-44_ll_CCCma-CanESM2_rcp45', 'CRCM5-v1_NAM-44_ll_MPI-M-MPI-ESM-LR_rcp45' ,...  
                         'HIRHAM5_NAM-44_ll_ICHEC-EC-EARTH_rcp45', ... 
                         'RCA4.v1_NAM-44_ll_CCCma-CanESM2_rcp45','RCA4.v1_NAM-44_ll_ICHEC-EC-EARTH_rcp45'}; 
              end
          
        mm=length(MODEL_LIST);      
        for mo = 1:mm   %boucle sur les modeles
              curr_model=MODEL_LIST(mo) ;
              curr_path=PATHM(mo) ;
              
             if strcmpi(curr_path,'CANRCM4_CanESM2_rcp45') ==1 || strcmpi(curr_path,'CRCM5-v1_MPI-M-MPI-ESM-MR_rcp45') ==1  || strcmpi(curr_path,'HIRHAM5_ICHEC-EC-EARTH_rcp45') ==1
             period3 = '2071-2099';  
             elseif strcmpi(curr_path,'CRCM5-v1_CCCma-CanESM2_rcp45')==1 || strcmpi(curr_path,'RCA4.v1_CCCma-CanESM2_rcp45')==1 || ...
                    strcmpi(curr_path,'RCA4.v1_ICHEC-EC-EARTH_rcp45')==1
             period3 = '2071-2098';      
             end
  
            % lecture du fichier anomalie
            FichierIn1 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period1),'_',char(mois),'.nc') );  
                [InArr1, LatArr, LonArr] = read_netcdf(FichierIn1); 
           
            FichierIn2 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period2),'_',char(mois),'.nc') );  
                [InArr2, LatArr, LonArr] = read_netcdf(FichierIn2);   
       
            FichierIn3 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period3),'_',char(mois),'.nc') );  
                [InArr3, LatArr, LonArr] = read_netcdf(FichierIn3);         

           if (strcmp(curr_model,'CANRCM4_NAM-44_ll_CanESM2_rcp45')==1 || strcmp(curr_model,'CANRCM4_NAM-44_ll_CanESM2_rcp85')==1 )
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest+360; LonEast+360; LonEast+360; LonWest+360; LonWest+360; LonWest+360]; 
           else
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest; LonEast; LonEast; LonWest; LonWest; LonWest];                
           end
 
            [IN] = inpolygon(LatArr,LonArr, LatLimits, LonLimits); 
            [row,col] = find(IN == 1); 
            NoCell = length([row,col]); 
            
                      for icell = 1:NoCell
                          tmp1(icell) = squeeze( InArr1(row(icell),col(icell))); 
                          tmp2(icell) = squeeze( InArr2(row(icell),col(icell))); 
                          tmp3(icell) = squeeze( InArr3(row(icell),col(icell))); 
                      end
                          eval(['mat1',num2str(mo) '  = tmp1;']);
                          eval(['mat2',num2str(mo) '  = tmp2;']);
                          eval(['mat3',num2str(mo) '  = tmp3;']);
                    clear tmp1 tmp2 tmp3
  
                  clear row col icell InArr1 InArr2 InArr3
        end    %fin de la boucle sur les modeles
        
         
            for j=1:(mm)
            eval(['vec1_mod(',num2str(j),')= length(mat1',num2str(j),');'])
            eval(['vec2_mod(',num2str(j),')= length(mat2',num2str(j),');'])
            eval(['vec3_mod(',num2str(j),')= length(mat3',num2str(j),');']) 
            end
         max_mat1 = max(vec1_mod)+1 ;
         max_mat2 = max(vec2_mod)+1 ;
         max_mat3 = max(vec3_mod)+1 ;  
         clear vec1_mod vec2_mod vec3_mod
         mat11=mat11';
         mat12=mat12';
         mat13=mat13';
         mat14=mat14';
         mat15=mat15';
         mat16=mat16';
         mat21=mat21';
         mat22=mat22';
         mat23=mat23';
         mat24=mat24';
         mat25=mat25';
         mat26=mat26';
         mat31=mat31';
         mat32=mat32';
         mat33=mat33';
         mat34=mat34';
         mat35=mat35';
         mat36=mat36';
         for l=1:mm
            eval(['mat_1',num2str(l),'=[mat1',num2str(l),';NaN(max_mat1-length(mat1',num2str(l),'),1)];'])
            eval(['rcp45_fin1(:,',num2str(l),')=mat_1',num2str(l),'(1:end-1,:);'])
            eval(['mat_2',num2str(l),'=[mat2',num2str(l),';NaN(max_mat2-length(mat2',num2str(l),'),1)];'])
            eval(['rcp45_fin2(:,',num2str(l),')=mat_2',num2str(l),'(1:end-1,:);'])
            eval(['mat_3',num2str(l),'=[mat3',num2str(l),';NaN(max_mat3-length(mat3',num2str(l),'),1)];'])
            eval(['rcp45_fin3(:,',num2str(l),')=mat_3',num2str(l),'(1:end-1,:);'])
         end
         for l=1:mm
            eval(['clear mat1',num2str(l)]);
            eval(['clear mat_1',num2str(l)]);
            eval(['clear mat2',num2str(l)]);
            eval(['clear mat_2',num2str(l)]);
            eval(['clear mat3',num2str(l)]);
            eval(['clear mat_3',num2str(l)]);
         end
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP45_',char(var1),'_',char(period1),'_',char(mois),'.csv'),rcp45_fin1)
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP45_',char(var1),'_',char(period2),'_',char(mois),'.csv'),rcp45_fin2)
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP45_',char(var1),'_2071-2100_',char(mois),'.csv'),rcp45_fin3)
          clear rcp45_fin1 rcp45_fin2 rcp45_fin3
         
              scen=scenario(2);
              if strcmpi(scen,'rcp85')   
                  PATHM={'CANRCM4_CanESM2_rcp85', ...           
                         'CRCM5-v1_CCCma-CanESM2_rcp85', ... %%'CRCM5-v1_MPI-M-MPI-ESM-MR_rcp85' ,...   %% pas de MPI-rcp85 pour tasmoy  
                         'HIRHAM5_ICHEC-EC-EARTH_rcp85', ... 
                         'RCA4.v1_CCCma-CanESM2_rcp85','RCA4.v1_ICHEC-EC-EARTH_rcp85', ... 
                         'RegCM4_GFDL-ESM2M_rcp85','RegCM4_HadGEM2-ES_rcp85','RegCM4_MPI-ESM-LR_rcp85'};  
                  MODEL_LIST={'CANRCM4_NAM-44_ll_CanESM2_rcp85', ...           
                         'CRCM5-v1_NAM-44_ll_CCCma-CanESM2_rcp85', ... %'CRCM5-v1_NAM-44_ll_MPI-M-MPI-ESM-MR_rcp85'...  %% pas de MPI-rcp85 pour tasmoy
                         'HIRHAM5_NAM-44_ll_ICHEC-EC-EARTH_rcp85', ... 
                         'RCA4.v1_NAM-44_ll_CCCma-CanESM2_rcp85','RCA4.v1_NAM-44_ll_ICHEC-EC-EARTH_rcp85',... 
                         'RegCM4_NAM-44_ll_GFDL-ESM2M_rcp85','RegCM4_NAM-44_ll_HadGEM2-ES_rcp85','RegCM4_NAM-44_ll_MPI-ESM-LR_rcp85'};
               end
          
        mm=length(MODEL_LIST);      
        for mo = 1:mm   %boucle sur les modeles
              curr_model=MODEL_LIST(mo) ;
              curr_path=PATHM(mo) ;
             if strcmpi(curr_path,'CANRCM4_CanESM2_rcp85') ==1  ||  strcmpi(curr_path,'CRCM5-v1_CCCma-CanESM2_rcp85') ==1 || strcmpi(curr_path,'HIRHAM5_ICHEC-EC-EARTH_rcp85') 
             period3 = '2071-2099';  
             elseif strcmpi(curr_path,'RCA4.v1_CCCma-CanESM2_rcp85')==1 || strcmpi(curr_path,' RCA4.v1_ICHEC-EC-EARTH_rcp85')==1 || strcmpi(curr_path,'RegCM4_GFDL-ESM2M_rcp85')==1 || ...
                    strcmpi(curr_path,'RegCM4_HadGEM2-ES_rcp85')==1 || strcmpi(curr_path,'RegCM4_MPI-ESM-LR_rcp85')==1
             period3 = '2071-2098';      
             end

            % lecture du fichier anomalie
            FichierIn1 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period1),'_',char(mois),'.nc') );  
                [InArr1, LatArr, LonArr] = read_netcdf(FichierIn1); 
           
            FichierIn2 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period2),'_',char(mois),'.nc') );  
                [InArr2, LatArr, LonArr] = read_netcdf(FichierIn2);   
       
            FichierIn3 = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_',char(period3),'_',char(mois),'.nc') );  
                [InArr3, LatArr, LonArr] = read_netcdf(FichierIn3);         

           if (strcmp(curr_model,'CANRCM4_NAM-44_ll_CanESM2_rcp45')==1 || strcmp(curr_model,'CANRCM4_NAM-44_ll_CanESM2_rcp85')==1 )
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest+360; LonEast+360; LonEast+360; LonWest+360; LonWest+360; LonWest+360]; 
           else
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest; LonEast; LonEast; LonWest; LonWest; LonWest];                
           end
 
            [IN] = inpolygon(LatArr,LonArr, LatLimits, LonLimits); 
            [row,col] = find(IN == 1); 
            NoCell = length([row,col]); 
            
                      for icell = 1:NoCell
                          tmp1(icell) = squeeze( InArr1(row(icell),col(icell))); 
                          tmp2(icell) = squeeze( InArr2(row(icell),col(icell))); 
                          tmp3(icell) = squeeze( InArr3(row(icell),col(icell))); 
                      end
                          eval(['mat1',num2str(mo) '  = tmp1;']);
                          eval(['mat2',num2str(mo) '  = tmp2;']);
                          eval(['mat3',num2str(mo) '  = tmp3;']);
                    clear tmp1 tmp2 tmp3
  
                  clear row col icell InArr1 InArr2 InArr3
        end    %fin de la boucle sur les modeles
        
         
            for j=1:(mm)
            eval(['vec1_mod(',num2str(j),')= length(mat1',num2str(j),');'])
            eval(['vec2_mod(',num2str(j),')= length(mat2',num2str(j),');'])
            eval(['vec3_mod(',num2str(j),')= length(mat3',num2str(j),');']) 
            end
         max_mat1 = max(vec1_mod)+1 ;
         max_mat2 = max(vec2_mod)+1 ;
         max_mat3 = max(vec3_mod)+1 ;  
         clear vec1_mod vec2_mod vec3_mod
         mat11=mat11';
         mat12=mat12';
         mat13=mat13';
         mat14=mat14';
         mat15=mat15';
         mat16=mat16';
         mat17=mat17';
         mat18=mat18';
       %  mat19=mat19'; % attention seulement 8 modeles en rcp85 avec tasmoy
         
         mat21=mat21';
         mat22=mat22';
         mat23=mat23';
         mat24=mat24';
         mat25=mat25';
         mat26=mat26';
         mat27=mat27';
         mat28=mat28';
     %    mat29=mat29';
         
         mat31=mat31';
         mat32=mat32';
         mat33=mat33';
         mat34=mat34';
         mat35=mat35';
         mat36=mat36';
         mat37=mat37';
         mat38=mat38';
      %   mat39=mat39';
         
         for l=1:mm
            eval(['mat_1',num2str(l),'=[mat1',num2str(l),';NaN(max_mat1-length(mat1',num2str(l),'),1)];'])
            eval(['rcp45_fin1(:,',num2str(l),')=mat_1',num2str(l),'(1:end-1,:);'])
            eval(['mat_2',num2str(l),'=[mat2',num2str(l),';NaN(max_mat2-length(mat2',num2str(l),'),1)];'])
            eval(['rcp45_fin2(:,',num2str(l),')=mat_2',num2str(l),'(1:end-1,:);'])
            eval(['mat_3',num2str(l),'=[mat3',num2str(l),';NaN(max_mat3-length(mat3',num2str(l),'),1)];'])
            eval(['rcp45_fin3(:,',num2str(l),')=mat_3',num2str(l),'(1:end-1,:);'])
         end
         for l=1:mm
            eval(['clear mat1',num2str(l)]);
            eval(['clear mat_1',num2str(l)]);
            eval(['clear mat2',num2str(l)]);
            eval(['clear mat_2',num2str(l)]);
            eval(['clear mat3',num2str(l)]);
            eval(['clear mat_3',num2str(l)]);
         end
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP85_',char(var1),'_',char(period1),'_',char(mois),'.csv'),rcp45_fin1)
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP85_',char(var1),'_',char(period2),'_',char(mois),'.csv'),rcp45_fin2)
         csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_RCP85_',char(var1),'_2071-2100_',char(mois),'.csv'),rcp45_fin3)
          clear rcp45_fin1 rcp45_fin2 rcp45_fin3
          
     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RCMs en MODE HISTORIQUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                 PATHM={'CANRCM4_CanESM2_historical', ...          
                         'CRCM5-v1_CCCma-CanESM2_historical', 'CRCM5-v1_MPI-M-MPI-ESM-LR_historical' ,...  
                         'HIRHAM5_ICHEC-EC-EARTH_histo', ... 
                         'RCA4.v1_CCCma-CanESM2_histo','RCA4.v1_ICHEC-EC-EARTH_histo', ...
                         'RegCM4_GFDL-ESM2M_histo','RegCM4_HadGEM2-ES_histo','RegCM4_MPI-ESM-LR_histo'}; 
                  MODEL_LIST={'CANRCM4_NAM-44_ll_CanESM2_historical', ...          
                         'CRCM5-v1_NAM-44_ll_CCCma-CanESM2_historical', 'CRCM5-v1_NAM-44_ll_MPI-M-MPI-ESM-LR_historical' ,...  
                         'HIRHAM5_NAM-44_ll_ICHEC-EC-EARTH_histo', ... 
                         'RCA4.v1_NAM-44_ll_CCCma-CanESM2_histo','RCA4.v1_NAM-44_ll_ICHEC-EC-EARTH_histo', ...
                         'RegCM4_NAM-44_ll_GFDL-ESM2M_histo','RegCM4_NAM-44_ll_HadGEM2-ES_histo','RegCM4_NAM-44_ll_MPI-ESM-LR_histo'}; 
       mm=length(MODEL_LIST);      
        for mo = 1:mm   %boucle sur les modeles
              curr_model=MODEL_LIST(mo) ;
              curr_path=PATHM(mo) ;
            % lecture du fichier anomalie
            FichierIn = char ( strcat(main_dir,curr_path,'\',char(var1),'\TENDANCES_SEN_',curr_model,'_',char(var1),'_1971-2000_',char(mois),'.nc') );  
                [InArr, LatArr, LonArr] = read_netcdf(FichierIn);        
           if (strcmp(curr_model,'CANRCM4_NAM-44_ll_CanESM2_historical')==1) 
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest+360; LonEast+360; LonEast+360; LonWest+360; LonWest+360; LonWest+360]; 
           else
              LatLimits = [LatSouth; LatSouth; LatNorth; LatNorth; LatSouth; LatNorth];
              LonLimits = [LonWest; LonEast; LonEast; LonWest; LonWest; LonWest];                
           end
 
            [IN] = inpolygon(LatArr,LonArr, LatLimits, LonLimits); 
            [row,col] = find(IN == 1); 
            NoCell = length([row,col]); 

                      for icell = 1:NoCell
                          tmp1(icell) = squeeze( InArr(row(icell),col(icell)));                               
                      end
                           eval(['mat1',num2str(mo) '  = tmp1;']);                     
                    clear tmp1 
                   clear row col InArr 
         end   %fin de la boucle sur les modeles 
                 
        for j=1:(mm)
            eval(['vec1_mod(',num2str(j),')= length(mat1',num2str(j),');'])
        end
         max_mat1 = max(vec1_mod)+1 ;
        
         clear vec1_mod vec2_mod vec3_mod
         mat11=mat11';
         mat12=mat12';
         mat13=mat13';
         mat14=mat14';
         mat15=mat15';
         mat16=mat16';
         mat17=mat17';
         mat18=mat18';
         mat19=mat19';
     
         for l=1:mm
            eval(['mat_1',num2str(l),'=[mat1',num2str(l),';NaN(max_mat1-length(mat1',num2str(l),'),1)];'])
            eval(['histo_fin(:,',num2str(l),')=mat_1',num2str(l),'(1:end-1,:);'])          
         end
         for l=1:mm
            eval(['clear mat1',num2str(l)]);
            eval(['clear mat_1',num2str(l)]);
         end        
           csvwrite(strcat(out_dir,char(domaine),'_Tendances_MONTH_HISTO_',char(var1),'_1971-2000_',char(mois),'.csv'),histo_fin)
         clear histo_fin

    end 
end
 






