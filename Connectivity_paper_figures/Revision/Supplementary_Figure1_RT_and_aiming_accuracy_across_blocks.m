function    Supplementary_Figure1_RT_and_aiming_accuracy_across_blocks()

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_RT_and_aiming_accuracy_across_blocks')];

%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);


panel_width1=0.12;
panel_height1=0.2;
horizontal_dist1=0.2;
vertical_dist1=0.3;
position_x1(1)=0.15;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;


% subject_list=[463189,464724,464725,463190,462458];



%% All Mice
corr_mean_before=[];
corr_stem_before=[];

corr_mean_after=[];
corr_stem_after=[];

lick_onset_mean=[];
lick_onset_stem=[];

    corr_mean_first_touch=[];
    corr_stem_first_touch=[];
    
for current_trial_num_in_block=1:1:7
    
     %% ONSET to touch
     T_first_touch= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort*EXP2.SessionBehavioral )-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'lick_touch_number=1' & 'behavioral_session_number>=1'),'lick_time_onset','session_uid');

    %% BEFORE LICKPORT ENTRANCE
    T_before= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort* EXP2.SessionBehavioral)-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'lick_number_relative_to_lickport_entrance<0'  & 'behavioral_session_number>=1'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');
    
     
    
    unique_sessions_before=unique([T_before.session_uid]);
    temp_corr_before=[];
    temp_onset=[];

    for i_s=1:numel(unique_sessions_before)
        
        
        TS = T_before([T_before.session_uid]==unique_sessions_before(i_s));
        
%         current_subject=unique([TS.subject_id]);
%         if sum(subject_list==current_subject)<=0
%             continue
%         end

        
        TS_onset = T_first_touch([T_first_touch.session_uid]==unique_sessions_before(i_s));

        temp_corr_before(end+1) =corr([TS.lickport_x]',[TS.lick_peak_x]','Rows','pairwise');
        temp_onset(end+1) =nanmedian([TS_onset.lick_time_onset]);

    end
    corr_mean_before (end+1) = nanmean(temp_corr_before);
    corr_stem_before (end+1)  = nanstd(temp_corr_before)/sqrt(i_s);
    
    lick_onset_mean (end+1) = nanmean(temp_onset);
    lick_onset_stem (end+1)  = nanstd(temp_onset)/sqrt(i_s);


    %% Lick at first contact

    
    T_first_touch= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort*EXP2.SessionBehavioral )-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) & 'lick_touch_number=1' & 'behavioral_session_number>=3'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');

    unique_sessions_after=unique([T_first_touch.session_uid]);
    temp_corr_first_touch=[];
    for i_s=1:numel(unique_sessions_after)
        TS = T_first_touch([T_first_touch.session_uid]==unique_sessions_after(i_s));
        
%         current_subject=unique([TS.subject_id]);
%         if sum(subject_list==current_subject)<=0
%             continue
%         end
        
        temp_corr_first_touch(end+1) =corr([TS.lickport_x]',[TS.lick_peak_x]','Rows','pairwise');
    end
    corr_mean_first_touch (end+1) = nanmean(temp_corr_first_touch);
    corr_stem_first_touch (end+1)  = nanstd(temp_corr_first_touch)/sqrt(i_s);

    
        %% AFTER LICKPORT ENTRANCE

%     T_after= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort *EXP2.SessionBehavioral)-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) &  'lick_number_relative_to_firsttouch>0'  & 'behavioral_session_number>=4'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');
T_after= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort *EXP2.SessionBehavioral)-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) &  'lick_number_relative_to_firsttouch>0'  & 'behavioral_session_number>=1'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');

% T_after= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort *EXP2.SessionBehavioral)-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) &  'lick_number_relative_to_firsttouch>0' & 'lick_touch_number=-1' & 'behavioral_session_number>=1'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');
%         T_after= fetch(((TRACKING.VideoNthLickTrial*EXP2.SessionID*EXP2.TrialLickBlock*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort *EXP2.SessionBehavioral)-TRACKING.VideoGroomingTrial & 'trial>100' & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block) &  'lick_number_relative_to_firsttouch>0' & 'lick_touch_number>1' & 'behavioral_session_number>=1'),'lick_peak_x','lick_time_onset','lickport_x','session_uid');

    unique_sessions_after=unique([T_after.session_uid]);
    temp_corr_after=[];
    for i_s=1:numel(unique_sessions_after)
        TS = T_after([T_after.session_uid]==unique_sessions_after(i_s));
        
%         current_subject=unique([TS.subject_id]);
%         if sum(subject_list==current_subject)<=0
%             continue
%         end
        
        temp_corr_after(end+1) =corr([TS.lickport_x]',[TS.lick_peak_x]','Rows','pairwise');
    end
    corr_mean_after (end+1) = nanmean(temp_corr_after);
    corr_stem_after (end+1)  = nanstd(temp_corr_after)/sqrt(i_s);
    
end
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(lick_onset_mean,3) ,smooth(lick_onset_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Trial number in block');
ylabel(sprintf('Time to contact (s),\n relative to target appearence'));
ylim([0.55,0.85])
xlim([1,7])
set(gca, 'FontSize',8);
title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);
text(4,0.72,sprintf('First \ncontact lick'),'Color',[0.5 0.25 0.25])


axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(corr_mean_first_touch,3) ,smooth(corr_stem_first_touch,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
shadedErrorBar(1:1:current_trial_num_in_block,smooth(corr_mean_after,3) ,smooth(corr_stem_after,3),'lineprops',{'-','Color',[0.25 0.25 0.25]});
text(4,0.55,sprintf('First \ncontact lick'),'Color',[0.5 0.25 0.25])
text(2,0.7,sprintf('All subsequent \nlicks'),'Color',[0.25 0.25 0.25])
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Trial number in block');
ylabel(sprintf('Correlation in (tongue,target)\n position, r'));
ylim([0.5,0.8])
xlim([1,7])
title(sprintf('Aiming accuracy'),'FontWeight','Bold', 'FontSize',8);
set(gca, 'FontSize',8);


% axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
% hold on
% % plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
% xlabel('Trial number in block');
% ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
% ylim([0.5,0.7])
% xlim([1,7])
% title(sprintf('Licks after target \nappearence'),'Color',[0 0 0.5]);
% set(gca, 'FontSize',8);






if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

end
