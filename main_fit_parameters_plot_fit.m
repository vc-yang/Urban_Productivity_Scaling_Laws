clear all; clc; 
% find scaling from avg number of partners needed
% fit treat each year as separate dataset. 


global x_scale data_cell np_block n_crimes c n_years  whichNorm

% ----- parameters -------- 
run_optimize = 0;  % whether run optimization routine. if 0, use the initial guess as best parameter
xbest = [ 2.63e+06, 0.93]; % initial guess for best fitting [s, alpha]
x_scale = [1e4, 0.01]; % scaling to put s and alpha on the same order
x0 = xbest./x_scale; 


np_source = 'national';  % data source for number of partners. 'national' or 'chicago'
whichNorm = 1; % specify 1 or 2 norm to minimize to find the best fit. 

crimelist = {'Murder', 'Rape', 'Robbery', 'Assault',...
    'Burglary', 'Larceny', 'Vehicle'}; % list of crimes in data

i_plot = 3; % id of data to plot. The name of the crime is crimelist{i_plot}
yr = 14; % year to plot, where 1 = 1999, the actual year is 1998 - yr. 


OS = 'PC'; 





%%----- load crime data ---- 


%%--- load number of co-offending partners data ----- 
if strcmp(np_source, 'chicago') == 1
load('np_block_chicago.mat')
elseif strcmp(np_source, 'national') == 1
load('np_block_national.mat')
end
%%---- Load crime instance data----- 
load('crime_total_incident.mat')
% each crime is saved as a cell

c = crime;
n_crimes = 7; % total 7 crimes
n_years = length(c); 


%% clean data
data_cell = cell(length(c), n_crimes); 
% data structure:cell 
% yr1, crime1 | yr1, crime 2 | .... 
% in each cell, N | crime


%% 
for k = 1:length(c)
% re-organize cell format, so that each cell is pop | crime
    for id = 1:n_crimes
        [N_temp, y_temp] = clean(c{k}(:,1), c{k}(:,id+1));  
        
        data_cell{k, id} = [N_temp,y_temp]; 
    end
end


%% optimization

if run_optimize ==1
    
disp('start optimization')
[x, fval, exitflag] = fminsearch(@err_outer_5, x0, optimset('TolFun', 0.0001));
if exitflag == 0
    disp('large optimization does not converge')
end

x_real = x.*x_scale;
str0 = sprintf('%d, Ns = %d, alpha = %0.2f,fval = %0.3f', exitflag,x_real(1),x_real(2), fval); 
disp(str0)

end

%% plot the data

linear_discount = 5*10^3; % discount y axis in linear plot

if run_optimize ==0 
    x_real = xbest;
end

id = i_plot; 
% fit s again
N = data_cell{yr, id}(:,1);
u = find_u_gam(x_real, N );
N_tot = N.^(1-0.12).*u.^np_block(yr, id);
s0 = mean(data_cell{yr,id}(:,2))/mean(N_tot);

[s, sval, exitflag_s] = fminsearch(@scale_err , s0, optimset('TolFun', 0.001), N_tot, data_cell{yr,id}(:,2));

% The theory line
N_theory = logspace(log10(min(N))-0.2, log10(max(N))+0.2, 40)'; 
u = find_u_gam(x_real, N_theory);
N_tot2 = N_theory.^(1 - 0.12).*u.^np_block(yr, id);

y_theory = s*N_tot2; 

figure()
loglog(N, data_cell{yr,id}(:,2), 'bo', 'linewidth', 1);
hold on 
loglog(N_theory, y_theory, 'r-','linewidth', 2);
loglog(N_theory, N_theory/linear_discount, 'k--','linewidth', 2);
% loglog(N, s*N_tot, 'r-','linewidth', 2); 
hold off
xlabel('City population','fontsize', 16)
ylabel('Number of crimes','fontsize', 16)
str1 = crimelist{id};
title(crimelist{id})
leg2 =sprintf('Model, np = %0.2f',np_block(yr, id));
leg1 = sprintf('data (%d)', yr + 1998); 
legend(leg1, leg2, 'Linear scaling')
set(gca,'fontsize', 16)
set(gca,'linewidth', 2)

