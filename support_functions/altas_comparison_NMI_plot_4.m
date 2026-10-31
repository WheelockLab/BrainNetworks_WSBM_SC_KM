function[] = altas_comparison_NMI_plot_4(kmeans_results, wsbm_results, sc_results, louvain_results, ...
    atlas_key, xtick_vals, legendVar)

% This function plots the NMI values of four methods compared to a
% specific altas.
% Inputs: solutions fromm three clustering methods "apply_method" 
%           kmeans_results, wsbm_results, sc_results, louvain_results
%           INPUT ORDERING MATTERS!!
% altas_key: vector of length nROI, Gordon et al. (2016), Kardan et al. (2022)
% x_tick_vals = Values of K for x-axis
% legendVar = legend T/F

% Outpot:
% The plots NMI values for three methods with Q1 and Q3 confidence bands.
% Kmeans is red
% WSBM is blue
% SC is black
% Louvain is green

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


if length(xtick_vals) == 0
    xtick_vals = 2:K_valid;
end


% calculate the NMI 
parfor k = 2:K_valid
   [~, NMI_s{k}] = partition_distance(sc_results.idx(:,:,k),atlas_key);
   [~, NMI_k{k}] = partition_distance(kmeans_results.idx(:,:,k),atlas_key);
   [~, NMI_w{k}] = partition_distance(valid_id{k},atlas_key);
   [~, NMI_l{k}] = partition_distance(louvain_results.idx{k},Kardan_key);
end

NMI_rep.k = NMI_k;
NMI_rep.w = NMI_w;
NMI_rep.s = NMI_s;
NMI_rep.l = NMI_l;


 for k = 2:K_valid
    mask_k = tril(true(size(NMI_rep.k{k})),-1);
    k_mat{k} = reshape(NMI_rep.k{k}(mask_k), numel(NMI_rep.k{k}(mask_k)),1);
    mask_s = tril(true(size(NMI_rep.s{k})),-1);
    s_mat{k} = reshape(NMI_rep.s{k}(mask_s), numel(NMI_rep.s{k}(mask_s)),1);
    mask_w = tril(true(size(NMI_rep.w{k})),-1);
    w_mat{k} = reshape(NMI_rep.w{k}(mask_w), numel(NMI_rep.k{k}(mask_w)),1);
    mask_l = tril(true(size(NMI_rep.l{k})),-1);
    l_mat{k} = reshape(NMI_rep.l{k}(mask_l), numel(NMI_rep.l{k}(mask_l)),1);
    clear mask_k mask_s mask_w mask_l;
 end
 NMI_mat.k = k_mat;
 NMI_mat.s = s_mat;
 NMI_mat.w = w_mat;
 NMI_mat.l = l_mat;
 
 
 for ii = 2:K_valid
    k_med(ii-1) = median(NMI_mat.k{ii}); 
    k_q1(ii-1) = quantile(NMI_mat.k{ii}, 0.25);
    k_q3(ii-1) = quantile(NMI_mat.k{ii}, 0.75);
    
    w_med(ii-1) = median(NMI_mat.w{ii}); 
    w_q1(ii-1) = quantile(NMI_mat.w{ii}, 0.25);
    w_q3(ii-1) = quantile(NMI_mat.w{ii}, 0.75);
    
    s_med(ii-1) = median(NMI_mat.s{ii}); 
    s_q1(ii-1) = quantile(NMI_mat.s{ii}, 0.25);
    s_q3(ii-1) = quantile(NMI_mat.s{ii}, 0.75);
    
    l_med(ii-1) = median(NMI_mat.l{ii}); 
    l_q1(ii-1) = quantile(NMI_mat.l{ii}, 0.25);
    l_q3(ii-1) = quantile(NMI_mat.l{ii}, 0.75);
 end
 
 x = 2:(numel(k_med)+1);
 
 x2 = [x, fliplr(x)];
 inbet_k = [k_q3, fliplr(k_q1)];
 inbet_w = [w_q3, fliplr(w_q1)];
 inbet_s = [s_q3, fliplr(s_q1)];
 inbet_l = [l_q3, fliplr(l_q1)];
 
 
 figure();
 set(gcf, 'color', 'w');
 hold on;
 s1 = fill(x2, inbet_k, [1 0 0], 'EdgeColor', 'none');
 alpha(s1, 0.1);
 s2 = fill(x2, inbet_w, [0 0 1],  'EdgeColor', 'none');
 alpha(s2, 0.1);
 s3 = fill(x2, inbet_s, [0.7 0.7 0.7], 'EdgeColor', 'none' );
 alpha(s3, 0.4);
 s4 = fill(x2, inbet_l, [0 1 0], 'EdgeColor', 'none' );
 alpha(s4, 0.2);
 line1 = plot(x, k_med, 'r', 'Linewidth', 2, 'color', [1 0 0]);
 line2 = plot(x, w_med, 'r', 'Linewidth', 2, 'color', [0 0 1]);
 line3 = plot(x, s_med, 'r', 'Linewidth', 2, 'color', 'black');
 line4 = plot(x, l_med, 'r', 'Linewidth', 2, 'color', [0 1 0]);
 xlabel('K');
 ylabel('NMI');
 xlim([2 K_valid]);
 ylim([0 1]);
 xticks(xtick_vals);
 ax = gca;
 ax.FontSize = 24;
 
 if legendVar == "T"
     legend([line1 line2 line3], 'Kmeans clustering', 'WSBM', 'Spectral clustering');
 end
hold off;

end