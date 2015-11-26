%% init

clearvars;

output_path = '/Users/beckel/Documents/Paper/2015-05-SmartGridComm/figures/';
if exist(output_path, 'dir') == 0
    mkdir(output_path);
end

result_path = 'projects/+diss/results/classification_weather_no_pca/';
weeks = 1:75;

% plotting
width = 10;
height = 6.5;
fontsize = 6;

labels = { ...
            'Age';...
            'All_Employed';...
            'Bedrooms';...
            'Devices';...
            'eCooking';...
            'Employment';...
            'Families';...
            'Floorarea';...
            'HouseType';...
            'Income';...
            'LightBulbs';...
            'NoKids';...
            'OldHouses';...
            'Persons';...
            'Retired';...
            'Singles';...
            'SocialClass';...
            'Unoccupied';...
        };

labels_in_plot = { ...
        'age\_person';...
        'all\_employed';...
        '#bedrooms';...
        '#appliances';...
        'cooking';...
        'employment';...
        'family';...
        'floor\_area';...
        'house\_type';...
        'income';...
        'lightbulbs';...
        'children';...
        'age\_house';...
        '#residents';...
        'retirement';...
        'single';...
        'social\_class';...
        'unoccupied';...
    };

method = 'lda';

feature_names = { ...
            'c\_total', ...  
            'c\_day', ...
            'c\_evening', ...
            'c\_morning', ...
            'c\_night', ...
            'c\_noon', ...
            'c\_weekday', ...
            'c\_weekend', ...
            'c\_max', ...
            'c\_min', ...
            'r\_mean/max', ...
            'r\_evening/noon', ...
            'r\_min/mean', ...
            'r\_noon/day', ...
            'r\_morning/noon', ...
            'r\_night/day', ...
            'r\_weekday/weekend', ...
            's\_diff', ...
            's\_num\_peaks', ...
            's\_variance', ...
            't\_above\_0.5kw', ...
            't\_above\_1kw', ...
            't\_above\_2kw', ...
            's\_x-corr', ...
            't\_above\_mean', ...
            'w\_sunrise', ...
            'w\_sunset', ...
            'w\_temperature', ...
};

%    'lda_undersampling';...

num_labels = length(labels);
num_features = length(feature_names);
num_weeks = length(weeks);

%% analysis 
res_features_accuracy = zeros(num_features, num_labels);
res_features_mcc = zeros(num_features, num_labels);

for w = 1:num_weeks
    week = weeks(w);
    result_folder = [result_path, num2str(w), '/sffs/'];

    for l = 1:length(labels)
        label = labels{l};

        % accuracy
        filename = ['sR-', label, '_accuracy_', method, '.mat'];
        load([result_folder, filename]);

        k = length(sTR);
        for fs = 1:k
            features = sTR{fs}.features;
            for f = 1:length(features)
                feature = features(f);
                res_features_accuracy(feature, l) = res_features_accuracy(feature, l) + 1;
            end
        end 
        clear('sR');
        clear('sTR');

        % mcc
        filename = ['sR-', label, '_mcc_', method, '_undersampling.mat'];
        load([result_folder, filename]);

        k = length(sTR);
        for fs = 1:k
            features = sTR{fs}.features;
            for f = 1:length(features)
                feature = features(f);
                res_features_mcc(feature, l) = res_features_mcc(feature, l) + 1;
            end
        end 
        clear('sR');
        clear('sTR');
    end
end

total = 4 * num_weeks;
fprintf('Total number of possible selections (per label): %d\n', total);

save('feature_summary.mat', 'res_features_mcc', 'res_features_accuracy', 'feature_names');


%% plot
% results are in res_features_mcc and res_features_accuracy
new_order = [ 1 7 8 2 3 4 5 6 9 10 11 13 15 12 14 16 17 21 22 23 25 20 18 24 19 26 27 28];
res_features_accuracy = res_features_accuracy(new_order,:);
res_features_mcc = res_features_mcc(new_order,:);
feature_names = feature_names(new_order);

data = {res_features_accuracy', res_features_mcc'};
filenames = {'num_features_accuracy', 'num_features_mcc'};
plot_title = {'Figure of merit: Accuracy', 'Figure of merit: MCC'};
num_labels = length(labels);

for p = 1:2
    
    fig = figure;
    imagesc(data{p});

    colormap('summer');
    colormap(flipud(colormap));
    set(gca,'YTick',1:num_labels);
    set(gca,'YTickLabel',labels_in_plot);
    set(gca,'XTick',0.5:1:num_features);
    set(gca,'XMinorTick','off');  % sets Minor X Ticks to display
    set(gcf,'color','w');
    set(gca, 'Ticklength', [0 0])
    set(gca,'XTickLabel',feature_names);
    set(gca, 'XTickLabelRotation', 45); 
%     title(plot_title{p});

    lines = {};
    color = [1, 1, 1];

    for i = 1:num_labels-1
        for j = 1:num_features-1
            % vertical line
            lines{end+1} = line([j+0.5, j+0.5], [0+0.5, num_labels+0.5], 'Color', color, 'LineStyle', '-');
            % horizontal line
            lines{end+1} = line([0+0.5, num_features+0.5], [i+0.5, i+0.5], 'Color', color, 'LineStyle', '-');
        end
    end

    ax = gca;
    cb = colorbar('peer', ax);
    
    fig = make_report_ready(fig, 'size', [width, height], 'fontsize', fontsize);

    for l = 1:length(lines)
        set(lines{l}, 'LineWidth', 'default');
    end
%     print('-dpdf', '-cmyk', '-r600', [output_path, filenames{p}, '.pdf']);
    export_fig('-cmyk', '-pdf', [output_path, filenames{p}, '.pdf']);
    close(fig);
end

    