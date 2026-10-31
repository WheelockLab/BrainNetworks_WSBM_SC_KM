%% add necessary file paths

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));
% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3')
% addpath('/data/wheelock/data1/software/Aicher_2015_WSBM/WSBM_v1.3/private')


%% load the data
% HCP data
data_path = '/data/wheelock/data1/datasets/HCP/HCP_965_10min_Gordon333_20221123/mat/HCP_965_10min_Gordon333_20221123_Rest1.mat';
load(data_path);
fcmat = HCPRest1;
clear HCPRest1 data_path;
ave_fcmat = mean(tanh(fcmat),3); % average fc matrix

% load Gordon atlas
load('IM_Gordon_2014_333_Parcels.mat');

%% data processing 

% order the fc matrix according to Gordon atlas
ave_fcmat = ave_fcmat(IM.ROI_order, IM.ROI_order);
% mat_plot(ave_fcmat);

% frequency distribution of the community memberships
tab = tabulate(IM.ROI_key(:,2));
tab(:,4) = cumsum(tab(:,2));
tab = [0 0 0 0; 
    tab];

% Find the community mean and variance matrix
ave_fcmat_mu = [];
ave_fcmat_sigma = [];
for ii = 1:max(max(IM.ROI_key(:,2)))
    for jj = 1:max(max(IM.ROI_key(:,2)))
        % find the sub_matrix with community pair (ii,jj)
        sub_mat = ave_fcmat((tab(ii,4)+1):tab(ii+1,4), (tab(jj,4)+1):tab(jj+1,4));
        off_diag = [];
       if ii == jj
           % delete the diagonal elements containing 1 for ii = jj
           for kk = 1:length(sub_mat)-1
               off_diag = [off_diag, diag(sub_mat, kk)'];
           end
       else
           off_diag = reshape( sub_mat,1, numel(sub_mat));
       end
       ave_fcmat_mu(ii,jj) = mean(off_diag); % compute the mean 
       ave_fcmat_sigma(ii,jj) = var(off_diag);%
    end
end
clear ii jj kk sub_mat off_diag;

% plots of matrices
%mat_plot(ave_fcmat_mu);
%mat_plot(ave_fcmat_sigma);

%% simulation setting

% number of communities 
K = 7;

mu_mat = [
            0.3   0.1  0.05  -0.4   0.05  -0.3   -0.25 ;
            0.1   0.3  0.05  -0.3  -0.4  -0.2    0.3  ;
            0.05   0.05  0.35 -0.01 -0.2  -0.15  -0.3  ;
           -0.4  -0.3 -0.01  0.4   0.1  -0.2   -0.1  ;
            0.05  -0.4 -0.2   0.1   0.3  -0.4   -0.3  ;
           -0.3  -0.2 -0.15  -0.2  -0.4   0.4  -0.1  ;
           -0.25  0.3 -0.3  -0.1  -0.3  -0.1    0.3  ];

% generate the variance matrix

% diagonalize the variance matrix 
on_diag_sig = diag(ave_fcmat_sigma, 0)';
off_diag_sig = [];
for kk = 1:length(ave_fcmat_sigma)-1
    off_diag_sig = [off_diag_sig, diag(ave_fcmat_sigma, kk)'];
end
clear kk;

% sample the values from ave_fcmat_sigma and retain the diagonal structure
rng(123)
sigma_mat = [];
for ii=1:K
    for jj=ii:K
        if ii==jj
            sigma_mat(ii,jj) = randsample(on_diag_sig, 1);
        else
            sigma_mat(ii,jj) = randsample(off_diag_sig, 1);
            sigma_mat(jj,ii) = sigma_mat(ii,jj);
        end
        
    end
end
clear ii jj on_diag_sig off_diag_sig;

clear IM Parcel_Nets Parcels tab ave_fcmat fc_mat;

% plots of matrices
% mat_plot(mu_mat, "T");
% mat_plot(sigma_mat);

label_true = repelem(1:K, [40 25 30 20 35 30 20]);

% number of ROI
nROI = 200;
% number of subjects
n = 1;

n_rep = 1000;
K_max = 12;
WSBM_best_K = [];

WSBM_NMI_bestK = []; SC_NMI_bestK = []; Kmeans_NMI_bestK = [];
WSBM_HD_bestK = []; SC_HD_bestK = []; Kmeans_HD_bestK = [];
WSBM_SIL_bestK = []; SC_SIL_bestK = []; Kmeans_SIL_bestK = [];
WSBM_CH_bestK = []; SC_CH_bestK = []; Kmeans_CH_bestK = [];
WSBM_Cindex_bestK = []; SC_Cindex_bestK = []; Kmeans_Cindex_bestK = [];
WSBM_VI_bestK = []; SC_VI_bestK = []; Kmeans_VI_bestK = [];
WSBM_Dunn_bestK = []; SC_Dunn_bestK = []; Kmeans_Dunn_bestK = [];
WSBM_Mod_bestK = []; SC_Mod_bestK = []; Kmeans_Mod_bestK = [];
WSBM_zRand_bestK = []; SC_zRand_bestK = []; Kmeans_zRand_bestK = [];

for sim_i = 1:100
 
% generate the fc matrix
rng(123+sim_i-1)
A = generate_fcmat(nROI, label_true, mu_mat, sigma_mat, n);

% save the data
sim.mat = A;
sim.mu = mu_mat;
sim.sigma = sigma_mat;
sim.label = label_true;
save(sprintf('HCP_sim2_fcmat_%d.mat',sim_i), "sim");
clear sim;
    

wsbm_results = apply_WSBM(A, K_max, n_rep);
save(sprintf('HCP_sim2_wsbm_results_%d.mat',sim_i), "wsbm_results");

kmeans_results = apply_Kmeans(A, K_max, n_rep);
save(sprintf('HCP_sim2_kmeans_results_%d.mat',sim_i), "kmeans_results");

sc_results = apply_SC(A, K_max, n_rep);
save(sprintf('HCP_sim2_sc_results_%d.mat',sim_i), "sc_results");

%%

boot_res = apply_WSBM_boot(wsbm_results, 2000, [2.5 97.5]);
save(sprintf('HCP_sim2_wsbm_boot_%d.mat',sim_i), "boot_res");

% Optimal number of communities at 95% level
%WSBM_best_K(sim_i) = find(boot_res.confInt(:,2)>0, 1);

WSBM_best_K(sim_i) = 1;
if ~isempty(find(boot_res.confInt(:,2) > 0, 1)), WSBM_best_K(sim_i) = find(boot_res.confInt(:,2) > 0, 1); end


dist_mat = 1 - corrcoef(A);

%% NMI

NMI_rep = NMI_intra(kmeans_results, wsbm_results, sc_results);
save(sprintf('HCP_sim2_NMI_%d.mat',sim_i), "NMI_rep");
%plot_intra_comparison_v1(NMI_rep, [], "NMI", "T")
WSBM_NMI_bestK(sim_i) = max_intra_comparison_v1(NMI_rep).wsbm;
SC_NMI_bestK(sim_i) = max_intra_comparison_v1(NMI_rep).sc;
Kmeans_NMI_bestK(sim_i) = max_intra_comparison_v1(NMI_rep).kmeans;

%% Hamming Distance

HD_rep = HD_intra(kmeans_results, wsbm_results, sc_results);
save(sprintf('HCP_sim2_HD_%d.mat',sim_i), "HD_rep");
%plot_intra_comparison_v1(HD_rep, [], "Hamming Distance", "T")
WSBM_HD_bestK(sim_i) = min_intra_comparison_v1(HD_rep).wsbm;
SC_HD_bestK(sim_i) = min_intra_comparison_v1(HD_rep).sc;
Kmeans_HD_bestK(sim_i) = min_intra_comparison_v1(HD_rep).kmeans;

%% Silhouette 

SIL_rep = SIL_intra(kmeans_results, wsbm_results, sc_results, A);
save(sprintf('HCP_sim2_SIL_%d.mat',sim_i), "SIL_rep");
%plot_intra_comparison_v1(SIL_rep, [], "Silhouette Coefficient", "T")

WSBM_SIL_bestK(sim_i) = max_intra_comparison_v1(SIL_rep).wsbm;
SC_SIL_bestK(sim_i) = max_intra_comparison_v1(SIL_rep).sc;
Kmeans_SIL_bestK(sim_i) = max_intra_comparison_v1(SIL_rep).kmeans;

%% CH index

CH_rep = CH_intra(kmeans_results, wsbm_results, sc_results, dist_mat);
save(sprintf('HCP_sim2_CH_%d.mat',sim_i), "CH_rep");
%plot_intra_comparison_v2(CH_rep, [], "CH Index", "T")
WSBM_CH_bestK(sim_i) = max_intra_comparison_v2(CH_rep).wsbm;
SC_CH_bestK(sim_i) = max_intra_comparison_v2(CH_rep).sc;
Kmeans_CH_bestK(sim_i) = max_intra_comparison_v2(CH_rep).kmeans;

%% C Index

Cindex_rep = Cindex_intra(kmeans_results, wsbm_results, sc_results, dist_mat);
save(sprintf('HCP_sim2_Cindex_%d.mat',sim_i), "Cindex_rep");
%plot_intra_comparison_v2(Cindex_rep, [], "C Index", "T")
WSBM_Cindex_bestK(sim_i) = min_intra_comparison_v2(Cindex_rep).wsbm;
SC_Cindex_bestK(sim_i) = min_intra_comparison_v2(Cindex_rep).sc;
Kmeans_Cindex_bestK(sim_i) = min_intra_comparison_v2(Cindex_rep).kmeans;

%% VI Distance

VI_rep = VI_intra(kmeans_results, wsbm_results, sc_results);
save(sprintf('HCP_sim2_VI_%d.mat',sim_i), "VI_rep");
%plot_intra_comparison_v1(VI_rep, [], "VI Distance", "T")
WSBM_VI_bestK(sim_i) = min_intra_comparison_v1(VI_rep).wsbm;
SC_VI_bestK(sim_i) = min_intra_comparison_v1(VI_rep).sc;
Kmeans_VI_bestK(sim_i) = min_intra_comparison_v1(VI_rep).kmeans;

%% Dunn Index

Dunn_rep = Dunn_intra(kmeans_results, wsbm_results, sc_results, dist_mat);
save(sprintf('HCP_sim2_Dunn_%d.mat',sim_i), "Dunn_rep");
%plot_intra_comparison_v2(Dunn_rep, [], "Dunn Index", "T")
WSBM_Dunn_bestK(sim_i) = min_intra_comparison_v2(Dunn_rep).wsbm;
SC_Dunn_bestK(sim_i) = min_intra_comparison_v2(Dunn_rep).sc;
Kmeans_Dunn_bestK(sim_i) = min_intra_comparison_v2(Dunn_rep).kmeans;

%% Modularity

Mod_rep = Mod_intra(kmeans_results, wsbm_results, sc_results, dist_mat);
save(sprintf('HCP_sim2_Mod_%d.mat',sim_i), "Mod_rep");
%plot_intra_comparison_v2(Mod_rep, [], "Modularity", "T")
WSBM_Mod_bestK(sim_i) = min_intra_comparison_v2(Mod_rep).wsbm;
SC_Mod_bestK(sim_i) = min_intra_comparison_v2(Mod_rep).sc;
Kmeans_Mod_bestK(sim_i) = min_intra_comparison_v2(Mod_rep).kmeans;

%% zRand

zRand_rep = zRand_intra(kmeans_results, wsbm_results, sc_results, 10000);
save(sprintf('HCP_sim2_zRand_%d.mat',sim_i), "zRand_rep", '-v7.3');
%plot_intra_comparison_v2(Mod_rep, [], "Modularity", "T")
WSBM_zRand_bestK(sim_i) = max_intra_comparison_v2(zRand_rep).wsbm;
SC_zRand_bestK(sim_i) = max_intra_comparison_v2(zRand_rep).sc;
Kmeans_zRand_bestK(sim_i) = max_intra_comparison_v2(zRand_rep).kmeans;


save('HCP_sim2_bestK.mat', ...
    'WSBM_best_K', ...
    'WSBM_NMI_bestK', 'SC_NMI_bestK', 'Kmeans_NMI_bestK', ...
    'WSBM_HD_bestK', 'SC_HD_bestK', 'Kmeans_HD_bestK', ...
    'WSBM_SIL_bestK', 'SC_SIL_bestK', 'Kmeans_SIL_bestK', ...
    'WSBM_CH_bestK', 'SC_CH_bestK', 'Kmeans_CH_bestK', ...
    'WSBM_Cindex_bestK', 'SC_Cindex_bestK', 'Kmeans_Cindex_bestK', ...
    'WSBM_VI_bestK', 'SC_VI_bestK', 'Kmeans_VI_bestK', ...
    'WSBM_Dunn_bestK', 'SC_Dunn_bestK', 'Kmeans_Dunn_bestK', ...
    'WSBM_Mod_bestK', 'SC_Mod_bestK', 'Kmeans_Mod_bestK', ...
    'WSBM_zRand_bestK', 'SC_zRand_bestK', 'Kmeans_zRand_bestK');

    
end

