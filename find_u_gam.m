function [ u ] = find_u_gam( x, N_in )
% find number of unique individual interacted via the gamma fun
% x = [s, alpha] s = number of interactions made
% N_in, population vector input
s = x(1);
alpha = x(2);

u = 0*N_in; 

for i = 1:length(N_in)
    N  = N_in(i); 
    m = (alpha - 1)/(1 -N.^(1-alpha));
    prefac = (s*m)^(1/alpha)/alpha; 
    % the gamma function arguments between maple and mathematica is
    % backwards... 
    % maple's gamma(a, z) is teh upper incomplete gamma in matlab. Matlab
    % also has an extra 1/gamma(a) infront... 
    
    z = m*N^(-alpha)*s;
    a = -1/alpha;
    
    gam = gamma_incomplete(z,a); 
    % downloaded the gamma function file from 
    % file exchange. Tested with a few value, 
    % give same results as maple. 

    u(i) = N - prefac*gam;

end


end

