function    lick2D_video_yaw_learning_across_block()
clf







corr_mean_before=[];
corr_stem_before=[];

corr_mean_after=[];
corr_stem_after=[];

%% BEFORE LICKPORT ENTRANCE
for current_trial_num_in_block=1:1:10
    
    T_before= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort )-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'lick_number_relative_to_lickport_entrance<0'),'lick_peak_x','lickport_x','session_uid');
    unique_sessions_before=unique([T_before.session_uid]);
    temp_corr_before=[];
    
    for i_s=1:numel(unique_sessions_before)
        TS = T_before([T_before.session_uid]==unique_sessions_before(i_s));
        temp_corr_before(end+1) =corr([TS.lickport_x]',[TS.lick_peak_x]','Rows','pairwise');
    end
    corr_mean_before (end+1) = nanmean(temp_corr_before);
    corr_stem_before (end+1)  = nanstd(temp_corr_before)/sqrt(i_s);
    
    T_after= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort )-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'lick_number_relative_to_lickport_entrance>=0'),'lick_peak_x','lickport_x','session_uid');
    unique_sessions_after=unique([T_after.session_uid]);
    temp_corr_after=[];
    for i_s=1:numel(unique_sessions_after)
        TS = T_after([T_after.session_uid]==unique_sessions_after(i_s));
        temp_corr_after(end+1) =corr([TS.lickport_x]',[TS.lick_peak_x]','Rows','pairwise');
    end
    corr_mean_after (end+1) = nanmean(temp_corr_after);
    corr_stem_after (end+1)  = nanstd(temp_corr_after)/sqrt(i_s);
    
end


subplot(2,2,1)
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(corr_mean_before,3) ,smooth(corr_stem_before,3),'lineprops',{'-','Color',[0.5 0.5 0.5]});
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Trial number in block');
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0,0.4])
xlim([1,10])
title('Before target appearence');

subplot(2,2,2)
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(corr_mean_after,3) ,smooth(corr_stem_after,3),'lineprops',{'-','Color',[0.5 0.5 0.5]});
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Trial number in block');
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0.6,0.75])
xlim([1,10])
title('After target appearence');

end
