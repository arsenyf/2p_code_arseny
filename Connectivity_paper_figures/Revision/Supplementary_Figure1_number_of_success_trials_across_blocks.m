function    Supplementary_Figure1_number_of_success_trials_across_blocks()

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_success_trials_accuracy_across_blocks')];

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
percent_success_trials=[];
percent_contact_licks =[];
percent_contact_licks_after_first_contact =[];
percent_contact_licks_after_lickport_entrance =[];
number_licks =[];
number_licks_before_lickport_entrance =[];
number_licks_after_lickport_entrance =[];
outcome_session=[];

for current_trial_num_in_block=1:1:7
    
    key=[];
    rel_behavior = (EXP2.BehaviorTrial*EXP2.TrialLickBlock*EXP2.SessionTrialUniqueIDCorrect*EXP2.SessionID &  key & TRACKING.VideoNthLickTrial & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block)) & (EXP2.TrialLickPortPositionRescale&  key) - TRACKING.VideoGroomingTrial;
    B=fetch(rel_behavior, 'outcome','trial_uid_correct', 'ORDER BY trial_uid_correct');
    outcome ={B.outcome};
    
    rel_licks_count = (TRACKING.VideoLickCountTrial*EXP2.TrialLickBlock*EXP2.SessionTrialUniqueIDCorrect*EXP2.SessionID & key & TRACKING.VideoNthLickTrial & sprintf('current_trial_num_in_block=%d',current_trial_num_in_block)) & (EXP2.TrialLickPortPositionRescale &  key) - TRACKING.VideoGroomingTrial;
    LICK_COUNT=fetch(rel_licks_count,'*', 'ORDER BY trial_uid_correct');
    
    unique_sessions_before=unique([LICK_COUNT.session_uid]);

    for i_s=1:numel(unique_sessions_before)
        
        idx = [LICK_COUNT.session_uid]==unique_sessions_before(i_s);
        LICK_COUNT_session = LICK_COUNT(idx);
        
        outcome_session = outcome(idx);
        percent_ignore = 100*sum(contains(outcome_session,'ignore'))/numel(outcome_session);
        percent_success_trials (i_s) = 100-percent_ignore;
        
        percent_contact_licks (i_s) =nanmean(100*[LICK_COUNT_session.licks_byelectric_contact]./[LICK_COUNT_session.licks_byvideo_in_trial]);
        percent_contact_licks_after_first_contact (i_s) = nanmean(100*[LICK_COUNT_session.licks_byelectric_contact]./[LICK_COUNT_session.licks_byvideo_after_1st_contact_including]);
        percent_contact_licks_after_lickport_entrance (i_s) = nanmean(100*[LICK_COUNT_session.licks_byelectric_contact]./[LICK_COUNT_session.licks_byvideo_after_lickport_entrance]);
        number_licks_before_lickport_entrance(i_s) = nanmean([LICK_COUNT_session.licks_byvideo_before_lickport_entrance]);
        number_licks_after_lickport_entrance (i_s) = nanmean([LICK_COUNT_session.licks_byvideo_after_lickport_entrance]);
        number_licks (i_s) = nanmean([LICK_COUNT_session.licks_byvideo_in_trial]);
        
    end
    
    %% Mean and STEM across sessions, for each block
    percent_success_trials_mean(current_trial_num_in_block)=mean([percent_success_trials]);
    percent_success_trials_stem(current_trial_num_in_block)=std([percent_success_trials])./sqrt(numel(unique_sessions_before));
    
    percent_contact_licks_mean(current_trial_num_in_block)=mean([percent_contact_licks]);
    percent_contact_licks_stem(current_trial_num_in_block)=std([percent_contact_licks])./sqrt(numel(unique_sessions_before));
    
    percent_contact_licks_after_first_contact_mean(current_trial_num_in_block)=mean([percent_contact_licks_after_first_contact]);
    percent_contact_licks_after_first_contact_stem(current_trial_num_in_block)=std([percent_contact_licks_after_first_contact])./sqrt(numel(unique_sessions_before));
    
    percent_contact_licks_after_lickport_entrance_mean (current_trial_num_in_block)=mean([percent_contact_licks_after_lickport_entrance]);
    percent_contact_licks_after_lickport_entrance_stem (current_trial_num_in_block)=std([percent_contact_licks_after_lickport_entrance])./sqrt(numel(unique_sessions_before));
    
    number_licks_before_lickport_entrance_mean (current_trial_num_in_block)=mean([number_licks_before_lickport_entrance]);
    number_licks_before_lickport_entrance_stem (current_trial_num_in_block)=std([number_licks_before_lickport_entrance])./sqrt(numel(unique_sessions_before));
    
    number_licks_after_lickport_entrance_mean (current_trial_num_in_block)=mean([number_licks_after_lickport_entrance]);
    number_licks_after_lickport_entrance_stem (current_trial_num_in_block)=std([number_licks_after_lickport_entrance])./sqrt(numel(unique_sessions_before));
    
    number_licks_mean (current_trial_num_in_block)=mean([number_licks]);
    number_licks_stem (current_trial_num_in_block)=std([number_licks])./sqrt(numel(unique_sessions_before));
        
       
end
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(percent_success_trials_mean,3) ,smooth(percent_success_trials_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Trials with succesfull \n target contacts (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([90,100])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);

axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(percent_contact_licks_after_lickport_entrance_mean,3) ,smooth(percent_contact_licks_after_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Licks with contacts \n after target appearance (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([60,90])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(number_licks_mean,3) ,smooth(number_licks_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Number of licks per trial'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,12])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(4),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(number_licks_before_lickport_entrance_mean,3) ,smooth(number_licks_before_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
shadedErrorBar(1:1:current_trial_num_in_block,smooth(number_licks_after_lickport_entrance_mean,3) ,smooth(number_licks_after_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Number of licks per trial before after lickport entrance'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,10])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);



axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(percent_contact_licks_mean,3) ,smooth(percent_contact_licks_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Contact licks (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,100])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:current_trial_num_in_block,smooth(percent_contact_licks_after_first_contact_mean,3) ,smooth(percent_contact_licks_after_first_contact_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Block', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Contact licks, after first contact (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,100])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

end
