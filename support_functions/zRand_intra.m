function[zRand_rep] = zRand_intra(kmeans_results, wsbm_results, sc_results, num_pairs)
% This function calculates the ...... for all replications
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
end

% Valid K
if length(min(find(count_valid_rep(2:wsbm_results.K_max) == 0))) == 0
    K_valid = wsbm_results.K_max;
else
    K_valid = min(find(count_valid_rep(2:wsbm_results.K_max) == 0));
end


parfor k = 2:K_valid
    zRand_w{k} = sample_zrand(valid_id{k}, num_pairs);
    
    zRand_k{k} = sample_zrand(kmeans_results.idx(:,:,k), num_pairs);
    
    zRand_s{k} = sample_zrand(sc_results.idx(:,:,k), num_pairs);
 
end

zRand_rep.kmeans = zRand_k;
zRand_rep.wsbm = zRand_w;
zRand_rep.sc = zRand_s;

end