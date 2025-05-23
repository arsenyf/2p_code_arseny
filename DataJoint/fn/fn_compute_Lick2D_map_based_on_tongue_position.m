function fn_compute_Lick2D_map_based_on_tongue_position(key,self, rel_data, fr_interval, fr_interval_limit, flag_electric_video)

smooth_window_sec=0.2; %frames for PSTH
timespent_min=5; %in trials
timespent_min_partial=3; %in trials, for partial conditions (e.g. reward modulation, and trial number in block )
min_percent_coverage=50; % minimal coverage needed for 2D map calculation
%Smoothing parameters for 2D maps
sigma=1;
hsize=1;

rel_ROI = (IMG.ROI-IMG.ROIBad) & key;

key_ROI1=fetch(rel_ROI,'ORDER BY roi_number'); %2D map
key_ROI2=fetch(rel_ROI,'ORDER BY roi_number'); %2D map PSTH
key_ROI3=fetch(rel_ROI,'ORDER BY roi_number'); %2D map PSTH stability (odd,even)
key_ROI4=fetch(rel_ROI,'ORDER BY roi_number'); %2D map stats
key_ROI5=fetch(rel_ROI,'ORDER BY roi_number'); %psth selectivity (preferred-nonpreferred computed based on the 2D map)
key_ROI6=fetch(rel_ROI,'ORDER BY roi_number'); %psth selectivity stats

rel_data =rel_data & rel_ROI & key;


%% Rescaling, rotation, and binning
[POS, number_of_bins] = fn_rescale_and_rotate_lickport_pos_based_on_tongue_position (key);
key.number_of_bins=number_of_bins;
pos_x = POS.pos_x;
pos_z = POS.pos_z;

prctile_vector = linspace(0,100,key.number_of_bins+1);
% x_bins = linspace(-1, 1,key.number_of_bins+1);
x_bins =  prctile(pos_x,prctile_vector);
z_bins =  prctile(pos_z,prctile_vector);

x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;
z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;

x_bins(1)= -inf;
x_bins(end)= inf;
z_bins(1)= -inf;
z_bins(end)= inf;



%% Compute maps
[hhh, ~, ~, z_idx, x_idx] = histcounts2(pos_z,pos_x,z_bins,x_bins);

%plot(pos_x,pos_z,'.')


mat_x=repmat(x_bins_centers,key.number_of_bins,1);
mat_z=repmat(z_bins_centers',1,key.number_of_bins);


% go_time=fetchn(EXP2.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time','LIMIT 1');
frame_rate = fetchn(IMG.FOVEpoch & key,'imaging_frame_rate');
smooth_window_frames = ceil(smooth_window_sec*frame_rate); %frames for PSTH

% TrialsStartFrame=fetchn(IMG.FrameStartTrial & key,'session_epoch_trial_start_frame','ORDER BY trial');
% if isempty(TrialsStartFrame) % not mesoscope recordings
%     TrialsStartFrame=fetchn(IMG.FrameStartFile & key,'session_epoch_file_start_frame', 'ORDER BY session_epoch_file_num');
% end

% L=fetch(EXP2.ActionEvent & key,'*');
R=fetch((EXP2.TrialRewardSize & key & TRACKING.VideoTongueTrial) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');
Block=fetch((EXP2.TrialLickBlock & key & TRACKING.VideoTongueTrial) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');

S=fetch(rel_data,'*');
if isfield(S,'spikes_trace') % to be able to run the code both on dff and on deconvulted "spikes" data
    [S.dff_trace] = S.spikes_trace;
    S = rmfield(S,'spikes_trace');
    self2=LICK2D.ROILick2DmapPSTHSpikesTongueMap;
    self3=LICK2D.ROILick2DmapPSTHStabilitySpikesTongueMap;
    self4=LICK2D.ROILick2DmapStatsSpikesTongueMap;
    self5=LICK2D.ROILick2DSelectivitySpikesTongueMap;
    self6=LICK2D.ROILick2DSelectivityStatsSpikesTongueMap;
else
    %     self2=LICK2D.ROILick2DmapPSTH;
    %     self3=LICK2D.ROILick2DmapStats;
    %     self4=LICK2D.ROILick2DSelectivity;
    %     self5=LICK2D.ROILick2DSelectivityStats;
end

% num_trials = numel(TrialsStartFrame);
[start_file, end_file ] = fn_parse_into_trials_and_get_lickrate_tonguemap (key,frame_rate, fr_interval, flag_electric_video);

num_trials =numel(start_file);
idx_response = (~isnan(start_file));
try
    % idx reward
    idx_regular = strcmp({R.reward_size_type},'regular')  & idx_response;
    idx_small= strcmp({R.reward_size_type},'omission')  & idx_response;
    idx_large= strcmp({R.reward_size_type},'large')  & idx_response;
    
    idx_odd_regular = find(idx_regular);
    idx_odd_regular = idx_odd_regular(1:2:sum(idx_regular));
    idx_odd_regular = ismember(1:1:num_trials,idx_odd_regular);
    idx_even_regular = find(idx_regular);
    idx_even_regular = idx_even_regular(2:2:sum(idx_regular));
    idx_even_regular = ismember(1:1:num_trials,idx_even_regular);
catch
    idx_regular = 1:1:num_trials  & idx_response;
    idx_odd_regular = ismember(1:1:num_trials,1:2:num_trials) & idx_response;
    idx_even_regular =  ismember(1:1:num_trials,2:2:num_trials) & idx_response;
end

try
    % idx order in a block
    num_trials_in_block=mode([Block.num_trials_in_block]); %the most frequently occurring number of trials per block (in case num trials in block change within session)
    begin_mid_end_bins = linspace(2,num_trials_in_block,4);
    idx_first = [Block.current_trial_num_in_block]==1 & idx_response & idx_regular;
    idx_begin = ([Block.current_trial_num_in_block]>=begin_mid_end_bins(1) & [Block.current_trial_num_in_block]<=floor(begin_mid_end_bins(2)) ) & idx_response & idx_regular;
    idx_mid=   ([Block.current_trial_num_in_block]>begin_mid_end_bins(2) & [Block.current_trial_num_in_block]<=round(begin_mid_end_bins(3)) ) & idx_response & idx_regular;
    idx_end=   ([Block.current_trial_num_in_block]>begin_mid_end_bins(3) & [Block.current_trial_num_in_block]<=ceil(begin_mid_end_bins(4)) ) & idx_response & idx_regular;
catch
end

for i_x=1:1:numel(x_bins_centers)
    for i_z=1:1:numel(z_bins_centers)
        idx_xz {i_z,i_x} = find((x_idx==i_x)  & idx_response &  (z_idx==i_z));
    end
end

for i_roi=1:1:size(S,1)
    
    %% PSTH
    spikes=S(i_roi).dff_trace;
    for i_tr = 1:1:numel(start_file)
        if idx_response(i_tr)==0 %its an ignore trial
            fr_all(i_roi,i_tr)=NaN;
            psth_all{i_roi,i_tr}=NaN;
            continue
        end
        s=spikes(start_file(i_tr):end_file(i_tr));
        s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
        time=(1:1:numel(s))/frame_rate + fr_interval(1);
        s_interval=s(time>=fr_interval_limit(1) & time<fr_interval_limit(2));
        fr_all(i_roi,i_tr)= sum(s_interval)/numel(s_interval); %taking mean fr
        %         fr_all(i_roi,i_tr)= max(s_interval); %taking the max
        psth_all{i_roi,i_tr}=s;
    end
    
    
    %% PSTH per position, and 2D maps
    for i_x=1:1:numel(x_bins_centers)
        for i_z=1:1:numel(z_bins_centers)
            %             idx = find((x_idx==i_x)  & ~isnan(start_file) &  (z_idx==i_z));
            idx_bin = idx_xz{i_z,i_x};
            
            %% Binning for 2D 2D MAP calculation
            %spikes binned
            map_xz_spikes_regular(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_regular));
            map_xz_spikes_regular_odd(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_regular & idx_odd_regular   ));
            map_xz_spikes_regular_even(i_z,i_x) = sum(fr_all(i_roi,  ismember(1:1:num_trials,idx_bin) & idx_regular & idx_even_regular   ));
            try
                map_xz_spikes_small(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_small));
                map_xz_spikes_large(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_large));
            catch
            end
            try
                map_xz_spikes_first(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin)  & idx_first));
                map_xz_spikes_begin(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_begin));
                map_xz_spikes_mid(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin)  & idx_mid));
                map_xz_spikes_end(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_end));
            catch
            end
            
            % timespent binned
            map_xz_timespent_regular(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular);
            map_xz_timespent_regular_odd(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular & idx_odd_regular);
            map_xz_timespent_regular_even(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular & idx_even_regular);
            try
                map_xz_timespent_small(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_small);
                map_xz_timespent_large(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_large);
            catch
            end
            try
                map_xz_timespent_first(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_first);
                map_xz_timespent_begin(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin)  & idx_begin);
                map_xz_timespent_mid(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin)  & idx_mid);
                map_xz_timespent_end(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin)  & idx_end);
            catch
            end
            
            %% Binning for 2D PSTH calculation
            [psth_per_position_regular{i_z,i_x}, psth_per_position_regular_stem{i_z,i_x},psth_per_position_regular_odd{i_z,i_x},psth_per_position_regular_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_regular, timespent_min, time);
            try
                [psth_per_position_small{i_z,i_x}, psth_per_position_small_stem{i_z,i_x},psth_per_position_small_odd{i_z,i_x},psth_per_position_small_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_small, timespent_min_partial, time);
                [psth_per_position_large{i_z,i_x}, psth_per_position_large_stem{i_z,i_x},psth_per_position_large_odd{i_z,i_x},psth_per_position_large_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_large, timespent_min_partial, time);
            catch
            end
            try
                [psth_per_position_first{i_z,i_x}, psth_per_position_first_stem{i_z,i_x},psth_per_position_first_odd{i_z,i_x},psth_per_position_first_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_first, timespent_min_partial, time);
                [psth_per_position_begin{i_z,i_x}, psth_per_position_begin_stem{i_z,i_x},psth_per_position_begin_odd{i_z,i_x},psth_per_position_begin_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_begin, timespent_min_partial, time);
                [psth_per_position_mid{i_z,i_x},  psth_per_position_mid_stem{i_z,i_x},psth_per_position_mid_odd{i_z,i_x},psth_per_position_mid_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_mid, timespent_min_partial, time);
                [psth_per_position_end{i_z,i_x},  psth_per_position_end_stem{i_z,i_x},psth_per_position_end_odd{i_z,i_x},psth_per_position_end_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_end, timespent_min_partial, time);
            catch
            end
        end
    end
    
    
    
    
    %% Actual 2D map calculation
    [~, lickmap_fr_regular, ~, information_per_spike_regular, ~, ~, ~, ~, field_size_regular, field_size_without_baseline_regular, ~, centroid_without_baseline_regular, percent_2d_map_coverage_regular] ...
        = fn_compute_generic_2D_field3 ...
        (x_bins, z_bins, map_xz_timespent_regular, map_xz_spikes_regular, timespent_min, sigma, hsize, 0 ,min_percent_coverage);
    
    [~, lickmap_fr_regular_odd] ...
        = fn_compute_generic_2D_field3 ...
        (x_bins, z_bins, map_xz_timespent_regular_odd, map_xz_spikes_regular_odd, timespent_min, sigma, hsize, 0, min_percent_coverage);
    
    [~, lickmap_fr_regular_even] ...
        = fn_compute_generic_2D_field3 ...
        (x_bins, z_bins, map_xz_timespent_regular_even, map_xz_spikes_regular_even, timespent_min, sigma, hsize, 0, min_percent_coverage);
    
    try
        [~, lickmap_fr_small, ~, information_per_spike_small, ~, ~, ~, ~, field_size_small, field_size_without_baseline_small, ~, centroid_without_baseline_small, percent_2d_map_coverage_small] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_small, map_xz_spikes_small, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
        
        [~, lickmap_fr_large, ~, information_per_spike_large, ~, ~, ~, ~, field_size_large, field_size_without_baseline_large, ~, centroid_without_baseline_large, percent_2d_map_coverage_large] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_large, map_xz_spikes_large, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
    catch
    end
    
    try
        [~, lickmap_fr_first, ~, information_per_spike_first, ~, ~, ~, ~, field_size_first, field_size_without_baseline_first, ~, centroid_without_baseline_first, percent_2d_map_coverage_first] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_first, map_xz_spikes_first, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
        
        [~, lickmap_fr_begin, ~, information_per_spike_begin, ~, ~, ~, ~, field_size_begin, field_size_without_baseline_begin, ~, centroid_without_baseline_begin, percent_2d_map_coverage_begin] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_begin, map_xz_spikes_begin, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
        
        [~, lickmap_fr_mid, ~, information_per_spike_mid, ~, ~, ~, ~, field_size_mid, field_size_without_baseline_mid, ~, centroid_without_baseline_mid, percent_2d_map_coverage_mid] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_mid, map_xz_spikes_mid, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
        
        [~, lickmap_fr_end, ~, information_per_spike_end, ~, ~, ~, ~, field_size_end, field_size_without_baseline_end, ~, centroid_without_baseline_end, percent_2d_map_coverage_end] ...
            = fn_compute_generic_2D_field3 ...
            (x_bins, z_bins, map_xz_timespent_end, map_xz_spikes_end, timespent_min_partial, sigma, hsize, 0, min_percent_coverage);
    catch
    end
    
    
    %% Correlations between 2D maps
    lickmap_regular_odd_vs_even_corr=corr([lickmap_fr_regular_odd(:),lickmap_fr_regular_even(:)],'Rows' ,'pairwise');
    lickmap_regular_odd_vs_even_corr=lickmap_regular_odd_vs_even_corr(2);
    try
        lickmap_regular_vs_small_corr=corr([lickmap_fr_regular(:),lickmap_fr_small(:)],'Rows' ,'pairwise');
        lickmap_regular_vs_small_corr=lickmap_regular_vs_small_corr(2);
        
        lickmap_regular_vs_large_corr=corr([lickmap_fr_regular(:),lickmap_fr_large(:)],'Rows' ,'pairwise');
        lickmap_regular_vs_large_corr=lickmap_regular_vs_large_corr(2);
    catch
    end
    
    if isnan(lickmap_regular_odd_vs_even_corr)
        lickmap_regular_odd_vs_even_corr=0;
    end
    
    try
        lickmap_first_vs_begin_corr=corr([lickmap_fr_first(:),lickmap_fr_begin(:)],'Rows' ,'pairwise');
        lickmap_first_vs_begin_corr=lickmap_first_vs_begin_corr(2);
        
        lickmap_first_vs_mid_corr=corr([lickmap_fr_first(:),lickmap_fr_mid(:)],'Rows' ,'pairwise');
        lickmap_first_vs_mid_corr=lickmap_first_vs_mid_corr(2);
        
        lickmap_first_vs_end_corr=corr([lickmap_fr_first(:),lickmap_fr_end(:)],'Rows' ,'pairwise');
        lickmap_first_vs_end_corr=lickmap_first_vs_end_corr(2);
        
        lickmap_begin_vs_end_corr=corr([lickmap_fr_begin(:), lickmap_fr_end(:)],'Rows' ,'pairwise');
        lickmap_begin_vs_end_corr=lickmap_begin_vs_end_corr(2);
        
        lickmap_begin_vs_mid_corr=corr([lickmap_fr_begin(:),lickmap_fr_mid(:)],'Rows' ,'pairwise');
        lickmap_begin_vs_mid_corr=lickmap_begin_vs_mid_corr(2);
        
        lickmap_mid_vs_end_corr=corr([lickmap_fr_mid(:),lickmap_fr_end(:)],'Rows' ,'pairwise');
        lickmap_mid_vs_end_corr=lickmap_mid_vs_end_corr(2);
    catch
    end
    
    
    
    
    %% Preferred bin and radius on the 2D map (radius refers to when transforming the 2D tuning into polar plot)
    
    [preferred_bin_regular,idx_preferred_trials_regular, idx_non_preferred_trials_regular, preferred_radius_regular ] ...
        = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_regular, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_regular, min_percent_coverage);
    
    try
        [preferred_bin_small,idx_preferred_trials_small, idx_non_preferred_trials_small, preferred_radius_small ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_small, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_small, min_percent_coverage);
        
        [preferred_bin_large,idx_preferred_trials_large, idx_non_preferred_trials_large, preferred_radius_large ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_large, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_large, min_percent_coverage);
    catch
    end
    try
        [preferred_bin_first,idx_preferred_trials_first, idx_non_preferred_trials_first, preferred_radius_first ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_first, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_first, min_percent_coverage);
        
        [preferred_bin_begin,idx_preferred_trials_begin, idx_non_preferred_trials_begin, preferred_radius_begin ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_begin, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_begin, min_percent_coverage);
        
        [preferred_bin_mid,idx_preferred_trials_mid, idx_non_preferred_trials_mid, preferred_radius_mid ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_mid, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_mid, min_percent_coverage);
        
        [preferred_bin_end,idx_preferred_trials_end, idx_non_preferred_trials_end, preferred_radius_end ] ...
            = fn_compute_Lick2D_preferred_2d_tuning_radius (lickmap_fr_end, mat_x, mat_z, num_trials, idx_xz, key, idx_response, idx_end, min_percent_coverage);
    catch
    end
    
    %--------------------------------------------------------------------------------------------------------------------------------------
    
    %% DJ insertion of 2D mAP
    key_ROI1(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI1(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI1(i_roi).number_of_bins = key.number_of_bins;
    key_ROI1(i_roi).lickmap_fr_regular = lickmap_fr_regular;
    key_ROI1(i_roi).lickmap_fr_regular_odd = lickmap_fr_regular_odd;
    key_ROI1(i_roi).lickmap_fr_regular_even = lickmap_fr_regular_even;
    try
        key_ROI1(i_roi).lickmap_fr_small = lickmap_fr_small;
        key_ROI1(i_roi).lickmap_fr_large = lickmap_fr_large;
    catch
    end
    try
        key_ROI1(i_roi).lickmap_fr_first = lickmap_fr_first;
        key_ROI1(i_roi).lickmap_fr_begin = lickmap_fr_begin;
        key_ROI1(i_roi).lickmap_fr_mid = lickmap_fr_mid;
        key_ROI1(i_roi).lickmap_fr_end = lickmap_fr_end;
    catch
    end
    
    key_ROI1(i_roi).pos_x_bins_centers = x_bins_centers;
    key_ROI1(i_roi).pos_z_bins_centers = z_bins_centers;
    
    
    %% DJ insertion of 2D map PSTH
    key_ROI2(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI2(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI2(i_roi).number_of_bins = key.number_of_bins;
    key_ROI2(i_roi).psthmap_time = time;
    
    key_ROI2(i_roi).psth_per_position_regular = psth_per_position_regular;
    key_ROI2(i_roi).psth_per_position_regular_stem = psth_per_position_regular_stem;
    
    try
        key_ROI2(i_roi).psth_per_position_small = psth_per_position_small;
        key_ROI2(i_roi).psth_per_position_small_stem = psth_per_position_small_stem;
        key_ROI2(i_roi).psth_per_position_large = psth_per_position_large;
        key_ROI2(i_roi).psth_per_position_large_stem = psth_per_position_large_stem;
    catch
    end
    try
        key_ROI2(i_roi).psth_per_position_first = psth_per_position_first;
        key_ROI2(i_roi).psth_per_position_begin = psth_per_position_begin;
        key_ROI2(i_roi).psth_per_position_mid = psth_per_position_mid;
        key_ROI2(i_roi).psth_per_position_end = psth_per_position_end;
        
        key_ROI2(i_roi).psth_per_position_first_stem = psth_per_position_first_stem;
        key_ROI2(i_roi).psth_per_position_begin_stem = psth_per_position_begin_stem;
        key_ROI2(i_roi).psth_per_position_mid_stem = psth_per_position_mid_stem;
        key_ROI2(i_roi).psth_per_position_end_stem = psth_per_position_end_stem;
    catch
    end
    
    %% DJ insertion of 2D map PSTH Stability (odd/even)
    key_ROI3(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI3(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI3(i_roi).number_of_bins = key.number_of_bins;
    
    key_ROI3(i_roi).psth_per_position_regular_odd = psth_per_position_regular_odd;
    key_ROI3(i_roi).psth_per_position_regular_even = psth_per_position_regular_even;
    try
        key_ROI3(i_roi).psth_per_position_small_odd = psth_per_position_small_odd;
        key_ROI3(i_roi).psth_per_position_small_even = psth_per_position_small_even;
        key_ROI3(i_roi).psth_per_position_large_odd = psth_per_position_large_odd;
        key_ROI3(i_roi).psth_per_position_large_even = psth_per_position_large_even;
    catch
    end
    
    try
        key_ROI3(i_roi).psth_per_position_first_odd = psth_per_position_first_odd;
        key_ROI3(i_roi).psth_per_position_first_even = psth_per_position_first_even;
        key_ROI3(i_roi).psth_per_position_begin_odd = psth_per_position_begin_odd;
        key_ROI3(i_roi).psth_per_position_begin_even = psth_per_position_begin_even;
        key_ROI3(i_roi).psth_per_position_mid_odd = psth_per_position_mid_odd;
        key_ROI3(i_roi).psth_per_position_mid_even = psth_per_position_mid_even;
        key_ROI3(i_roi).psth_per_position_end_odd = psth_per_position_end_odd;
        key_ROI3(i_roi).psth_per_position_end_even = psth_per_position_end_even;
    catch
    end
    
    %% DJ insertion of 2D map Stats
    key_ROI4(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI4(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI4(i_roi).number_of_bins = key.number_of_bins;
    key_ROI4(i_roi).number_of_response_trials = sum(idx_response);
    
    key_ROI4(i_roi).lickmap_regular_odd_vs_even_corr = lickmap_regular_odd_vs_even_corr;
    key_ROI4(i_roi).information_per_spike_regular = information_per_spike_regular;
    key_ROI4(i_roi).preferred_bin_regular = preferred_bin_regular;
    key_ROI4(i_roi).preferred_radius_regular = preferred_radius_regular;
    key_ROI4(i_roi).field_size_regular = field_size_regular;
    key_ROI4(i_roi).field_size_without_baseline_regular = field_size_without_baseline_regular;
    key_ROI4(i_roi).centroid_without_baseline_regular = centroid_without_baseline_regular;
    key_ROI4(i_roi).percent_2d_map_coverage_regular = percent_2d_map_coverage_regular;
    key_ROI4(i_roi).percent_2d_map_coverage_regular_odd = 100*sum(~isnan(cell2mat(psth_per_position_regular_odd(:)')'))/sum(numel(cell2mat(psth_per_position_regular_odd(:)')'));
    key_ROI4(i_roi).percent_2d_map_coverage_regular_even = 100*sum(~isnan(cell2mat(psth_per_position_regular_even(:)')'))/sum(numel(cell2mat(psth_per_position_regular_even(:)')'));
    
    %Contcatenating the PSTH across all positions, to get a vector of PSTH
    %lengh X number of positions, and then computing the correlation of the contcatentated PSTH between odd vs even trials
    r=corr([cell2mat(psth_per_position_regular_odd(:)')',cell2mat(psth_per_position_regular_even(:)')'],'Rows' ,'pairwise');
    key_ROI4(i_roi).psth_position_concat_regular_odd_even_corr=r(2);
    
    try
        key_ROI4(i_roi).lickmap_regular_vs_small_corr = lickmap_regular_vs_small_corr;
        key_ROI4(i_roi).lickmap_regular_vs_large_corr = lickmap_regular_vs_large_corr;
        
        key_ROI4(i_roi).information_per_spike_small = information_per_spike_small;
        key_ROI4(i_roi).information_per_spike_large = information_per_spike_large;
        
        key_ROI4(i_roi).preferred_bin_small = preferred_bin_small;
        key_ROI4(i_roi).preferred_bin_large = preferred_bin_large;
        
        key_ROI4(i_roi).preferred_radius_small = preferred_radius_small;
        key_ROI4(i_roi).preferred_radius_large = preferred_radius_large;
        
        key_ROI4(i_roi).field_size_small = field_size_small;
        key_ROI4(i_roi).field_size_large = field_size_large;
        
        key_ROI4(i_roi).field_size_without_baseline_small = field_size_without_baseline_small;
        key_ROI4(i_roi).field_size_without_baseline_large = field_size_without_baseline_large;
        
        key_ROI4(i_roi).centroid_without_baseline_small = centroid_without_baseline_small;
        key_ROI4(i_roi).centroid_without_baseline_large = centroid_without_baseline_large;
        
        
        key_ROI4(i_roi).percent_2d_map_coverage_small = percent_2d_map_coverage_small;
        key_ROI4(i_roi).percent_2d_map_coverage_small_odd =100*sum(~isnan(cell2mat(psth_per_position_small_odd(:)')'))/sum(numel(cell2mat(psth_per_position_small_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_small_even = 100*sum(~isnan(cell2mat(psth_per_position_small_even(:)')'))/sum(numel(cell2mat(psth_per_position_small_even(:)')'));
        
        key_ROI4(i_roi).percent_2d_map_coverage_large = percent_2d_map_coverage_large;
        key_ROI4(i_roi).percent_2d_map_coverage_large_odd = 100*sum(~isnan(cell2mat(psth_per_position_large_odd(:)')'))/sum(numel(cell2mat(psth_per_position_large_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_large_even = 100*sum(~isnan(cell2mat(psth_per_position_large_even(:)')'))/sum(numel(cell2mat(psth_per_position_large_even(:)')'));
        
        %Contcatenating the PSTH across all positions, to get a vector of PSTH
        %lengh X number of positions, and then computing the correlation of the contcatentated PSTH between odd vs even trials
        
        r=corr([cell2mat(psth_per_position_small_odd(:)')',cell2mat(psth_per_position_small_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_small_odd_even_corr=r(2);
        
        r=corr([cell2mat(psth_per_position_large_odd(:)')',cell2mat(psth_per_position_large_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_large_odd_even_corr=r(2);
        
        
    catch
    end
    
    try
        
        key_ROI4(i_roi).lickmap_first_vs_begin_corr=lickmap_first_vs_begin_corr;
        key_ROI4(i_roi).lickmap_first_vs_mid_corr=lickmap_first_vs_mid_corr;
        key_ROI4(i_roi).lickmap_first_vs_end_corr=lickmap_first_vs_end_corr;
        key_ROI4(i_roi).lickmap_begin_vs_end_corr=lickmap_begin_vs_end_corr;
        key_ROI4(i_roi).lickmap_begin_vs_mid_corr=lickmap_begin_vs_mid_corr;
        key_ROI4(i_roi).lickmap_mid_vs_end_corr=lickmap_mid_vs_end_corr;
        
        key_ROI4(i_roi).information_per_spike_first = information_per_spike_first;
        key_ROI4(i_roi).information_per_spike_begin = information_per_spike_begin;
        key_ROI4(i_roi).information_per_spike_mid = information_per_spike_mid;
        key_ROI4(i_roi).information_per_spike_end = information_per_spike_end;
        
        key_ROI4(i_roi).preferred_bin_first = preferred_bin_first;
        key_ROI4(i_roi).preferred_bin_begin = preferred_bin_begin;
        key_ROI4(i_roi).preferred_bin_mid = preferred_bin_mid;
        key_ROI4(i_roi).preferred_bin_end = preferred_bin_end;
        
        key_ROI4(i_roi).field_size_first = field_size_first;
        key_ROI4(i_roi).field_size_begin = field_size_begin;
        key_ROI4(i_roi).field_size_mid = field_size_mid;
        key_ROI4(i_roi).field_size_end = field_size_end;
        
        key_ROI4(i_roi).field_size_without_baseline_first = field_size_without_baseline_first;
        key_ROI4(i_roi).field_size_without_baseline_begin = field_size_without_baseline_begin;
        key_ROI4(i_roi).field_size_without_baseline_mid = field_size_without_baseline_mid;
        key_ROI4(i_roi).field_size_without_baseline_end = field_size_without_baseline_end;
        
        key_ROI4(i_roi).centroid_without_baseline_first = centroid_without_baseline_first;
        key_ROI4(i_roi).centroid_without_baseline_begin = centroid_without_baseline_begin;
        key_ROI4(i_roi).centroid_without_baseline_mid = centroid_without_baseline_mid;
        key_ROI4(i_roi).centroid_without_baseline_end = centroid_without_baseline_end;
        
        key_ROI4(i_roi).percent_2d_map_coverage_first = percent_2d_map_coverage_first;
        key_ROI4(i_roi).percent_2d_map_coverage_first_odd =100*sum(~isnan(cell2mat(psth_per_position_first_odd(:)')'))/sum(numel(cell2mat(psth_per_position_first_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_first_even = 100*sum(~isnan(cell2mat(psth_per_position_first_even(:)')'))/sum(numel(cell2mat(psth_per_position_first_even(:)')'));
        
        key_ROI4(i_roi).percent_2d_map_coverage_begin = percent_2d_map_coverage_begin;
        key_ROI4(i_roi).percent_2d_map_coverage_begin_odd =100*sum(~isnan(cell2mat(psth_per_position_begin_odd(:)')'))/sum(numel(cell2mat(psth_per_position_begin_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_begin_even = 100*sum(~isnan(cell2mat(psth_per_position_begin_even(:)')'))/sum(numel(cell2mat(psth_per_position_begin_even(:)')'));
        
        key_ROI4(i_roi).percent_2d_map_coverage_mid = percent_2d_map_coverage_mid;
        key_ROI4(i_roi).percent_2d_map_coverage_mid_odd =100*sum(~isnan(cell2mat(psth_per_position_mid_odd(:)')'))/sum(numel(cell2mat(psth_per_position_mid_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_mid_even = 100*sum(~isnan(cell2mat(psth_per_position_mid_even(:)')'))/sum(numel(cell2mat(psth_per_position_mid_even(:)')'));
        
        key_ROI4(i_roi).percent_2d_map_coverage_end = percent_2d_map_coverage_end;
        key_ROI4(i_roi).percent_2d_map_coverage_end_odd =100*sum(~isnan(cell2mat(psth_per_position_end_odd(:)')'))/sum(numel(cell2mat(psth_per_position_end_odd(:)')'));
        key_ROI4(i_roi).percent_2d_map_coverage_end_even = 100*sum(~isnan(cell2mat(psth_per_position_end_even(:)')'))/sum(numel(cell2mat(psth_per_position_end_even(:)')'));
        
        
        %Contcatenating the PSTH across all positions, to get a vector of PSTH
        %lengh X number of positions, and then computing the correlation of the contcatentated PSTH between odd vs even trials
        
        r=corr([cell2mat(psth_per_position_first_odd(:)')',cell2mat(psth_per_position_first_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_first_odd_even_corr=r(2);
        
        r=corr([cell2mat(psth_per_position_begin_odd(:)')',cell2mat(psth_per_position_begin_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_begin_odd_even_corr=r(2);
        
        r=corr([cell2mat(psth_per_position_mid_odd(:)')',cell2mat(psth_per_position_mid_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_mid_odd_even_corr=r(2);
        
        r=corr([cell2mat(psth_per_position_end_odd(:)')',cell2mat(psth_per_position_end_even(:)')'],'Rows' ,'pairwise');
        key_ROI4(i_roi).psth_position_concat_end_odd_even_corr=r(2);
        
    catch
    end
    
    
    %% DJ Selectivity
    
    %preferred bins
    psth_preferred_regular =  nanmean(cell2mat(psth_all(i_roi, idx_preferred_trials_regular)'),1);
    psth_preferred_regular_stem =  nanstd(cell2mat(psth_all(i_roi, idx_preferred_trials_regular)'),0,1)/sqrt(sum(idx_preferred_trials_regular));
    
    psth_preferred_regular_odd =  nanmean(cell2mat(psth_all(i_roi, idx_preferred_trials_regular & idx_odd_regular)'),1);
    psth_preferred_regular_even = nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_regular  & idx_even_regular)'),1);
    
    
    %non preferred bins
    psth_non_preferred_regular =  nanmean(cell2mat(psth_all(i_roi, idx_non_preferred_trials_regular)'),1);
    psth_non_preferred_regular_stem =  nanstd(cell2mat(psth_all(i_roi, idx_non_preferred_trials_regular)'),0,1)/sqrt(sum(idx_non_preferred_trials_regular));
    
    psth_non_preferred_regular_odd =  nanmean(cell2mat(psth_all(i_roi, idx_non_preferred_trials_regular & idx_odd_regular)'),1);
    psth_non_preferred_regular_even = nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_regular  & idx_even_regular)'),1);
    
    
    %% DJ insetion of selectivity
    selectivity_regular =psth_preferred_regular - psth_non_preferred_regular;
    selectivity_regular_odd = psth_preferred_regular_odd - psth_non_preferred_regular_odd;
    selectivity_regular_even = psth_preferred_regular_even - psth_non_preferred_regular_even;
    
    key_ROI5(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI5(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI5(i_roi).number_of_bins = key.number_of_bins;
    key_ROI5(i_roi).psth_preferred_regular =  psth_preferred_regular;
    key_ROI5(i_roi).psth_preferred_regular_odd =  psth_preferred_regular_odd;
    key_ROI5(i_roi).psth_preferred_regular_even =  psth_preferred_regular_even;
    key_ROI5(i_roi).psth_non_preferred_regular = psth_non_preferred_regular;
    key_ROI5(i_roi).psth_preferred_regular_stem =  psth_preferred_regular_stem;
    key_ROI5(i_roi).psth_non_preferred_regular_stem = psth_non_preferred_regular_stem;
    
    key_ROI5(i_roi).selectivity_regular = selectivity_regular;
    key_ROI5(i_roi).selectivity_regular_odd = selectivity_regular_odd;
    key_ROI5(i_roi).selectivity_regular_even = selectivity_regular_even;
    
    try
        %selectivity parsed by reward size
        if sum(idx_preferred_trials_small)>timespent_min
            selectivity_small =nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_small)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_small)'),1);
        else
            selectivity_small=time + NaN;
        end
        if sum(idx_preferred_trials_large)>timespent_min
            selectivity_large =nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_large)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_large)'),1);
        else
            selectivity_large=time + NaN;
        end
        
        % selectivity parsed by trial order in blocks
        if sum(idx_preferred_trials_first)>timespent_min
            selectivity_first = nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_first)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_first)'),1);
        else
            selectivity_first=time + NaN;
        end
        
        if sum(idx_preferred_trials_begin)>timespent_min
            selectivity_begin = nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_begin)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_begin)'),1);
        else
            selectivity_begin=time + NaN;
        end
        
        if sum(idx_preferred_trials_mid)>timespent_min
            selectivity_mid = nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_mid)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_mid)'),1);
        else
            selectivity_mid=time + NaN;
        end
        
        if sum(idx_preferred_trials_end)>timespent_min
            selectivity_end = nanmean(cell2mat(psth_all(i_roi,idx_preferred_trials_end)'),1) -  nanmean(cell2mat(psth_all(i_roi,idx_non_preferred_trials_end)'),1);
        else
            selectivity_end=time + NaN;
        end
        
        key_ROI5(i_roi).selectivity_small = selectivity_small;
        key_ROI5(i_roi).selectivity_large = selectivity_large;
        key_ROI5(i_roi).selectivity_first = selectivity_first;
        key_ROI5(i_roi).selectivity_begin = selectivity_begin;
        key_ROI5(i_roi).selectivity_mid = selectivity_mid;
        key_ROI5(i_roi).selectivity_end = selectivity_end;
        
    catch
    end
    
    %% DJ Selectivity Stats
    
    key_ROI6(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI6(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI6(i_roi).number_of_bins = key.number_of_bins;
    
    r = corr([psth_preferred_regular_odd(:),psth_preferred_regular_even(:)+eps],'Rows' ,'pairwise');
    key_ROI6(i_roi).psth_preferred_regular_odd_even_corr = r(2);
    
    [~,idx_peak]=max(psth_preferred_regular);
    key_ROI6(i_roi).peaktime_preferred_regular = time(idx_peak);
    [~,idx_peak]=max(psth_preferred_regular_odd);
    key_ROI6(i_roi).peaktime_preferred_regular_odd = time(idx_peak);
    [~,idx_peak]=max(psth_preferred_regular_even);
    key_ROI6(i_roi).peaktime_preferred_regular_even = time(idx_peak);
    
    r = corr([selectivity_regular_odd(:),selectivity_regular_even(:)],'Rows' ,'pairwise');
    key_ROI6(i_roi).selectivity_regular_odd_even_corr = r(2);
    
    [~,idx_peak]=max(selectivity_regular);
    key_ROI6(i_roi).peaktime_selectivity_regular = time(idx_peak);
    [~,idx_peak]=max(selectivity_regular_odd);
    key_ROI6(i_roi).peaktime_selectivity_regular_odd = time(idx_peak);
    [~,idx_peak]=max(selectivity_regular_even);
    key_ROI6(i_roi).peaktime_selectivity_regular_even = time(idx_peak);
    
    try
        [~,idx_peak]=max(selectivity_small);
        key_ROI6(i_roi).peaktime_selectivity_small = time(idx_peak);
        [~,idx_peak]=max(selectivity_large);
        key_ROI6(i_roi).peaktime_selectivity_large = time(idx_peak);
        [~,idx_peak]=max(selectivity_first);
        key_ROI6(i_roi).peaktime_selectivity_first = time(idx_peak);
        [~,idx_peak]=max(selectivity_begin);
        key_ROI6(i_roi).peaktime_selectivity_begin = time(idx_peak);
        [~,idx_peak]=max(selectivity_mid);
        key_ROI6(i_roi).peaktime_selectivity_mid = time(idx_peak);
        [~,idx_peak]=max(selectivity_end);
        key_ROI6(i_roi).peaktime_selectivity_end = time(idx_peak);
    catch
    end
    
    
    % per ROI insertion
    %     k1=key_ROI1(i_roi);
    %     insert(self, k1);
    %
    %     k2=key_ROI2(i_roi);
    %     insert(self2, k2);
    %
    %     k3=key_ROI3(i_roi);
    %     insert(self3, k3);
    %
    %     k4=key_ROI4(i_roi);
    %     insert(self4, k4);
    %
    %     k5=key_ROI5(i_roi);
    %     insert(self5, k5);
    
    %     k6=key_ROI5(i_roi);
    %     insert(self5, k6);
end

%bulk insertion
insert(self, key_ROI1);
insert(self2, key_ROI2);
insert(self3, key_ROI3);
insert(self4, key_ROI4);
insert(self5, key_ROI5);
insert(self6, key_ROI6);