function[louvain_clustering] =  identify_optimal_comm_Louvain(louvain_results, ave_fcmat)
% This function indentifies the best Kmeans fits by identifying the community
% assignment with maximum silhoutte coefficient for each k.
% Input: louvain_results (output from apply_Kmeans())
%        ave_fcmat: average fc matrix

%% Compute the silhouette coefficient

parfor k = numel(louvain_results.idx)
    stat = Matrix_metrics_HSB(louvain_results.idx{k}, ave_fcmat); 
    AvgSil{k} = stat.AvgSil;
end

%% Choose the best partition according to Max Sil 

idx_final = [];
SIL_final = [];
for k = 2:numel(louvain_results.idx)
   rep_opt = min(find(AvgSil{k} == max(AvgSil{k})));
   idx_final(:,k) = louvain_results.idx{k}(:,rep_opt);
   SIL_final(k) = max(AvgSil{k});
end

% louvain_clustering.path = louvain_results.path;
louvain_clustering.K_max = numel(louvain_results.idx);
louvain_clustering.idx = idx_final;
louvain_clustering.SIL = SIL_final;

end