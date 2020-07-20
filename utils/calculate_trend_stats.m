function [trendDurations, trendSlopes] = ...
    calculate_trend_stats(data,subjectIndex)
% calculate_trend_stats.m determines subject's trend stats 
% (durations and slopes)for a given gait parameter 
% at specific treadmill speed.
% Inputs:
% data: struct representing prepared gait data
% subjectIndex: number representing index of the subject in data struct
% cells
% 
% Outputs:
% trendDurations: vector containing durations of trends
% trendSlopes: vector containing slopes of trends

% knot indices
kia = data.knotIndicesAll{subjectIndex};

% checking if there are knots
if ~isempty(kia)
    
    vaka = data.valuesAtKnotAll{subjectIndex};

    % removing duplicates (indices)
    [~, ind] = unique(kia);

    knotInd = kia(ind);

    if(iscell(data.timestampsAll{subjectIndex}))
        timeSeries = cell2mat(data.timestampsAll{subjectIndex});
    else
        timeSeries = data.timestampsAll{subjectIndex};  
    end
    
    series = data.seriesAll{subjectIndex};

    knotSites = timeSeries(knotInd);

    % calculating time series
    STSeries = inverseCumsum(timeSeries);

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

else % no knots

    trendDurations = []; 
    trendSlopes = [];
    valuesAtKnot = [];
    
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

