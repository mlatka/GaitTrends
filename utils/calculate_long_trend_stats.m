function [trendDurationsLong, trendSlopesLong] = ...
    calculate_long_trend_stats(data,subjectIndex,tresh)

% calculate_long_trend_stats.m determines subject's trend stats 
% (durations and slopes)for a given gait parameter 
% at specific treadmill speed only for trends lasting over
% selected treshold.
% Inputs:
% data: struct representing prepared gait data
% subjectIndex: number representing index of the subject in data struct
% cells
% 
% Outputs:
% trendDurationsLong: vector containing durations of trends
% trendSlopesLong: vector containing slopes of trends

% knot indices
kia = data.knotIndicesAll{subjectIndex};

trendDurationsLong = [];
trendSlopesLong = [];

% checking if there are knots
if ~isempty(kia)
    vaka = data.valuesAtKnotAll{subjectIndex};

    % removing duplicates (indices)
    [~, ind] = unique(kia);

    knotInd = kia(ind);
    timeSeries = data.timestampsAll{subjectIndex};
    series = data.seriesAll{subjectIndex};
    trendSeries = data.trendsAll{subjectIndex};
    knotSites = timeSeries(knotInd);

    % calculating time series
    STSeries = inverseCumsum(data.timestampsAll{subjectIndex});

    % calculating trend durations
    trendDurations = diff(knotSites)/mean(STSeries);

    valuesAtKnot = vaka(ind);

    trendSlopes = [];

    % calculating trend slopes
    for i = 1 : length(trendDurations)
        trendSlopes = [trendSlopes; 
            (valuesAtKnot(i+1)-valuesAtKnot(i))/...
            (mean(data.seriesAll{subjectIndex})*trendDurations(i))];
    end

    locs = [];

    % finding long trends
    for i = 1 : length(trendDurations)    
        if(trendDurations(i) > tresh && abs(trendSlopes(i)) < 0.001)
            locs = [locs; i];      
        end    
    end

    if (length(locs) > 0)

        trendDurationsLong = trendDurations(locs);
        trendSlopesLong = trendSlopes(locs);

        for l = 1 : length(locs)  

            timeFragment = timeSeries(knotInd(locs(l)):knotInd(locs(l)+1));
            seriesFragment = series(knotInd(locs(l)):knotInd(locs(l)+1));

        end

    end
    
else % no knots

            trendDurations = []; 
            trendSlopes = [];
            valuesAtKnot = [];
            trendDurationsLong = [];
            trendSlopesLong = [];   
            
end


end

function [z] = inverseCumsum(a)
% inverseCumsum.m determines
% Inputs:
% a: vector containing time series
% 
% Outputs:
% z: vector containing stride times (ST)

z = diff(a);

end
