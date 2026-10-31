function[VI_rep] = VI_intra(kmeans_results, wsbm_results, sc_results)
% This function calculates the VI distance between all pair-wise replications
% within the solutions from clustering methods for each k. 
% Inputs: solutions from three clustering methods "apply_method" 
%           kmeans_results, wsbm_results, sc_results
%           INPUT ORDERING MATTERS!!

% Ouput: The pairwise post-hoc values for each methods
 

for k = 2:wsbm_results.K_max
    % for each k, find the valid community assignments
    num_uni = splitapply(@num_unique, ...
        wsbm_results.idx(:,:,k),...
        1:size(wsbm_results.idx, 2));
    valid_rep_id{k} = find(num_uni == k);
    valid_id{k} = wsbm_results.idx(:,valid_rep_id{k}, k);
    count_valid_rep(k) = length(valid_rep_id{k});
%     valid_rep{k} = wsbm_results.idx(:,valid_rep_id{k},k);
%     valid_loglik{k} = wsbm_results.log_lik(valid_rep_id{k},k);
end

% Valid K
if length(min(find(count_valid_rep(2:wsbm_results.K_max) == 0))) == 0
    K_valid = wsbm_results.K_max;
else
    K_valid = min(find(count_valid_rep(2:wsbm_results.K_max) == 0));
end


parfor k = 2:K_valid
    
   [VI_s{k}, ~] = partition_distance(sc_results.idx(:,:,k),sc_results.idx(:,:,k));
   [VI_k{k}, ~] = partition_distance(kmeans_results.idx(:,:,k),kmeans_results.idx(:,:,k));
   [VI_w{k}, ~] = partition_distance(valid_id{k},valid_id{k});
end

VI_rep.kmeans = VI_k;
VI_rep.wsbm = VI_w;
VI_rep.sc = VI_s;

end