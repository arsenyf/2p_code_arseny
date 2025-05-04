function matchedRanges = fn_find_matched_lick_bins(lickMatrix, reward_type_vector, condA, condB, minTrialsPerBin)

% INPUTS:
% lickMatrix           - (nTrials x nTimepoints) binary lick matrix
% reward_type_vector   - (nTrials x 1), reward condition per trial (e.g., 0 = regular, 2 = large)
% condA, condB         - reward condition values to compare (e.g., 0 and 2)
% minTrialsPerBin      - minimum # of trials per bin to consider it usable

% OUTPUT:
% matchedRanges        - cell array of [startBin, endBin] for contiguous matched ranges

% Get trials for each condition
idxA = find(reward_type_vector == condA);
idxB = find(reward_type_vector == condB);

% Compute total lick count per trial
licksA = sum(lickMatrix(idxA,:), 2);
licksB = sum(lickMatrix(idxB,:), 2);

% Define lick count bins (bin edges: 0 to max lick)
maxLick = max([licksA; licksB]);
edges = 0:2:(maxLick+2);
centers = edges(1:end-1);

% Histogram: trials per bin
histA = histcounts(licksA, edges);
histB = histcounts(licksB, edges);

% Compute overlap (min trials per bin)
overlap = min(histA, histB);

% Plot histograms
% figure;
bar(centers, [histA; histB]', 'grouped');
legend(sprintf('Reward %d', condA), sprintf('Reward %d', condB));
xlabel('Lick Count per Trial');
ylabel('Number of Trials');
title('Lick Count Distributions');

% Find valid bins (where overlap is sufficient)
validBins = find(overlap >= minTrialsPerBin);

% Group into contiguous ranges
if isempty(validBins)
    matchedRanges = {};
    disp('No matched lick bins found with enough trials.');
    return;
end

splitPoints = find(diff(validBins) > 1);
binStarts = [validBins(1), validBins(splitPoints + 1)];
binEnds   = [validBins(splitPoints), validBins(end)];

% Output ranges
matchedRanges = cell(numel(binStarts), 1);
fprintf('\nMatched lick count ranges:\n');
for i = 1:numel(binStarts)
    startVal = centers(binStarts(i));
    endVal   = centers(binEnds(i)+1) - 1;  % inclusive end
    matchedRanges{i} = [startVal, endVal];
    fprintf('  Range %d: %d–%d licks (%d matched trials/bin)\n', ...
        i, startVal, endVal, ...
        min(sum(histA(binStarts(i):binEnds(i))), sum(histB(binStarts(i):binEnds(i)))));
end

end
