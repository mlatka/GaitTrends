clc, clear, close all

% This script generates Fractal Brownian Motion series with specific
% Hurst exponent (parameter alpha)and calculates scaling exponent values 
% using four methods (DFA1-3 and madogram) for various window lengths.
% It takes some time (ca. 15 min.) to complete computations.

% Before running the script, please set: Hurst exponent (alpha).
% By default the variable saveResults is set to true 
% so that the outcomes are saved to MAT-file.
% Please ensure that you have added WFDB Toolbox folder (in libs/ folder) 
% to MATLAB path.
alpha = 0.75;
saveResults = true;


outputDir = '../data/window_length_dependence/';
window_lengths = 40:20:260;
alpha_matrix = [];

parfor i = 1 : 500
    
    % generate series using WFBM Toolbox
    series = diff(wfbm(alpha,260));
    
    for w = 1 : length(window_lengths)
        
        n = floor(length(series)/window_lengths(w));
        chunks = reshape(series(1:n*window_lengths(w)), [], n);

        sc = size(chunks);
        
        % calculate exponents for chunks
        for c = 1 : sc(2)
             
             Hrow = [];
             fragment = chunks(:,c);
             
            if(length(fragment) > 1)
                 
                % DFA1
                [ln,lf] = dfa(fragment,1);
                fit = polyfit(ln,lf,1);
                H1 = fit(1);
                % DFA2
                [ln,lf] = dfa(fragment,2);
                fit = polyfit(ln,lf,1);
                H2 = fit(1);
                % DFA3
                [ln,lf] = dfa(fragment,3);
                fit = polyfit(ln,lf,1);
                H3 = fit(1);  
                % MAD
                H_MD = variogram(cumsum(fragment),1);
                 
                row =  [H1 H2 H3 H_MD window_lengths(w) i];
                alpha_matrix = [alpha_matrix; row];
  
            end % end if
             
         end % end for c (chunks)
        
        
    end % end for w (windows)
    
    
end % end for i (subjects)

% save results (optional)
if(saveResults)
    file = strcat(outputDir,'fbm_',num2str(alpha),'_alphas_windowed.mat');
    save(file,'alpha_matrix');
    disp(strcat('Data saved to: ',file));
end

% visualize results
labels = {'{\alpha}^(^1^)','{\alpha}^(^2^)','{\alpha}^(^3^)', ...
    '{\alpha}^(^M^D^)'};

window_lengths = 40:20:300;

for col = 1:4 % 1 - alpha1, 2 - alpha2, 3 - alpha3

    dataBoxplot = [];
    groups = [];
    
    for w = 1 : length(window_lengths)

        wl = window_lengths(w);
        ind = find(alpha_matrix(:,5) == wl);
        selectedWindow = alpha_matrix(ind,col);
        dataBoxplot = [dataBoxplot; selectedWindow];
        groups = [groups; wl*ones(size(selectedWindow))];


    end
    
    figure;
    boxplot(dataBoxplot,groups);
    title(labels{col});
    xlabel('window length');
    ylabel('scaling exponent');

end


