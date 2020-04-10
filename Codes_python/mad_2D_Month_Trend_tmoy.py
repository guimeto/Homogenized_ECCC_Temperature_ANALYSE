# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 14:32:51 2020

@author: guillaume
"""

#for array manipulation
import numpy as np
import pandas as pd
import datetime

#for plotting

import cartopy.crs as ccrs
import cartopy.feature as cfeature
import matplotlib
import matplotlib.pylab as plt
from matplotlib.gridspec import GridSpec

import warnings
warnings.filterwarnings("ignore")
variable = 'Tasmoy'
indice = 'MOY'

start_year = '1990'
end_year = '2019'
path_in = 'K:/DATA/Donnees_Stations/2nd_generation_V2019/INDICES/INDICES_MONTH/TENDANCES_INDICES/'+variable.lower()+'/'+indice+'/'
path_std = 'K:/DATA/Donnees_Stations/2nd_generation_V2019/INDICES/INDICES_MONTH/TENDANCES_ANO_STD/'+variable.lower()+'/'+indice+'/'
path_out = 'K:/DATA/Donnees_Stations/2nd_generation_V2019/figures/MONTH/Tmoy'

def plot_background(ax):
    ax.set_extent([-140,-50,32,82])  
    ax.coastlines(resolution='110m');
    ax.add_feature(cfeature.OCEAN.with_scale('50m'))      
    ax.add_feature(cfeature.LAND.with_scale('50m'))       
    ax.add_feature(cfeature.LAKES.with_scale('50m'))     
    ax.add_feature(cfeature.BORDERS.with_scale('50m'))    
    ax.add_feature(cfeature.RIVERS.with_scale('50m'))    
    coast = cfeature.NaturalEarthFeature(category='physical', scale='10m',    
                        facecolor='none', name='coastline')
    ax.add_feature(coast, edgecolor='black')
    
    states_provinces = cfeature.NaturalEarthFeature(
        category='cultural',
        name='admin_1_states_provinces_lines',
        scale='10m',
        facecolor='none')

    ax.add_feature(states_provinces, edgecolor='gray')

   
    return ax

list_mon = ['01','02','03','04','05','06','07','08','09','10','11','12']
for month in list_mon:
    name_month = datetime.date(1900, int(month), 1).strftime('%B')
    file = path_in + 'INDICES_'+indice+'_'+variable+'_'+month+'_CANADA_'+start_year+'_'+end_year+'_90p.dat'
    # Lecture du raw
    df1 = pd.read_table(file, header=None, delim_whitespace=True)
    df1.columns = ['Station_ID','latitude','longitude','trend']
    
    file = path_std + 'INDICES_'+indice+'_'+variable+'_'+month+'_CANADA_'+start_year+'_'+end_year+'_90p.dat'
    # Lecture du STD
    df2 = pd.read_table(file, header=None, delim_whitespace=True)
    df2.columns = ['Station_ID','latitude','longitude','trend']
    
    fig=plt.figure(figsize=(30,18), frameon=True)     
    gs = GridSpec(1,4, width_ratios=[1,0.05, 1,0.05], wspace = 0.2)
    crs=ccrs.LambertConformal()
    
    # Left plot - Eanomalies standardisées
    ax1 = plt.subplot(gs[0, 0], projection=crs)
    plot_background(ax1)
    cmap = plt.cm.jet  # define the colormap
    norm = matplotlib.colors.BoundaryNorm(np.arange(-2,2.1,0.5), cmap.N)
    # Plots the data onto map
    plt.scatter(df1['longitude'][(df1['trend'] > 0)], 
                df1['latitude'][(df1['trend'] > 0)],
                alpha=1.,
                s=800, label="Tmoy Treand",
                c=df1['trend'][(df1['trend'] > 0)],
                vmin=-2,
                vmax=2,
                cmap=cmap,
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="^")
    
    mm1 =plt.scatter(df1['longitude'][(df1['trend'] < 0)], 
                df1['latitude'][(df1['trend'] < 0)],
                alpha=1.,
                s=800, label="Tmoy Treand",
                c=df1['trend'][(df1['trend'] < 0)],
                vmin=-2,
                vmax=2,
                cmap=cmap,
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="v")
    string_title=u'Tendances de Mann Kendall \n anomalies standardisées\n significatives à 90%\n'
    plt.title(string_title, size='xx-large', fontsize=30)
    
    ax = fig.add_subplot(gs[0,1])
    cbar =  plt.colorbar(mm1,  shrink=0.25, drawedges='True', ticks=np.arange(-2, 2.1, 0.5), extend='both', cax = ax)  
    ticklabs = cbar.ax.get_yticklabels()
    cbar.ax.set_yticklabels(ticklabs, fontsize=20) 
    
    # right plot - Eanomalies standardisées
    ax2 = plt.subplot(gs[0, 2], projection=crs)
    plot_background(ax2)    
    cmap = plt.cm.jet  # define the colormap
    norm = matplotlib.colors.BoundaryNorm(np.arange(-1,1.1,0.2), cmap.N)
    
    # Plots the data onto map
    plt.scatter(df2['longitude'][(df2['trend'] > 0)], 
                df2['latitude'][(df2['trend'] > 0)],
                alpha=1.,
                s=800, label="Tmoy Treand",
                c=df2['trend'][(df2['trend'] > 0)],
                vmin=-1.0,
                vmax=1.0,
                cmap=cmap,
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="^")
    
    mm= plt.scatter(df2['longitude'][(df2['trend'] < 0)], 
                df2['latitude'][(df2['trend'] < 0)],
                alpha=1.,
                s=800, label="Tmoy Treand",
                c=df2['trend'][(df2['trend'] < 0)],
                vmin=-1.0,
                vmax=1.0,
                cmap=cmap,
                norm=norm,
                transform=ccrs.PlateCarree(),
                marker="v")
    string_title=u'Tendances de Mann Kendall\n moyennes mensuelles de Tmoy [Celcius]\n significatives à 90%\n'
    plt.title(string_title, size='xx-large', fontsize=30)       
    #ax.gridlines()
    ax = fig.add_subplot(gs[0,3])
    cbar =  plt.colorbar(mm,  shrink=0.75, drawedges='True', ticks=np.arange(-1, 1.1, 0.2), extend='both', cax = ax)
    ticklabs = cbar.ax.get_yticklabels()
    cbar.ax.set_yticklabels(ticklabs, fontsize=20) 

    fig.suptitle(name_month + ': from ' + start_year+' to '+end_year, fontsize=40)
    plt.savefig(path_out+'/Tendances_'+indice+'_'+variable+'_'+month+'_CANADA_'+start_year+'_'+end_year+'_90p.png', bbox_inches='tight', pad_inches=0.1)
    plt.close()
    
