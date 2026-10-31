function[SIL_rep] = SIL_intra(kmeans_results, wsbm_results, sc_results, ave_fcmat)
% This function calculates the silhouette values for all replications
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
    stat_w = Matrix_metrics_HSB(valid_id{k}, ave_fcmat);
    SIL_w{k} = stat_w.AvgSil';
    
    stat_k = Matrix_metrics_HSB(kmeans_results.idx(:,:,k), ave_fcmat);
    SIL_k{k} = stat_k.AvgSil';
    
    stat_s = Matrix_metrics_HSB(sc_results.idx(:,:,k), ave_fcmat);
    SIL_s{k} = stat_s.AvgSil';
end

SIL_rep.kmeans = SIL_k;
SIL_rep.wsbm = SIL_w;
SIL_rep.sc = SIL_s;

end