
%% add paths

% project_dir = "your_dir";
addpath(fullfile(project_dir,'support_functions'));

%% consesus
con_results = WSBM_consensus_HD(wsbm_results, 15);

