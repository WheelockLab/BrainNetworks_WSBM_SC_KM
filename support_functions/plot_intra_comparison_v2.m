function[] = plot_intra_comparison_v2(val_rep, xtick_vals, y_axis_title, legendVar)
% This function plots the intra comparison for three methods on a given
% metric. 
% Works for CH index, C index, Dunn index, Modularity, zRand

% Input:
% val_rep = the structure of values of the post-hoc measures from
% "methods_intra"
% x_tick_vals = Values of K for x-axis
% y_axis_title = name of the post-hoc measure
% legendVar = legend T/F

% Outpot:
% The plots for three methods with Q1 and Q3 confidence bands.
% Kmeans is red
% WSBM is blue
% SC is black

K_valid = size(val_rep.wsbm, 2);

if length(xtick_vals) == 0
    xtick_vals = 2:K_valid;
end

if length(y_axis_title) == 0
    y_axis_title = "Title";
end 
 
  for ii = 2:K_valid
    k_med(ii-1) = median(val_rep.kmeans{ii}); 
    k_q1(ii-1) = quantile(val_rep.kmeans{ii}, 0.25);
    k_q3(ii-1) = quantile(val_rep.kmeans{ii}, 0.75);
    
    w_med(ii-1) = median(val_rep.wsbm{ii}); 
    w_q1(ii-1) = quantile(val_rep.wsbm{ii}, 0.25);
    w_q3(ii-1) = quantile(val_rep.wsbm{ii}, 0.75);
    
    s_med(ii-1) = median(val_rep.sc{ii}); 
    s_q1(ii-1) = quantile(val_rep.sc{ii}, 0.25);
    s_q3(ii-1) = quantile(val_rep.sc{ii}, 0.75);
 end
 
 
 x = 2:(numel(k_med)+1);
 
 x2 = [x, fliplr(x)];
 inbet_k = [k_q3, fliplr(k_q1)];
 inbet_w = [w_q3, fliplr(w_q1)];
 inbet_s = [s_q3, fliplr(s_q1)];
 
 
 figure();
 set(gcf, 'color', 'w');
 hold on;
 s1 = fill(x2, inbet_k, [1 0 0], 'EdgeColor', 'none');
 alpha(s1, 0.1);
 s2 = fill(x2, inbet_w, [0 0 1],  'EdgeColor', 'none');
 alpha(s2, 0.1);
 s3 = fill(x2, inbet_s, [0.7 0.7 0.7], 'EdgeColor', 'none' );
 alpha(s3, 0.4);
 line1 = plot(x, k_med, 'r', 'Linewidth', 2, 'color', [1 0 0]);
 line2 = plot(x, w_med, 'r', 'Linewidth', 2, 'color', [0 0 1]);
 line3 = plot(x, s_med, 'r', 'Linewidth', 2, 'color', 'black');
 xlabel('K');
 ylabel(y_axis_title);
 xlim([2 K_valid]);
 ylim('auto');
 xticks(xtick_vals);
 ax = gca;
 ax.FontSize = 20;
 
 
 if legendVar == "T"
     legend([line1 line2 line3], 'Kmeans clustering', 'WSBM', 'Spectral clustering');
 end
hold off;
 
end