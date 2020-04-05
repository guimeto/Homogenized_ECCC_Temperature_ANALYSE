# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 14:32:51 2020

@author: guillaume
"""
#for Netcdf manipulation
import xarray as xr

#for array manipulation
import numpy as np
import pandas as pd

#for plotting

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib
import matplotlib.pylab as plt

import warnings
warnings.filterwarnings("ignore")
variable = 'Tasmax'
indice = 'MOY'

start_year = '1970'
end_year = '2019'
path_in = 'K:/DATA/Donnees_Stations/2nd_generation_V2019/INDICES/INDICES_MONTH/TENDANCES/'+variable.lower()+'/'+indice+'/'
path_out = 'K:/DATA/Donnees_Stations/2nd_generation_V2019/figures/MONTH/Tmax'

list_mon = ['01','02','03','04','05','06','07','08','09','10','11','12']
for month in list_mon:
    file = path_in + 'INDICES_'+indice+'_'+variable+'_'+month+'_CANADA_'+start_year+'_'+end_year+'_90p.dat'
    # Lecture du fichier
    df = pd.read_table(file, header=None, delim_whitespace=True)
    df.columns = ['Station_ID','latitude','longitude','trend']
    
    fig=plt.figure(figsize=(28,16), frameon=True) 
    ax = plt.subplot(111, projection=ccrs.LambertConformal())
    ax.set_extent([-140,-50,32,82])
    
     #ax.coastlines(resolution='110m');
    ax.add_feature(cfeature.OCEAN.with_scale('50m'))      # couche ocean
    ax.add_feature(cfeature.LAND.with_scale('50m'))       # couche land
    ax.add_feature(cfeature.LAKES.with_scale('50m'))      # couche lac
      
    ax.add_feature(cfeature.BORDERS.with_scale('50m'))    # couche frontieres
    ax.add_feature(cfeature.RIVERS.with_scale('50m'))     # couche rivières
    coast = cfeature.NaturalEarthFeature(category='physical', scale='10m',     # ajout de la couche cotière
                                facecolor='none', name='coastline')
    ax.add_feature(coast, edgecolor='black')   
    states_provinces = cfeature.NaturalEarthFeature(
                category='cultural',
                name='admin_1_states_provinces_lines',
                scale='10m',
                facecolor='none')
       
    ax.add_feature(states_provinces, edgecolor='gray')
    
    cmap = plt.cm.jet  # define the colormap
    norm = matplotlib.colors.BoundaryNorm(np.arange(-1,1,0.2), cmap.N)
    
    # Plots the data onto map
    plt.scatter(df['longitude'][(df['trend'] > 0)], 
                df['latitude'][(df['trend'] > 0)],
                alpha=1.,
                s=800, label="Tmax Treand",
                c=df['trend'][(df['trend'] > 0)],
                vmin=-1,
                vmax=1,
                cmap=plt.get_cmap("jet"),
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="^")
    
    plt.scatter(df['longitude'][(df['trend'] < 0)], 
                df['latitude'][(df['trend'] < 0)],
                alpha=1.,
                s=800, label="Tmax Treand",
                c=df['trend'][(df['trend'] < 0)],
                vmin=-1,
                vmax=1,
                cmap=plt.get_cmap("jet"),
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="v")
           
    ax.gridlines()
    cbar = plt.colorbar()
    string_title=u'Tendances de Mann Kendall sur les anomalies standardisées \n des moyennes mensuelles de Tmax [significatives à 90%]\n'
    ticklabs = cbar.ax.get_yticklabels()
    cbar.ax.set_yticklabels(ticklabs, fontsize=30)
    
    plt.title(string_title, size='xx-large', fontsize=30)
    plt.savefig(path_out+'/Tendances_'+indice+'_'+variable+'_'+month+'_CANADA_'+start_year+'_'+end_year+'_90p.png', bbox_inches='tight', pad_inches=0.1)
    plt.close()
