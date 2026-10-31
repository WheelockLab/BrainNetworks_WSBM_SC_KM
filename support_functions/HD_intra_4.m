function[HD_rep] = HD_intra_4(kmeans_results, wsbm_results, sc_results, louvain_results)
% This function calculates the Hammding distance values between all pairs of 
% replications within the solutions from clustering methods for each k. 
% Inputs: solutions from four clustering methods "apply_method" 
%           kmeans_results, wsbm_results, sc_results, louvain_results
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
   HD_s{k} = hamming_distance(sc_results.idx(:,:,k),sc_results.idx(:,:,k));
   HD_k{k} = hamming_distance(kmeans_results.idx(:,:,k),kmeans_results.idx(:,:,k));
   HD_w{k} = hamming_distance(valid_id{k},valid_id{k});
   HD_l{k} = hamming_distance(louvain_results.idx{k},louvain_results.idx{k});
end

HD_rep.kmeans = HD_k;
HD_rep.wsbm = HD_w;
HD_rep.sc = HD_s;
HD_rep.louvain = HD_l;

end

 