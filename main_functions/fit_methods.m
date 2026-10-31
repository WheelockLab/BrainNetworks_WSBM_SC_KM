% This code run apply_WSBM , apply_SC and apply_Kmeans 
% for the average fcmatrix

%% add necessary file paths

% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3')
% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3/private')
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

K_max = 3;
replication = 10;

%% WSBM

wsbm_results = apply_WSBM(ave_fcmat, K_max, replication);


%% Kmeans

kmeans_results = apply_Kmeans(ave_fcmat, K_max, replication);

%% SC

sc_results = apply_SC(ave_fcmat, K_max, replication);

%% Louvain

gamma_vals = 0:0.05:4;
BCP_louvain = apply_Louvain(ave_fcmat,gamma_vals,[],...
    'negative_sym',replication);


