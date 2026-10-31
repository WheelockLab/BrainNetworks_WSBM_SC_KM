function [zRand, pair] = all_zrand(part)
%ALL_ZRAND Calculate z-Rand for all unique pairs of partitions.
%
%   [zRand, pair] = ALL_ZRAND(part)
%
%   Input:
%       part  - n x d matrix, where each column is a partition
%
%   Outputs:
%       zRand - d*(d-1)/2 x 1 vector of z-Rand scores
%       pair  - d*(d-1)/2 x 2 matrix containing partition indices
%
%   Only unique pairs are calculated:
%       (1,2), (1,3), ..., (d-1,d)
%
%   Self-comparisons and duplicate pairs are excluded.
%
%   A progress bar is displayed during calculation.

    [n, d] = size(part);

    % Number of unique pairs
    numPairs = d * (d - 1) / 2;

    % Preallocate
    zRand = zeros(numPairs, 1);
    pair = zeros(numPairs, 2);

    % Create progress bar
    h = waitbar(0, 'Calculating z-Rand...');
    
    % Make sure the progress bar closes if an error occurs
    cleanupObj = onCleanup(@() closeWaitbar(h));

    k = 1;

    for i = 1:d-1
        for j = i+1:d

            % Calculate z-Rand
            zRand(k) = zrand(part(:,i), part(:,j));

            % Store pair indices
            pair(k,:) = [i j];

            % Update progress bar
            progress = k / numPairs;

            waitbar(progress, h, sprintf( ...
                'Calculating z-Rand: %d / %d (%.1f%%)', ...
                k, numPairs, 100*progress));

            k = k + 1;
        end
    end

    % Close progress bar
    close(h);

end


function closeWaitbar(h)
% Close waitbar safely if it still exists.
    if isvalid(h)
        close(h);
    end
end


% function [zRand, pair] = all_zrand(part)
% %ALL_ZRAND Calculate z-Rand for all unique pairs of partitions.
% %
% %   [zRand, pair] = ALL_ZRAND(part)
% %
% %   Input:
% %       part  - n x d matrix, where each column is a partition
% %
% %   Outputs:
% %       zRand - d*(d-1)/2 x 1 vector of z-Rand scores
% %       pair  - d*(d-1)/2 x 2 matrix containing the partition
% %               indices for each z-Rand score
% %
% %   Only unique pairs are calculated:
% %       (1,2), (1,3), ..., (1,d),
% %       (2,3), ..., (2,d),
% %       ...
% %       (d-1,d)
% %
% %   Self-comparisons (i,i) are excluded, as are duplicate pairs.
% 
%     [n, d] = size(part);
% 
%     % Number of unique pairs
%     numPairs = d * (d - 1) / 2;
% 
%     % Preallocate
%     zRand = zeros(numPairs, 1);
%     pair = zeros(numPairs, 2);
% 
%     k = 1;
% 
%     for i = 1:d-1
%         for j = i+1:d
% 
%             % Calculate z-Rand between partition i and partition j
%             zRand(k) = zrand(part(:,i), part(:,j));
% 
%             % Store which pair was compared
%             pair(k,:) = [i j];
% 
%             k = k + 1;
%         end
%     end
% end
