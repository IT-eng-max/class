% This file is part of the project CLASS (https://github.com/beckel/class).
% Licence: GPL 2.0 (http://www.gnu.org/licenses/gpl-2.0.html)
% Copyright: ETH Zurich & TU Darmstadt, 2012
% Authors: Christian Beckel (beckel@inf.ethz.ch), Leyna Sadamori (sadamori@inf.ethz.ch)

function feat_set = feature_set_plus_hourly(option)
    if (nargin == 0)
		feat_set = {...
            @hourly_temperature_sunrise_sunset; ...
            @pca_analysis;...
            };
 	elseif (nargin == 1)
		if (strcmp(option, 'name'))
			feat_set = 'additional';
        else
			error('This option is not supported');
		end
	end
end