% =========================================================================
% This script calculates normalized MARS trend durations and normalized trend 
% slopes for each treadmill speed (SPD). It also calculates these 
% two quantities for trends lasting longer that the chosen threshold. 
% The script uses MAT-files located in ..\data\mat_data folder. These input
% files must be created first by running prepare_data.m
% Change attributeNumber variable to select gait parameter (1 – SL, 2 – ST, 3 – SS). 
% The script  plots histograms of normalized trend duration
% and normalized slope of long trends.  By default, the output MAT files
% are saved in ../data/trend_stats/ folder.
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

attributeNumber = 1; % 1 - SL, 2 - ST
saveResults = true;
threshold = 40;

addpath('../utils/');
addpath('../data/mat_data/');

if(attributeNumber < 1 || attributeNumber > 2)
    error('Error. attributeNumber must be an integer between 1 and 2.')
end

switch attributeNumber
    case 1
        fileNamesCell = {'Ln_SPD1.mat','Ln_SPD2.mat',...
        'Ln_SPD3.mat','Ln_SPD4.mat',...
        'Ln_SPD5.mat'};
        param = 'SL';
    case 2
        fileNamesCell = {'Tn_SPD1.mat','Tn_SPD2.mat',...
        'Tn_SPD3.mat','Tn_SPD4.mat',...
        'Tn_SPD5.mat'};
        param = 'ST';
    otherwise
        error('Error. Attribute must be a value between 1 and 2.')
end

s = size(fileNamesCell);
trend_durations_cell = {};
trend_slopes_cell = {};
trend_dur_fig = [];

long_trend_durations_cell = {};
long_trend_slopes_cell = {};
long_slo_fig = [];

for i = 1 : s(2)
    
	data = load(fileNamesCell{i});
	trialSize = size(data.residualsAll);
	trend_dur = [];
	trend_slo = [];
	long_trend_dur = [];
	long_trend_slo = [];

	for j = 1 : trialSize(2)

		% calculate stats for trends
        [trendDurations, trendSlopes] = calculate_trend_stats(data,j);
        % calculate stats for long trends
		[longTrendDurations, longTrendSlopes] = ... 
            calculate_long_trend_stats(data,j,threshold);

		trend_dur = [trend_dur; trendDurations];
		trend_slo = [trend_slo; trendSlopes];
		trend_dur_fig =[trend_dur_fig;trend_dur];

		long_trend_dur = [long_trend_dur; longTrendDurations];
		long_trend_slo = [long_trend_slo; longTrendSlopes];
		long_slo_fig = [long_slo_fig; longTrendSlopes];

	end 

	trend_durations_cell{end+1} = trend_dur;
	trend_slopes_cell{end+1} = trend_slo;

	long_trend_durations_cell{end+1} = long_trend_dur;
	long_trend_slopes_cell{end+1} = long_trend_slo;

end 

% save results (optional)
if(saveResults)
    file = strcat('../data/trend_stats/',param,'_trends.mat');
    save(file,'trend_durations_cell','trend_slopes_cell', ...
        'long_trend_durations_cell', 'long_trend_slopes_cell');
    disp(strcat('Data saved to: ',file));
end

% visualize results
figure;
histogram(trend_dur_fig,30,'Normalization','pdf');
xlabel('normalized trend duration [s]');
ylabel('pdf');
title(strcat(param,' trends'));

figure;
histogram(long_slo_fig,30,'Normalization','pdf');
xlabel('normalized slope');
ylabel('pdf');
title(strcat(param,' long trends'));


