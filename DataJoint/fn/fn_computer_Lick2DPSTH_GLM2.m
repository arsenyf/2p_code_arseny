function fn_computer_Lick2DPSTH_GLM2(key,self, rel_data,fr_interval, flag_electric_video, time_resample_bin, flag_plot_cells, self2, SPLINE_PARAM, dir_current_fig)

smooth_window_sec=0.2; %frames for PSTH



if isempty(dir([dir_current_fig ]))
    mkdir ([dir_current_fig ])
end
session_date = fetch1(EXP2.Session & key,'session_date');
filename_prefix = [ 'anm' num2str(key.subject_id) '_s' num2str(key.session) '_' session_date];

rel_ROI = (IMG.ROI-IMG.ROIBad) & key;
key_ROI1=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHSpikes
key_ROI2=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHStatsSpikes

rel_data =rel_data & rel_ROI & key;

try
    frame_rate = fetch1(IMG.FOVEpoch & key,'imaging_frame_rate');
catch
    frame_rate = fetch1(IMG.FOV & key,'imaging_frame_rate');
end

smooth_window_frames = ceil(smooth_window_sec*frame_rate); %frames for PSTH


R=fetch((EXP2.TrialRewardSize & key) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');

S=fetch(rel_data,'*');
roi_numbers = [S.roi_number];
if isfield(S,'spikes_trace') % to be able to run the code both on dff and on deconvulted "spikes" data
    [S.dff_trace] = S.spikes_trace;
    S = rmfield(S,'spikes_trace');
else
end

% num_trials = numel(TrialsStartFrame);
% [start_file, end_file ] = fn_parse_into_trials (key, frame_rate, fr_interval);
[start_file, end_file, lick_tr_times_relative_to_first_lick ] = fn_parse_into_trials_and_get_lickrate (key, frame_rate, fr_interval, flag_electric_video);

% Get indices of response trials
idx_response = ~isnan(start_file); % logical array

% Create masks for each reward type (relative to all trials)
mask_regular = strcmp({R.reward_size_type}, 'regular') & idx_response;
mask_large   = strcmp({R.reward_size_type}, 'large')   & idx_response;
mask_small   = strcmp({R.reward_size_type}, 'omission') & idx_response;

% Now convert these to indices relative to the response-only trials
idx_regular_resp_only = find(mask_regular(idx_response));  % e.g. [1 4 5]
idx_large_resp_only   = find(mask_large(idx_response));    % same idea
idx_small_resp_only   = find(mask_small(idx_response));



time_new_bins = [fr_interval(1):time_resample_bin:fr_interval(end)];

%% Computing Lick number X time tuning
counter=0;
for i_tr = 1:1:numel(start_file)
    if isnan(start_file(i_tr))
        continue
    end
    counter=counter+1;
    for i_t = 1:numel(time_new_bins)-1
        
        curr_licks =lick_tr_times_relative_to_first_lick{i_tr};
        
        licks_at_bin = sum(curr_licks>time_new_bins(i_t) & curr_licks<=time_new_bins(i_t+1));
        TRIALS_LICKS(counter,i_t) =licks_at_bin;
    end
end

% num_trials =numel(start_file);
% idx_response = (~isnan(start_file));
%
% % if isempty(R)
% %     return
% % else
% %         idx_regular_response = find(strcmp({R.reward_size_type},'regular')  & idx_response);
% %
% % end
%
% try
%     % idx reward
%     idx_regular = find(strcmp({R.reward_size_type},'regular')  & idx_response);
%     idx_regular_temp = strcmp({R.reward_size_type},'regular')  & idx_response;
%     idx_small= find(strcmp({R.reward_size_type},'omission')  & idx_response);
%     idx_large= find(strcmp({R.reward_size_type},'large')  & idx_response);
% catch
%     return
% end

nNeurons = size(S,1);
% nNeurons=50;
figure;

reward_p_value_threshold=0.01;
stability_threshold=0.9;
roi_reward_large_signif = fetchn(rel_ROI & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('reward_mean_pval_regular_large<=%.2f',reward_p_value_threshold)),'roi_number');
roi_reward_small_signif = fetchn(rel_ROI & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('reward_mean_pval_regular_small<=%.2f',reward_p_value_threshold)),'roi_number');
roi_stabiliy = fetchn(rel_ROI & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('psth_regular_odd_vs_even_corr>=%.2f',stability_threshold)),'roi_number');


for i_roi=1:1:nNeurons
    
    key_ROI1(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI1(i_roi).session_epoch_number = key.session_epoch_number;
    
    key_ROI2(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI2(i_roi).session_epoch_number = key.session_epoch_number;
    
    %% PSTH, time resampled
    spikes=S(i_roi).dff_trace;
    for i_tr = 1:1:numel(start_file)
        if idx_response(i_tr)==0 %its an ignore trial
            psth_all{i_tr}=NaN;
            continue
        end
        s=spikes(start_file(i_tr):end_file(i_tr));
        s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
        time=(1:1:numel(s))/frame_rate + fr_interval(1);
        for i_t = 1:numel(time_new_bins)-1
            idx_t = time>time_new_bins(i_t) & time<=time_new_bins(i_t+1);
            s_resampled(i_t) = mean(s(idx_t));
        end
        psth_all{i_tr}=s_resampled;
    end
    
    
    TRIALS_SPIKES = cell2mat([psth_all(idx_response)]');
    
    
    %     %% Setting up the predictors for GLM  - regular vs large rewards
    %     timeBins = time_new_bins(1:end-1);  % nTimepoints
    %
    %     reward_type_vector = NaN(sum(idx_response), 1); % pre-allocate as NaN  % nTrials
    %     reward_type_vector(idx_regular_resp_only) = 0;
    %     reward_type_vector(idx_small_resp_only) = 1;
    %     reward_type_vector(idx_small_resp_only)=[]; %ignoring small reward trials
    %
    %     % Neuron's responses: matrix (nTrials x nTimepoints)
    %     neuralResponse = TRIALS_SPIKES;
    %     neuralResponse (idx_small_resp_only,:)=[];
    %
    %     % Behavioral response (Licks) : matrix (nTrials x nTimepoints)
    %     lickMatrix = TRIALS_LICKS;
    %     lickMatrix (idx_small_resp_only,:)=[];
    %     clf
    %     [p_val_lick(i_roi) large_reward_coeffs(i_roi) large_reward_p_val_LLR(i_roi) ] = fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse,lickMatrix , 1);
    
    %% Setting up the predictors for GLM  - regular vs small rewards
    timeBins = time_new_bins(1:end-1);  % nTimepoints
    
    reward_type_vector = NaN(sum(idx_response), 1); % pre-allocate as NaN  % nTrials
    reward_type_vector(idx_regular_resp_only) = 0;
    reward_type_vector(idx_small_resp_only) = 1;
    reward_type_vector(idx_large_resp_only)=2;
    
    % Neuron's responses: matrix (nTrials x nTimepoints)
    neuralResponse = TRIALS_SPIKES;
    %     neuralResponse (idx_large_resp_only,:)=[];
    
    % Behavioral response (Licks) : matrix (nTrials x nTimepoints)
    lickMatrix = TRIALS_LICKS;
    %     lickMatrix (idx_large_resp_only,:)=[];
    warning('off')
    [p_val_lick_model1(i_roi), p_val_lick_model2(i_roi), reward_coeff_small(i_roi), reward_coeff_large(i_roi), p_val_LLR_small(i_roi), p_val_LLR_large(i_roi), fitPair_large, fitPair_small]  = ...
        fn_GLM_splitReward_compare2(timeBins, reward_type_vector, neuralResponse, lickMatrix, roi_numbers(i_roi), key, flag_plot_cells, SPLINE_PARAM);
    %fn_GLM_splitReward_compare
    warning('on')
    
    if flag_plot_cells==1
    if p_val_LLR_large(i_roi)>0.001 && (sum(ismember(roi_reward_large_signif,roi_numbers(i_roi))) || sum(ismember(roi_reward_small_signif,roi_numbers(i_roi))))  && sum(ismember(roi_stabiliy,roi_numbers(i_roi)))
        filename=[filename_prefix 'roi_' num2str(roi_numbers(i_roi))];
        figure_name_out=[ dir_current_fig '\' filename];
        eval(['print ', figure_name_out, ' -dtiff  -r200']);
        saveas(gcf,figure_name_out);
    end
    clf
    end
    
    key_ROI1(i_roi).psth_regular_glm1 = fitPair_large.model1_mean_by_reward(1,:);
    key_ROI1(i_roi).psth_small__glm1 = fitPair_small.model1_mean_by_reward(2,:);
    key_ROI1(i_roi).psth_large__glm1 = fitPair_large.model1_mean_by_reward(3,:);
    
    key_ROI1(i_roi).psth_regular_stem__glm1 = fitPair_large.model1_sem_by_reward(1,:);
    key_ROI1(i_roi).psth_small_stem__glm1 = fitPair_small.model1_sem_by_reward(2,:);
    key_ROI1(i_roi).psth_large_stem__glm1 = fitPair_large.model1_sem_by_reward(3,:);
    
    key_ROI1(i_roi).psth_regular_glm2 = fitPair_large.model2_mean_by_reward(1,:);
    key_ROI1(i_roi).psth_small__glm2 = fitPair_small.model2_mean_by_reward(2,:);
    key_ROI1(i_roi).psth_large__glm2 = fitPair_large.model2_mean_by_reward(3,:);
    
    key_ROI1(i_roi).psth_regular_stem__glm2 = fitPair_large.model2_sem_by_reward(1,:);
    key_ROI1(i_roi).psth_small_stem__glm2 = fitPair_small.model2_sem_by_reward(2,:);
    key_ROI1(i_roi).psth_large_stem__glm2 = fitPair_large.model2_sem_by_reward(3,:);
    key_ROI1(i_roi).psth_time_glm = timeBins;
    
    
    key_ROI2(i_roi).p_val_lick_model1 = p_val_lick_model1(i_roi);
    key_ROI2(i_roi).p_val_lick_model2 = p_val_lick_model2(i_roi);
    key_ROI2(i_roi).p_val_llr_small = p_val_LLR_small(i_roi);
    key_ROI2(i_roi).p_val_llr_large = p_val_LLR_large(i_roi);
    key_ROI2(i_roi).reward_coeff_small = reward_coeff_small(i_roi);
    key_ROI2(i_roi).reward_coeff_large = reward_coeff_large(i_roi);
    
    
end

insert(self, key_ROI1);
insert(self2, key_ROI2);

% %  [p_val_lick(i_roi) reward_coeff_small(i_roi) reward_coeff_large(i_roi) large_reward_p_val_LLR(i_roi) ]=  fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse,lickMatrix, i_roi);
% doSubsample=0;
%  [p_val_lick(i_roi) reward_coeff_small(i_roi) reward_coeff_large(i_roi) large_reward_p_val_LLR(i_roi) ]=  fn_GLM_reward_subsample_plot(timeBins, reward_type_vector, neuralResponse,lickMatrix, i_roi, doSubsample)
%
% %   [~, small_reward_coeffs(i_roi) small_reward_p_val_LLR(i_roi) ]
%
%     subplot(2,3,5);
%
%     matchedRanges = fn_find_matched_lick_bins(lickMatrix, reward_type_vector, 0, 2, 20);
%     bestMatch = 0;
% bestIdx = 1;
%
% for i = 1:numel(matchedRanges)
%     range = matchedRanges{i};
%     % Count trials in this range for both reward types
%     regCount = sum(reward_type_vector == 0 & sum(lickMatrix, 2) >= range(1) & sum(lickMatrix, 2) <= range(2));
%     bigCount = sum(reward_type_vector == 2 & sum(lickMatrix, 2) >= range(1) & sum(lickMatrix, 2) <= range(2));
%     matched = min(regCount, bigCount);  % number of matched trials
%     if matched > bestMatch
%         bestMatch = matched;
%         bestIdx = i;
%     end
% end
%
% lickRange = matchedRanges{bestIdx};  % This is the best matched range
% subplot(2,3,6);
% fn_plot_matched_reward_trials(timeBins, neuralResponse, lickMatrix, reward_type_vector, 0, 2, lickRange, i_roi);
%
%
% %     %% Setting up the predictors for GLM  - regular vs large rewards
% %     timeBins = time_new_bins(1:end-1);  % nTimepoints
% %
% %     reward_type_vector = NaN(sum(idx_response), 1); % pre-allocate as NaN  % nTrials
% %     reward_type_vector(idx_regular_resp_only) = 0;
% %     reward_type_vector(idx_large_resp_only) = 1;
% %     reward_type_vector(idx_small_resp_only)=[]; %ignoring small reward trials
% %
% %     % Neuron's responses: matrix (nTrials x nTimepoints)
% %     neuralResponse = TRIALS_SPIKES;
% %     neuralResponse (idx_small_resp_only,:)=[];
% %
% %     % Behavioral response (Licks) : matrix (nTrials x nTimepoints)
% %     lickMatrix = TRIALS_LICKS;
% %     lickMatrix (idx_small_resp_only,:)=[];
% %     clf
% %     [p_val_lick(i_roi) large_reward_coeffs(i_roi) large_reward_p_val_LLR(i_roi) ] = fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse,lickMatrix , 1);
% %
% %      %% Setting up the predictors for GLM  - regular vs small rewards
% %     timeBins = time_new_bins(1:end-1);  % nTimepoints
% %
% %     reward_type_vector = NaN(sum(idx_response), 1); % pre-allocate as NaN  % nTrials
% %     reward_type_vector(idx_regular_resp_only) = 0;
% %     reward_type_vector(idx_small_resp_only) = 1;
% %     reward_type_vector(idx_large_resp_only)=[]; %ignoring large reward trials
% %
% %     % Neuron's responses: matrix (nTrials x nTimepoints)
% %     neuralResponse = TRIALS_SPIKES;
% %     neuralResponse (idx_large_resp_only,:)=[];
% %
% %     % Behavioral response (Licks) : matrix (nTrials x nTimepoints)
% %     lickMatrix = TRIALS_LICKS;
% %     lickMatrix (idx_large_resp_only,:)=[];
% %
% %
% %     [~, small_reward_coeffs(i_roi) small_reward_p_val_LLR(i_roi) ] = fn_GLM_fit_lick_reward(timeBins, reward_type_vector, neuralResponse,lickMatrix, 2);
% %
%
% end
%
%

