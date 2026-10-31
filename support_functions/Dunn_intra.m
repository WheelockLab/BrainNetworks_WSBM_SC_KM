function[Dunn_rep] = Dunn_intra(kmeans_results, wsbm_results, sc_results, D)
% This function calculates the Dunn index for all replications
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
    
   dunn_s{k} = dunns(D,sc_results.idx(:,:,k));
   dunn_k{k} = dunns(D,kmeans_results.idx(:,:,k));
   dunn_w{k} = dunns(D,valid_id{k});
end

Dunn_rep.kmeans = dunn_k;
Dunn_rep.wsbm = dunn_w;
Dunn_rep.sc = dunn_s;

end