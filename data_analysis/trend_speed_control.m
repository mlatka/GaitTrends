clc, clear, close all

% This script loads postprocessed Dingwell’s data 
% and calculates coefficient of variation (COV) for: gait
% parameters (SL/ST/SS), trend speed, and speed control.

% Script generates boxplots of trend speed control and COV
% of: trend speed, SL, ST, and SS for each treadmill speed.

addpath('../data/mat_data/');

COV_trend_speed_cell = {};
COV_SL = {};
COV_ST = {};
COV_SS = {};
speed_control = {};

for i = 1 : 5 % 1-5 SPD
    
	% load SL data
	SLdata = load(strcat('Ln_SPD',num2str(i),'.mat'));
	% load SL data
	STdata = load(strcat('Tn_SPD',num2str(i),'.mat'));
	% load SL data
	SSdata = load(strcat('Sn_SPD',num2str(i),'.mat'));

	trialSize = size(SLdata.residualsAll);
	COV_trend_speed_vec = [];
	COV_SL_vec = [];
	COV_ST_vec = [];
	COV_SS_vec = [];
	speed_control_vec = [];

	for j = 1 : trialSize(2)
		
		tr_sl = SLdata.trendsAll{j};
		tr_st = STdata.trendsAll{j};
		sl = SLdata.seriesAll{j};
		st = STdata.seriesAll{j};
		ss = SSdata.seriesAll{j};
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


	end % end j loop

	COV_trend_speed_cell{end+1} = COV_trend_speed_vec;
	COV_SL{end+1} = COV_SL_vec;
	COV_ST{end+1} = COV_ST_vec;
	COV_SS{end+1} = COV_SS_vec;
	speed_control{end+1} = speed_control_vec;


end % end i loop

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
set(gca,'XTickLabel',{'80','90','100','110','120'});

%
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
set(gca,'XTickLabel',{'80','90','100','110','120'});
