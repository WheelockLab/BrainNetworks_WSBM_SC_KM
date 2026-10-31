function[Mod_rep] = Mod_intra(kmeans_results, wsbm_results, sc_results, ave_fcmat)
% This function calculates the Modularity for all replications
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
    
   mod_s{k} = modularity(ave_fcmat,sc_results.idx(:,:,k));
   mod_k{k} = modularity(ave_fcmat,kmeans_results.idx(:,:,k));
   mod_w{k} = modularity(ave_fcmat,valid_id{k});
 end
 
Mod_rep.kmeans = mod_k;
Mod_rep.wsbm = mod_w;
Mod_rep.sc = mod_s;


end

