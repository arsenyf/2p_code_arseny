function [h, p_value, stats] = my_chi_square_test (N, p_reward, p_positional, p_joint_obs )



% Define parameters
% N             Total number of neurons (adjust as needed)
% p_reward      Probability of tuning to reward
% p_positional  Probability of tuning to positional
% p_joint_obs   Observed co-tuning probability

% Compute expected co-tuning under independence
p_joint_exp = p_reward * p_positional;

% Compute observed and expected counts
obs_joint = round(p_joint_obs * N);
exp_joint = round(p_joint_exp * N);

obs_reward_only = round((p_reward * N) - obs_joint);
exp_reward_only = round((p_reward * (1 - p_positional) * N));

obs_positional_only = round((p_positional * N) - obs_joint);
exp_positional_only = round((p_positional * (1 - p_reward) * N));

obs_neither = N - (obs_joint + obs_reward_only + obs_positional_only);
exp_neither = N - (exp_joint + exp_reward_only + exp_positional_only);

% Construct observed and expected contingency tables
obs_table = [obs_joint, obs_positional_only; obs_reward_only, obs_neither];
exp_table = [exp_joint, exp_positional_only; exp_reward_only, exp_neither];

% Perform chi-square test
[h, p_value, stats] = chi2gof([obs_joint, obs_positional_only, obs_reward_only, obs_neither], ...
    'Expected', [exp_joint, exp_positional_only, exp_reward_only, exp_neither], 'Emin', 5);
disp(['p-value: ', num2str(p_value)])

% Interpretation
if p_value < 0.05
    disp('The observed co-tuning significantly deviates from expectation (p < 0.05).')
else
    disp('No significant deviation from the expected co-tuning under independence.')
end
