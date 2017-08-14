function [ err ] = err_outer_fit_s(x)
global data_cell n_crimes np_block x_scale n_years alpha
% find fit error for all datasets in attempt 5
% x = s

if x <0 
    err = 1e10; 
else
        x_real = x.*x_scale; % scale back Ns and alphs
    
        err_outer = zeros(n_years, n_crimes);
        
        for k = 1:n_years
            for id = 1:n_crimes
                N = data_cell{k, id}(:,1);
                u = find_u_gam([x_real, alpha], N);
                N_tot = N.^(1-0.12).*u.^np_block(k,id);
                
                s0 = mean(data_cell{k,id}(:,2))/mean(N_tot);

                
                [s, fval, exitflag] = fminsearch(@scale_err , s0, optimset('TolFun', 0.0001), N_tot, data_cell{k,id}(:,2));
            
                err_outer(k, id) = fval;
                % normalize error, so that no crime is weighted more
                if exitflag == 0;
                    disp('Optimization didnt converge')
                end
            end
            
        end
        
        err = mean(mean(err_outer));
        
end
end

