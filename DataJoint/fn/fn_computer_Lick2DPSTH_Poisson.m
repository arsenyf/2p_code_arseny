function fn_computer_Lick2DPSTH_Poisson(key,self, rel_data, fr_interval)

smooth_window_sec=0; %frames for PSTH

rel_ROI = (IMG.ROI-IMG.ROIBad) & key;
key_ROI1=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTH
key_ROI2=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DPSTHStats
key_ROI3=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DRewardStats
key_ROI4=fetch(rel_ROI,'ORDER BY roi_number'); % LICK2D.ROILick2DBlockStats

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
    self2=LICK2D.ROILick2DPSTHStatsSpikes;
    self3=LICK2D.ROILick2DRewardStatsSpikes;
    self4=LICK2D.ROILick2DBlockStatsSpikes;
else
    self2=LICK2D.ROILick2DPSTHStats;
    self3=LICK2D.ROILick2DRewardStats;
    self4=LICK2D.ROILick2DBlockStats;
end

% num_trials = numel(TrialsStartFrame);
[start_file, end_file, lick_tr_times_relative_to_first_lick, lick_tr_total ] = fn_parse_into_trials_and_get_lickrate (key, frame_rate, fr_interval);
num_trials =numel(start_file);

idx_response = (~isnan(start_file));
% idx odd/even
idx_odd = ismember(1:1:num_trials,1:2:num_trials) & idx_response;
idx_even =  ismember(1:1:num_trials,2:2:num_trials) & idx_response;

try
    % idx order in a block
    idx_first = [Block.current_trial_num_in_block]==1 & idx_response;
    idx_begin = ([Block.current_trial_num_in_block]==2 | [Block.current_trial_num_in_block]==3) & idx_response;
    idx_mid=   ([Block.current_trial_num_in_block]==4 | [Block.current_trial_num_in_block]==5) & idx_response;
    idx_end=    ([Block.current_trial_num_in_block]==6 | [Block.current_trial_num_in_block]==7) & idx_response;
    
    % idx reward
    idx_small= strcmp({R.reward_size_type},'omission')  & [Block.current_trial_num_in_block]~=1 & idx_response;
    idx_regular = strcmp({R.reward_size_type},'regular')  & [Block.current_trial_num_in_block]~=1 & idx_response;  % we don't include the first trial in the block
    idx_large= strcmp({R.reward_size_type},'large')  & [Block.current_trial_num_in_block]~=1 & idx_response;
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
    time_new_bins = [fr_interval(1):0.5:fr_interval(end)];
    time_new = time_new_bins(1:end-1)+mean(diff(time_new_bins)/2);
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
        
        for i_t = 1:numel(time_new_bins)-1
            idx_t = time>time_new_bins(i_t) & time<=time_new_bins(i_t+1);
            s_resampled(i_t) = mean(s(idx_t));
        end
        psth_all{i_tr}=s_resampled;
    end
    
    
    lick_number_bins = 0:1:6;
    mat_time_licks_spikes = zeros(numel(lick_number_bins), numel(time_new_bins)-1);
    mat_time_licks_timespent= zeros(numel(lick_number_bins), numel(time_new_bins)-1);
    for i_t = 1:numel(time_new_bins)-1
        for i_tr = 1:1:numel(start_file)
            if isnan(start_file(i_tr))
                continue
            end
            curr_licks =lick_tr_times_relative_to_first_lick{i_tr};
            
            licks_at_bin = sum(curr_licks>time_new_bins(i_t) & curr_licks<=time_new_bins(i_t+1));
            if licks_at_bin>=max(lick_number_bins) % all bins with lick number bigger then max lick_number_bins go to the last bin
                licks_at_bin=max(lick_number_bins);
            end
            mat_time_licks_spikes(licks_at_bin+1,i_t) =[mat_time_licks_spikes(licks_at_bin+1,i_t) + mean(psth_all{i_tr}(i_t))];
            mat_time_licks_timespent(licks_at_bin+1,i_t) = [mat_time_licks_timespent(licks_at_bin+1,i_t) + 1];
        end
    end
    
    
    %% Poisson
    psth_all_poisson= zeros(numel(start_file), numel(time_new_bins)-1);
    min_trials_poisson=5;
    mat_time_licks_timespent(mat_time_licks_timespent<5)=NaN;
    tuning_lick_time = (mat_time_licks_spikes./mat_time_licks_timespent);
    
    for i_t = 1:numel(time_new_bins)-1
        for i_tr = 1:1:numel(start_file)
            if isnan(start_file(i_tr))
                continue
            end
            curr_licks =lick_tr_times_relative_to_first_lick{i_tr};
            licks_at_bin = sum(curr_licks>time_new_bins(i_t) & curr_licks<=time_new_bins(i_t+1));
            if licks_at_bin>=max(lick_number_bins) % all bins with lick number bigger then max lick_number_bins go to the last bin
                licks_at_bin=max(lick_number_bins);
            end
            psth_all_poisson(i_tr,i_t) = poissrnd(tuning_lick_time(licks_at_bin+1,i_t));
        end
    end
    
    
    %     hold on
    %
    %     plot(time_new,mean(psth_all_poisson(idx_response,:),1))
    
    %     plot(time,psth)
    %    marginal_t=sum(mat_time_licks_spikes,1)./sum(mat_time_licks_timespent,1);
    %    marginal_licks=sum(mat_time_licks_spikes,2)./sum(mat_time_licks_timespent,2);
    %
    %    hold on
    %    plot(time_new_bins(1:end-1)+mean(diff(time_new_bins)/2),marginal_t)
    
    %% Real PSTHs
    psth = mean(cell2mat(psth_all(idx_response)'),1);
    psth_stem = std(cell2mat(psth_all(idx_response)'),1)/sqrt(sum(idx_response));
    psth_odd =  nanmean(cell2mat(psth_all(idx_odd)'),1);
    psth_even =  nanmean(cell2mat(psth_all(idx_even)'),1);
    
    key_ROI1(i_roi).psth = psth;
    key_ROI1(i_roi).psth_stem = psth_stem;
    key_ROI1(i_roi).psth_odd = psth_odd;
    key_ROI1(i_roi).psth_even = psth_even;
    key_ROI1(i_roi).psth_time = time_new;
    
    r = corr([psth_odd(:),psth_even(:)],'Rows' ,'pairwise');
    key_ROI2(i_roi).psth_odd_even_corr = r(2);
    
    [~,idx_peak_psth]=max(psth);
    key_ROI2(i_roi).peaktime_psth = time_new(idx_peak_psth);
    [~,idx_peak]=max(psth_odd);
    key_ROI2(i_roi).peaktime_psth_odd = time_new(idx_peak);
    [~,idx_peak]=max(psth_even);
    key_ROI2(i_roi).peaktime_psth_even = time_new(idx_peak);
    
    
    
        
    
    %% Poisson PSTHs
    psth_poisson = nanmean(psth_all_poisson(idx_response,:),1);
    psth_stem_poisson = nanstd(psth_all_poisson(idx_response,:),[],1)/sqrt(sum(idx_response));
    psth_odd_poisson =  nanmean(psth_all_poisson(idx_odd,:),1);
    psth_even_poisson =  nanmean(psth_all_poisson(idx_even,:),1);
    
    key_ROI1(i_roi).psth_poisson = psth_poisson;
    key_ROI1(i_roi).psth_stem_poisson = psth_stem_poisson;
    key_ROI1(i_roi).psth_odd_poisson = psth_odd_poisson;
    key_ROI1(i_roi).psth_even_poisson = psth_even_poisson;
    
    r = corr([psth_odd_poisson(:),psth_even_poisson(:)],'Rows' ,'pairwise');
    key_ROI2(i_roi).psth_odd_even_corr_poisson = r(2);
    
    [~,idx_peak_psth]=max(psth_poisson);
    key_ROI2(i_roi).peaktime_psth_poisson = time_new(idx_peak_psth);
    [~,idx_peak]=max(psth_odd_poisson);
    key_ROI2(i_roi).peaktime_psth_odd_poisson = time_new(idx_peak);
    [~,idx_peak]=max(psth_even_poisson);
    key_ROI2(i_roi).peaktime_psth_even_poisson = time_new(idx_peak);
    
    
    
    try
        
        
        %% Real Reward
        % psth reward, averaged across trials
        psth_small =  nanmean(cell2mat(psth_all(idx_small)'),1);
        psth_regular =  nanmean(cell2mat(psth_all(idx_regular)'),1);
        psth_large =  nanmean(cell2mat(psth_all(idx_large)'),1);
        
        key_ROI1(i_roi).psth_small = psth_small;
        key_ROI1(i_roi).psth_regular = psth_regular;
        key_ROI1(i_roi).psth_large = psth_large;
        
        [~,idx_peak]=max(psth_small);
        key_ROI2(i_roi).peaktime_psth_small = time_new(idx_peak);
        [~,idx_peak]=max(psth_regular);
        key_ROI2(i_roi).peaktime_psth_regular = time_new(idx_peak);
        [~,idx_peak]=max(psth_large);
        key_ROI2(i_roi).peaktime_psth_large = time_new(idx_peak);
        
        % averaged across time, for all trial duration
        psth_small =  nanmean(cell2mat(psth_all(idx_small)'),2);
        psth_regular =  nanmean(cell2mat(psth_all(idx_regular)'),2);
        psth_large =  nanmean(cell2mat(psth_all(idx_large)'),2);
        
        key_ROI3(i_roi).reward_mean_small = nanmean(psth_small);
        key_ROI3(i_roi).reward_mean_regular = nanmean(psth_regular);
        key_ROI3(i_roi).reward_mean_large = nanmean(psth_large);
        
        [p,~] = ranksum(psth_regular,psth_small);
        key_ROI3(i_roi).reward_mean_pval_regular_small = p;
        [p,~] = ranksum(psth_regular,psth_large);
        key_ROI3(i_roi).reward_mean_pval_regular_large = p;
        [p,~] = ranksum(psth_small,psth_large);
        key_ROI3(i_roi).reward_mean_pval_small_large = p;
        
        
        % at peak response time
        psth_small =  cell2mat(psth_all(idx_small)'); psth_small = psth_small(:,idx_peak_psth);
        psth_regular =  cell2mat(psth_all(idx_regular)');  psth_regular = psth_regular(:,idx_peak_psth);
        psth_large =  cell2mat(psth_all(idx_large)'); psth_large = psth_large(:,idx_peak_psth);
        
        key_ROI3(i_roi).reward_peak_small = nanmean(psth_small);
        key_ROI3(i_roi).reward_peak_regular = nanmean(psth_regular);
        key_ROI3(i_roi).reward_peak_large = nanmean(psth_large);
        
        [p,~] = ranksum(psth_regular,psth_small);
        key_ROI3(i_roi).reward_peak_pval_regular_small = p;
        [p,~] = ranksum(psth_regular,psth_large);
        key_ROI3(i_roi).reward_peak_pval_regular_large = p;
        [p,~] = ranksum(psth_small,psth_large);
        key_ROI3(i_roi).reward_peak_pval_small_large = p;
        
        
        %% Real BLOCK
        % psth block, averaged across trials
        psth_first =   nanmean(cell2mat(psth_all(idx_first)'),1);
        psth_begin =  nanmean(cell2mat(psth_all(idx_begin)'),1);
        psth_mid =  nanmean(cell2mat(psth_all(idx_mid)'),1);
        psth_end =  nanmean(cell2mat(psth_all(idx_end)'),1);
        
        key_ROI1(i_roi).psth_first = psth_first;
        key_ROI1(i_roi).psth_begin = psth_begin;
        key_ROI1(i_roi).psth_mid = psth_mid;
        key_ROI1(i_roi).psth_end = psth_end;
        
        [~,idx_peak]=max(psth_first);
        key_ROI2(i_roi).peaktime_psth_first = time_new(idx_peak);
        [~,idx_peak]=max(psth_begin);
        key_ROI2(i_roi).peaktime_psth_begin = time_new(idx_peak);
        [~,idx_peak]=max(psth_mid);
        key_ROI2(i_roi).peaktime_psth_mid = time_new(idx_peak);
        [~,idx_peak]=max(psth_end);
        key_ROI2(i_roi).peaktime_psth_end = time_new(idx_peak);
        
        % averaged across time, for all trial duration
        psth_first =  nanmean(cell2mat(psth_all(idx_first)'),2);
        psth_begin =  nanmean(cell2mat(psth_all(idx_begin)'),2);
        psth_mid =  nanmean(cell2mat(psth_all(idx_mid)'),2);
        psth_end =  nanmean(cell2mat(psth_all(idx_end)'),2);
        
        key_ROI4(i_roi).block_mean_first = nanmean(psth_first);
        key_ROI4(i_roi).block_mean_begin = nanmean(psth_begin);
        key_ROI4(i_roi).block_mean_mid = nanmean(psth_mid);
        key_ROI4(i_roi).block_mean_end = nanmean(psth_end);
        
        [p,~] = ranksum(psth_first,psth_begin);
        key_ROI4(i_roi).block_mean_pval_first_begin = p;
        [p,~] = ranksum(psth_first,psth_end);
        key_ROI4(i_roi).block_mean_pval_first_end = p;
        [p,~] = ranksum(psth_begin,psth_end);
        key_ROI4(i_roi).block_mean_pval_begin_end = p;
        
        
        % at peak response time
        psth_first =  cell2mat(psth_all(idx_first)'); psth_first = psth_first(:,idx_peak_psth);
        psth_begin =  cell2mat(psth_all(idx_begin)');  psth_begin = psth_begin(:,idx_peak_psth);
        psth_mid =  cell2mat(psth_all(idx_mid)'); psth_mid = psth_mid(:,idx_peak_psth);
        psth_end =  cell2mat(psth_all(idx_end)'); psth_end = psth_end(:,idx_peak_psth);
        
        key_ROI4(i_roi).block_peak_first = nanmean(psth_first);
        key_ROI4(i_roi).block_peak_begin = nanmean(psth_begin);
        key_ROI4(i_roi).block_peak_mid = nanmean(psth_mid);
        key_ROI4(i_roi).block_peak_end = nanmean(psth_end);
        
        [p,~] = ranksum(psth_first,psth_begin);
        key_ROI4(i_roi).block_peak_pval_first_begin = p;
        [p,~] = ranksum(psth_first,psth_end);
        key_ROI4(i_roi).block_peak_pval_first_end = p;
        [p,~] = ranksum(psth_begin,psth_end);
        key_ROI4(i_roi).block_peak_pval_begin_end = p;
        
        
        
        
        %% Reward Poisson
        % psth reward, averaged across trials
        psth_small_poisson =  nanmean(psth_all_poisson(idx_small,:),1);
        psth_regular_poisson =  nanmean(psth_all_poisson(idx_regular,:),1);
        psth_large_poisson =  nanmean(psth_all_poisson(idx_large,:),1);
        
        
        key_ROI1(i_roi).psth_small_poisson = psth_small_poisson;
        key_ROI1(i_roi).psth_regular_poisson = psth_regular_poisson;
        key_ROI1(i_roi).psth_large_poisson = psth_large_poisson;
        
        %         [~,idx_peak]=max(psth_small_poisson);
        %         key_ROI2(i_roi).peaktime_psth_small_poisson = time_new(idx_peak);
        %         [~,idx_peak]=max(psth_regular_poisson);
        %         key_ROI2(i_roi).peaktime_psth_regular_poisson = time_new(idx_peak);
        %         [~,idx_peak]=max(psth_large_poisson);
        %         key_ROI2(i_roi).peaktime_psth_large_poisson = time_new(idx_peak);
        
        %         % averaged across time, for all trial duration
        %         psth_small =  nanmean(cell2mat(psth_all(idx_small)'),2);
        %         psth_regular =  nanmean(cell2mat(psth_all(idx_regular)'),2);
        %         psth_large =  nanmean(cell2mat(psth_all(idx_large)'),2);
        %
        %         key_ROI3(i_roi).reward_mean_small = nanmean(psth_small);
        %         key_ROI3(i_roi).reward_mean_regular = nanmean(psth_regular);
        %         key_ROI3(i_roi).reward_mean_large = nanmean(psth_large);
        %
        %         [p,~] = ranksum(psth_regular,psth_small);
        %         key_ROI3(i_roi).reward_mean_pval_regular_small = p;
        %         [p,~] = ranksum(psth_regular,psth_large);
        %         key_ROI3(i_roi).reward_mean_pval_regular_large = p;
        %         [p,~] = ranksum(psth_small,psth_large);
        %         key_ROI3(i_roi).reward_mean_pval_small_large = p;
        %
        %
        %         % at peak response time
        %         psth_small =  cell2mat(psth_all(idx_small)'); psth_small = psth_small(:,idx_peak_psth);
        %         psth_regular =  cell2mat(psth_all(idx_regular)');  psth_regular = psth_regular(:,idx_peak_psth);
        %         psth_large =  cell2mat(psth_all(idx_large)'); psth_large = psth_large(:,idx_peak_psth);
        %
        %         key_ROI3(i_roi).reward_peak_small = nanmean(psth_small);
        %         key_ROI3(i_roi).reward_peak_regular = nanmean(psth_regular);
        %         key_ROI3(i_roi).reward_peak_large = nanmean(psth_large);
        %
        %         [p,~] = ranksum(psth_regular,psth_small);
        %         key_ROI3(i_roi).reward_peak_pval_regular_small = p;
        %         [p,~] = ranksum(psth_regular,psth_large);
        %         key_ROI3(i_roi).reward_peak_pval_regular_large = p;
        %         [p,~] = ranksum(psth_small,psth_large);
        %         key_ROI3(i_roi).reward_peak_pval_small_large = p;
        %
        %
        %% BLOCK Poisson
        % psth block, averaged across trials
        psth_first_poisson =  nanmean(psth_all_poisson(idx_first,:),1);
        psth_begin_poisson =  nanmean(psth_all_poisson(idx_begin,:),1);
        psth_mid_poisson =  nanmean(psth_all_poisson(idx_mid,:),1);
        psth_end_poisson =  nanmean(psth_all_poisson(idx_end,:),1);

        
        key_ROI1(i_roi).psth_first_poisson = psth_first_poisson;
        key_ROI1(i_roi).psth_begin_poisson = psth_begin_poisson;
        key_ROI1(i_roi).psth_mid_poisson = psth_mid_poisson;
        key_ROI1(i_roi).psth_end_poisson = psth_end_poisson;
        %
        %         [~,idx_peak]=max(psth_first);
        %         key_ROI2(i_roi).peaktime_psth_first = time_new(idx_peak);
        %         [~,idx_peak]=max(psth_begin);
        %         key_ROI2(i_roi).peaktime_psth_begin = time_new(idx_peak);
        %         [~,idx_peak]=max(psth_mid);
        %         key_ROI2(i_roi).peaktime_psth_mid = time_new(idx_peak);
        %         [~,idx_peak]=max(psth_end);
        %         key_ROI2(i_roi).peaktime_psth_end = time_new(idx_peak);
        %
        %         % averaged across time, for all trial duration
        %         psth_first =  nanmean(cell2mat(psth_all(idx_first)'),2);
        %         psth_begin =  nanmean(cell2mat(psth_all(idx_begin)'),2);
        %         psth_mid =  nanmean(cell2mat(psth_all(idx_mid)'),2);
        %         psth_end =  nanmean(cell2mat(psth_all(idx_end)'),2);
        %
        %         key_ROI4(i_roi).block_mean_first = nanmean(psth_first);
        %         key_ROI4(i_roi).block_mean_begin = nanmean(psth_begin);
        %         key_ROI4(i_roi).block_mean_mid = nanmean(psth_mid);
        %         key_ROI4(i_roi).block_mean_end = nanmean(psth_end);
        %
        %         [p,~] = ranksum(psth_first,psth_begin);
        %         key_ROI4(i_roi).block_mean_pval_first_begin = p;
        %         [p,~] = ranksum(psth_first,psth_end);
        %         key_ROI4(i_roi).block_mean_pval_first_end = p;
        %         [p,~] = ranksum(psth_begin,psth_end);
        %         key_ROI4(i_roi).block_mean_pval_begin_end = p;
        %
        %
        %         % at peak response time
        %         psth_first =  cell2mat(psth_all(idx_first)'); psth_first = psth_first(:,idx_peak_psth);
        %         psth_begin =  cell2mat(psth_all(idx_begin)');  psth_begin = psth_begin(:,idx_peak_psth);
        %         psth_mid =  cell2mat(psth_all(idx_mid)'); psth_mid = psth_mid(:,idx_peak_psth);
        %         psth_end =  cell2mat(psth_all(idx_end)'); psth_end = psth_end(:,idx_peak_psth);
        %
        %         key_ROI4(i_roi).block_peak_first = nanmean(psth_first);
        %         key_ROI4(i_roi).block_peak_begin = nanmean(psth_begin);
        %         key_ROI4(i_roi).block_peak_mid = nanmean(psth_mid);
        %         key_ROI4(i_roi).block_peak_end = nanmean(psth_end);
        %
        %         [p,~] = ranksum(psth_first,psth_begin);
        %         key_ROI4(i_roi).block_peak_pval_first_begin = p;
        %         [p,~] = ranksum(psth_first,psth_end);
        %         key_ROI4(i_roi).block_peak_pval_first_end = p;
        %         [p,~] = ranksum(psth_begin,psth_end);
        %         key_ROI4(i_roi).block_peak_pval_begin_end = p;
        %
        %         k2=key_ROI3(i_roi);
        %         insert(self3, k2);
        %         k2=key_ROI4(i_roi);
        %         insert(self4, k2);
        
        
    catch
    end

k2=key_ROI1(i_roi);
insert(self, k2);
% k2=key_ROI2(i_roi);
% insert(self2, k2);




end