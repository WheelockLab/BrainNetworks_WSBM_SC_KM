% This file shows the betweeen algorithm agreement for four algorithms

%% add necessary file paths

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
addpath(fullfile(project_dir,'main_functions'));


%% Data preprocessing

% Input matrix should be the average fc-matrix of dimension nROI x nROI
% Diagonal elements should be 1

% Example 
% data_path = '/data/wheelock/data1/datasets/BCP/January2023/pconns/BCP_Jan2023_QCpass_asleep_atleast8min_UNC_UMN_20240124_parcellation_Gordon_20240315.mat';
% load(data_path);
% fcmat = zmat;
% clear zmat;
% ave_fcmat = mean(tanh(fcmat),3);
% ave_fcmat = ave_fcmat + diag(ones(1,333));
dist_mat = 1 - corrcoef(ave_fcmat);

%% NMI

NMI_rep4 = NMI_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results);

plot_intra_comparison_v1_4(NMI_rep4, [], "NMI", "T")

%% Hamming Distance

HD_rep4 = HD_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results);

plot_intra_comparison_v1_4(HD_rep4, [], "Hamming Distance", "T")

%% Silhouette 

SIL_rep4 = SIL_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, ave_fcmat);

plot_intra_comparison_v1_4(SIL_rep4, [], "Silhouette Coefficient", "T")

%% CH index

CH_rep4 = CH_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, dist_mat);

plot_intra_comparison_v2_4(CH_rep4, [], "CH Index", "T")

%% C Index

Cindex_rep4 = Cindex_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, dist_mat);

plot_intra_comparison_v2_4(Cindex_rep4, [], "C Index", "T")

%% VI Distance

VI_rep4 = VI_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results);

plot_intra_comparison_v1_4(VI_rep4, [], "VI Distance", "T")

%% Dunn Index

Dunn_rep4 = Dunn_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, dist_mat);

plot_intra_comparison_v2_4(Dunn_rep4, [], "Dunn Index", "T")

%% Modularity

Mod_rep4 = Mod_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, dist_mat);

plot_intra_comparison_v2_4(Mod_rep4, [], "Modularity", "T")

%% zRand

zRand_rep4 = zRand_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results, 10000);

plot_intra_comparison_v2_4(zRand_rep4, [], "zRand", "T")

