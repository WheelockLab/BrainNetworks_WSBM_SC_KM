function[louvain_results] = apply_Louvain(ave_fcmat, gamma_vals,M0,B, replication)
% apply Louvain for the average fcmatrix

% Input: 
% ave_fcmat = average fc matrix 
% K_max = maximum value of communities
% replication = number of replication, typically we set 1000

% Output: 
% louvain_clustering.idx = (nROI x replication x K_max) matrix containing the
% estimated community labels

idx_mat_louvain = {}; 

for k = 1:numel(gamma_vals)
    
    start_time_k = datestr(now);
    
    for ii = 1:replication
       idx = community_louvain(ave_fcmat, gamma_vals(k),M0,B);
       
       K = numel(unique(idx));
       
       if numel(idx_mat_louvain) < K
           idx_mat_louvain{K} = [];
       end
       
       idx_mat_louvain{K} = [idx_mat_louvain{K} idx];
   end
   end_time_k = datestr(now);
   total_time_k = diff(datenum([start_time_k;end_time_k]))*24*60; % min
   fprintf('Total time for %d th value = %f mins\n', k,total_time_k);
end


louvain_results.gamma_vals = gamma_vals;
louvain_results.replication = replication;
louvain_results.idx = idx_mat_louvain;


end