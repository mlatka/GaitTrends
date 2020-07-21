% =========================================================================
% This script loads surrogate data created by prepared_surrogates.m.
% Then it calculates the normalized trend durations and normalized trend
% slopes for every speed (SPD).
% Before running the script, please set attribute 
% (SL/ST/SS) and type of surrogates (cross_correlated true, 
% independent = false). By default the variable saveResults 
% is set to true so that the results are saved to MAT-file.
% =========================================================================

% GaitTrends: 
% Authors: Klaudia Kozlowska (Klaudia.Kozlowska@pwr.edu.pl)
%          Miroslaw Latka    (Miroslaw.Latka@pwr.edu.pl)
% URL: https://github.com/mlatka/GaitTrends.git
%
% Copyright (C) 2020  Klaudia Kozlowska and Miroslaw Latka
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
% <http://www.gnu.org/licenses/>.

% =========================================================================
% Last update: July 21, 2020
% =========================================================================

% Citing the GaitTrends:
% https://doi.org/10.1101/677948

% =========================================================================


clc, clear, close all
cross_correlated = false;
saveResults = true;

addpath('../utils/');
addpath('../data/surrogates/');

if(cross_correlated)
     dir = '../data/surrogates/cross_correlated/';
     fileNamesCell = {'cross_correlated_surrogates_SPD1.mat',...
    'cross_correlated_surrogates_SPD2.mat',...
    'cross_correlated_surrogates_SPD3.mat',...
    'cross_correlated_surrogates_SPD4.mat',...
    'cross_correlated_surrogates_SPD5.mat'};
    ver = 'cross-correlated';
else
    dir = '../data/surrogates/independent/';
    fileNamesCell = {'independent_surrogates_SPD1.mat',...
    'independent_surrogates_SPD2.mat',...
    'independent_surrogates_SPD3.mat',...
    'independent_surrogates_SPD4.mat',...
    'independent_surrogates_SPD5.mat'};
    ver = 'independent';
end

s = size(fileNamesCell);
trend_durationsSL_cell = {};
trend_slopesSL_cell = {};
trend_durSL_fig = [];

trend_durationsST_cell = {};
trend_slopesST_cell = {};
trend_durST_fig = [];

for i = 1 : s(2)
      
	data = load(strcat(dir,fileNamesCell{i}));

	trialSize = size(data.data_surrogatesSL.residualsAll);
	trendSL_dur = [];
	trendSL_slo = [];

	trendST_dur = [];
	trendST_slo = [];

	for j = 1 : trialSize(2)

		% calculate stats for SL trends
        [trendDurationsSL, trendSlopesSL] = ...
			calculate_trend_stats(data.data_surrogatesSL,j);
        % calculate stats for ST trends
		[trendDurationsST, trendSlopesST] = ...
			calculate_trend_stats(data.data_surrogatesST,j);

		trendSL_dur = [trendSL_dur; trendDurationsSL];
		trendSL_slo = [trendSL_slo; trendSlopesSL];
		trend_durSL_fig =[trend_durSL_fig;trendSL_dur];

		trendST_dur = [trendST_dur; trendDurationsST];
		trendST_slo = [trendST_slo; trendSlopesST];
		trend_durST_fig =[trend_durST_fig;trendST_dur];

	end 

	trend_durationsSL_cell{end+1} = trendSL_dur;
	trend_slopesSL_cell{end+1} = trendSL_slo;

	trend_durationsST_cell{end+1} = trendST_dur;
	trend_slopesST_cell{end+1} = trendST_slo;

end 

% save results (optional)
if(saveResults)
    file = strcat('../data/trend_stats/trends_',ver,'_surrogates.mat');
    save(file,'trend_durationsSL_cell','trend_slopesSL_cell', ...
         'trend_durationsST_cell', 'trend_slopesST_cell');
     disp(strcat('Data saved to: ',file));
end

% visualize results
figure;
histogram(trend_durSL_fig,30);
xlabel('normalized trend duration [s]');
ylabel('pdf');
title(strcat(ver,' surrogates ST'));

figure;
histogram(trend_durST_fig,30);
xlabel('normalized trend duration [s]');
ylabel('pdf');
title(strcat(ver,' surrogates SL'));

