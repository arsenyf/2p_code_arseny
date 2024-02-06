function    lick2D_video_behavior_across_sessions_tongue_trajectories()
close all

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\behavior_sessions_tongue_trajectories\'];

filename=[sprintf('Tongue_trajectories')];
%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);


panel_width1=0.05;
panel_height1=0.1;
horizontal_dist1=0.085;
vertical_dist1=0.3;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
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
% % subject_list=[464725];
% subject_list=[463189];


subj_counter=0;
for i_sub = 1:1:numel(subject_list)
    clf;
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
        %         Z=fetchn((TRACKING.VideoTongueTrial & key )-TRACKING.VideoGroomingTrial & 'trial>100','licks_peak_z');
        D=fetch((TRACKING.VideoBodypartTrajectTrial*(TRACKING.TrackingTrial& (TRACKING.TrackingDevice & 'tracking_device_description="side view"'))	 & key & 'bodypart_name="tongue"'),'traj_x','traj_y1','traj_y2','traj_z','time_first_frame','tracking_sampling_rate','tracking_num_samples','tracking_duration');
        tracking_sampling_rate=D(1).tracking_sampling_rate;
        min_time=-1;
        max_time=7;
        max_frames=(max_time-min_time)*tracking_sampling_rate;
        Z={D.traj_z}';
        tonset=[D.time_first_frame]';
        
        Z_padded=zeros(size(Z,1),max_frames)+NaN;
        Z_padded_trimmed=zeros(size(Z,1),max_frames)+NaN;
        
        for i_tr = 1:1:size(Z,1)
            Z_trial=Z{i_tr};
            %            Z_trial=Z_trial/nanmax(Z_trial);
            max_trial=min(numel(Z_trial),max_frames);
            Z_padded(i_tr,1:max_trial)=Z_trial(1:max_trial);
            
            t=(0:(1/tracking_sampling_rate):(max_frames/tracking_sampling_rate))+tonset(i_tr);
            idx_t=t>=-1 & t<=5;
            
            Z_padded_trimmed(i_tr,1:sum(idx_t))=Z_padded(i_tr,idx_t);
            
        end
        t_2_plot=t(idx_t);
        %         Z_padded_trimmed=Z_padded_trimmed/nanmean(nanmean(Z_padded_trimmed,2));
        
        axes('position',[position_x1(i_ses),position_y1(1), panel_width1, panel_height1]);
        hold on
        num_trials=size(Z_padded_trimmed,1);
        imagesc(t_2_plot,1:1:num_trials,Z_padded_trimmed(:,idx_t(1:end-1)));
        
        if i_ses==1
            xlabel(sprintf('Lick time (s),\n relative to target appearence', 'FontSize',8,'FontWeight','Bold'));
            ylabel('Trials', 'FontSize',8,'FontWeight','Bold');
        else
%             axis off;
        end
        %         ylabel(sprintf('Lick time (s),\n relative to target appearence'));
        %         title(sprintf('Reaction time'),'FontWeight','Bold', 'FontSize',8);
        %         text(4,1,sprintf('Lick on first \ntarget contact'),'Color',[1 0 0])
        ylim([0,num_trials])
        xlim([-1,4])
        plot([0,0],[0,num_trials],'-w');
        colormap  inferno
        c_lim=[prctile(Z_padded_trimmed(:),5), prctile(Z_padded_trimmed(:),95)];
        set(gca, 'CLim',c_lim)
        
        %         bluewhitered
        % freezeColors(colorbar)
        set(gca, 'FontSize',8);
        axis tight
%         title(sprintf('Session %d',sessions_list(i_ses)));
                title(sprintf('Session %d',i_ses));

        axes('position',[position_x1(i_ses),position_y1(2), panel_width1, panel_height1]);
        hold on
        plot(t_2_plot,nanmean(Z_padded_trimmed(:,idx_t(1:end-1)),1))
        set(gca, 'YDir','reverse')
        if i_ses==1
            xlabel(sprintf('Lick time (s),\n relative to target appearence', 'FontSize',8,'FontWeight','Bold'));
            ylabel('Tongue position (vertical)', 'FontSize',8,'FontWeight','Bold');
        end
    end
    
    if isempty(dir(dir_current_fig))
        mkdir (dir_current_fig)
    end
    figure_name_out=[ dir_current_fig filename '_' num2str(subject_list(i_sub))];
    eval(['print ', figure_name_out, ' -dtiff  -r500']);
    eval(['print ', figure_name_out, ' -dpdf -r200']);
    
    
end






