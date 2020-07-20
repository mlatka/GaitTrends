%% single file
clc, clear, close all

% This script visualizes relationship between madoogram scaling 
% exponent values and window lengths.

% Before running the script, please set fileName. For example,
% 'dingwell_alphas_windowed_Ln_SPD1.mat' performs calculations for
% SL at 100%PWS whereas 'fbm_0.4_alphas_windowed.mat' for Fractional
% Brownian Motion with Hurst exponent equal to 0.4.

fileName = 'dingwell_alphas_windowed_Ln_SPD1.mat';
% fileName = 'fbm_0.4_alphas_windowed.mat';
% fileName = 'fbm_0.75_alphas_windowed.mat';


addpath('../data/window_length_dependence');
labels = {'{\alpha}^(^1^)','{\alpha}^(^2^)','{\alpha}^(^3^)', ...
    '{\alpha}^(^M^D^)'};
dataBoxplot = [];
groups = [];
% load data
data = load(fileName);

for col = 1 : 4 % 1 - alpha1, 2 - alpha2, 3 - alpha3, 4 - alphaMD

	window_lengths = 40:20:260;

	for w = 1 : length(window_lengths)
		
		wl = window_lengths(w);
		ind = find(data.alpha_matrix(:,5) == wl);
		selectedWindow = data.alpha_matrix(ind,col);
		dataBoxplot = [dataBoxplot; selectedWindow];
		groups = [groups; wl*ones(size(selectedWindow))];

	end

	figure;
	boxplot(dataBoxplot,groups);
	title(labels{col});
	xlabel('window length');
	ylabel('scaling exponent');

end