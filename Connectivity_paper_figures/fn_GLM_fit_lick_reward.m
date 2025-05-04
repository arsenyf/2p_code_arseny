function [p_val_lick, reward_coeff_small, reward_coeff_large, p_val_LLR] = fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx)

nTrials = numel(reward_type_vector);
nTimepoints = numel(timeBins);

Y = neuralResponse(:);
Lick = lickMatrix(:);

% Expand Reward and Time
RewardExpanded = repmat(reward_type_vector, nTimepoints, 1);
TimeVector = repmat(timeBins, nTrials, 1);
TimeVector = TimeVector(:);

% Create Time Spline basis
order = 4;
nInternalKnots = 5;
knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
augKnots = augknt(knots, order);
TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
TimeSpline = fnval(TimeSplineBasis, TimeVector')';

% Create reward dummy variables (categorical coding)
RewardCategorical = categorical(reward_type_vector);
RewardDummy = dummyvar(RewardCategorical);
RewardDummy = RewardDummy(:, 2:end);  % drop the reference category
RewardExpandedDummy = repmat(RewardDummy, nTimepoints, 1);

%% Fit Model 1: Lick + Time
X1 = [Lick, TimeSpline];
warning('off')
[b1, dev1, stats1] = glmfit(X1, Y, 'poisson');
warning('on')

p_val_lick = stats1.p(2);  % p-value for Lick

%% Fit Model 2: Lick + RewardDummy + TimeSpline
X2 = [Lick, RewardExpandedDummy, TimeSpline];
warning('off')
[b2, dev2, stats2] = glmfit(X2, Y, 'poisson');
warning('on')

% Save reward coefficients (one per category beyond the reference)
% reward_coeffs = b2(3:2+size(RewardExpandedDummy,2));
reward_coeff_small = b2(3);
reward_coeff_large = b2(4);

%% Likelihood ratio test for reward
LLR_stat = dev1 - dev2;
df = size(X2,2) - size(X1,2);
p_val_LLR = 1 - chi2cdf(LLR_stat, df);

fprintf('Model 1 deviance: %.2f\n', dev1);
fprintf('Model 2 deviance: %.2f\n', dev2);
fprintf('Likelihood Ratio: %.2f\n', LLR_stat);
fprintf('p-value for Reward effect: %.4f\n', p_val_LLR);

%% Prepare predictions for plotting
% Spline for plotting
timeSplinePlot = fnval(TimeSplineBasis, timeBins')';

% Calculate mean lick per reward type
meanLick = zeros(nTimepoints, 3);
for k = 0:2
    idx = reward_type_vector == k;
    meanLick(:, k+1) = mean(lickMatrix(idx, :), 1)';
end

% Model 1 predictions (reward absent)
fitModel1 = zeros(nTimepoints, 3);
for k = 1:3
    X1_plot = [meanLick(:,k), timeSplinePlot];
    fitModel1(:,k) = exp([ones(nTimepoints,1) X1_plot] * b1);
end

% Model 2 predictions (reward included)
RewardDummyFull = [0 0; 1 0; 0 1];  % reference = regular, then small, large
fitModel2 = zeros(nTimepoints, 3);
for k = 1:3
    reward_k = repmat(RewardDummyFull(k,:), nTimepoints, 1);
    X2_plot = [meanLick(:,k), reward_k, timeSplinePlot];
    fitModel2(:,k) = exp([ones(nTimepoints,1) X2_plot] * b2);
end

%% Compute normalization factor
meanReg   = mean(neuralResponse(reward_type_vector == 0, :), 1);
meanSmall = mean(neuralResponse(reward_type_vector == 1, :), 1);
meanLarge = mean(neuralResponse(reward_type_vector == 2, :), 1);

maxData = max([
    max(meanReg), max(meanSmall), max(meanLarge), max(fitModel1(:)), max(fitModel2(:))
]);

%% Plotting normalized results
colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};  % Blue, Green, Orange
labels = {'Regular reward', 'Small reward', 'Large reward'};

% Subplot 1: Original data
subplot(2,3,1);
hold on;
for k = 0:2
    idx = reward_type_vector == k;
    meanData = mean(neuralResponse(idx,:), 1);
    plot(timeBins, meanData / maxData, 'Color', colors{k+1}, 'LineWidth', 2);
end
legend(labels, 'Location', 'Best');
title(sprintf('Cell %d: Real tuning', cell_idx), 'FontSize', 12);
xlabel('Time to 1st contact-lick (s)'); ylabel('Normalized Activity');
ylim([0 1]); grid off; hold off;

% Subplot 2: Model 1 predictions
subplot(2,3,2);
hold on;
for k = 1:3
    plot(timeBins, fitModel1(:,k) / maxData, '-', 'Color', colors{k}, 'LineWidth', 2);
end
title('GLM 1 fit: Lick + Time', 'FontSize', 12);
xlabel('Time to 1st contact-lick (s)'); ylabel('Normalized Prediction');
ylim([0 1]); grid off; hold off;

% Subplot 3: Model 2 predictions
subplot(2,3,3);
hold on;
for k = 1:3
    plot(timeBins, fitModel2(:,k) / maxData, '-', 'Color', colors{k}, 'LineWidth', 2);
end
title('GLM fit: Lick + Time +  Reward', 'FontSize', 12);
xlabel('Time to 1st contact-lick (s)'); ylabel('Normalized Prediction');
ylim([0 1]); grid off; hold off;

end



% function   [p_val_lick reward_coeffs p_val_LLR] =  fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse, lickMatrix, cell_idx)
% 
% nTrials = numel(reward_type_vector);
% nTimepoints = numel(timeBins);
% 
% % Flatten responses
% Y = neuralResponse(:);
% Lick = lickMatrix(:);
% 
% % Expand Reward for each time bin
% RewardExpanded = repmat(reward_type_vector, nTimepoints, 1);
% 
% % Time vector expanded for all trials
% TimeVector = repmat(timeBins, nTrials, 1);
% TimeVector = TimeVector(:);
% 
% % Create spline basis for Time
% order = 4;
% nInternalKnots = 5;
% knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);
% augKnots = augknt(knots, order);
% TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
% TimeSpline = fnval(TimeSplineBasis, TimeVector')';
% 
% % Create dummy variables for reward types (categorical coding)
% RewardCategorical = categorical(reward_type_vector);
% RewardDummy = dummyvar(RewardCategorical);
% % Drop the first column to avoid collinearity (MATLAB reference coding)
% RewardDummy = RewardDummy(:, 2:end);
% 
% RewardExpandedDummy = repmat(RewardDummy, nTimepoints, 1);
% 
% %% Model 1: Lick + TimeSpline (no reward)
% X1 = [Lick, TimeSpline];
% [b1, ~, ~] = glmfit(X1, Y, 'poisson');
% 
% %% Model 2: Lick + RewardDummy + TimeSpline (with reward as categorical)
% X2 = [Lick, RewardExpandedDummy, TimeSpline];
% [b2, ~, ~] = glmfit(X2, Y, 'poisson');
% 
% %% Predictions for all reward types
% % Evaluate spline basis at timeBins for plotting
% timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
% 
% % Calculate mean lick rate for each reward type
% meanLick = zeros(nTimepoints, 3);
% for k = 0:2
%     idx = reward_type_vector == k;
%     meanLick(:, k+1) = mean(lickMatrix(idx, :), 1)';
% end
% 
% % Predictions for Model 1 (reward absent)
% fitModel1 = zeros(nTimepoints, 3);
% for k = 1:3
%     X1_plot = [meanLick(:,k), timeSplinePlot];
%     fitModel1(:,k) = exp([ones(nTimepoints,1) X1_plot] * b1);
% end
% 
% % Predictions for Model 2 (reward included)
% RewardDummyFull = [0 0; 1 0; 0 1];  % regular, small, large
% fitModel2 = zeros(nTimepoints, 3);
% for k = 1:3
%     reward_k = repmat(RewardDummyFull(k,:), nTimepoints, 1);
%     X2_plot = [meanLick(:,k), reward_k, timeSplinePlot];
%     fitModel2(:,k) = exp([ones(nTimepoints,1) X2_plot] * b2);
% end
% 
% %% Compute normalization factor
% % Compute maximum across real data and both model fits
% 
% %% Compute maximum value for normalization
% meanReg   = mean(neuralResponse(reward_type_vector == 0, :), 1);
% meanSmall = mean(neuralResponse(reward_type_vector == 1, :), 1);
% meanLarge = mean(neuralResponse(reward_type_vector == 2, :), 1);
% 
% maxData = max([
%     max(meanReg), ...
%     max(meanSmall), ...
%     max(meanLarge), ...
%     max(fitModel1(:)), ...
%     max(fitModel2(:))
% ]);
% 
% %% Plotting with normalization
% set(gcf, 'Position', [100 100 1200 400]);
% 
% % Subplot 1: Original data
% subplot(1,3,1);
% hold on;
% colors = {[0 0 1], [0 0.6 0], [1 0.5 0]};  % Blue, Green, Orange
% labels = {'Regular reward', 'Small reward', 'Large reward'};
% for k = 0:2
%     idx = reward_type_vector == k;
%     meanData = mean(neuralResponse(idx,:), 1);
%     plot(timeBins, meanData / maxData, 'Color', colors{k+1}, 'LineWidth', 2);
% end
% legend(labels, 'Location', 'Best');
% title(sprintf('Cell %d: Normalized Data', cell_idx), 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Activity');
% ylim([0 1]);
% grid on; hold off;
% 
% % Subplot 2: Model 1 (without reward)
% subplot(1,3,2);
% hold on;
% for k = 1:3
%     plot(timeBins, fitModel1(:,k) / maxData, '--', 'Color', colors{k}, 'LineWidth', 2);
% end
% title('Model 1: Lick + Time (Normalized)', 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Prediction');
% ylim([0 1]);
% grid on; hold off;
% 
% % Subplot 3: Model 2 (with reward)
% subplot(1,3,3);
% hold on;
% for k = 1:3
%     plot(timeBins, fitModel2(:,k) / maxData, '-', 'Color', colors{k}, 'LineWidth', 2);
% end
% title('Model 2: Lick + Reward + Time (Normalized)', 'FontSize', 12);
% xlabel('Time (s)'); ylabel('Normalized Prediction');
% ylim([0 1]);
% grid on; hold off;
% 
% 
% end
% 
% 
% 
% % function [p_val_lick reward_coeffs p_val_LLR] = fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse,lickMatrix, subplot_idx)
% % 
% % %% GLM FIT code:
% % nTrials = numel(reward_type_vector);      % nTrials 
% % nTimepoints = numel(timeBins);
% % 
% % Y = neuralResponse(:);                     % Flatten neural responses
% % Lick = lickMatrix(:);                     % Flatten licks
% % 
% % % Expand Reward for each time bin
% % RewardExpanded = repmat(reward_type_vector, nTimepoints, 1);
% % 
% % % Time vector expanded for all trials
% % TimeVector = repmat(timeBins, nTrials, 1);
% % TimeVector = TimeVector(:);
% % 
% % %% Create Safe Spline Basis for Time using spmak + fnval
% % order = 4;  % Cubic spline 4
% % nInternalKnots = 5; %5
% % knots = linspace(min(timeBins), max(timeBins), nInternalKnots + 2);  % include boundaries
% % augKnots = augknt(knots, order);  % augmented knot vector
% % 
% % % Create B-spline basis
% % TimeSplineBasis = spmak(augKnots, eye(length(augKnots) - order));
% % 
% % % Evaluate spline basis safely even with repeated TimeVector
% % TimeSpline = fnval(TimeSplineBasis, TimeVector')';
% % % Now: TimeSpline is [nTrials * nTimepoints] x nBasis
% % 
% % %% Fit Model 1: Lick + TimeSpline
% % X1 = [Lick, TimeSpline];
% % [b1, dev1, stats1] = glmfit(X1, Y, 'poisson');  % Model 1
% % % Save p-value for Lick predictor
% % p_val_lick = stats1.p(2);  % 2nd entry is for Lick
% % 
% % %% Fit Model 2: Lick + Reward + TimeSpline
% % X2 = [Lick, RewardExpanded, TimeSpline];
% % [b2, dev2, stats2] = glmfit(X2, Y, 'poisson');  % Model 2
% % % Reward coefficient (3rd predictor) from Model 2
% % reward_coeffs = b2(3);
% % 
% % %% Comparing the two models
% % % Likelihood ratio statistic:
% % LLR_stat = dev1 - dev2;
% % 
% % % Degrees of freedom: difference in number of predictors
% % df = size(X2,2) - size(X1,2);
% % 
% % % p-value:
% % p_val_LLR = 1 - chi2cdf(LLR_stat, df);
% % 
% % 
% % 
% % fprintf('Model 1 deviance: %.2f\n', dev1);
% % fprintf('Model 2 deviance: %.2f\n', dev2);
% % fprintf('Likelihood Ratio: %.2f\n', LLR_stat);
% % fprintf('p-value for Reward effect: %.4f\n', p_val_LLR);
% % 
% % %% Predict Fits for Regular and Large Reward Conditions
% % RewardReg = zeros(nTimepoints, 1);
% % RewardBig = ones(nTimepoints, 1);
% % 
% % % Evaluate spline basis at the timeBins
% % timeSplinePlot = fnval(TimeSplineBasis, timeBins')';
% % 
% % % Model 1 Predictions (Reward absent — same for both conditions)
% % meanLick_Reg = mean(lickMatrix(reward_type_vector==0,:), 1)';
% % meanLick_Big = mean(lickMatrix(reward_type_vector==1,:), 1)';
% % 
% % X1_Reg = [meanLick_Reg, timeSplinePlot];
% % fitModel1_Reg = exp([ones(nTimepoints,1) X1_Reg] * b1);
% % 
% % X1_Big = [meanLick_Big, timeSplinePlot];
% % fitModel1_Big = exp([ones(nTimepoints,1) X1_Big] * b1);
% % 
% % % Model 2 Predictions
% % X2_Reg = [meanLick_Reg, RewardReg, timeSplinePlot];
% % fitReg_Model2 = exp([ones(nTimepoints,1) X2_Reg] * b2);
% % 
% % X2_Big = [meanLick_Big, RewardBig, timeSplinePlot];
% % fitBig_Model2 = exp([ones(nTimepoints,1) X2_Big] * b2);
% % 
% % %% Plot Real Data vs Model Fits — with clear legend
% % regTrials = reward_type_vector == 0;
% % bigTrials = reward_type_vector == 1;
% % 
% % meanReg = mean(neuralResponse(regTrials,:), 1);
% % meanBig = mean(neuralResponse(bigTrials,:), 1);
% % 
% % if subplot_idx==1
% %     subplot(2,2,1)
% %     hold on;
% %     % Plot real trial-averaged data
% %     p1 = plot(timeBins, meanReg, 'b-', 'LineWidth', 2);
% %     p2 = plot(timeBins, meanBig, 'r-', 'LineWidth', 2);
% %     
% %     % Plot Model 1 fits
% %     p3 = plot(timeBins, fitModel1_Reg, 'b--', 'LineWidth', 2);
% %     p4 = plot(timeBins, fitModel1_Big, 'r--', 'LineWidth', 2);
% %     
% %     % Plot Model 2 fits
% %     p5 = plot(timeBins, fitReg_Model2, 'b.', 'LineWidth', 2.5);
% %     p6 = plot(timeBins, fitBig_Model2, 'r.', 'LineWidth', 2.5);
% % end
% % 
% % subplot(2,2,subplot_idx+1)
% % hold on;
% % % Plot real trial-averaged data
% % p1 = plot(timeBins, meanReg, 'b-', 'LineWidth', 2);
% % p2 = plot(timeBins, meanBig, 'r-', 'LineWidth', 2);
% % 
% % % Plot Model 1 fits
% % p3 = plot(timeBins, fitModel1_Reg, 'b--', 'LineWidth', 2);
% % p4 = plot(timeBins, fitModel1_Big, 'r--', 'LineWidth', 2);
% % 
% % % Plot Model 2 fits
% % p5 = plot(timeBins, fitReg_Model2, 'b.', 'LineWidth', 2.5);
% % p6 = plot(timeBins, fitBig_Model2, 'r.', 'LineWidth', 2.5);
% % 
% % % Add legend with clear descriptions
% % if subplot_idx==1
% % legend([p1, p2, p3, p4, p5, p6], ...
% %     {'Data: Regular reward', ...
% %     'Data: Large reward', ...
% %     'Model 1 Fit: Regular', ...
% %     'Model 1 Fit: Large', ...
% %     'Model 2 Fit: Regular', ...
% %     'Model 2 Fit: Large'}, ...
% %     'Location', 'Best', 'FontSize', 10);
% % 
% % else
% %     legend([p1, p2, p3, p4, p5, p6], ...
% %     {'Data: Regular reward', ...
% %     'Data: Large reward', ...
% %     'Model 1 Fit: Regular', ...
% %     'Model 1 Fit: Omission', ...
% %     'Model 2 Fit: Regular', ...
% %     'Model 2 Fit: Omission'}, ...
% %     'Location', 'Best', 'FontSize', 10);
% % end
% % 
% % xlabel('Time in trial (s)', 'FontSize', 12);
% % ylabel('Mean Neural Response', 'FontSize', 12);
% % title('Real Neural Data vs Model Fits', 'FontSize', 14);
% % grid on;
% % hold off;