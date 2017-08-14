function [ err ] = err_outer_5(x)
global data_cell n_crimes np_block x_scale n_years
% find fit error for all datasets in attempt 5
% x = [Ns_unscaled, alpha_unscaled]

if x(1)<0  || x(2) < 0
    err = 1e10;
    
else
    
    x_real = x.*x_scale; % scale back Ns and alphs
    if x_real(2)< 0 % force alpha < 0.5 if changed to 0.5
        err = 1e10;
    else
        
        err_outer = zeros(n_years, n_crimes);
        
        for k = 1:n_years
            for id = 1:n_crimes
                N = data_cell{k, id}(:,1);
                u = find_u_gam(x_real, N);
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
end

