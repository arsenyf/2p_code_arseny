function    lick2D_video_behavior_single_trials()


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_behavior_across_sessions')];
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

% subject_list=unique(fetchn(TRACKING.VideoNthLickTrial,'subject_id'));

subject_list=[463190];

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
        V=fetch(TRACKING.VideoBodypartTrajectTrial & key &'bodypart_name="tongue"','*');
        VMAT=zeros(size(V,1),3000)+NaN;
        
        for i_tr=1:1:size(V,1)
           VMAT(i_tr,1:numel(V(i_tr).traj_z))= V(i_tr).traj_z;
        end
        
        imagesc(VMAT(:,1:2000))
    end
end

axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(first_touch_onset_mean,3) ,smooth(first_touch_onset_stem,3),'lineprops',{'-','Color',[1 0 0]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Lick time (s),\n relative to target appearence'));
title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);
text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
ylim([0,2])
xlim([1,8])
set(gca, 'FontSize',8);

axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(before_licks_mean,3) ,smooth(before_licks_stem,3),'lineprops',{'-','Color',[0 0.3 0]});
shadedErrorBar(1:1:i_s,smooth(after_licks_mean,3) ,smooth(after_licks_stem,3),'lineprops',{'-','Color',[0 0 0.5]});
text(2,1.5,sprintf('Before target \nappearence)'),'Color',[0 0.3 0])
text(1.5,6.5,sprintf('After target \nappearence'),'Color',[0 0 0.5])
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Number of licks in trial'));
ylim([0,9])
xlim([1,8])
set(gca, 'FontSize',8);
title(sprintf('Lick count'),'FontWeight','Bold', 'FontSize',8);

axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(x_corr_mean_before,3) ,smooth(x_corr_stem_before,3),'lineprops',{'-','Color',[0 0.3 0]});
% legend([h(1).mainLine], 'Before target','EastOutside')
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0,0.3])
text(2,0.3,sprintf('Licks before \ntarget appearence'),'Color',[0 0.3 0]);
xlim([1,8])
set(gca, 'FontSize',8);
text(7, 0.35, sprintf('Aiming accuracy'),'FontWeight','Bold', 'FontSize',8);

axes('position',[position_x1(4),position_y1(1), panel_width1, panel_height1]);
hold on
shadedErrorBar(1:1:i_s,smooth(x_corr_mean_first_touch,3) ,smooth(x_corr_stem_first_touch,3),'lineprops',{'-','Color',[1 0 0]});
shadedErrorBar(1:1:i_s,smooth(x_corr_mean_later_touch,3) ,smooth(x_corr_stem_later_touch,3),'lineprops',{'-','Color',[0 0 1]});
xlabel('Session', 'FontSize',8,'FontWeight','Bold');
% ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0.4,1])
text(4,0.72,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
text(2,0.93,sprintf('All subsequent \ntarget contact licks'),'Color',[0 0 1])
xlim([1,8])
set(gca, 'FontSize',8);




if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

