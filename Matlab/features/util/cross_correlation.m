% This file is part of the project CLASS (https://github.com/beckel/class).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich & TU Darmstadt, 2012
% Authors: Christian Beckel (beckel@inf.ethz.ch), Leyna Sadamori (sadamori@inf.ethz.ch)

% "cross correlation between weekdays (average from mo/tue, tue/wed, wed/thur, thur/fri)
% (no shift in signal to account for changing schedules)
% http://www.icbm.de/studproj/kp_helgoland_05/tsa_korrelation.html"
function feature = cross_correlation(consumption)
    N = length(consumption);
    D = N/7;
    
    feature = zeros(4,1);
    for i=1:4
    startX = (i-1) * D + 1;
        stopX = (i-1) * D + D;
        startY = i * D + 1;
        stopY = i * D + D;
        
        CorrelationCoefficient = corrcoef(consumption(startX:stopX), consumption(startY:stopY));
        feature(i) = CorrelationCoefficient(2,1);
    end
end 
