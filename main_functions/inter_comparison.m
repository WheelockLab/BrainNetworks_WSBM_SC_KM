% This file shows the betweeen algorithm agreement for three algorithms

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

NMI_rep = NMI_inter(kmeans_results, wsbm_results, sc_results);

plot_inter_comparison(NMI_rep, [], "NMI", "T")

%% Hamming Distance

HD_rep = HD_inter(kmeans_results, wsbm_results, sc_results);

plot_inter_comparison(HD_rep, [], "Hamming Distance", "T")
