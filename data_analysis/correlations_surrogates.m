clc, clear, close all

% This script loads surrogate data and calculates Pearson's 
% correlation coefficients between ST and SL for: original, 
% trend, and residuals (noise) series for each treadmill speed.

% Script generates boxplots of Pearson's correlation coefficients 
% between ST and SL trends for each treadmill speed.

% Before running the script,  please set: type of surrogates  
% (cross-correlated true, independent = false).
cross_correlated = true;

addpath('../data/surrogates/');
corr_cell = {};

for i = 1 : 5
    
	corrMatrix = [];

    % load data for given surrogates
	if(cross_correlated)
		dir = '../data/surrogates/cross_correlated/';
		data = load(strcat(dir,'cross_correlated_surrogates_SPD',num2str(i),'.mat'));
		ver = 'cross-correlated';
    else
        dir = '../data/surrogates/independent/'; 
		data = load(strcat(dir,'independent_surrogates_SPD',num2str(i),'.mat'));
		ver = 'independent';
	end

	% loading SL data
	SLdata = data.data_surrogatesSL;
	% loading ST data
	STdata = data.data_surrogatesST;

	s = size(SLdata.residualsAll);


	for j = 1 : s(2)
		
		corrRow = [];

		% original series
		orgST = STdata.seriesAll{j};
		orgSL = SLdata.seriesAll{j};
		
        % correlation coefficient and p-value for original series
		[rhoOrg, pOrg] = corr(orgST,orgSL,'type','Pearson');
			
		% trend series
		trST = STdata.trendsAll{j};
		trSL = SLdata.trendsAll{j};
		
        % correlation coefficient and p-value for trend series
		[rhoTr, pTr] = corr(trST,trSL,'type','Pearson');
		 
		% residuals series
		resST = STdata.residualsAll{j};
		resSL = SLdata.residualsAll{j};
		
         % correlation coefficient and p-value for residuals series
		[rhoRes, pRes] = corr(resST,resSL,'type','Pearson');  
		 
		corrRow =  [rhoOrg pOrg rhoTr pTr rhoRes pRes];     
		corrMatrix = [corrMatrix; corrRow]; 
		
	end % end j loop

	corr_cell{end+1} = corrMatrix;

end % end i loop

% visualize results for trends
ind = [5, 3, 1, 2, 4];
dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; corr_cell{ind(l)}(:,3)];
    group = [group; l*ones(size(corr_cell{ind(l)}(:,3)))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('trend correlation coefficient');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});

