% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));

%% load average fc matrix

% HCP

% data_path = '/data/wheelock/data1/datasets/HCP/HCP_965_10min_Gordon333_20221123/mat/HCP_965_10min_Gordon333_20221123_Rest1.mat';
% load(data_path);
% fcmat = HCPRest1;
% clear HCPRest1;
% ave_fcmat = mean(tanh(fcmat),3);

% WU120
% data_path = '/data/wheelock/data1/datasets/WashU120/pconns/washu120_parcellation_Gordon_20231101.mat';
% load(data_path);
% fcmat = zmat;
% clear zmat;
% fcmat = double(fcmat);
% ave_fcmat = mean(tanh(fcmat),3);
% clear fcmat data_path;
% ave_fcmat(logical(eye(size(ave_fcmat)))) = 1;


% BCP
% data_path = '/data/wheelock/data1/datasets/BCP/January2023/pconns/BCP_Jan2023_QCpass_asleep_atleast8min_UNC_UMN_20240124_parcellation_Gordon_20240315.mat';
% load(data_path);
% fcmat = zmat;
% clear zmat;
% ave_fcmat = mean(tanh(fcmat),3);
% ave_fcmat = ave_fcmat + diag(ones(1,333));

%% Plot without ordering

mat_plot(ave_fcmat, "T", "F", 20, 5);


%% load the IM file

%% fc matrix plot
Matrix_Org3(ave_fcmat(IM.order,IM.order), IM.key, 10 ,...
    [-0.3, 0.3], IM.cMap, 1);
