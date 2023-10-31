function Regression_against_PC_comonents_SIMULATION()

%% This is a useful script it we want to regress the activity of N neurons against some variables X, and understand how it relates to doing PCA on neural activity and regressing the PCs against X

%% Say we have X preictors and Y responses. We want to do regress each Y against all X
%The script runs a simulation to test if:
%------------------------
% 1) the average of R2 when  (over all Y responses), gives the same result as
% 2) taking Y, doing PCA on it regressing the Principle Componets of Y against X. 
%    We then multiply (i.e. scale) R2 of each PC by the variance of this PC (to give less weight to PCs that don't explain much variance in Y). 
%    We then average this scaled R2 over all components
%------------------------
%% The answer is that these two measurements are the same if we z-score each Y before doing PCA. % We will define this measurement as the total or average R2 of the regression



%%  Generate Preictors X and  response variable Y 
% The ability of X to explain each variable Y in this simulation is set by  a random level of noise -- this parameter unique to each variable of Y.
% The predictors are not necessarily orthogonal to each other

% Set the dimensions of the data
num_predictors = 20; %X
num_responses = 100; % Y
num_samples = 1000; % number of observations

% Generate random predictors (X)
X = randn(num_samples, num_predictors);

% Generate responses
Y=zeros(num_samples, num_responses); %initialize
for i=1:1:num_responses
    % Generate random coefficients for the predictors (Beta)
    Beta = randn(num_predictors, 1);
    % Generate random noise (Epsilon). Each response varialbe Y will have a different level of noise
    %noise
    noise_level(i)=randi(10); % we scale the noise relative to the contribution of the input X, to decorrelate Y from X
    Epsilon = noise_level(i)*randn(num_samples, 1);
    % Generate the response variables (Y) using the linear model: Y = X * Beta + Epsilon
    Y(:,i) = X * Beta + Epsilon;
    % Z-scoring the Responses
    Y_zscored(:,i) = zscore(Y(:,i));
end


% %Sanity check to show that it doesn't matter how X is scaled for the regression analysis in this script
% X_original=X;
% X=X.*randi(100,num_predictors,1)'; 

% %Sanity check to show that it doesn't matter if  X is centered or not (has mean = 0) for the regression analysis in this script
% X_original=X;
% X=X_original;
% X=X.*randi(5,num_predictors,1)'; 
% X=X + 10*mean(X).*randi(5,num_predictors,1)';

%% Regress each Y against all X. It doesn't matter if we z-score or don't z-score Y in the simple regression. Here it is without z-scoring:
for i=1:1:num_responses
    % Perform regression for each response variable
    y=Y(:,i);
    mdl = fitlm(X, y);
    % Get the R-squared value for each response variable
    R2_for_each_Y_not_zcored(i) = mdl.Rsquared.Ordinary;
     %sanity check to check how regression weights are affected by X scaling
     W_for_all_X_of_each_Y(i,:)=[mdl.Coefficients.Estimate]'; 

end
% Sanity check: R2 should change linearlyt with noise level
% scatter(R2_for_each_Y,noise_level) 


%sanity check to check show that regression weights are affected by X
%scaling, but as you see later the R2 does not
figure
imagesc(W_for_all_X_of_each_Y(:,2:end))
xlabel('X')
ylabel('Y')
title('Regression weights')


%% Regress each Y against all X after z-scoring Y -- this is a sanity check to show that z-scoring Y doesnt matter for simple regression 
%% Note z-coring will matter when doing SVD/PCA in the next step
for i=1:1:num_responses
    % Perform regression for each response variable
    y=Y_zscored(:,i); %here we z-score just to show that it does not matter for simple regression
    mdl = fitlm(X, y);
    % Get the R-squared value for each response variable
    R2_for_each_Y_zscored(i) = mdl.Rsquared.Ordinary;
    %sanity check to check how regression weights are affected by X scaling
%     W_for_all_X_of_each_Y_zscored(i,:)=[mdl.Coefficients.Estimate]'; 
end



%% Computing the PCs of the response variables using the PCA function
[~, PCs_PCA, ~, ~, variance_percentage] = pca(Y_zscored);
variance_explained_PCA=variance_percentage/100; % a feature of PCA. proportion of variance explained by each component


%% Regress each PC (computed by PCA function) of Y against all X
for i=1:1:num_responses
    % Perform regression for each PC of the response variable
    y=PCs_PCA(:,i);
    mdl = fitlm(X, y);
    % Get the R-squared value for each response variable
    R2_for_each_Y_PC(i) = mdl.Rsquared.Ordinary;
end


%% ALTERNATIVELY we can compute the PCs of the response variables using SVD function. It is equivalent to do PCA so I am showing it here just for easiness of using it in other scripts
%% Z-scoring is important!!!
[U,S,V]=svd(Y_zscored'); % 
singular_values =diag(S);
variance_explained_SVD=singular_values.^2/sum(singular_values.^2); % a feature of SVD. proportion of variance explained by each component
PCs_SVD=V';

%% Regress each PC (computed by SVD function) of Y against all X after z-scoring Y. 
for i=1:1:num_responses
    % Perform regression for each PC of the response variable
   y=PCs_SVD(i,:);
    mdl = fitlm(X, y);
    % Get the R-squared value for each response variable
    R2_for_each_Y_SVD(i) = mdl.Rsquared.Ordinary;
end


%% TO show that z-scoring before doing PCA or SVD matters here we compute what happens if we don't z-score before:
%% Here we don't z-score
[U,S,V]=svd(Y'); % 
singular_values =diag(S);
variance_explained_SVD_not_zscored=singular_values.^2/sum(singular_values.^2); % a feature of SVD. proportion of variance explained by each component
PCs_SVD=V';

%% Regress each PC (computed by SVD function) of Y against all X without z-scoring Y. 
for i=1:1:num_responses
    % Perform regression for each PC of the response variable
    y=PCs_SVD(i,:);
    mdl = fitlm(X, y);
    % Get the R-squared value for each response variable
    R2_for_each_Y_SVD_not_zscored(i) = mdl.Rsquared.Ordinary;
end




%% PLOTTING RESULTS SUMMARY

total_R2_Y_not_zcored=mean(R2_for_each_Y_not_zcored)
total_R2_Y_zscored=mean(R2_for_each_Y_zscored)
total_R2_Y_PCA_scaled_zcored=mean(R2_for_each_Y_PC*variance_explained_PCA)
total_R2_Y_SVD_scaled_zcored=(R2_for_each_Y_SVD*variance_explained_SVD)
total_R2_Y_SVD_scaled_not_zcored=(R2_for_each_Y_SVD_not_zscored*variance_explained_SVD_not_zscored)

%%figure

subplot(4,2,1)
plot(R2_for_each_Y_zscored)
ylabel('R2')
xlabel('Y')
title(sprintf('Average R2  %0.2f, Y z-scored',total_R2_Y_zscored))

% Not z scored
subplot(4,2,2)
plot(R2_for_each_Y_not_zcored)
ylabel('R2')
xlabel('Y')
title(sprintf('Average R2  %0.2f NOT z-scored',total_R2_Y_not_zcored))


subplot(4,2,3)
plot(R2_for_each_Y_SVD)
ylabel('R2')
xlabel('PCs of Y computed with SVD function')
title(sprintf('Average R2 %.2f scaled and z-scored',total_R2_Y_SVD_scaled_zcored))


subplot(4,2,4)
plot(R2_for_each_Y_SVD_not_zscored)
ylabel('R2')
xlabel('PCs of Y computed with SVD function')
title(sprintf('Average R2 %.2f scaled NOT z-scored',total_R2_Y_SVD_scaled_not_zcored))


subplot(4,2,5)
plot(R2_for_each_Y_PC)
ylabel('R2')
xlabel('PCs of Y computed with PCA function')
title(sprintf('Average R2 %0.2f scaled and z-scored',total_R2_Y_PCA_scaled_zcored))

subplot(4,2,6)
plot(variance_explained_SVD)
ylabel('Variance of the PCs used for scaling')
xlabel('PCs of Y computed with PCA function')


subplot(4,2,7)
plot(mean(X))
ylabel('mean X')
xlabel('X')
title(sprintf('Mean of predictors X'))

subplot(4,2,8)
plot(var(X))
ylabel('variance X')
xlabel('X')
title(sprintf('Variance of predictors X'))

