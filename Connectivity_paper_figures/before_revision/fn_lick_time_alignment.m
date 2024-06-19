function [t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue)

%time
time_go = fetchn(rel_behavior_trial ,'trial_event_time','ORDER BY trial'); %relative to trial start
lickport_t_entrance=fetchn(TRACKING.VideoLickportTrial & key_tongue, 'lickport_t_entrance'); % relative to Go cue
lick_time_electric_1st_contact_lick = fetchn(TRACKING.VideoNthLickTrial & key_tongue & 'lick_number_relative_to_firsttouch=0','lick_time_electric','ORDER BY trial'); %lick onset time, relative to movinglickport entrance in case lickport is moving
lick_time_electric_all = fetchn(TRACKING.VideoNthLickTrial & key_tongue,'lick_time_electric','ORDER BY trial'); %lick onset time, relative to movinglickport entrance in case lickport is moving
ttt=fetch(TRACKING.TrackingTrial & key_tongue,'*');
frame_rate=ttt.tracking_sampling_rate;
num_frames=ttt.tracking_num_samples;
tracking_start_time=ttt.tracking_start_time;
t_relative_trial_start = [0:(1/frame_rate): (num_frames-1)/frame_rate] + tracking_start_time;
t  =t_relative_trial_start- time_go; % relative to Go cue. We will set it later relative to lickport move onset, in case of moving lickport
t  =t- (lick_time_electric_1st_contact_lick + lickport_t_entrance); % relative to Go cue. We will set it later relative to lickport move onset, in case of moving lickport
% lick_time_electric_all_aligned = lick_time_electric_all-lick_time_electric_all(1);
lick_time_electric_all_aligned = lick_time_electric_all-lick_time_electric_1st_contact_lick;

TT=fetch(TRACKING.VideoTongueTrial & key_tongue,'*');
% licks_time_onset = TT.licks_time_onset - lick_time_electric_all(1);
licks_time_onset = TT.licks_time_onset - lick_time_electric_1st_contact_lick;
licks_time_ends = licks_time_onset + TT.licks_duration_total;

for i_l=1:1:numel(lick_time_electric_all_aligned)
    [~, idx_lick_contact_time(i_l)] = min(abs(t - lick_time_electric_all_aligned(i_l)));
    [~, idx_licks_time_onset(i_l)] = min(abs(t - licks_time_onset(i_l)));
    [~, idx_licks_time_ends(i_l)] = min(abs(t - licks_time_ends(i_l)));
end
% idx_lick_contact_time(isnan(lick_time_electric_all_aligned))=[];



