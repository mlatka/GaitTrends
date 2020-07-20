clc, clear, close all

% This script loads surrogate data and calculates coefficient 
% of variation (COV) for: gait parameters (SL/ST/SS), 
% trend speed, and speed control.

% Before running the script,  please set: type of surrogates  
 % (1 - independent, 2 - cross-correlated, 3 - shuffled).
 
% Script generates boxplots of trend speed control and COV
% of: trend speed, SL, ST, and SS for each treadmill speed.
surrogates_type = 1;


if(surrogates_type < 1 || surrogates_type > 3)
    error('Error. surrogates_type must be an integer between 1 and 3.')
end

COV_trend_speed_cell = {};
COV_SL = {};
COV_ST = {};
COV_SS = {};
speed_control = {};

for i = 1 : 5 % 1-5 SPD
    
	COV_trend_speed_vec = [];
	COV_SL_vec = [];
	COV_ST_vec = [];
	COV_SS_vec = [];
	speed_control_vec = [];
		
	% load data for given surrogates
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
	 
	for j = 1 : trialSize(2)
		
		tr_sl = data.data_surrogatesSL.trendsAll{j};
		tr_st = data.data_surrogatesST.trendsAll{j};
		sl = data.data_surrogatesSL.seriesAll{j};
		st = data.data_surrogatesST.seriesAll{j};
		ss = sl./st;
		x = 1:length(tr_sl);
        % calculate trend speed
		trendSpeed = tr_sl./tr_st; 

		% calculate COVs
		COV_SL_vec =[COV_SL_vec; 100*std(sl)/mean(sl)];
		COV_ST_vec =[COV_ST_vec; 100*std(st)/mean(st)];
		COV_SS_vec =[COV_SS_vec; 100*std(ss)/mean(ss)];
		COV_trend_speed_vec = [COV_trend_speed_vec; ...
			100*std(trendSpeed)/mean(trendSpeed)];

		% calculate speed control
        speed_control_vec = [speed_control_vec; sum((trendSpeed-mean(ss)).^2)/...
			sum((ss-mean(ss)).^2)];
			
	end

	COV_trend_speed_cell{end+1} = COV_trend_speed_vec;
	COV_SL{end+1} = COV_SL_vec;
	COV_ST{end+1} = COV_ST_vec;
	COV_SS{end+1} = COV_SS_vec;
	speed_control{end+1} = speed_control_vec;
		
end

% visualize data
ind = [5, 3, 1, 2, 4];
dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; speed_control{ind(l)}];
    group = [group; l*ones(size(speed_control{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('trend speed control');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});

dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; COV_trend_speed_cell{ind(l)}];
    group = [group; l*ones(size(COV_trend_speed_cell{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('COV trend speed [%]');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});

dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; COV_SL{ind(l)}];
    group = [group; l*ones(size(COV_SL{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('COV SL [%]');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});


dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; COV_ST{ind(l)}];
    group = [group; l*ones(size(COV_ST{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('COV ST [%]');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});

dat = [];
group = [];

for l = 1 : length(ind)
    dat = [dat; COV_SS{ind(l)}];
    group = [group; l*ones(size(COV_SS{ind(l)}))];
end
figure;
boxplot(dat,group);
xlabel('treadmill speed [%PWS]');
ylabel('COV SS [%]');
title(strcat(ver,' surrogates'));
set(gca,'XTickLabel',{'80','90','100','110','120'});
