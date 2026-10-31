%% Reproducibility analysis legend

figure('Color','w')

h1 = plot(NaN, NaN, 'r-', 'LineWidth', 1.5); hold on
h2 = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
h3 = plot(NaN, NaN, 'k-', 'LineWidth', 1.5);
h4 = plot(NaN, NaN, 'g-', 'Linewidth', 1.5);

lgd = legend([h2 h3 h1 h4], ...
    {'WSBM','Spectral Clustering', 'K-means Clustering', 'Louvain'}, ...
    'Location','best');
set([h1 h2 h3 h4], 'LineWidth', 3);
set(lgd, ...
    'FontSize', 25, ...
    'Color', 'white', ...
    'EdgeColor', 'black');
lgd.ItemTokenSize = [40, 18];   
axis off

%% Similarity analysis legends

figure('Color','w')

h1 = plot(NaN, NaN, 'r-', 'LineWidth', 1.5); hold on
h2 = plot(NaN, NaN, 'b-', 'LineWidth', 1.5);
h3 = plot(NaN, NaN, 'k-', 'LineWidth', 1.5);

lgd = legend([h2 h3 h1], ...
    {'WSBM vs Spectral Clustering','WSBM vs K-means Clustering', 'Spectral vs K-means Clustering' }, ...
    'Location','best');
set([h1 h2 h3], 'LineWidth', 3);
set(lgd, ...
    'FontSize', 25, ...
    'Color', 'white', ...
    'EdgeColor', 'black');
lgd.ItemTokenSize = [40, 18];   
axis off