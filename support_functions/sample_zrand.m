function [zRand, pair] = sample_zrand(part, numSamples)
%SAMPLE_ZRAND Randomly sample pairwise z-Rand comparisons.
%
%   [zRand, pair] = SAMPLE_ZRAND(part, numSamples)
%
%   Inputs:
%       part       - n x d matrix, where each column is a partition
%       numSamples - requested number of random pairwise comparisons
%
%   Outputs:
%       zRand      - z-Rand score for each sampled pair
%       pair       - indices of the two partitions being compared

    [~, d] = size(part);

    % Total number of unique pairs
    totalPairs = d * (d - 1) / 2;

    % Actual number of samples
    numSamples = min(totalPairs, numSamples);

    % -------------------------------------------------------------
    % Generate unique random pairs
    % -------------------------------------------------------------

    if numSamples == 0
        pair = zeros(0, 2);
    elseif numSamples == totalPairs

        % All possible pairs
        [ii, jj] = find(triu(true(d), 1));
        pair = [ii, jj];

    else

        pair = zeros(numSamples, 2);

        k = 1;

        while k <= numSamples

            % Generate a batch of candidate pairs
            batchSize = max(2, 2 * (numSamples - k + 1));

            i = randi(d, batchSize, 1);
            j = randi(d, batchSize, 1);

            % Remove self-pairs
            valid = (i ~= j);
            i = i(valid);
            j = j(valid);

            if isempty(i)
                continue;
            end

            % Put smaller index first
            ii = min(i, j);
            jj = max(i, j);

            newPairs = [ii, jj];

            % Remove duplicate candidate pairs
            newPairs = unique(newPairs, 'rows');

            % Explicitly make sure the array has two columns
            if isempty(newPairs)
                continue;
            end
            newPairs = reshape(newPairs, [], 2);

            % Remove pairs already selected
            if k > 1
                alreadySelected = pair(1:k-1, :);

                % Use ismember rather than setdiff to avoid
                % dimension problems with empty arrays.
                isOld = ismember(newPairs, alreadySelected, 'rows');
                newPairs = newPairs(~isOld, :);
            end

            % Add new pairs
            nNew = min(size(newPairs, 1), numSamples - k + 1);

            if nNew > 0
                pair(k:k+nNew-1, :) = newPairs(1:nNew, :);
                k = k + nNew;
            end
        end
    end

    % -------------------------------------------------------------
    % Calculate z-Rand
    % -------------------------------------------------------------

    zRand = zeros(numSamples, 1);

    if numSamples == 0
        return;
    end

    % Progress bar
    h = waitbar(0, 'Calculating z-Rand...');
    cleanupObj = onCleanup(@() closeWaitbar(h));

    for k = 1:numSamples

        i = pair(k, 1);
        j = pair(k, 2);

        zRand(k) = zrand(part(:, i), part(:, j));

        % Update progress every ~1%
        if mod(k, max(1, floor(numSamples/100))) == 0 || k == numSamples

            p = k / numSamples;

            waitbar(p, h, sprintf( ...
                'Calculating z-Rand: %d / %d (%.1f%%)', ...
                k, numSamples, 100*p));
        end
    end

    close(h);

end


function closeWaitbar(h)

    if isvalid(h)
        close(h);
    end

end
