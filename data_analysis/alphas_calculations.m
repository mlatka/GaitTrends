clc, clear, close all

% This script loads postprocessed Dingwell’s data 
% and calculates scaling exponent values using four methods 
% (DFA1-3 and madogram) for original time series 
% and their corresponding residuals.
% The script determines whether exponents' means or medians
% are statistically lower than 0.5. 

% Before running the script,  please set attribute (SL/ST/SS).
% Please ensure that you have added WFDB Toolbox folder 
% (in libs/ folder) to MATLAB path.
attributeNumber = 1; % 1 - SL, 2 - ST, 3 - SS


addpath('../data/mat_data/');
addpath('../utils/');

switch attributeNumber
    case 1
        fileNamesCell = {'Ln_SPD1.mat','Ln_SPD2.mat',...
        'Ln_SPD3.mat','Ln_SPD4.mat',...
        'Ln_SPD5.mat'};
    case 2
        fileNamesCell = {'Tn_SPD1.mat','Tn_SPD2.mat',...
        'Tn_SPD3.mat','Tn_SPD4.mat',...
        'Tn_SPD5.mat'};
    case 3
        fileNamesCell = {'Sn_SPD1.mat','Sn_SPD2.mat',...
        'Sn_SPD3.mat','Sn_SPD4.mat',...
        'Sn_SPD5.mat'};
    otherwise
        error('Error. attributeNumber must be an integer between 1 and 3.')
end

s = size(fileNamesCell);
alphas_cell = {};

for i = 1 : s(2)
    
	% load data
    data = load(fileNamesCell{i});
	trialSize = size(data.residualsAll);
	alphas_matrix = [];

	for j = 1 : trialSize(2)
		
		% get series and residuals
        series = data.seriesAll{j};
		residuals = data.residualsAll{j};

		row = [];

		% calculate exponents for original series
		% DFA1
		[ln,lf] = dfa(series,1);
		fit = polyfit(ln,lf,1);
		H1o = fit(1);
		% DFA2
		[ln,lf] = dfa(series,2);
		fit = polyfit(ln,lf,1);
		H2o = fit(1);
		% DFA3
		[ln,lf] = dfa(series,3);
		fit = polyfit(ln,lf,1);
		H3o = fit(1);
		% madogram
		H_MDo = variogram(cumsum(series-mean(series)),1);
		 
		% calculate exponents for residuals series
		% DFA1
		[ln,lf] = dfa(residuals,1);
		fit = polyfit(ln,lf,1);
		H1d = fit(1);
		% DFA2
		[ln,lf] = dfa(residuals,2);
		fit = polyfit(ln,lf,1);
		H2d = fit(1);
		% DFA3
		[ln,lf] = dfa(residuals,3);
		fit = polyfit(ln,lf,1);
		H3d = fit(1);
		% madogram
		H_MDd = variogram(cumsum(residuals-mean(residuals)),1);

		row =  [H1o H2o H3o H_MDo H1d H2d H3d H_MDd];
			
		alphas_matrix = [alphas_matrix; row]; 

	end % end j loop

	alphas_cell{end+1} = alphas_matrix;

end % end i loop

% checking if exponents mean/median < 0.5
clc
% L denotes detrended series
alphas_labels = {'alpha1','alpha2','alpha3','alphaMD',...
        'alphaL1','alphaL2','alphaL3','alphaLMD'};
    
for SPD = 1:5

    % alphas matrix
    alphas_mat = alphas_cell{SPD};
    disp(strcat('SPD',num2str(SPD)))

    d = size(alphas_mat);
    pVec = [];

    for k = 1 : d(2)

        v = alphas_mat(:,k);

        % Shapiro-Wilk test for normality
        [hs, ps] = swtest(v);

        if hs == 0 % t-test
            [h,p] = ttest(v,0.5,'tail','left');
        else % Wilcoxon signed rank test
            [p,h] = signrank(v,0.5,'tail','left');
        end

        disp(strcat(alphas_labels{k},': H=',num2str(h),', p=',num2str(p)))

        pVec = [pVec; p];

    end

end
