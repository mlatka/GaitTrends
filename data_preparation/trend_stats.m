clc, clear, close all

% This script loads postprocessed Dingwell’s data
% and calculates normalized trend durations 
% and normalized trend slopes for every speed (SPD).
% Furthermore, script calculates the same parameters
% for long trends (lasting abovegiven treshold).

% % Before running the script, please set attribute 
% (SL/ST/SS), treshold for long trends. By default the variable 
% saveResults is set to true so that the outcomes are saved to MAT-file.
attributeNumber = 1; % 1 - SL, 2 - ST
saveResults = true;
tresh = 40;

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
            calculate_long_trend_stats(data,j,tresh);

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


