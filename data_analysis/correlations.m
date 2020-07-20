clc, clear, close all

% This script calculates Pearson's correlation coefficient between ST and
% SL for: original, trend, and residuals (noise) series.

% This script loads postprocessed Dingwell’s data 
% and calculates Pearson's correlation coefficients between ST and
% SL for: original, trend, and residuals (noise) series for each
% treadmill speed.

% Script generates boxplots of Pearson's correlation coefficients 
% between ST and SL trends for each treadmill speed.

addpath('../data/mat_data/');

corr_cell = {};

for i = 1 : 5
    
	% load SL data
	SLdata = load(strcat('Ln_SPD',num2str(i),'.mat'));
	% load ST data
	STdata = load(strcat('Tn_SPD',num2str(i),'.mat'));
		
	trialSize = size(SLdata.residualsAll);
	corrMatrix = [];

	for j = 1 : trialSize(2)
		
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
set(gca,'XTickLabel',{'80','90','100','110','120'});

