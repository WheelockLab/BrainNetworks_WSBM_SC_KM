function[Cindex_rep] = Cindex_intra(kmeans_results, wsbm_results, sc_results, D)
% This function calculates the C index for all replications
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
    
   Cindex_s{k} = Cindex(D,sc_results.idx(:,:,k));
   Cindex_k{k} = Cindex(D,kmeans_results.idx(:,:,k));
   Cindex_w{k} = Cindex(D,valid_id{k});
end

Cindex_rep.kmeans = Cindex_k;
Cindex_rep.wsbm = Cindex_w;
Cindex_rep.sc = Cindex_s;

end