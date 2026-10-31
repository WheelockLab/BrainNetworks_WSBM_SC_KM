% This file shows the within algorithm agreement for three algorithms

%% add necessary file paths

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
addpath(fullfile(project_dir,'main_functions'));


%% Data preprocessing

% Input matrix should be the average fc-matrix of dimension nROI x nROI
% Diagonal elements should be 1

% Example 
% data_path = '/data/wheelock/data1/datasets/HCP/HCP_965_10min_Gordon333_20221123/mat/HCP_965_10min_Gordon333_20221123_Rest1.mat';
% load(data_path);
% fcmat = HCPRest1;
% ave_fcmat = mean(tanh(fcmat),3);
% clear fcmat HCPRest1 datapath ;
dist_mat = 1 - corrcoef(ave_fcmat);

%% NMI

NMI_rep = NMI_intra(kmeans_results, wsbm_results, sc_results);

plot_intra_comparison_v1(NMI_rep, [], "NMI", "T")

%% Hamming Distance

HD_rep = HD_intra(kmeans_results, wsbm_results, sc_results);

plot_intra_comparison_v1(HD_rep, [], "Hamming Distance", "T")

%% Silhouette 

SIL_rep = SIL_intra(kmeans_results, wsbm_results, sc_results, ave_fcmat);

plot_intra_comparison_v1(SIL_rep, [], "Silhouette Coefficient", "T")

%% CH index

CH_rep = CH_intra(kmeans_results, wsbm_results, sc_results, dist_mat);

plot_intra_comparison_v2(CH_rep, [], "CH Index", "T")

%% C Index

Cindex_rep = Cindex_intra(kmeans_results, wsbm_results, sc_results, dist_mat);

plot_intra_comparison_v2(Cindex_rep, [], "C Index", "T")

%% VI Distance

VI_rep = VI_intra(kmeans_results, wsbm_results, sc_results);

plot_intra_comparison_v1(VI_rep, [], "VI Distance", "T")

%% Dunn Index

Dunn_rep = Dunn_intra(kmeans_results, wsbm_results, sc_results, dist_mat);

plot_intra_comparison_v2(Dunn_rep, [], "Dunn Index", "T")

%% Modularity

Mod_rep = Mod_intra(kmeans_results, wsbm_results, sc_results, dist_mat);

plot_intra_comparison_v2(Mod_rep, [], "Modularity", "T")

%% zRand

zRand_rep = zRand_intra(kmeans_results, wsbm_results, sc_results, 10000);

plot_intra_comparison_v2(zRand_rep, [], "zRand", "T")

