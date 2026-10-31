function[NMI_rep] = NMI_inter(kmeans_results, wsbm_results, sc_results)
% This function calculates the NMI values between all pairs of replications
% between the solutions from different clustering methods for each k. 
% Inputs: solutions from three clustering methods "apply_method" 
%           kmeans_results, wsbm_results, sc_results
%           INPUT ORDERING MATTERS!!

% Ouput: The pairwise post-hoc values for each methods


valid_id = [];
for k = 2:wsbm_results.K_max
    num_uni = splitapply(@num_unique, ...
        wsbm_results.idx(:,:,k), 1:size(wsbm_results.idx, 2));
    valid_rep_id{k} = find(num_uni == k);
    valid_id{k} = wsbm_results.idx(:,valid_rep_id{k}, k);
    count_valid_rep(k) = length(valid_rep_id{k});
%     valid_rep{k} = wsbm_results.idx(:,valid_rep_id{k},k);
%     valid_loglik{k} = wsbm_results.log_lik(valid_rep_id{k},k);
end
clear k;


% Valid K
if length(min(find(count_valid_rep(2:wsbm_results.K_max) == 0))) == 0
    K_valid = wsbm_results.K_max;
else
    K_valid = min(find(count_valid_rep(2:wsbm_results.K_max) == 0));
end

parfor k = 2:K_valid
    
   [~, NMI_k_s{k}] = partition_distance(sc_results.idx(:,:,k),kmeans_results.idx(:,:,k))
   [~, NMI_w_k{k}] = partition_distance(valid_id{k},kmeans_results.idx(:,:,k));
   [~, NMI_w_s{k}] = partition_distance(valid_id{k},sc_results.idx(:,:,k))
end

NMI_rep.kmeans_sc = NMI_k_s;
NMI_rep.wsbm_kmeans = NMI_w_k;
NMI_rep.wsbm_sc = NMI_w_s;


end