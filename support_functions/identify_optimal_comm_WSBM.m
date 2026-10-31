function[wsbm_clustering] = identify_optimal_comm_WSBM(wsbm_results)
% This function indentifies the best WSBM fits by identifying the community
% assignment with maximum loglikelihood for each k.
% Input: wsbm_results (output from apply_WSBM())


for k = 2:wsbm_results.K_max
    % for each k, find the valid community assignments
    num_uni = splitapply(@num_unique, ...
        wsbm_results.idx(:,:,k),...
        1:size(wsbm_results.idx, 2));
    valid_rep_id{k} = find(num_uni == k);
    count_valid_rep(k) = length(valid_rep_id{k});
    valid_rep{k} = wsbm_results.idx(:,valid_rep_id{k},k);
    valid_loglik{k} = wsbm_results.log_lik(valid_rep_id{k},k);
end

% Valid K
if length(min(find(count_valid_rep(2:wsbm_results.K_max) == 0))) == 0
    K_valid = wsbm_results.K_max;
else
    K_valid = min(find(count_valid_rep(2:wsbm_results.K_max) == 0));
end

idx_final = [];
log_lik_final = [];
for k = 2:K_valid
   rep_opt = min(find(valid_loglik{k} == max(valid_loglik{k})));
   idx_final(:,k) = valid_rep{1,k}(:,rep_opt);
   log_lik_final(k) = max(valid_loglik{k});
end


%wsbm_clustering.datapath = wsbm_results.path;
wsbm_clustering.K_valid = K_valid;
wsbm_clustering.idx = idx_final;
wsbm_clustering.log_lik = log_lik_final;

end
