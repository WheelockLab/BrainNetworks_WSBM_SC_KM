% load all the method_results from apply_method
% kmeans_results, wsbm_results, sc_results

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
addpath(fullfile(project_dir,'atlases'));

%% Load the atlas

% HCP
load('IM_Gordon_13nets_333Parcels.mat');
[~,sortID] = sort(IM.order);
atlas_key = IM.key(sortID,2);
% BCP
IM = load('Kardan_11nets_333parcels_on_MNI.mat');
[~,sortID] = sort(IM.ROI_order);
atlas_key = IM.ROI_key(sortID,2);

clear IM sortID;

%% Plot

altas_comparison_NMI_plot(kmeans_results, wsbm_results, sc_results, atlas_key, [], "T")
