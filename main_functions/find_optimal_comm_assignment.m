% This code run apply_WSBM , apply_SC and apply_Kmeans 
% for the average fcmatrix

%% add necessary file paths

% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3')
% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3/private')
% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
addpath(fullfile(project_dir,'main_functions'));

%% Bootstrap

% number of boostrap replication = 2000
% 95% confidence interval
boot_res = apply_WSBM_boot(wsbm_results, 2000, [2.5 97.5]);

% Optimal number of communities at 95% level
Best_K_loglik_95 = find(boot_res.confInt(:,2)>0, 1);

%% Plot the boostrap values

plot_WSBM_boot_CI(boot_res,[2,5, 10,15, 18] );

%% Indentify the best solution

wsbm_clustering = identify_optimal_comm_WSBM(wsbm_results);


% load the average fc matrix
% data_path = '/data/wheelock/data1/datasets/HCP/HCP_965_10min_Gordon333_20221123/mat/HCP_965_10min_Gordon333_20221123_Rest1.mat';
% load(data_path);
% fcmat = HCPRest1;
% ave_fcmat = mean(tanh(fcmat),3);
% clear fcmat HCPRest1 datapath ;

kmeans_clustering = identify_optimal_comm_Kmeans(kmeans_results, ave_fcmat);

sc_clustering = identify_optimal_comm_SC(sc_results, ave_fcmat);

louvain_clustering = identify_optimal_comm_Louvain(louvain_results, ave_fcmat);

