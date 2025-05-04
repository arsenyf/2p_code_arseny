function [p_val_lick, reward_coeff_small, reward_coeff_large, p_val_LLR] = ...
    fn_GLM_reward_flex_plot(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx, doSubsample)

% Inputs:
% timeBins             - 1 x nTimepoints vector
% reward_type_vector   - nTrials x 1 (0 = regular, 1 = small, 2 = large)
% neuralResponse       - nTrials x nTimepoints matrix
% lickMatrix           - nTrials x nTimepoints matrix
% cell_idx             - for RNG and title
% doSubsample          - if true, balances trial numbers across reward types

% Optional subsampling
if doSubsample
    nTrialsPerClass = histcounts(reward_type_vector, [-0.5, 0.5, 1.5, 2.5]);
    minTrials = min(nTrialsPerClass);
    balancedIdx = [];

    rng(cell_idx);  % reproducible per neuron
    for rewardType = 0:2
        candidateIdx = find(reward_type_vector == rewardType);
        balancedIdx = [balancedIdx; candidateIdx(randperm(length(candidateIdx), minTrials))];
    end

    reward_type_vector = reward_type_vector(balancedIdx);
    neuralResponse = neuralResponse(balancedIdx,:);
    lickMatrix = lickMatrix(balancedIdx,:);
end

% Basic setup
nTrials = numel(reward_type_vector);
nTimepoints = numel(timeBins);
Y = neuralResponse(:);
Lick = lickMatrix(:);
RewardExpanded = repmat(reward_type_vector, nTimepoints, 1);
TimeVector = repmat(timeBins, nTrials, 1);
TimeVector = TimeVector(:);

% Spline basis
order = 4;
nInternalKnots = 5;
knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
augKnots = augknt(knots, order);
TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
TimeSpline = fnval(TimeSplineBasis, TimeVector')';

% Dummy coding reward
RewardCategorical = categorical(reward_type_vector);
RewardDummy = dummyvar(RewardCategorical);
RewardDummy = RewardDummy(:, 2:end);
RewardExpandedDummy = repmat(RewardDummy, nTimepoints, 1);

%% Fit models
X1 = [Lick, TimeSpline];
[b1, dev1, stats1] = glmfit(X1, Y, 'poisson');
p_val_lick = stats1.p(2);

X2 = [Lick, RewardExpandedDummy, TimeSpline];
[b2, dev2, stats2] = glmfit(X2, Y, 'poisson');
reward_coeff_small = b2(3);
reward_coeff_large = b2(4);

LLR_stat = dev1 - dev2;
df = size(X2,2) - size(X1,2);
p_val_LLR = 1 - chi2cdf(LLR_stat, df);

fprintf('Cell %d | Model 1 dev=%.2f, Model 2 dev=%.2f, LLR=%.2f, p=%.2e\n', ...
    cell_idx, dev1, dev2, LLR_stat, p_val_LLR);

%% Prediction and plotting
timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
meanLick = zeros(nTimepoints,3);
for k = 0:2
    idx = reward_type_vector == k;
    meanLick(:,k+1) = mean(lickMatrix(idx,:), 1)';
end

% Model predictions
RewardDummyFull = [0 0; 1 0; 0 1];
fitModel1 = zeros(nTimepoints,3);
fitModel2 = zeros(nTimepoints,3);
for k = 1:3
    % Model 1
    X1_plot = [meanLick(:,k), timeSplinePlot];
    fitModel1(:,k) = exp([ones(nTimepoints,1) X1_plot] * b1);

    % Model 2
    reward_k = repmat(RewardDummyFull(k,:), nTimepoints, 1);
    X2_plot = [meanLick(:,k), reward_k, timeSplinePlot];
    fitModel2(:,k) = exp([ones(nTimepoints,1) X2_plot] * b2);
end

% Normalize
meanReg   = mean(neuralResponse(reward_type_vector == 0,:), 1);
meanSmall = mean(neuralResponse(reward_type_vector == 1,:), 1);
meanLarge = mean(neuralResponse(reward_type_vector == 2,:), 1);
maxData = max([max(meanReg), max(meanSmall), max(meanLarge), max(fitModel1(:)), max(fitModel2(:))]);

% Colors and labels
colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};
labels = {'Regular reward', 'Small reward', 'Large reward'};
set(gcf, 'Position', [100 100 1200 500]);

%% Plot: original data
subplot(2,3,1); hold on;
for k = 0:2
    idx = reward_type_vector == k;
    plot(timeBins, mean(neuralResponse(idx,:), 1) / maxData, 'Color', colors{k+1}, 'LineWidth', 2);
end
legend(labels, 'Location', 'Best');
title(sprintf('Cell %d: Normalized Data', cell_idx));
xlabel('Time (s)'); ylabel('Norm Activity'); ylim([0 1]); grid on;

%% Plot: Model 1
subplot(2,3,2); hold on;
for k = 1:3
    plot(timeBins, fitModel1(:,k) / maxData, '--', 'Color', colors{k}, 'LineWidth', 2);
end
title('Model 1: Lick + Time'); ylim([0 1]); grid on;

%% Plot: Model 2
subplot(2,3,3); hold on;
for k = 1:3
    plot(timeBins, fitModel2(:,k) / maxData, '-', 'Color', colors{k}, 'LineWidth', 2);
end
title('Model 2: Lick + Reward + Time'); ylim([0 1]); grid on;

%% Subplot 4: Lick Effect Kernel
subplot(2,3,4); hold on;
lickVals = [0, 1];
predictedLickEffect = zeros(nTimepoints, 2);

for i = 1:2
    lickCol = ones(nTimepoints,1) * lickVals(i);
    rewardDummyZero = zeros(nTimepoints, size(RewardDummyFull,2));
    Xplot = [lickCol, rewardDummyZero, timeSplinePlot];
    pred = exp([ones(nTimepoints,1), Xplot] * b2);
    predictedLickEffect(:,i) = pred;
end

predictedLickEffect = predictedLickEffect / max(predictedLickEffect(:));
plot(timeBins, predictedLickEffect(:,1), '--k', 'LineWidth', 2);
plot(timeBins, predictedLickEffect(:,2), '-r',  'LineWidth', 2);
legend({'No Lick', 'Lick Present'}, 'Location', 'Best');
xlabel('Time (s)'); ylabel('Norm Prediction');
title('Predicted Effect of Licking'); ylim([0 1]); grid on; hold off;

end


% function [p_val_lick, reward_coeff_small, reward_coeff_large, p_val_LLR] = fn_GLM_reward_subsample_plot(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx)
% 
% % Subsampling to balance reward conditions
% nTrialsPerClass = histcounts(reward_type_vector, [-0.5, 0.5, 1.5, 2.5]);  % counts for 0,1,2
% minTrials = min(nTrialsPerClass);
% 
% balancedIdx = [];
% rng(cell_idx);  % reproducible sampling per neuron
% for rewardType = 0:2
%     candidateIdx = find(reward_type_vector == rewardType);
%     balancedIdx = [balancedIdx; candidateIdx(randperm(length(candidateIdx), minTrials))];
% end
% 
% % Subsample data
% reward_type_vector_bal = reward_type_vector(balancedIdx);
% neuralResponse_bal = neuralResponse(balancedIdx, :);
% lickMatrix_bal = lickMatrix(balancedIdx, :);
% 
% nTrials = numel(reward_type_vector_bal);
% nTimepoints = numel(timeBins);
% 
% % Prepare predictors
% Y = neuralResponse_bal(:);
% Lick = lickMatrix_bal(:);
% RewardExpanded = repmat(reward_type_vector_bal, nTimepoints, 1);
% TimeVector = repmat(timeBins, nTrials, 1);
% TimeVector = TimeVector(:);
% 
% % Spline basis
% order = 4;
% nInternalKnots = 5;
% knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
% augKnots = augknt(knots, order);
% TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
% TimeSpline = fnval(TimeSplineBasis, TimeVector')';
% 
% % Dummy coding for reward
% RewardCategorical = categorical(reward_type_vector_bal);
% RewardDummy = dummyvar(RewardCategorical);
% RewardDummy = RewardDummy(:, 2:end);
% RewardExpandedDummy = repmat(RewardDummy, nTimepoints, 1);
% 
% %% Fit models
% X1 = [Lick, TimeSpline];
% [b1, dev1, stats1] = glmfit(X1, Y, 'poisson');
% p_val_lick = stats1.p(2);
% 
% X2 = [Lick, RewardExpandedDummy, TimeSpline];
% [b2, dev2, stats2] = glmfit(X2, Y, 'poisson');
% % reward_coeffs = b2(3:2+size(RewardExpandedDummy,2));
% reward_coeff_small = b2(3); 
% reward_coeff_large =  b2(4);
% LLR_stat = dev1 - dev2;
% df = size(X2,2) - size(X1,2);
% p_val_LLR = 1 - chi2cdf(LLR_stat, df);
% 
% fprintf('Balanced: Model 1 dev=%.2f, Model 2 dev=%.2f, LLR=%.2f, p=%.4e\n', dev1, dev2, LLR_stat, p_val_LLR);
% 
% %% Predict for plotting
% timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
% 
% meanLick = zeros(nTimepoints,3);
% for k = 0:2
%     idx = reward_type_vector_bal == k;
%     meanLick(:,k+1) = mean(lickMatrix_bal(idx,:), 1)';
% end
% 
% % Model 1 predictions
% fitModel1 = zeros(nTimepoints,3);
% for k = 1:3
%     X1_plot = [meanLick(:,k), timeSplinePlot];
%     fitModel1(:,k) = exp([ones(nTimepoints,1) X1_plot] * b1);
% end
% 
% % Model 2 predictions
% RewardDummyFull = [0 0; 1 0; 0 1];
% fitModel2 = zeros(nTimepoints,3);
% for k = 1:3
%     reward_k = repmat(RewardDummyFull(k,:), nTimepoints, 1);
%     X2_plot = [meanLick(:,k), reward_k, timeSplinePlot];
%     fitModel2(:,k) = exp([ones(nTimepoints,1) X2_plot] * b2);
% end
% 
% %% Normalize and plot
% meanReg   = mean(neuralResponse_bal(reward_type_vector_bal == 0,:), 1);
% meanSmall = mean(neuralResponse_bal(reward_type_vector_bal == 1,:), 1);
% meanLarge = mean(neuralResponse_bal(reward_type_vector_bal == 2,:), 1);
% 
% maxData = max([max(meanReg), max(meanSmall), max(meanLarge), max(fitModel1(:)), max(fitModel2(:))]);
% 
% set(gcf, 'Position', [100 100 1200 400]);
% colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};
% labels = {'Regular reward', 'Small reward', 'Large reward'};
% 
% % Subplot 1: Original data
% subplot(2,3,1);
% hold on;
% for k = 0:2
%     idx = reward_type_vector_bal == k;
%     meanData = mean(neuralResponse_bal(idx,:), 1);
%     plot(timeBins, meanData / maxData, 'Color', colors{k+1}, 'LineWidth', 2);
% end
% legend(labels, 'Location', 'Best');
% title(sprintf('Cell %d: Normalized Data (Balanced)', cell_idx), 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Activity'); ylim([0 1]); grid on; hold off;
% 
% % Subplot 2: Model 1 predictions
% subplot(2,3,2);
% hold on;
% for k = 1:3
%     plot(timeBins, fitModel1(:,k) / maxData, '--', 'Color', colors{k}, 'LineWidth', 2);
% end
% title('Model 1: Lick + Time (Normalized)', 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Prediction'); ylim([0 1]); grid on; hold off;
% 
% % Subplot 3: Model 2 predictions
% subplot(2,3,3);
% hold on;
% for k = 1:3
%     plot(timeBins, fitModel2(:,k) / maxData, '-', 'Color', colors{k}, 'LineWidth', 2);
% end
% title('Model 2: Lick + Reward + Time (Normalized)', 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Prediction'); ylim([0 1]); grid on; hold off;
% 
% 
% %% Subplot 4: Lick Effect Kernel (Model 2 if available, else Model 1)
% subplot(2,3,4);  % new panel
% hold on;
% 
% % Spline basis at plotting time bins
% timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
% 
% % Simulate two scenarios: no lick vs. lick
% lickVals = [0, 1];
% predictedLickEffect = zeros(nTimepoints, 2);
% 
% for i = 1:2
%     lickCol = ones(nTimepoints,1) * lickVals(i);
% 
%     if exist('b2', 'var') && length(b2) >= 4  % model with reward
%         rewardDummyZero = zeros(nTimepoints, size(RewardDummyFull,2));  % reward fixed at baseline (regular)
%         Xplot = [lickCol, rewardDummyZero, timeSplinePlot];
%         pred = exp([ones(nTimepoints,1), Xplot] * b2);
%     else  % fallback to model 1
%         Xplot = [lickCol, timeSplinePlot];
%         pred = exp([ones(nTimepoints,1), Xplot] * b1);
%     end
% 
%     predictedLickEffect(:,i) = pred;
% end
% 
% % Normalize for fair comparison
% predictedLickEffect = predictedLickEffect / max(predictedLickEffect(:));
% 
% % Plot
% plot(timeBins, predictedLickEffect(:,1), '--k', 'LineWidth', 2);  % No Lick
% plot(timeBins, predictedLickEffect(:,2), '-r', 'LineWidth', 2);   % Lick
% 
% legend({'No Lick', 'Lick Present'}, 'Location', 'Best');
% xlabel('Time (s)');
% ylabel('Normalized Prediction');
% title('Predicted Effect of Licking');
% ylim([0 1]);
% grid on; hold off;
% 
% 
% end