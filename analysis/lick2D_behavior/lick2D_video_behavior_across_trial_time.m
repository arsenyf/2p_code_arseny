function    lick2D_video_behavior_across_trial_time()

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_behavior_across_trial_time')];
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


%% BEFORE LICKPORT ENTRANCE
Tall= fetch((((TRACKING.VideoNthLickTrial*EXP2.SessionID*TRACKING.VideoLickportTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial )-TRACKING.VideoGroomingTrial) & 'trial>100' & (EXP2.SessionBehavioral & 'behavioral_session_number>=1')),'lick_peak_x','lickport_x', 'lick_time_onset','lickport_t_entrance_start','lickport_t_entrance_end','lickport_lickable_duration','session_uid');

unique_sessions_before=unique([Tall.session_uid]);

for i_s=1:1:numel(unique_sessions_before)
    
    T = Tall([Tall.session_uid]==unique_sessions_before(i_s));
    lickport_x=[T.lickport_x];
    lick_peak_x=[T.lick_peak_x];
    
%     mean_lickport_t_entrance_min(i_s)=prctile([T.lickport_t_entrance_start],1)-mean([T.lickport_t_entrance_start]);
%     mean_lickport_t_entrance_max(i_s)=prctile([T.lickport_t_entrance_start],99)-mean([T.lickport_t_entrance_start]);
%     lickport_lickable_duration(i_s)=mean([T.lickport_lickable_duration]);

    mean_lickport_t_entrance_min(i_s)=0;
    mean_lickport_t_entrance_max(i_s)=mean([T.lickport_t_entrance_end]-[T.lickport_t_entrance_start]);
    lickport_lickable_duration(i_s)=mean([T.lickport_lickable_duration]-[T.lickport_t_entrance_start]);

    lick_time_onset=[T.lick_time_onset] + ([T.lickport_t_entrance_start]+[T.lickport_t_entrance_end])/2 - [T.lickport_t_entrance_start];
    lick_peak_x_shuffled=lick_peak_x(randperm(numel(lick_peak_x)));
    [~,edges,bins]=histcounts(lick_time_onset,[-1:0.1:4]);
    
    [counts,edges_sessions]=histcounts(lick_time_onset,[-1.5:0.2:10]);
   bins_seesions(i_s,:)=counts./sum(counts);

    for i_b=1:1:max(bins)
        idx=find(bins==i_b);
        if ~isempty(idx)
            corr_bin_seesions(i_s,i_b)=corr([lickport_x(idx)]',[lick_peak_x(idx)]','Rows','pairwise');
            corr_bin_seesions_shuffled(i_s,i_b)=corr([lickport_x(idx)]',[lick_peak_x_shuffled(idx)]','Rows','pairwise');
        else
            corr_bin_seesions(i_s,i_b)=NaN;
            corr_bin_seesions_shuffled(i_s,i_b)=NaN;
        end
    end
end

corr_mean=nanmean(corr_bin_seesions,1);
corr_std=nanstd(corr_bin_seesions,1)/sqrt(numel(unique_sessions_before));

corr_mean_shuffled=nanmean(corr_bin_seesions_shuffled,1);
corr_std_shuffled=nanstd(corr_bin_seesions_shuffled,1)/sqrt(numel(unique_sessions_before));

lick_time_mean=nanmean(bins_seesions,1);
lick_time_std=nanstd(bins_seesions,1)/sqrt(numel(unique_sessions_before));

axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1]);
hold on
t_bins=edges(1:end-1)+mean(diff(edges))/2;
shadedErrorBar(t_bins,smooth(corr_mean,1) ,smooth(corr_std,1),'lineprops',{'-','Color',[0 0 0]});
% shadedErrorBar(edges(1:end-1),smooth(corr_mean_shuffled,1) ,smooth(corr_std_shuffled,1),'lineprops',{'-','Color',[0.5 0.5 0.5]});
plot([mean(mean_lickport_t_entrance_min),mean(mean_lickport_t_entrance_min)],[0,1],'-r')
plot([mean(mean_lickport_t_entrance_max),mean(mean_lickport_t_entrance_max)],[0,1],'-r')
plot([mean(lickport_lickable_duration),mean(lickport_lickable_duration)],[0,1],'-b')
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel(sprintf('Lick time (s),\n relative to target appearence'));
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0,1])
xlim([min(edges) max(edges)])
text(0,1.15,sprintf('Target ON\nmovement time'),'Color',[1 0 0],'HorizontalAlignment','center')
text(2.3,1.15,sprintf('Target OFF \n(on average)'),'Color',[0 0 1],'HorizontalAlignment','left')
set(gca, 'FontSize',8);


% axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
% hold on
% h(1)=histogram([Tall.lick_time_onset],[-1.5:0.2:10],'Normalization','Probability','FaceColor',[0 0 0]);
% plot([0,0],[0,0.1],'-r')
% xlabel(sprintf('Lick time (s),\n relative to target appearence'));
% ylabel(sprintf('Probability'));
% title(sprintf('Lick time'));
% plot([mean(lickport_lickable_duration),mean(lickport_lickable_duration)],[0,0.1],'-b')
% set(gca, 'FontSize',8);

axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1]);
hold on
t_bins=edges_sessions(1:end-1)+mean(diff(edges_sessions))/2;
shadedErrorBar(t_bins,smooth(lick_time_mean,1) ,smooth(lick_time_std,1),'lineprops',{'-','Color',[0 0 0]});
plot([0,0],[0,max(lick_time_mean)],'-r')
xlabel(sprintf('Lick time (s),\n relative to target appearence'));
ylabel(sprintf('Probability'));
title(sprintf('Lick time'));
plot([mean(lickport_lickable_duration),mean(lickport_lickable_duration)],[0,max(lick_time_mean)],'-b')
set(gca, 'FontSize',8);
xlim([min(edges_sessions) max(edges_sessions)])

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

