function [ B1, B2 ] = clean( A1, A2)
% clean NaN and 0's fromclean 2 pairs of data, when data 2 
% can have 0 and NaN's 

idx = find((isnan(A2) ==0)); 
B1 = A1(idx);
B2 = A2(idx);


idx = find(B2 ~= 0);
B1 = B1(idx);
B2 = B2(idx);
end

