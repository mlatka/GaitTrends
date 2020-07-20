function [H] = variogram(x,p)
% variogram.m computes madogram estimator for the
% scaling exponents based on paper:
% Gneiting, T., Ševèíková, H., & Percival, D. B. (2012). Estimators 
% of fractal dimension: Assessing the roughness of time series 
% and spatial data. Statistical Science, 247-277.
% 
% Inputs:
% x: vector of data series
% p: order of variogram

% 
% Outputs:
% H: scaling exponent estimate

n = length(x);


V1 = 0;
V2 = 0;

for i = 1 : n-1
    V1 = V1 + (abs(x(i+1)-x(i)))^p;
end

for i = 1 : n-2
    V2 = V2 + (abs(x(i+2)-x(i)))^p;
end

V1 = 0.5*V1/(n-1);
V2 = 0.5*V2/(n-2);

H = (1./p)* (log(V2)-log(V1))/log(2);

end

