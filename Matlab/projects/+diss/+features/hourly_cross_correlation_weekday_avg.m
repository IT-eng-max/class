% This file is part of the project CLASS (https://github.com/beckel/class).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich & TU Darmstadt, 2012
% Authors: Christian Beckel (beckel@inf.ethz.ch), Leyna Sadamori (sadamori@inf.ethz.ch)

% cross correlation between weekdays - weekday average
function feature = hourly_cross_correlation_weekday_avg(consumption)
    if strcmp(consumption, 'dim') == 1
		feature = 1;
    else
        if consumption.granularity ~= 30
            error('30-minute granularity required');
        end
        
        num_weeks = length(consumption.weekly_traces);
        weekly_averages = zeros(1,num_weeks);
        for i=1:num_weeks
            trace = consumption.weekly_traces{i};
            trace = mean(reshape(trace, 2, 7*24), 1);
            tmp = cross_correlation(trace);
            weekly_averages(i) = mean(tmp(1:4));
        end
        
        feature = mean(weekly_averages);
        
        if feature < -0.2
            feature = -0.2;
        end
    end
end
