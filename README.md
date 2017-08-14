# Origin of Urban Productivity Scaling Laws
This is the code and data repository for the “Origin of urban productivity scaling laws”. 
The code is written in Matlab. Last successful ran using Matlab version 2016a in August 2017. 
Authored by Vicky Chuqiao Yang, Last updated August 2017. 

The main script - “main_fit_parameters_plot_fit.m”
This script runs the optimization routine to fit the 3 parameters as specified in the paper. The parameters s and alpha are fitted across all crime data sets, while a multiplicative factor is fitted individually for each. 

Data input - 
The script takes one of  “np_block_chicago.mat” and “np_block_national.mat” as input for the number of co-offending group size, based on the Chicago Police Department dataset, or the US National Incidence Based Report dataset, respectively. 

The script also takes the “crime_total_incident.mat” file as input. This file stores data of the MSA population and the number of total incidences of seven types of crimes. In order: 'Murder', 'Rape', 'Robbery', ‘Agg. Assault', 'Burglary', 'Larceny', ‘Motor Vehicle Theft’. 



