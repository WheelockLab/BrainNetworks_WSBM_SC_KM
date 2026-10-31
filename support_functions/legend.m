figure;
hold on;

% Dummy lines for legend
h1 = plot(nan, nan, 'b-', 'LineWidth', 1.5);
h2 = plot(nan, nan, 'k-', 'LineWidth', 1.5);
h3 = plot(nan, nan, 'r-', 'LineWidth', 1.5);

% Legend
lgd = legend([h1, h2, h3], ...
    {'WSBM', 'Spectral Clustering', 'K-means Clustering'}, ...
    'Location', 'northwest');

% Formatting
lgd.FontSize = 20;
lgd.Box = 'on';
lgd.EdgeColor = [0.3 0.3 0.3];
lgd.Color = 'white';
lgd.LineWidth = 1;

% Hide axes if you only want to display the legend
axis off;