# -*- coding: utf-8 -*-
"""
Created on Thu May  2 09:59:07 2019

@author: guillaume
"""
import pandas as pd
import os
from datetime import date
import calendar
import numpy as np
import Indices_Temperatures
from dateutil.relativedelta import relativedelta

yearmin = 1948
yearmax = 2018
### lecture de toutes les stations d'ECCC pour la température
dataframe = pd.read_excel("./Temperature_Stations.xls", skiprows = range(0, 3))

### on va filtrer les données ayant pour période commune: 1948 - 2018

globals()['dataframe_'+str(yearmin)+'_'+str(yearmax)] = dataframe.loc[(dataframe["année déb."] <= yearmin) & (dataframe["année fin."] >= yearmax),:]
## boucle sur chaque station et extraction des séries quotidiennes
names = []
for i, row in globals()['dataframe_'+str(yearmin)+'_'+str(yearmax)].iterrows():
   stnid = row['stnid']
   
   f1 = open('./Homog_daily_min_temp_v2018/dn'+str(stnid)+'.txt', 'r')
   f2 = open('./tmp.txt', 'w')
  

   for line in f1:
        for word in line:
            if word == 'M':
                f2.write(word.replace('M', ' '))
            elif word == 'a':
                f2.write(word.replace('a', ' '))                    
            else:
                f2.write(word)
   f1.close()
   f2.close()
          
   station = pd.read_csv('./tmp.txt', delim_whitespace=True, skiprows = range(0, 4))
   
   station.columns = ['Annee', 'Mois', 'D1','D2','D3','D4','D5','D6','D7','D8','D9','D10',
                                  'D11','D12','D13','D14','D15','D16','D17','D18','D19','D20',
                                  'D21','D22','D23','D24','D25','D26','D27','D28','D29','D30','D31']
     
   os.remove("./tmp.txt")
   
   try:  
       station = station.replace({'E':''}, regex=True)
   except:
       pass
   try: 
       station = station.replace({'a':''}, regex=True)
   except:
       pass
   try:     
       station = station.replace({'-9999.9':''}, regex=True)
   except:
       pass
   try:     
       station = station.replace({-9999.9:''}, regex=True)
   except:
       pass    
       
   for col in  station.columns[2:]:
       station[col] = pd.to_numeric(station[col], errors='coerce')
       
   m_start =  station['Mois'].loc[(station['Annee'] == yearmin)].min()
   m_end   =  station['Mois'].loc[(station['Annee'] == yearmax)].max()
   
   d_end = calendar.monthrange(yearmax, m_end)[1]
   
####################################Extraction des données quotidiennes     
   tmp_tmin = [ ] 
   for year in range(yearmin,yearmax+1):    ### Boucle sur les annees
       for month in range(1,13):
           df = []
           last_day = calendar.monthrange(year, month)[1] 
           tmin = station.loc[(station["Annee"] == year) & (station["Mois"] == month)].iloc[:,2:last_day+2].values
           
           if len(tmin) == 0:
               a = np.empty((calendar.monthrange(year,month)[1]))
               a[:] = np.nan
               df=pd.DataFrame(a)
           else:
               df=pd.DataFrame(tmin.T)
               
           start = date(year, month, 1)
           end =   date(year, month, last_day)
           delta=(end-start) 
           nb_days = delta.days + 1 
           rng = pd.date_range(start, periods=nb_days, freq='D')          
           df['datetime'] = rng
           df.index = df['datetime']
           tmp_tmin.append(df)
           
   tmp_tmin = pd.concat(tmp_tmin) 
   df = pd.DataFrame({'datetime': tmp_tmin['datetime'], 'Tmin': tmp_tmin.iloc[:,0]}, columns = ['datetime','Tmin']) 
   df.index = df['datetime']
   tmp_tmin = tmp_tmin.drop(["datetime"], axis=1)
   
#################################### Calcul des indices mensuels   
   
   resamp_tmin = df.resample('M').agg([Indices_Temperatures.MOY ])
   
#################################### Calcul des indices saisonniers  
   
   djf = []
   mam = []
   son=[]
   jja=[]
   incr= date(yearmin, 1, 1)
   end = date(yearmax, 12, 31)
   while incr <= end:
        current_year = str(incr.year)
        print(current_year)
        last_year = str(incr.year-1)
        try:
            dec = df[last_year][np.in1d(df[last_year].index.month, [12])]
        except:
            rng = pd.date_range(last_year, periods=31, freq='D')
            dec = pd.DataFrame({'datetime': rng, 'Tmin': [np.nan]*31}, columns = ['datetime','Tmin']) 
            
        j_f = df[current_year][np.in1d(df[current_year].index.month, [1,2])]
           
        djf.append(Indices_Temperatures.MOY(dec.append(j_f).iloc[:,1].values))
        
        mam.append(Indices_Temperatures.MOY((df[current_year][np.in1d(df[current_year].index.month, [3,4,5])].iloc[:,1]).values))
        jja.append(Indices_Temperatures.MOY((df[current_year][np.in1d(df[current_year].index.month, [6,4,8])].iloc[:,1]).values))
        son.append(Indices_Temperatures.MOY((df[current_year][np.in1d(df[current_year].index.month, [9,10,11])].iloc[:,1]).values))
          
        incr = incr + relativedelta(years=1)
       
   TIME=[]
   for y in range(yearmin,yearmax+1,1):
        TIME.append(y) 
   df_djf = pd.DataFrame({'Date': TIME,'Moyenne DJF': djf}, columns = ['Date','Moyenne DJF']) 
   df_mam = pd.DataFrame({'Date': TIME,'Moyenne MAM': mam}, columns = ['Date','Moyenne MAM']) 
   df_jja = pd.DataFrame({'Date': TIME,'Moyenne JJA': jja}, columns = ['Date','Moyenne JJA']) 
   df_son = pd.DataFrame({'Date': TIME,'Moyenne SON': son}, columns = ['Date','Moyenne SON']) 
      
   name = row['Nom de station'].replace(' ','_')
   name = name.replace("'",'')
   names.append(name)
   tmp_tmin.to_csv('./TIME_SERIES/Tmin/'+name+'_daily_tasmin_'+str(yearmin)+'-'+str(yearmax)+'.csv')
   
   df_djf.to_csv('./INDICES_SEASON/Tasmin/MOY/'+name+'_SEASON_tasmin_MOY_'+str(yearmin)+'_'+str(yearmax)+'_DJF.csv')
   df_mam.to_csv('./INDICES_SEASON/Tasmin/MOY/'+name+'_SEASON_tasmin_MOY_'+str(yearmin)+'_'+str(yearmax)+'_MAM.csv')
   df_jja.to_csv('./INDICES_SEASON/Tasmin/MOY/'+name+'_SEASON_tasmin_MOY_'+str(yearmin)+'_'+str(yearmax)+'_JJA.csv')
   df_son.to_csv('./INDICES_SEASON/Tasmin/MOY/'+name+'_SEASON_tasmin_MOY_'+str(yearmin)+'_'+str(yearmax)+'_SON.csv') 
   for m in range(1,13):
       month_var = resamp_tmin[resamp_tmin.index.month==m]
       month_var.to_csv('./INDICES_MONTH/Tasmin/MOY/'+name+'_MONTH_tasmin_MOY_'+str(yearmin)+'_'+str(yearmax)+'_'+str("{:02}".format(m))+'.csv')
        
latlon = pd.DataFrame({'Latitude': globals()['dataframe_'+str(yearmin)+'_'+str(yearmax)]["lat (deg)"], 'Longitude': globals()['dataframe_'+str(yearmin)+'_'+str(yearmax)]["long (deg)"] }, columns = ['Latitude','Longitude']) 
latlon.to_csv('./stations_latlon_CANADA_'+str(yearmin)+'-'+str(yearmax)+'.csv')
names = pd.DataFrame(names)
names.to_csv('./stations_noms_CANADA_'+str(yearmin)+'-'+str(yearmax)+'.csv')

