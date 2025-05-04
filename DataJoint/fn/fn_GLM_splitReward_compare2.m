function [p_val_lick_model1, p_val_lick_model2, reward_coeff_small, reward_coeff_large, p_val_LLR_small, p_val_LLR_large, fitPair_large, fitPair_small] = ...
    fn_GLM_splitReward_compare2(timeBins, reward_type_vector, neuralResponse, lickMatrix, roi_numbers, key, flag_plot_cells, SPLINE_PARAM)



% ============ Begin main function body ============

% Prepare trial indices
idx_reg   = find(reward_type_vector == 0);
idx_small = find(reward_type_vector == 1);
idx_large = find(reward_type_vector == 2);

% Fit REG vs SMALL
[p_val_lick_small, reward_coeff_small, p_val_LLR_small, fitPair_small] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_small],:), ...
    lickMatrix([idx_reg; idx_small],:), ...
    reward_type_vector([idx_reg; idx_small]), [0 1], SPLINE_PARAM);

% Fit REG vs LARGE
[p_val_lick_large, reward_coeff_large, p_val_LLR_large, fitPair_large] = ...
    fit_glm_pairwise(timeBins, neuralResponse([idx_reg; idx_large],:), ...
    lickMatrix([idx_reg; idx_large],:), ...
    reward_type_vector([idx_reg; idx_large]), [0 2], SPLINE_PARAM);

% Average p-values for lick predictor across both comparisons
p_val_lick_model1 = mean([p_val_lick_small.model1, p_val_lick_large.model1]);
p_val_lick_model2 = mean([p_val_lick_small.model2, p_val_lick_large.model2]);


if flag_plot_cells==1
    % Compute average data traces for all reward types
    meanReg   = mean(neuralResponse(idx_reg,:), 1);
    meanSmall = mean(neuralResponse(idx_small,:), 1);
    meanLarge = mean(neuralResponse(idx_large,:), 1);
    
    % Normalize all responses
    maxVal = max([meanReg, meanSmall, meanLarge]);
    
    colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};
    % labels = {'Regular', 'Small', 'Large'};
    
    % Subplot 1: Real Data
    subplot(2,4,1); hold on;
    plot([0,0],[0,1],'-k','linewidth',0.25);
    shadedErrorBar(timeBins, meanReg / maxVal, std(neuralResponse(idx_reg,:), [], 1) / sqrt(length(idx_reg)) / maxVal, 'lineprops', {'Color', colors{1}, 'LineWidth', 2});
    shadedErrorBar(timeBins, meanSmall / maxVal, std(neuralResponse(idx_small,:), [], 1) / sqrt(length(idx_small)) / maxVal, 'lineprops', {'Color', colors{2}, 'LineWidth', 2});
    shadedErrorBar(timeBins, meanLarge / maxVal, std(neuralResponse(idx_large,:), [], 1) / sqrt(length(idx_large)) / maxVal, 'lineprops', {'Color', colors{3}, 'LineWidth', 2});
    title(sprintf(' Animal %d S%d roi = %d \n Real tuning \n', key.subject_id, key.session, roi_numbers));
    ylim([0 1]);
    xlabel('Time to 1st contact-lick (s)');
    ylabel('Activity (norm.)');
    xlim([timeBins(1) timeBins(end)]);
    
    % Subplot 2: Model 1 prediction by reward group
    subplot(2,4,2); hold on;
    plot([0,0],[0,1],'-k','linewidth',0.25)
    shadedErrorBar(timeBins, fitPair_large.model1_mean_by_reward(1,:) / maxVal, fitPair_large.model1_sem_by_reward(1,:) / maxVal, 'lineprops', {'-', 'Color', colors{1}});
    shadedErrorBar(timeBins, fitPair_small.model1_mean_by_reward(2,:) / maxVal, fitPair_small.model1_sem_by_reward(2,:) / maxVal, 'lineprops', {'-', 'Color', colors{2}});
    shadedErrorBar(timeBins, fitPair_large.model1_mean_by_reward(3,:) / maxVal, fitPair_large.model1_sem_by_reward(3,:) / maxVal, 'lineprops', {'-', 'Color', colors{3}});
    title(sprintf('Model 1: \n Lick + Time')); ylim([0 1]);
    ylim([0 1]);
    % xlabel('Time to 1st contact-lick (s)');
    % ylabel('Activity (norm.)');
    xlim([timeBins(1) timeBins(end)]);
    
    
    % Subplot 3: Model 2 predictions
    subplot(2,4,3); hold on;
    plot([0,0],[0,1],'-k','linewidth',0.25)
    shadedErrorBar(timeBins, fitPair_large.model2_mean_by_reward(1,:) / maxVal, fitPair_large.model2_sem_by_reward(1,:) / maxVal, 'lineprops', {'-', 'Color', colors{1}});
    shadedErrorBar(timeBins, fitPair_small.model2_mean_by_reward(2,:) / maxVal, fitPair_small.model2_sem_by_reward(2,:) / maxVal, 'lineprops', {'-', 'Color', colors{2}});
    shadedErrorBar(timeBins, fitPair_large.model2_mean_by_reward(3,:) / maxVal, fitPair_large.model2_sem_by_reward(3,:) / maxVal, 'lineprops', {'-', 'Color', colors{3}});
    title(sprintf('Model 2: \n Lick + Time + Reward')); ylim([0 1]);
    ylim([0 1]);
    % xlabel('Time to 1st contact-lick (s)');
    % ylabel('Activity (norm.)');
    xlim([timeBins(1) timeBins(end)]);
    
    
    % Subplot 4: Predicted response with licks in both models
    subplot(2,4,4); hold on;
    plot([0,0],[0,1],'-k','linewidth',0.25)
    plot(timeBins, fitPair_large.model1_pred_with_lick / maxVal, '--k', 'LineWidth', 2);
    plot(timeBins, fitPair_large.model2_pred_with_lick / maxVal, '-r', 'LineWidth', 2);
    title('Lick Response');
    legend({'Model 1', 'Model 2'});
    ylim([0 1]);
    xlabel('Time to 1st contact-lick (s)');
    ylabel('Activity (norm.)');
    xlim([timeBins(1) timeBins(end)]);
end

end





% Internal function declaration
function [p_vals, reward_coeff, p_val_LLR, out] = fit_glm_pairwise(timeBins, neuralResponse, lickMatrix, rewardVec, rewardLevels, SPLINE_PARAM)

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
order = SPLINE_PARAM.order;
nInternalKnots = SPLINE_PARAM.nInternalKnots;
knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
augKnots = augknt(knots, order);
TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
TimeSpline = fnval(TimeSplineBasis, TimeVector')';

% Model 1
X1 = [Lick, TimeSpline];
[b1, dev1, stats1] = glmfit(X1, Y, 'poisson');
p_val_lick_model1 = stats1.p(2);

% Model 2
X2 = [Lick, RewardExpanded, TimeSpline];
[b2, dev2, stats2] = glmfit(X2, Y, 'poisson');
p_val_lick_model2 = stats2.p(2);
reward_coeff = b2(3);
LLR_stat = dev1 - dev2;
df = size(X2,2) - size(X1,2);
p_val_LLR = 1 - chi2cdf(LLR_stat, df);

% Predictions per trial for SEM calculation
LickMat = reshape(Lick, nTrials, nTimepoints);
timeSplinePlot = fnval(TimeSplineBasis, timeBins')';

preds_model1 = zeros(nTrials, nTimepoints);
preds_model2 = zeros(nTrials, nTimepoints);

for i = 1:nTrials
    X1_trial = [LickMat(i,:)', timeSplinePlot];
    X1_with_intercept = [ones(nTimepoints,1), X1_trial];
    preds_model1(i,:) = (exp(X1_with_intercept * b1))';
    
    reward_val = RewardBin(i);
    X2_trial = [LickMat(i,:)', repmat(reward_val, nTimepoints,1), timeSplinePlot];
    X2_with_intercept = [ones(nTimepoints,1), X2_trial];
    preds_model2(i,:) = (exp(X2_with_intercept * b2))';
end

% Compute mean and SEM per reward type
model1_mean_by_reward = zeros(3, nTimepoints);
model1_sem_by_reward  = zeros(3, nTimepoints);
model2_mean_by_reward = zeros(3, nTimepoints);
model2_sem_by_reward  = zeros(3, nTimepoints);

for r = 0:2
    idx_r = find(rewardVec == r);
    model1_mean_by_reward(r+1,:) = mean(preds_model1(idx_r,:), 1);
    model1_sem_by_reward(r+1,:)  = std(preds_model1(idx_r,:), [], 1) / sqrt(length(idx_r));
    model2_mean_by_reward(r+1,:) = mean(preds_model2(idx_r,:), 1);
    model2_sem_by_reward(r+1,:)  = std(preds_model2(idx_r,:), [], 1) / sqrt(length(idx_r));
end

% Predict licking effect
lick_1 = ones(nTimepoints,1);
lick_0 = zeros(nTimepoints,1);

X1_lick = [lick_1, fnval(TimeSplineBasis, timeBins')'];
X2_lick = [lick_1, zeros(nTimepoints,1), fnval(TimeSplineBasis, timeBins')'];

model1_pred_with_lick = exp([ones(nTimepoints,1), X1_lick] * b1);
model2_pred_with_lick = exp([ones(nTimepoints,1), X2_lick] * b2);



% Real model outputs
out = struct('model1_mean_by_reward', model1_mean_by_reward, ...
    'model1_sem_by_reward', model1_sem_by_reward, ...
    'model2_mean_by_reward', model2_mean_by_reward, ...
    'model2_sem_by_reward', model2_sem_by_reward, ...
    'model1_pred_with_lick', model1_pred_with_lick,  ...
    'model2_pred_with_lick', model2_pred_with_lick);

p_vals = struct('model1', p_val_lick_model1, 'model2', p_val_lick_model2);
end
