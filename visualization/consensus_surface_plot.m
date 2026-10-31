%% add paths

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
addpath(fullfile(project_dir,'atlases'));
load('Parcels_Gordon.mat','Parcels');

%% rainbow plots

% load the color
customcolor = distinguishable_colors(max(con_results.idx)); % use your own colors

% unordered rainbow plots
Explore_parcel_levels_HSB(con_results.des_order_idx,...
    customcolor,Parcels,1:size(con_results.des_order_idx,2),...
    'your_file_name');

% ordered rainbow plots
net_order = randperm(max(con_results.idx)); % use your custom network ordering

Explore_parcel_levels_HSB(rearrange_id(con_results.des_order_idx, net_order),...
    customcolor(net_order,:),Parcels,1:size(con_results.des_order_idx,2),...
    'your_file_name');


%% final consensus surface plot

% unordered plot
Explore_parcel_levels_HSB(con_results.idx,....
    customcolor,Parcels,max(con_results.idx),...
    'your_file_name');


% ordered plot
Explore_parcel_levels_HSB(rearrange_id(con_results.idx, net_order),....
    customcolor(net_order,:),Parcels,max(con_results.idx),...
    'your_file_name');
