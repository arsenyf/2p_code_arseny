function [p_val_lick, reward_coeff_small, reward_coeff_large, p_val_LLR_small, p_val_LLR_large] = ...
    fn_GLM_splitReward_compare(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx)

% Prepare trial indices
idx_reg   = find(reward_type_vector == 0);
idx_small = find(reward_type_vector == 1);
idx_large = find(reward_type_vector == 2);

% Fit REG vs SMALL
[~, reward_coeff_small, p_val_LLR_small, fitModel2_small] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_small],:), ...
                     lickMatrix([idx_reg; idx_small],:), ...
                     reward_type_vector([idx_reg; idx_small]), [0 1]);

% Fit REG vs LARGE
[p_val_lick, reward_coeff_large, p_val_LLR_large, fitModel2_large] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_large],:), ...
                     lickMatrix([idx_reg; idx_large],:), ...
                     reward_type_vector([idx_reg; idx_large]), [0 2]);

% Compute average data traces for all reward types
meanReg   = mean(neuralResponse(idx_reg,:), 1);
meanSmall = mean(neuralResponse(idx_small,:), 1);
meanLarge = mean(neuralResponse(idx_large,:), 1);

% Use one model's fit to predict Model 1 (Lick + Time only) for visualization
fitModel1 = mean([fitModel2_small.fitModel1, fitModel2_large.fitModel1], 2);

% Normalize all responses
maxVal = max([meanReg, meanSmall, meanLarge, fitModel1(:)', ...
              fitModel2_small.fit_small(:)', fitModel2_large.fit_large(:)']);

colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};
labels = {'Regular', 'Small', 'Large'};

% Plot all in one figure
figure;
set(gcf, 'Position', [100 100 1200 400]);

% Subplot 1: Real Data
subplot(1,3,1); hold on;
plot(timeBins, meanReg / maxVal, 'Color', colors{1}, 'LineWidth', 2);
plot(timeBins, meanSmall / maxVal, 'Color', colors{2}, 'LineWidth', 2);
plot(timeBins, meanLarge / maxVal, 'Color', colors{3}, 'LineWidth', 2);
title(sprintf('Cell %d: Normalized Data', cell_idx));
legend(labels); ylim([0 1]); grid on;
xlabel('Time (s)'); ylabel('Normalized Response');

% Subplot 2: Model 1 prediction (same for all)
subplot(1,3,2); hold on;
plot(timeBins, fitModel1 / maxVal, '--k', 'LineWidth', 2);
title('Model 1: Lick + Time'); ylim([0 1]); grid on;
xlabel('Time (s)');

% Subplot 3: Model 2 predictions (Reg vs Small + Reg vs Large combined)
subplot(1,3,3); hold on;
plot(timeBins, fitModel2_small.fit_small / maxVal, 'Color', colors{2}, 'LineWidth', 2);
plot(timeBins, fitModel2_large.fit_large / maxVal, 'Color', colors{3}, 'LineWidth', 2);
plot(timeBins, fitModel2_large.fit_reg / maxVal, 'Color', colors{1}, 'LineWidth', 2);
title('Model 2: Lick + Time + Reward'); ylim([0 1]); grid on;
xlabel('Time (s)');
end


function [p_lick, reward_coeff, p_val_LLR, fitOut] = fit_glm_pairwise(timeBins, neuralResponse, lickMatrix, rewardVec, rewardLevels)

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
order = 4;
nInternalKnots = 5;
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
for k = 0:1
    idx = RewardBin == k;
    meanLick(:,k+1) = mean(LickMat(idx,:), 1)';
end

X1_plot = [mean(meanLick,2), timeSplinePlot];
fitModel1 = exp([ones(nTimepoints,1) X1_plot] * b1);

% Model 2 predictions
X2_reg = [meanLick(:,1), zeros(nTimepoints,1), timeSplinePlot];
X2_alt = [meanLick(:,2), ones(nTimepoints,1),  timeSplinePlot];
fitReg  = exp([ones(nTimepoints,1) X2_reg] * b2);
fitAlt  = exp([ones(nTimepoints,1) X2_alt] * b2);

fitOut = struct('fitModel1', fitModel1, 'fit_reg', fitReg, 'fit_small', [], 'fit_large', []);
if rewardLevels(2) == 1
    fitOut.fit_small = fitAlt;
else
    fitOut.fit_large = fitAlt;
end
end
