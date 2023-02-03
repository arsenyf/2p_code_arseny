function    lick2D_video_yaw_learning_across_blocks_electric()
clf

% subject_list=[463189,464724,464725,463190,462458];


lick_onset_mean=[];
lick_onset_stem=[];


for current_trial_num_in_block=1:1:7
    
     %% ONSET to touch
     T_first_touch= fetch(((EXP2.BehaviorTrial * EXP2.BehaviorTrialEvent * EXP2.ActionEvent * EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*EXP2.SessionBehavioral) & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'action_event_type="lick"' &  'trial_event_type="go"' & 'behavioral_session_number>0'),'action_event_time','trial_event_time','session_uid','trial_uid');
     
     
    unique_sessions=unique([T_first_touch.session_uid]);
    temp_onset=[];

    for i_s=1:numel(unique_sessions)
        TS_onset = T_first_touch([T_first_touch.session_uid]==unique_sessions(i_s));
%         current_subject=unique([TS.subject_id]);
%         if sum(subject_list==current_subject)<=0
%             continue
%         end
        
        trials = unique([TS_onset.trial_uid]);
        lick_onset_trial=[];
        for i_tr=1:1:numel(trials)
        TS_onset_tr = TS_onset([TS_onset.trial_uid]==trials(i_tr));
        lick_onset_trial(i_tr) = min([TS_onset_tr.action_event_time]- [TS_onset_tr.trial_event_time]);
        end
        
        temp_onset(end+1) =nanmedian(lick_onset_trial);

    end
    
    lick_onset_mean (end+1) = nanmedian(temp_onset);
    lick_onset_stem (end+1)  = nanstd(temp_onset)/sqrt(i_s);


end


subplot(2,2,1)
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(lick_onset_mean,3) ,smooth(lick_onset_stem,3),'lineprops',{'-','Color',[1 0 0]});
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Trial number in block');
ylabel(sprintf('Lick time (s)\n relative to target appearence'));
ylim([0.4,0.7])
xlim([1,7])
title('First lick with target contact');


end
