function[] = plot_intra_comparison_v1_4(val_rep, xtick_vals, y_axis_title, legendVar)
% This function plots the intra comparison for three methods on a given
% metric. 
% Works for NMI, Hamming Distance, Silhouette coefficient, VI diatance

% Input:
% val_rep = the structure of values of the post-hoc measures from
% "methods_intra"
% x_tick_vals = Values of K for x-axis
% y_axis_title = name of the post-hoc measure
% legendVar = legend T/F

% Outpot:
% The plots for four methods with Q1 and Q3 confidence bands.
% Kmeans is red
% WSBM is blue
% SC is black
% Louvain is green

K_valid = size(val_rep.wsbm, 2);

if length(xtick_vals) == 0
    xtick_vals = 2:K_valid;
end

if length(y_axis_title) == 0
    y_axis_title = "Title";
end 

 for k = 2:K_valid
    mask_k = tril(true(size(val_rep.kmeans{k})),-1);
    k_mat{k} = reshape(val_rep.kmeans{k}(mask_k), numel(val_rep.kmeans{k}(mask_k)),1);
    mask_s = tril(true(size(val_rep.sc{k})),-1);
    s_mat{k} = reshape(val_rep.sc{k}(mask_s), numel(val_rep.sc{k}(mask_s)),1);
    mask_w = tril(true(size(val_rep.wsbm{k})),-1);
    w_mat{k} = reshape(val_rep.wsbm{k}(mask_w), numel(val_rep.wsbm{k}(mask_w)),1);
    mask_l = tril(true(size(val_rep.louvain{k})),-1);
    l_mat{k} = reshape(val_rep.louvain{k}(mask_l), numel(val_rep.louvain{k}(mask_l)),1);
    clear mask_k mask_s mask_w mask_l;
 end
 val_mat.k = k_mat;
 val_mat.s = s_mat;
 val_mat.w = w_mat;
 val_mat.l = l_mat;

 for ii = 2:K_valid
    k_med(ii-1) = median(val_mat.k{ii}); 
    k_q1(ii-1) = quantile(val_mat.k{ii}, 0.25);
    k_q3(ii-1) = quantile(val_mat.k{ii}, 0.75);
    
    w_med(ii-1) = median(val_mat.w{ii}); 
    w_q1(ii-1) = quantile(val_mat.w{ii}, 0.25);
    w_q3(ii-1) = quantile(val_mat.w{ii}, 0.75);
    
    s_med(ii-1) = median(val_mat.s{ii}); 
    s_q1(ii-1) = quantile(val_mat.s{ii}, 0.25);
    s_q3(ii-1) = quantile(val_mat.s{ii}, 0.75);
    
    l_med(ii-1) = median(val_mat.l{ii}); 
    l_q1(ii-1) = quantile(val_mat.l{ii}, 0.25);
    l_q3(ii-1) = quantile(val_mat.l{ii}, 0.75);
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
 ylabel(y_axis_title);
 xlim([2 K_valid]);
 ylim('auto');
 xticks(xtick_vals);
 ax = gca;
 ax.FontSize = 24;
 
 
 if legendVar == "T"
     legend([line1 line2 line3 line4],...
         'Kmeans clustering', 'WSBM', 'Spectral clustering', 'Louvain');
 end
hold off;
 
end