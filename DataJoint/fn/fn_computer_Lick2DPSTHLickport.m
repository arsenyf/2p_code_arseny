function fn_computer_Lick2DPSTHLickport(key,self, rel_data, fr_interval,fr_interval_limit, flag_electric_video, time_resample_bin, self2, self3, self4)

smooth_window_sec=0.2; %frames for PSTH

rel_ROI = (IMG.ROI-IMG.ROIBad) & key;
key_ROI1=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHSpikes
key_ROI2=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHStatsSpikes
key_ROI3=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHBlockSpikes
key_ROI4=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHBlockStatsSpikes

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
[start_file, end_file ] = fn_parse_into_trials_and_get_lickrate_alinged_to_Lickport (key, frame_rate, fr_interval, flag_electric_video);

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
    
    idx_odd_small = idx_regular(1:2:numel(idx_small));
    idx_even_small = idx_regular(2:2:numel(idx_small));
    
    idx_odd_large = idx_regular(1:2:numel(idx_large));
    idx_even_large = idx_regular(2:2:numel(idx_large));
    
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
    
    
    idx_odd_first = idx_regular(1:2:numel(idx_first));
    idx_even_first = idx_regular(2:2:numel(idx_first));
    
    idx_odd_begin = idx_regular(1:2:numel(idx_begin));
    idx_even_begin = idx_regular(2:2:numel(idx_begin));
    
    idx_odd_mid = idx_regular(1:2:numel(idx_mid));
    idx_even_mid = idx_regular(2:2:numel(idx_mid));
    
    idx_odd_end = idx_regular(1:2:numel(idx_end));
    idx_even_end = idx_regular(2:2:numel(idx_end));
catch
end

for i_roi=1:1:size(S,1)
    
    key_ROI1(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI1(i_roi).session_epoch_number = key.session_epoch_number;
    
    key_ROI2(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI2(i_roi).session_epoch_number = key.session_epoch_number;
    
    key_ROI3(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI3(i_roi).session_epoch_number = key.session_epoch_number;
    
    key_ROI4(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI4(i_roi).session_epoch_number = key.session_epoch_number;
    
    %% PSTH
    spikes=S(i_roi).dff_trace;

    if isempty(time_resample_bin)
        for i_tr = 1:1:numel(start_file)
            if idx_response(i_tr)==0 %its an ignore trial
                psth_all{i_tr}=NaN;
                continue
            end
            s=spikes(start_file(i_tr):end_file(i_tr));
            s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
            time=(1:1:numel(s))/frame_rate + fr_interval(1);
            %         s_interval=s(time>fr_interval(1) & time<=fr_interval(2));
            %         fr_all(i_roi,i_tr)= max(s_interval); %taking the max
            psth_all{i_tr}=s;
        end
    else
        time_new_bins = [fr_interval(1):time_resample_bin:fr_interval(end)];
        time_new = time_new_bins(1:end-1)+mean(diff(time_new_bins)/2);
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
        time = time_new;
    end
    
    psth_regular = mean(cell2mat(psth_all(idx_regular)'),1);
    psth_regular_stem = std(cell2mat(psth_all(idx_regular)'),1)/sqrt(numel(idx_regular));
    psth_regular_odd =  nanmean(cell2mat(psth_all(idx_odd_regular)'),1);
    psth_regular_even =  nanmean(cell2mat(psth_all(idx_even_regular)'),1);
    
    key_ROI1(i_roi).psth_regular = psth_regular;
    key_ROI1(i_roi).psth_regular_stem = psth_regular_stem;
    key_ROI1(i_roi).psth_regular_odd = psth_regular_odd;
    key_ROI1(i_roi).psth_regular_even = psth_regular_even;
    key_ROI1(i_roi).psth_time = time;
    
    r = corr([psth_regular_odd(:),psth_regular_even(:)],'Rows' ,'pairwise');
    key_ROI2(i_roi).psth_regular_odd_vs_even_corr = r(2);
    
    [~,idx_peak]=max(psth_regular);
    key_ROI2(i_roi).peaktime_psth_regular = time(idx_peak);
    [~,idx_peak]=max(psth_regular_odd);
    key_ROI2(i_roi).peaktime_psth_regular_odd = time(idx_peak);
    [~,idx_peak]=max(psth_regular_even);
    key_ROI2(i_roi).peaktime_psth_regular_even = time(idx_peak);
    
    
    try
        %% Reward
        % Taking the mean PSTH across trials
        psth_small =  nanmean(cell2mat(psth_all(idx_small)'),1);
        psth_small_stem = std(cell2mat(psth_all(idx_small)'),1)/sqrt(numel(idx_small));
        psth_small_odd =  nanmean(cell2mat(psth_all(idx_odd_small)'),1);
        psth_small_even =  nanmean(cell2mat(psth_all(idx_even_small)'),1);
        
        psth_large =  nanmean(cell2mat(psth_all(idx_large)'),1);
        psth_large_stem = std(cell2mat(psth_all(idx_large)'),1)/sqrt(numel(idx_large));
        psth_large_odd =  nanmean(cell2mat(psth_all(idx_odd_large)'),1);
        psth_large_even =  nanmean(cell2mat(psth_all(idx_even_large)'),1);
        
        key_ROI1(i_roi).psth_small = psth_small;
        key_ROI1(i_roi).psth_small_stem = psth_small_stem;
        key_ROI1(i_roi).psth_small_odd = psth_small_odd;
        key_ROI1(i_roi).psth_small_even = psth_small_even;
        
        key_ROI1(i_roi).psth_large = psth_large;
        key_ROI1(i_roi).psth_large_stem = psth_large_stem;
        key_ROI1(i_roi).psth_large_odd = psth_large_odd;
        key_ROI1(i_roi).psth_large_even = psth_large_even;
        
        
        r = corr([psth_small_odd(:),psth_small_even(:)],'Rows' ,'pairwise');
        key_ROI2(i_roi).psth_small_odd_vs_even_corr = r(2);
        
        r = corr([psth_large_odd(:),psth_large_even(:)],'Rows' ,'pairwise');
        key_ROI2(i_roi).psth_large_odd_vs_even_corr = r(2);
        
        r = corr([psth_regular(:),psth_small(:)],'Rows' ,'pairwise');
        key_ROI2(i_roi).psth_regular_vs_small_corr = r(2);
        
        r = corr([psth_regular(:),psth_large(:)],'Rows' ,'pairwise');
        key_ROI2(i_roi).psth_regular_vs_large_corr = r(2);
        
        r = corr([psth_small(:),psth_large(:)],'Rows' ,'pairwise');
        key_ROI2(i_roi).psth_small_vs_large_corr = r(2);
        
        
        [~,idx_peak_small]=max(psth_small);
        key_ROI2(i_roi).peaktime_psth_small = time(idx_peak_small);
        [~,idx_peak_regular]=max(psth_regular);
        key_ROI2(i_roi).peaktime_psth_regular = time(idx_peak_regular);
        [~,idx_peak_large]=max(psth_large);
        key_ROI2(i_roi).peaktime_psth_large = time(idx_peak_large);
        
        % single trials, averaged across all time duration in a specific time interval (e.g. after the  licport onset (t>=0))
        idx_onset = time>=fr_interval_limit(1) & time <fr_interval_limit(2);
        temp=cell2mat(psth_all(idx_regular)');
        psth_regular_trials =  nanmean(temp(:,idx_onset),2);
        temp=cell2mat(psth_all(idx_small)');
        psth_small_trials =  nanmean(temp(:,idx_onset),2);
        temp=cell2mat(psth_all(idx_large)');
        psth_large_trials =  nanmean(temp(:,idx_onset),2);
        
        [p,~] = ranksum(psth_regular_trials,psth_small_trials);
        key_ROI2(i_roi).reward_mean_pval_regular_small = p;
        [p,~] = ranksum(psth_regular_trials,psth_large_trials);
        key_ROI2(i_roi).reward_mean_pval_regular_large = p;
        [p,~] = ranksum(psth_small_trials,psth_large_trials);
        key_ROI2(i_roi).reward_mean_pval_small_large = p;
        
        key_ROI2(i_roi).reward_mean_regular = nanmean(psth_regular_trials);
        key_ROI2(i_roi).reward_mean_small = nanmean(psth_small_trials);
        key_ROI2(i_roi).reward_mean_large = nanmean(psth_large_trials);
        
        
        % at peak response time
        temp =  cell2mat(psth_all(idx_regular)');
        psth_regular_trials_peak = temp(:,idx_peak_regular);
        temp =  cell2mat(psth_all(idx_small)');
        psth_small_trials_peak = temp(:,idx_peak_small);
        temp =  cell2mat(psth_all(idx_large)');
        psth_large_trials_peak = temp(:,idx_peak_large);
        
        key_ROI2(i_roi).reward_peak_regular = nanmean(psth_regular_trials_peak);
        key_ROI2(i_roi).reward_peak_small = nanmean(psth_small_trials_peak);
        key_ROI2(i_roi).reward_peak_large = nanmean(psth_large_trials_peak);
        
        [p,~] = ranksum(psth_regular_trials_peak,psth_small_trials_peak);
        key_ROI2(i_roi).reward_peak_pval_regular_small = p;
        [p,~] = ranksum(psth_regular_trials_peak,psth_large_trials_peak);
        key_ROI2(i_roi).reward_peak_pval_regular_large = p;
        [p,~] = ranksum(psth_small_trials_peak,psth_large_trials_peak);
        key_ROI2(i_roi).reward_peak_pval_small_large = p;
        

    catch
    end
    
    
end
insert(self, key_ROI1);
insert(self2, key_ROI2);
