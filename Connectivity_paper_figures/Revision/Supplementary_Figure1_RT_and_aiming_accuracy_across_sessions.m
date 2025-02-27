function    Supplementary_Figure1_RT_and_aiming_accuracy_across_sessions()


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_RT_and_aiming_accuracy_across_sessions')];

%% average number of sessions per animal 

S=fetch(EXP2.SessionBehavioral & PAPER.ROILICK2DInclusion,'*');

subjects=unique([S.subject_id]);
behavioral_sessions_per_subject = [];
for i_subj = 1:1:numel(subjects)
    behavioral_sessions_per_subject(i_subj) = numel(find ([S.subject_id] == subjects(i_subj)))
end

mean(behavioral_sessions_per_subject)
max(behavioral_sessions_per_subject)
std(behavioral_sessions_per_subject)/sqrt(numel(behavioral_sessions_per_subject))
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
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1*1.2;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;
position_y1(end+1)=position_y1(end)-vertical_dist1;

% subject_list=[463189,464724,464725,463190,462458];

subject_list=unique(fetchn(TRACKING.VideoNthLickTrial,'subject_id'));

x_tong_port_corr_after=[];
x_tong_port_corr_before=[];
x_tong_port_corr_first_touch=[];
x_tong_port_corr_later_touch=[];
before_licks_all=[];
after_licks_all=[];
% licks_contact=[];
first_touch_onset=[];

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
        
        %% ONSET to touch all licks
        key.session = sessions_list(i_ses);
        first_touch_onset{subj_counter,i_ses} = median([fetchn((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_touch_number=1','lick_time_onset')]);

        %% BEFORE LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance<=-1','lick_peak_x','lickport_x');
        x_tong_port_corr_before{subj_counter,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');
        
       trials_list_total= unique(fetchn((TRACKING.TrackingTrial & key) -TRACKING.VideoGroomingTrial & 'trial>100', 'trial'));

        
        trials_list= unique([T.trial]);
%         early_licks_trials=[];
%         for i_tr=1:1:numel(trials_list)
%             idx_this_trial = [T.trial]==trials_list(i_tr);
%             
%             %         lick_yaw_lickbout = [T(idx_this_trial).lick_yaw_lickbout];
%             %         idx_early =[T(idx_this_trial).lick_number_relative_to_lickport_entrance]<0;
%             %         idx_late =[T(idx_this_trial).lick_number_relative_to_lickport_entrance]>=0;
%             %         num_of_not_nan_licks = sum(~isnan(lick_yaw_lickbout(idx_early)));
%             %         if num_of_not_nan_licks>1
%             %             yaw_early_std(subj_counter) =nanstd(lick_yaw_lickbout(idx_early));%/sqrt(num_of_not_nan_licks);
%             %         end
%             %         num_of_not_nan_licks = sum(~isnan(lick_yaw_lickbout(idx_late)));
%             %         if  num_of_not_nan_licks>1
%             %             yaw_late_std(subj_counter) =nanstd(lick_yaw_lickbout(idx_late));%/sqrt(num_of_not_nan_licks);
%             %         end
%             %         [T(idx_this_trial).lick_number_relative_to_lickport_entrance]<0)
%             
%             
%             early_licks_trials(i_tr) =sum(idx_this_trial);
%             %         kk.trial=trials(i_tr);
%             %         early_licks(i_tr) = numel(fetchn((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*EXP2.TrialLickBlock & key & kk & 'lick_number_relative_to_lickport_entrance<0')-TRACKING.VideoGroomingTrial,'lick_time_onset'));
%             
%         end
        
%         early_licks_all{subj_counter,i_ses} = mean(early_licks_trials);
        before_licks_all{subj_counter,i_ses} = numel(T)/numel(trials_list_total);
        
        
        
        %% AFTER LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance>=0','lick_peak_x','lickport_x');
        x_tong_port_corr_after{subj_counter,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');
        trials_list= unique([T.trial]);
        after_licks_all{subj_counter,i_ses} = numel(T)/numel(trials_list_total);

        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_firsttouch=0','lick_peak_x','lickport_x');
        x_tong_port_corr_first_touch{subj_counter,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');
        
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_firsttouch>0','lick_peak_x','lickport_x');
        x_tong_port_corr_later_touch{subj_counter,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');
        
%          T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_touch_number>0');
%         trials_list= unique([T.trial]);
%         licks_contact{subj_counter,i_ses} = numel(T)/numel(trials_list);

    end
    
end


%% Mean and STEM across sessions
for i_s= 1:1:size(x_tong_port_corr_after,2)
    x_corr_mean_after(i_s)=mean([x_tong_port_corr_after{:,i_s}]);
    x_corr_stem_after(i_s)=std([x_tong_port_corr_after{:,i_s}])./sqrt(numel([x_tong_port_corr_after{:,i_s}]));
    
    x_corr_mean_before(i_s)=mean([x_tong_port_corr_before{:,i_s}]);
    x_corr_stem_before(i_s)=std([x_tong_port_corr_before{:,i_s}])./sqrt(numel([x_tong_port_corr_before{:,i_s}]));
    
    x_corr_mean_first_touch(i_s)=mean([x_tong_port_corr_first_touch{:,i_s}]);
    x_corr_stem_first_touch(i_s)=std([x_tong_port_corr_first_touch{:,i_s}])./sqrt(numel([x_tong_port_corr_first_touch{:,i_s}]));
    
    x_corr_mean_later_touch(i_s)=mean([x_tong_port_corr_later_touch{:,i_s}]);
    x_corr_stem_later_touch(i_s)=std([x_tong_port_corr_later_touch{:,i_s}])./sqrt(numel([x_tong_port_corr_later_touch{:,i_s}]));
    
    before_licks_mean(i_s)=mean([before_licks_all{:,i_s}]);
    before_licks_stem(i_s)=std([before_licks_all{:,i_s}])./sqrt(numel([before_licks_all{:,i_s}]));

    after_licks_mean(i_s)=mean([ after_licks_all{:,i_s}]);
     after_licks_stem(i_s)=std([ after_licks_all{:,i_s}])./sqrt(numel([ after_licks_all{:,i_s}]));

     
     
     first_touch_onset_mean(i_s)=mean([ first_touch_onset{:,i_s}]);
     first_touch_onset_stem(i_s)=std([ first_touch_onset{:,i_s}])./sqrt(numel([ first_touch_onset{:,i_s}]));

%      licks_contact_mean(i_s)=mean([ licks_contact{:,i_s}]);
%      licks_contact_stem(i_s)=std([ licks_contact{:,i_s}])./sqrt(numel([ licks_contact{:,i_s}]));

end


axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(first_touch_onset_mean,3) ,smooth(first_touch_onset_stem,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Time to contact (s),\n relative to target appearence'));
% text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,2])
xlim([1,7])
set(gca, 'FontSize',8);
title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);
text(4,0.72,sprintf('First \ncontact lick'),'Color',[0.5 0.25 0.25])

axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(x_corr_mean_first_touch,3) ,smooth(x_corr_stem_first_touch,3),'lineprops',{'-','Color',[0.5 0.25 0.25]});
shadedErrorBar(1:1:i_s,smooth(x_corr_mean_later_touch,3) ,smooth(x_corr_stem_later_touch,3),'lineprops',{'-','Color',[0.25 0.25 0.25]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Correlation in (tongue,target)\n position, r'));
ylim([0.4,1])
text(4,0.72,sprintf('First \ncontact lick'),'Color',[0.5 0.25 0.25])
text(2,0.93,sprintf('All subsequent \nlicks'),'Color',[0.25 0.25 0.25])
xlim([1,7])
set(gca, 'FontSize',8);
title(sprintf('Aiming accuracy'),'FontWeight','Bold', 'FontSize',8);




if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

