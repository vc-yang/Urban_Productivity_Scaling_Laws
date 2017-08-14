function [ scale_err ] = scale_err(s, N_tot, y_data)
% find best scaling, from minimizing this scaling error
global whichNorm

if s < 0
    scale_err = 1e10; 
else

    y_theory = s*N_tot; 

    if whichNorm == 1 % 1 norm
    scale_err = sum(abs(log10(y_data) - log10(y_theory))); %relative errs at each point
    elseif whichNorm == 2 % 2 norm
    scale_err = sqrt(sum((log10(y_data) - log10(y_theory)).^2));
    else 
        disp('wrong norm number! ')
    end
    
    %     weighted fit
%      weight = log10(y_data)/(sum(log10(y_data)));
%      scale_err = sum(r_err.*weight); 
    
end


end

