function [ sunrise_hour ] = get_sunrise_hour_from_sunrise_sunset(all_weeks, sun)

    assert(strcmp(sun.date{1}, '20-Jul-09') == 1);
    
    num_weeks = length(all_weeks);
    num_days = num_weeks * 7;
    
    sunrise_hour = zeros(1, num_days * 48);
    
    for w = 1:num_weeks
        week = all_weeks(w);
        for d = 1:7
            idx = (week-1)*7 + d;
            sunrise = sun.rise{idx};
            hours = round((datenum(sunrise, 'HH:MM') - datenum('00:00', 'HH:MM')) * 24);
            minutes = round(60 * mod((datenum(sunrise, 'HH:MM') - datenum('00:00', 'HH:MM'))*24, 1));
            half = 0;
            if minutes >= 30
                half = 1;
            end
            daylight_start = 2 * hours + half + 1 + 2;
            
            sunset = sun.set{idx};
            hours = round((datenum(sunset, 'HH:MM') - datenum('00:00', 'HH:MM')) * 24);
            minutes = round(60 * mod((datenum(sunset, 'HH:MM') - datenum('00:00', 'HH:MM'))*24, 1));
            half = 0;
            if minutes >= 30
                half = 1;
            end
            daylight_stop = 2 * hours + half + 1;
            
            daylight_idx = (w-1)*7 + d;

            res_start = (daylight_idx-1)*48+daylight_start-1;
            res_stop = (daylight_idx-1)*48+daylight_start;
            sunrise_hour(res_start : res_stop) = 1;
        end
    end
end

