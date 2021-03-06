function [event_vector]= fn_predictors_task(key, time_bin, predictor_name, num_resampled_frames)

rel_lickport = TRACKING.VideoLickportTrial & key;
rel_lick = TRACKING.VideoNthLickTrial & key;
rel_trial = EXP2.TrialRewardSize*EXP2.TrialLickBlock & key;
rel_trial_reward_time = EXP2.BehaviorTrialEvent & 'trial_event_type="reward"'& key;

rel_licport_pos=EXP2.TrialLickPort & key;

% time_resampled = (0:1:num_resampled_frames)/sampling_rate_2p;  %% for the mesoscope we binned the video according to the mesoscope frame rate because it was very slow anyway

time_resampled = (0:1:num_resampled_frames)/(1/time_bin);
event_vector = time_resampled(2:1:end)*0;

event=[];
event_start=[];
event_end=[];

event_size=1; % by default -- it will only change for LickPort_pos_x, LickPort_pos_z
switch predictor_name
    
    
    case 'LickPort_pos_x' %front view
        event_size= fetch1(rel_licport_pos ,'lickport_pos_x')/10000;%
        event_start= fetch1(rel_lickport ,'lickport_t_entrance_relative_to_trial_start');
        event_end= fetch1(rel_lickport.proj('lickport_t_entrance_relative_to_trial_start + lickport_lickable_duration -> t_exit'),'t_exit');
        idx_event_start = find(time_resampled<=event_start,1,'last');
        idx_event_end = find(time_resampled>event_end,1,'first')-1;
        event = time_resampled(idx_event_start:1:idx_event_end);

    case 'LickPort_pos_z' %front view
        event_size= fetch1(rel_licport_pos ,'lickport_pos_z')/10000;%
        event_start= fetch1(rel_lickport ,'lickport_t_entrance_relative_to_trial_start');
        event_end= fetch1(rel_lickport.proj('lickport_t_entrance_relative_to_trial_start + lickport_lickable_duration -> t_exit'),'t_exit');
        idx_event_start = find(time_resampled<=event_start,1,'last');
        idx_event_end = find(time_resampled>event_end,1,'first')-1;
        event = time_resampled(idx_event_start:1:idx_event_end);
        
    case 'LickPortEntrance'
        event= fetch1(rel_lickport ,'lickport_t_entrance_relative_to_trial_start');
    case 'LickPortExit'
        event= fetch1(rel_lickport.proj('lickport_t_entrance_relative_to_trial_start + lickport_lickable_duration -> t_exit'),'t_exit');
    case 'Lick'
        event= fetchn(rel_lick,'lick_time_onset_relative_to_trial_start','ORDER BY LICK_NUMBER');%
    case 'LickTouch'
        event= fetchn(rel_lick & 'lick_touch_number>0', 'lick_time_onset_relative_to_trial_start','ORDER BY LICK_NUMBER');%
    case 'LickNoTouch'
        event= fetchn(rel_lick  & 'lick_touch_number=-1', 'lick_time_onset_relative_to_trial_start','ORDER BY LICK_NUMBER');%
    case 'LickTouchReward'
        event= fetchn(rel_lick  & 'lick_touch_number>0' & 'lick_number_with_touch_relative_to_reward>0', 'lick_time_onset_relative_to_trial_start','ORDER BY LICK_NUMBER');%
    case 'LickTouchNoReward'
        event= fetchn(rel_lick  & 'lick_touch_number>0' & 'lick_number_with_touch_relative_to_reward=-1', 'lick_time_onset_relative_to_trial_start', 'ORDER BY LICK_NUMBER');%
    case 'LickTouchNoRewardOmitted'
        if ~isempty(fetchn(rel_trial & 'reward_size_type="omission"','reward_size_type'))
            event= fetchn(rel_lick  & 'lick_touch_number>0' & 'lick_number_with_touch_relative_to_reward>0', 'lick_time_onset_relative_to_trial_start', 'ORDER BY LICK_NUMBER');%
        end
    case 'FirstLickTouch'
        event= fetchn(rel_lick & 'lick_touch_number=1', 'lick_time_onset_relative_to_trial_start' ,'ORDER BY LICK_NUMBER');%
    case 'FirstLickReward'
        event= fetchn(rel_lick & 'lick_number_with_touch_relative_to_reward=1','lick_time_onset_relative_to_trial_start' ,'ORDER BY LICK_NUMBER');%
    case 'RewardDelivery'
        event= fetchn(rel_trial_reward_time ,'trial_event_time');%
    case 'RewardSize'
        event= fetchn(rel_trial & 'reward_size_type="large"','reward_size_type');
        if ~isempty(event)
            event= fetchn(rel_trial_reward_time ,'trial_event_time');
        end
    case 'RewardOmission'
        event= fetchn(rel_trial & 'reward_size_type="omission"','reward_size_type');
        if ~isempty(event)
            event= fetchn(rel_trial_reward_time ,'trial_event_time');
        end
    case 'LickPortBlockStart'
        event= fetchn(rel_trial & 'current_trial_num_in_block=1','current_trial_num_in_block');%
        if ~isempty(event)
            event= fetch1(rel_lickport ,'lickport_t_entrance_relative_to_trial_start');
        end
    case 'AutoWater'
        event= fetchn(rel_trial & 'flag_auto_water_curret_trial=1','flag_auto_water_curret_trial');%
        if ~isempty(event)
            event= fetchn(rel_trial_reward_time ,'trial_event_time');%
        end
end




if isempty(event)
    return
end

for ii=1:1:numel(time_resampled)-1
    idx_b = event>=time_resampled(ii) & event <time_resampled(ii+1);
    event_vector(ii) =  sum(idx_b)*event_size; %For each 2p imaging frame we save the number of events that happened in this bin.
end


