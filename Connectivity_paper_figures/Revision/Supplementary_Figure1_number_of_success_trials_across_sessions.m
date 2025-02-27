function    Supplementary_Figure1_number_of_success_trials_across_sessions()


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_success_trials_accuracy_across_sessions')];

%% average number of sessions per animal 

S=fetch(EXP2.SessionBehavioral & PAPER.ROILICK2DInclusion,'*');

subjects=unique([S.subject_id]);
behavioral_sessions_per_subject = [];
for i_subj = 1:1:numel(subjects)
    behavioral_sessions_per_subject(i_subj) = numel(find ([S.subject_id] == subjects(i_subj)))
end

mean(behavioral_sessions_per_subject);
max(behavioral_sessions_per_subject);
std(behavioral_sessions_per_subject)/sqrt(numel(behavioral_sessions_per_subject));

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
panel_height1=0.12;
horizontal_dist1=0.2;
vertical_dist1=0.3;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;

% subject_list=[463189,464724,464725,463190,462458];

subject_list=unique(fetchn(TRACKING.VideoNthLickTrial,'subject_id'));

percent_success_trials=[];
percent_contact_licks =[];
percent_contact_licks_after_first_contact =[];
percent_contact_licks_after_lickport_entrance =[];
number_licks =[];
number_licks_before_lickport_entrance =[];
number_licks_after_lickport_entrance =[];

subj_counter=0;


for i_sub = 1:1:numel(subject_list)
    %     clf;
    key=[];
    key.subject_id =subject_list(i_sub);
    sessions_list = fetchn(EXP2.Session & TRACKING.VideoNthLickTrial & key, 'session');
    if numel(sessions_list)<=3
        continue
    end
    subj_counter=subj_counter+1;
    for i_ses = 1:1:numel(sessions_list)
        
        %% Percent of trials with contant, percent of licks with contact
        key.session = sessions_list(i_ses);
        
        rel_behavior = (EXP2.BehaviorTrial*EXP2.SessionTrialUniqueIDCorrect &  key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale&  key) - TRACKING.VideoGroomingTrial;
        B=fetch(rel_behavior, 'outcome','trial_uid_correct', 'ORDER BY trial_uid_correct');
        outcome ={B.outcome};
        
        percent_ignore = 100*sum(contains(outcome,'ignore'))/numel(outcome);
        percent_success_trials {subj_counter,i_ses} = 100-percent_ignore;
%         idx_hit_trials = contains(outcome,'hit');
        
        rel_licks_count = (TRACKING.VideoLickCountTrial*EXP2.SessionTrialUniqueIDCorrect & key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale &  key) - TRACKING.VideoGroomingTrial;
        LICK_COUNT=fetch(rel_licks_count,'*', 'ORDER BY trial_uid_correct');
        
        
        percent_contact_licks {subj_counter,i_ses} =nanmean(100*[LICK_COUNT.licks_byelectric_contact]./[LICK_COUNT.licks_byvideo_in_trial]);
        percent_contact_licks_after_first_contact {subj_counter,i_ses} = nanmean(100*[LICK_COUNT.licks_byelectric_contact]./[LICK_COUNT.licks_byvideo_after_1st_contact_including]);
        percent_contact_licks_after_lickport_entrance {subj_counter,i_ses} = nanmean(100*[LICK_COUNT.licks_byelectric_contact]./[LICK_COUNT.licks_byvideo_after_lickport_entrance]);
        number_licks_before_lickport_entrance{subj_counter,i_ses} = nanmean([LICK_COUNT.licks_byvideo_before_lickport_entrance]);
        number_licks_after_lickport_entrance {subj_counter,i_ses} = nanmean([LICK_COUNT.licks_byvideo_after_lickport_entrance]);
        number_licks {subj_counter,i_ses} = nanmean([LICK_COUNT.licks_byvideo_in_trial]);

        
        
      

%         percent_contact_licks {subj_counter,i_ses} = nanmean(percentage_contact_licks_per_trial(idx_hit_trials));
    end
end


%% Mean and STEM across sessions
for i_s= 1:1:size(subject_list)
    percent_success_trials_mean(i_s)=mean([percent_success_trials{:,i_s}]);
    percent_success_trials_stem(i_s)=std([percent_success_trials{:,i_s}])./sqrt(numel(subject_list));
    
    percent_contact_licks_mean(i_s)=mean([percent_contact_licks{:,i_s}]);
    percent_contact_licks_stem(i_s)=std([percent_contact_licks{:,i_s}])./sqrt(numel(subject_list));
    
    percent_contact_licks_after_first_contact_mean(i_s)=mean([percent_contact_licks_after_first_contact{:,i_s}]);
    percent_contact_licks_after_first_contact_stem(i_s)=std([percent_contact_licks_after_first_contact{:,i_s}])./sqrt(numel(subject_list));
    
    percent_contact_licks_after_lickport_entrance_mean (i_s)=mean([percent_contact_licks_after_lickport_entrance{:,i_s}]);
    percent_contact_licks_after_lickport_entrance_stem (i_s)=std([percent_contact_licks_after_lickport_entrance{:,i_s}])./sqrt(numel(subject_list));
    
    number_licks_before_lickport_entrance_mean (i_s)=mean([number_licks_before_lickport_entrance{:,i_s}]);
    number_licks_before_lickport_entrance_stem (i_s)=std([number_licks_before_lickport_entrance{:,i_s}])./sqrt(numel(subject_list));
    
    number_licks_after_lickport_entrance_mean (i_s)=mean([number_licks_after_lickport_entrance{:,i_s}]);
    number_licks_after_lickport_entrance_stem (i_s)=std([number_licks_after_lickport_entrance{:,i_s}])./sqrt(numel(subject_list));
 
    number_licks_mean (i_s)=mean([number_licks{:,i_s}]);
    number_licks_stem (i_s)=std([number_licks{:,i_s}])./sqrt(numel(subject_list));

    
end


axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(percent_success_trials_mean,3) ,smooth(percent_success_trials_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Trials with succesfull \n target contacts (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([90,100])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);

axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(percent_contact_licks_after_lickport_entrance_mean,3) ,smooth(percent_contact_licks_after_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Licks with contacts \n after target appearance (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([60,90])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(number_licks_mean,3) ,smooth(number_licks_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Number of licks per trial'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,12])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(4),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(number_licks_before_lickport_entrance_mean,3) ,smooth(number_licks_before_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
shadedErrorBar(1:1:i_s,smooth(number_licks_after_lickport_entrance_mean,3) ,smooth(number_licks_after_lickport_entrance_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Number of licks per trial before after lickport entrance'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,10])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);



axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(percent_contact_licks_mean,3) ,smooth(percent_contact_licks_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Contact licks (%%)'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,100])
xlim([1,7])
set(gca, 'FontSize',8);
% title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);


axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(percent_contact_licks_after_first_contact_mean,3) ,smooth(percent_contact_licks_after_first_contact_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
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

