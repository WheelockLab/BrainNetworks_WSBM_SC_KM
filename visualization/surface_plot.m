% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));

%% load IM file
[~,sortID] = sort(IM.order);

%%

Explore_parcel_levels_HSB(IM.key(sortID,2),IM.cMap,...
    IM.Parcels, max(IM.key(:,2)),"your_file_name");


Explore_parcel_levels_HSB(IM.key(sortID,2),IM.cMap,...
    Parcels, max(IM.key(:,2)),"your_file_name");

%% Gordon Atlas

load('IM_Gordon_13nets_333Parcels.mat');

[~,sortID] = sort(IM.order);
clus_str.idx = IM.key(sortID,2);

k = 11;
stats.clusters = clus_str.idx; 
nameoption = 3;% 1: automatic, 3: using template
[CWro, stats.SortClusRO] = assign_network_colors(stats.clusters,nameoption); % currently using Gordon 13 network colors as default
parcel_name ='Gordon';% params.parcel_name
load(['Parcels_',parcel_name,'.mat'],'Parcels');

Explore_parcel_levels_HSB(stats.clusters,IM.cMap,Parcels,k,fullfile('gordon_'));



%% Kardan Atlas

IM = load('./support_functions/Kardan_11nets_333parcels_on_MNI.mat');

[~,sortID] = sort(IM.ROI_order);
clus_str.idx = IM.ROI_key(sortID,2);

k = 11;
stats.clusters = clus_str.idx; %sc_clustering.idx(:,2:sc_clustering.K_max);
nameoption = 3;% 1: automatic, 3: using template
[CWro, stats.SortClusRO] = assign_network_colors(stats.clusters,nameoption); % currently using Gordon 13 network colors as default
parcel_name ='Gordon';% params.parcel_name
load(['Parcels_',parcel_name,'.mat'],'Parcels');

IM.net_colors(2,:) = [0 0.4 0.4];
IM.net_colors(4,:) = [0.41 0.11 0.11];
IM.net_colors(6,:) = [1 0.64 0.48];
IM.net_colors(9,:) = [0.6 0 0.6];

Explore_parcel_levels_HSB(stats.clusters,IM.net_colors,Parcels,k,fullfile('kardan_'));


