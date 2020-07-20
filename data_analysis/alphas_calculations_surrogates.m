clc, clear, close all

% This script loads surrogate data for ST and SL
% and calculates scaling exponent values using four methods 
% (DFA1-3 and madogram) for original time series 
% and their corresponding residuals.
% The script determines whether exponents' means or medians
% are statistically lower than 0.5. 

% This script calculates scaling exponents using various 
% methods (DFA1-3 and madogram) for surrogates. 
% The script determines which exponent are statistically lower than 0.5.
% Script generates boxplots of madogram scaling exponents for each
% treadmill speed and each gait parameter.

% Before running the script,  please set attribute (SL/ST/SS) and
% type of surrogates (1 - independent, 2 - cross-correlated, 3 - shuffled).
% Please ensure that you have added WFDB Toolbox folder 
% (in libs/ folder) to MATLAB path.

% 1 - independent, 2 - cross-correlated, 3 - shuffled
surrogates_type = 1;

addpath('../utils/');

if(surrogates_type < 1 || surrogates_type > 3)
    error('Error. surrogates_type must be an integer between 1 and 3.')
end


alphasST_cell = {};
alphasSL_cell = {};
alphasSS_cell = {};

for i = 1 : 5 % 1-5 SPD
    
	switch surrogates_type
		case 1
			dir = '../data/surrogates/independent/'; 
			data = load(strcat(dir,'independent_surrogates_SPD',num2str(i),'.mat'));
			ver = 'independent';
		case 2
			dir = '../data/surrogates/cross_correlated/';
			data = load(strcat(dir,'cross_correlated_surrogates_SPD',num2str(i),'.mat'));
			ver = 'cross-correlated';
		case 3
			dir = '../data/surrogates/shuffled/';
			data = load(strcat(dir,'shuffled_surrogates_SPD',num2str(i),'.mat'));
			ver = 'shuffled';
		otherwise
			error('Error. Attribute must be value between 1 and 3.')
	end

	trialSize = size(data.data_surrogatesSL.seriesAll);
	alphas_ST = [];
	alphas_SL = [];
	alphas_SS = [];

	for j = 1 : trialSize(2)
		
		% load SL, ST, SS
        sl = data.data_surrogatesSL.seriesAll{j};
		st = data.data_surrogatesST.seriesAll{j};
		ss = sl./st;
			
		% calculate scaling exponent using madogram
		H_MDsl = variogram(cumsum(sl-mean(sl)),1);
		H_MDst = variogram(cumsum(st-mean(st)),1);
		H_MDss = variogram(cumsum(ss-mean(ss)),1);


		alphas_SL = [alphas_SL; H_MDsl];
		alphas_ST = [alphas_ST; H_MDst];
		alphas_SS = [alphas_SS; H_MDss];

	end % end j loop

alphasST_cell{end+1} = alphas_ST;
alphasSL_cell{end+1} = alphas_SL;
alphasSS_cell{end+1} = alphas_SS;

end % end i loop

% visualize results
ind = [5, 3, 1, 2, 4];
dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; alphasSL_cell{ind(l)}];
    group = [group; l*ones(size(alphasSL_cell{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('{\alpha}^(^M^D^ for SL');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});


dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; alphasST_cell{ind(l)}];
    group = [group; l*ones(size(alphasST_cell{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('{\alpha}^(^M^D^) for ST');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});


dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; alphasSS_cell{ind(l)}];
    group = [group; l*ones(size(alphasSS_cell{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('{\alpha}^(^M^D^) for SS');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});

