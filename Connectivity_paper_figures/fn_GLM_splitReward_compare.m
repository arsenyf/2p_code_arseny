function [p_val_lick, reward_coeff_small, reward_coeff_large, p_val_LLR_small, p_val_LLR_large] = ...
    fn_GLM_splitReward_compare(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx)

% Prepare trial indices
idx_reg   = find(reward_type_vector == 0);
idx_small = find(reward_type_vector == 1);
idx_large = find(reward_type_vector == 2);

% Fit REG vs SMALL
[~, reward_coeff_small, p_val_LLR_small, fitPair_small] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_small],:), ...
                     lickMatrix([idx_reg; idx_small],:), ...
                     reward_type_vector([idx_reg; idx_small]), [0 1]);

% Fit REG vs LARGE
[p_val_lick, reward_coeff_large, p_val_LLR_large, fitPair_large] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_large],:), ...
                     lickMatrix([idx_reg; idx_large],:), ...
                     reward_type_vector([idx_reg; idx_large]), [0 2]);

% Compute average data traces for all reward types
meanReg   = mean(neuralResponse(idx_reg,:), 1);
meanSmall = mean(neuralResponse(idx_small,:), 1);
meanLarge = mean(neuralResponse(idx_large,:), 1);

% Normalize all responses
maxVal = max([meanReg, meanSmall, meanLarge, ...
              fitPair_small.model2_alt(:)', fitPair_large.model2_alt(:)', ...
              fitPair_small.model1_by_reward(:)', fitPair_large.model1_by_reward(:)']);

colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};
labels = {'Regular', 'Small', 'Large'};

% Plot all in one figure


% Subplot 1: Real Data
subplot(1,3,1); hold on;
plot(timeBins, meanReg / maxVal, 'Color', colors{1}, 'LineWidth', 2);
plot(timeBins, meanSmall / maxVal, 'Color', colors{2}, 'LineWidth', 2);
plot(timeBins, meanLarge / maxVal, 'Color', colors{3}, 'LineWidth', 2);
title(sprintf('Cell %d: Normalized Data', cell_idx));
legend(labels); ylim([0 1]); grid on;
xlabel('Time (s)'); ylabel('Normalized Response');

% Subplot 2: Model 1 prediction by reward group
subplot(1,3,2); hold on;
plot(timeBins, fitPair_small.model1_by_reward(:,2) / maxVal, '--', 'Color', colors{2}, 'LineWidth', 2);
plot(timeBins, fitPair_large.model1_by_reward(:,2) / maxVal, '--', 'Color', colors{3}, 'LineWidth', 2);
plot(timeBins, fitPair_large.model1_by_reward(:,1) / maxVal, '--', 'Color', colors{1}, 'LineWidth', 2);
title('Model 1: Lick + Time (per reward)'); ylim([0 1]); grid on;
xlabel('Time (s)');

% Subplot 3: Model 2 predictions
subplot(1,3,3); hold on;
plot(timeBins, fitPair_small.model2_alt / maxVal, 'Color', colors{2}, 'LineWidth', 2);
plot(timeBins, fitPair_large.model2_alt / maxVal, 'Color', colors{3}, 'LineWidth', 2);
plot(timeBins, fitPair_large.model2_baseline / maxVal, 'Color', colors{1}, 'LineWidth', 2);
title('Model 2: Lick + Time + Reward'); ylim([0 1]); grid on;
xlabel('Time (s)');
end


function [p_lick, reward_coeff, p_val_LLR, out] = fit_glm_pairwise(timeBins, neuralResponse, lickMatrix, rewardVec, rewardLevels)

nTrials = size(neuralResponse, 1);
nTimepoints = numel(timeBins);
Y = neuralResponse(:);
Lick = lickMatrix(:);
RewardBin = rewardVec;
RewardBin(rewardVec == rewardLevels(1)) = 0;
RewardBin(rewardVec == rewardLevels(2)) = 1;
RewardExpanded = repmat(RewardBin, nTimepoints, 1);
TimeVector = repmat(timeBins, nTrials, 1);
TimeVector = TimeVector(:);

% Spline basis
order = 3; %4
nInternalKnots = 4; %5
knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
augKnots = augknt(knots, order);
TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
TimeSpline = fnval(TimeSplineBasis, TimeVector')';

% Model 1
X1 = [Lick, TimeSpline];
[b1, dev1, stats1] = glmfit(X1, Y, 'poisson');
p_lick = stats1.p(2);

% Model 2
X2 = [Lick, RewardExpanded, TimeSpline];
[b2, dev2, stats2] = glmfit(X2, Y, 'poisson');
reward_coeff = b2(3);
LLR_stat = dev1 - dev2;
df = size(X2,2) - size(X1,2);
p_val_LLR = 1 - chi2cdf(LLR_stat, df);

% Generate model predictions
timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
LickMat = reshape(Lick, nTrials, nTimepoints);
meanLick = zeros(nTimepoints, 2);
model1_by_reward = zeros(nTimepoints, 2);
for k = 0:1
    idx = RewardBin == k;
    meanLick(:,k+1) = mean(LickMat(idx,:), 1)';
    X1_plot_k = [meanLick(:,k+1), timeSplinePlot];
    model1_by_reward(:,k+1) = exp([ones(nTimepoints,1), X1_plot_k] * b1);
end

% Model 1 (averaged)
X1_plot = [mean(meanLick,2), timeSplinePlot];
model1_avg = exp([ones(nTimepoints,1) X1_plot] * b1);

% Model 2 predictions
X2_baseline = [meanLick(:,1), zeros(nTimepoints,1), timeSplinePlot];
X2_alt = [meanLick(:,2), ones(nTimepoints,1),  timeSplinePlot];
model2_baseline = exp([ones(nTimepoints,1) X2_baseline] * b2);
model2_alt = exp([ones(nTimepoints,1) X2_alt] * b2);

out = struct('model1_avg', model1_avg, 'model1_by_reward', model1_by_reward, ...
             'model2_baseline', model2_baseline, 'model2_alt', model2_alt);
end
