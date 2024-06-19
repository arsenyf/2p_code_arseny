function fn_computer_Lick2DPSTH_shuffle(key,self, rel_data, fr_interval,fr_interval_limit, flag_electric_video, time_resample_bin, self2)

smooth_window_sec=0.2; %frames for PSTH
num_shuffles=101;

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


% L=fetch(EXP2.ActionEvent & key,'*');
R=fetch((EXP2.TrialRewardSize & key) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');
Block=fetch((EXP2.TrialLickBlock & key) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');

S=fetch(rel_data,'*');
if isfield(S,'spikes_trace') % to be able to run the code both on dff and on deconvulted "spikes" data
    [S.dff_trace] = S.spikes_trace;
    S = rmfield(S,'spikes_trace');
else
end

% num_trials = numel(TrialsStartFrame);
[start_file, end_file ] = fn_parse_into_trials_and_get_lickrate (key, frame_rate, fr_interval, flag_electric_video);

% we don't use the very last trial
start_file(end)=NaN;   end_file(end)=NaN;

num_trials =numel(start_file);
idx_response = (~isnan(start_file));
try
    % idx reward
    idx_regular = find(strcmp({R.reward_size_type},'regular')  & idx_response);
    idx_regular_temp = strcmp({R.reward_size_type},'regular')  & idx_response;
    idx_small= find(strcmp({R.reward_size_type},'omission')  & idx_response);
    idx_large= find(strcmp({R.reward_size_type},'large')  & idx_response);
    
    idx_odd_small = idx_small(1:2:numel(idx_small));
    idx_even_small = idx_small(2:2:numel(idx_small));
    
    idx_odd_large = idx_large(1:2:numel(idx_large));
    idx_even_large = idx_large(2:2:numel(idx_large));
    
catch
    idx_regular = find(1:1:num_trials  & idx_response);
    idx_regular_temp = 1:1:num_trials  & idx_response;
end
idx_odd_regular = idx_regular(1:2:numel(idx_regular));
idx_even_regular = idx_regular(2:2:numel(idx_regular));

try
    % idx order in a block
    num_trials_in_block=mode([Block.num_trials_in_block]); %the most frequently occurring number of trials per block (in case num trials in block change within session)
    begin_mid_end_bins = linspace(2,num_trials_in_block,4);
    idx_first = find([Block.current_trial_num_in_block]==1 & idx_response & idx_regular_temp);
    idx_begin = find(([Block.current_trial_num_in_block]>=begin_mid_end_bins(1) & [Block.current_trial_num_in_block]<=floor(begin_mid_end_bins(2)) ) & idx_response & idx_regular_temp);
    idx_mid=   find(([Block.current_trial_num_in_block]>begin_mid_end_bins(2) & [Block.current_trial_num_in_block]<=round(begin_mid_end_bins(3)) ) & idx_response & idx_regular_temp);
    idx_end=   find(([Block.current_trial_num_in_block]>begin_mid_end_bins(3) & [Block.current_trial_num_in_block]<=ceil(begin_mid_end_bins(4)) ) & idx_response & idx_regular_temp);
    
    
    idx_odd_first = idx_first(1:2:numel(idx_first));
    idx_even_first = idx_first(2:2:numel(idx_first));
    
    idx_odd_begin = idx_begin(1:2:numel(idx_begin));
    idx_even_begin = idx_begin(2:2:numel(idx_begin));
    
    idx_odd_mid = idx_mid(1:2:numel(idx_mid));
    idx_even_mid = idx_mid(2:2:numel(idx_mid));
    
    idx_odd_end = idx_end(1:2:numel(idx_end));
    idx_even_end = idx_end(2:2:numel(idx_end));
catch
end

for i_roi=1:1:size(S,1)
    
    key_ROI1(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI1(i_roi).session_epoch_number = key.session_epoch_number;
    
    key_ROI2(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI2(i_roi).session_epoch_number = key.session_epoch_number;
    
    
    
    %% PSTH
    spikes=S(i_roi).dff_trace;
    
    psth_regular_odd_vs_even_corr_shuffled=[];
    psth_small_odd_vs_even_corr_shuffled=[];
    psth_large_odd_vs_even_corr_shuffled=[];
    
    psth_first_odd_vs_even_corr_shuffled=[];
    psth_begin_odd_vs_even_corr_shuffled=[];
    psth_mid_odd_vs_even_corr_shuffled=[];
    psth_end_odd_vs_even_corr_shuffled=[];
    
    
    psth_regular_modulation_shuffled=[];
    psth_small_modulation_shuffled=[];
    psth_large_modulation_shuffled=[];
    
    psth_first_modulation_shuffled=[];
    psth_begin_modulation_shuffled=[];
    psth_mid_modulation_shuffled=[];
    psth_end_modulation_shuffled=[];
    
    for i_shuffle = 1:1:num_shuffles
        if i_shuffle==1 % first iteration of the shuffle we don't actually do shuffle but use the original data
            spikes_shuffled=spikes;
        else %we do shuffling
            shift = randi(numel(spikes)-100)+100;
            spikes_shuffled=circshift(spikes,shift);
        end
        [psth_all,~] = fn_parse_neural_activity_into_trials(spikes_shuffled, time_resample_bin, start_file,end_file, smooth_window_frames, frame_rate, fr_interval, idx_response );
        
        
        psth_regular =  nanmean(cell2mat(psth_all(idx_regular)'),1);
        psth_regular_odd =  nanmean(cell2mat(psth_all(idx_odd_regular)'),1);
        psth_regular_even =  nanmean(cell2mat(psth_all(idx_even_regular)'),1);
        
        r = corr([psth_regular_odd(:),psth_regular_even(:)],'Rows' ,'pairwise');
        psth_regular_odd_vs_even_corr_shuffled(i_shuffle)=r(2);
        
        psth_regular_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_regular);
        
        
        try
            %% Reward
            % Taking the mean PSTH across trials
            psth_small =  nanmean(cell2mat(psth_all(idx_small)'),1);
            psth_small_odd =  nanmean(cell2mat(psth_all(idx_odd_small)'),1);
            psth_small_even =  nanmean(cell2mat(psth_all(idx_even_small)'),1);
            
            psth_large =  nanmean(cell2mat(psth_all(idx_large)'),1);
            psth_large_odd =  nanmean(cell2mat(psth_all(idx_odd_large)'),1);
            psth_large_even =  nanmean(cell2mat(psth_all(idx_even_large)'),1);
            
            r = corr([psth_small_odd(:),psth_small_even(:)],'Rows' ,'pairwise');
            psth_small_odd_vs_even_corr_shuffled(i_shuffle)=r(2);
            psth_small_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_small);
            
            
            r = corr([psth_large_odd(:),psth_large_even(:)],'Rows' ,'pairwise');
            psth_large_odd_vs_even_corr_shuffled(i_shuffle)=r(2);
            psth_large_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_large);
            
        catch
        end
        
        try
            %% BLOCK
            % Taking the mean PSTH across trials
            psth_first =  nanmean(cell2mat(psth_all(idx_first)'),1);
            psth_first_odd =  nanmean(cell2mat(psth_all(idx_odd_first)'),1);
            psth_first_even =  nanmean(cell2mat(psth_all(idx_even_first)'),1);
            
            psth_begin =  nanmean(cell2mat(psth_all(idx_begin)'),1);
            psth_begin_odd =  nanmean(cell2mat(psth_all(idx_odd_begin)'),1);
            psth_begin_even =  nanmean(cell2mat(psth_all(idx_even_begin)'),1);
            
            psth_mid =  nanmean(cell2mat(psth_all(idx_mid)'),1);
            psth_mid_odd =  nanmean(cell2mat(psth_all(idx_odd_mid)'),1);
            psth_mid_even =  nanmean(cell2mat(psth_all(idx_even_mid)'),1);
            
            psth_end =  nanmean(cell2mat(psth_all(idx_end)'),1);
            psth_end_odd =  nanmean(cell2mat(psth_all(idx_odd_end)'),1);
            psth_end_even =  nanmean(cell2mat(psth_all(idx_even_end)'),1);
            
            
            %Stability
            r = corr([psth_first_odd(:),psth_first_even(:)],'Rows' ,'pairwise');
            psth_first_odd_vs_even_corr_shuffled(i_shuffle) = r(2);
            psth_first_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_first);
            
            r = corr([psth_begin_odd(:),psth_begin_even(:)],'Rows' ,'pairwise');
            psth_begin_odd_vs_even_corr_shuffled(i_shuffle) = r(2);
            psth_begin_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_begin);
            
            r = corr([psth_mid_odd(:),psth_mid_even(:)],'Rows' ,'pairwise');
            psth_mid_odd_vs_even_corr_shuffled(i_shuffle) = r(2);
            psth_mid_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_mid);
            
            r = corr([psth_end_odd(:),psth_end_even(:)],'Rows' ,'pairwise');
            psth_end_odd_vs_even_corr_shuffled(i_shuffle) = r(2);
            psth_end_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (psth_end);
            
            
        catch
        end
    end
    
    
    % Computing p-value: what fraction of observations in the shuffled distribution  were above the true observation (the first entry)
    key_ROI1(i_roi).psth_regular_odd_vs_even_corr_pval = sum(psth_regular_odd_vs_even_corr_shuffled(2:end)>=psth_regular_odd_vs_even_corr_shuffled(1))/num_shuffles;
    try
        key_ROI1(i_roi).psth_small_odd_vs_even_corr_pval = sum(psth_small_odd_vs_even_corr_shuffled(2:end)>=psth_small_odd_vs_even_corr_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_large_odd_vs_even_corr_pval = sum(psth_large_odd_vs_even_corr_shuffled(2:end)>=psth_large_odd_vs_even_corr_shuffled(1))/num_shuffles;
    catch
    end
    
    try
        key_ROI1(i_roi).psth_first_odd_vs_even_corr_pval = sum(psth_first_odd_vs_even_corr_shuffled(2:end)>=psth_first_odd_vs_even_corr_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_begin_odd_vs_even_corr_pval = sum(psth_begin_odd_vs_even_corr_shuffled(2:end)>=psth_begin_odd_vs_even_corr_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_mid_odd_vs_even_corr_pval = sum(psth_mid_odd_vs_even_corr_shuffled(2:end)>=psth_mid_odd_vs_even_corr_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_end_odd_vs_even_corr_pval = sum(psth_end_odd_vs_even_corr_shuffled(2:end)>=psth_end_odd_vs_even_corr_shuffled(1))/num_shuffles;
    catch
    end
    
    try
        key_ROI1(i_roi).psth_regular_modulation_pval = sum(psth_regular_modulation_shuffled(2:end)>=psth_regular_modulation_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_small_modulation_pval = sum(psth_small_modulation_shuffled(2:end)>=psth_small_modulation_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_large_modulation_pval = sum(psth_large_modulation_shuffled(2:end)>=psth_large_modulation_shuffled(1))/num_shuffles;
    catch
    end
    
    try
        key_ROI1(i_roi).psth_first_modulation_pval = sum(psth_first_modulation_shuffled(2:end)>=psth_first_modulation_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_begin_modulation_pval = sum(psth_begin_modulation_shuffled(2:end)>=psth_begin_modulation_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_mid_modulation_pval = sum(psth_mid_modulation_shuffled(2:end)>=psth_mid_modulation_shuffled(1))/num_shuffles;
        key_ROI1(i_roi).psth_end_modulation_pval = sum(psth_end_modulation_shuffled(2:end)>=psth_end_modulation_shuffled(1))/num_shuffles;
    catch
    end
    key_ROI2(i_roi).psth_regular_odd_vs_even_corr_shuffled = psth_regular_odd_vs_even_corr_shuffled(2:end);
    key_ROI2(i_roi).psth_regular_modulation_shuffled = psth_regular_modulation_shuffled(2:end);
    
end


insert(self, key_ROI1);
insert(self2, key_ROI2);
