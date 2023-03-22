function Figure1
close all;

rel_roi=(IMG.ROI& IMG.ROIGood-IMG.ROIBad) -IMG.Mesoscope;
% rel_stats= LICK2D.ROILick2DmapStatsSpikes3bins*LICK2D.ROILick2DPSTHStatsSpikes* LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins & rel_roi;
rel_stats= LICK2D.ROILick2DmapStatsSpikes*LICK2D.ROILick2DPSTHStatsSpikes* LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes2 & rel_roi ...
    & 'number_of_bins=4';

rel_stats=rel_stats & 'psth_position_concat_regular_odd_even_corr>0.1';

rel_example = IMG.ROI*LICK2D.ROILick2DPSTHSpikesExample*LICK2D.ROILick2DmapSpikesExample*LICK2D.ROILick2DmapPSTHSpikesExample*LICK2D.ROILick2DmapPSTHStabilitySpikesExample*LICK2D.ROILick2DmapStatsSpikesExample;
rel_example_psth = IMG.ROI*LICK2D.ROILick2DPSTHSpikesLongerInterval;

rel_map_single_session    = LICK2D.ROILick2DmapSpikes*LICK2D.ROILick2DmapStatsSpikes& rel_roi & 'psth_position_concat_regular_odd_even_corr>=0.5';
key_single_session.subject_id = 486668;
key_single_session.session = 5;

key_fov_example.subject_id = 480483;
key_fov_example.session = 2;
key_fov_example.session_epoch_type='behav_only';

rel_psth = LICK2D.ROILick2DPSTHSpikesLongerInterval & rel_roi & rel_stats;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure1')];
%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

%% behavior cartoon
panel_width1=0.15;
panel_height1=0.15;
horizontal_dist1=0.1;
vertical_dist1=0.1;
position_x1(1)=0.05;

position_y1(1)=0.76;

%% fov
panel_width1_fov=0.07;
panel_height1_fov=0.07;
horizontal_dist1_fov=0.007;
vertical_dist1_fov=0.007;
position_x1_fov(1)=0.22+0.12;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;

position_y1_fov(1)=0.79;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;


%% ROI traces 
panel_width1_trace=0.08;
panel_height1_trace=0.015;
horizontal_dist1_trace=0.04;
vertical_dist1_trace=0.025;
position_x1_trace(1)=0.32+0.12;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;

position_y1_trace(1)=0.84;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;


% PSTH - position averaged
panel_width2=0.03;
panel_height2=0.03;
horizontal_dist2=0.04;
vertical_dist2=0.045;
position_x2(1)=0.47+0.12;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2*1.6;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.82;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

position_y22=0.784;

% Histograms
panel_width3=0.05;
panel_height3=0.04;
horizontal_dist3=0.1;
vertical_dist3=0.1;
position_x3(1)=0.1;
position_x3(end+1)=position_x3(end)+horizontal_dist3*0.4;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;

position_y3(1)=0.5;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;


% 2d tuning on grid
horizontal_dist_between_cells_grid1=0.085;
vertical_dist_between_cells_grid1=0.075;

position_x1_grid(1)=0.1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;

position_y1_grid(1)=0.67;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;

% 2d tuning 100 cells from a given session
position_x2_grid(1)=0.37;
position_y2_grid(1)=0.7;


panel_width4=0.05;
panel_height4=0.04;
horizontal_dist4=0.07;
vertical_dist4=0.09;
position_x4(1)=0.565;
position_x4(end+1)=position_x4(end)+horizontal_dist4;
position_x4(end+1)=position_x4(end)+horizontal_dist4*1.8;


position_y4(1)=0.67;
position_y4(end+1)=position_y4(end)-vertical_dist4;
position_y4(end+1)=position_y4(end)-vertical_dist4;
position_y4(end+1)=position_y4(end)-vertical_dist4;

%% ROI images
panel_width1_roi=0.02;
panel_height1_roi=0.02;
horizontal_dist1_roi=0.04;
vertical_dist1_roi=0.025;
position_x1_roi(1)=0.41+0.12;
position_x1_roi(end+1)=position_x1_roi(end)+horizontal_dist1_roi;

position_y1_roi(1)=0.84;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;


%% Lick
panel_lick_width1=0.07;
panel_lick_height1=0.03;
position_lick_x1(1)=0.11;
position_lick_y1(1)=0.75;

panel_lick_width2=0.04;
panel_lick_height2=0.04;
position_lick_x2(1)=0.2;
position_lick_x2(end+1)=position_lick_x2(end)+0.06;
position_lick_y2(1)=0.8;
position_lick_y2(end+1)=position_lick_y2(end)-0.06;

% panel_lick_width3=0.04;
% panel_lick_height3=0.04;
% position_lick_x3(1)=0.25;
% position_lick_x3(end+1)=position_lick_x3(end)+0.06;
% position_lick_y3(1)=0.8;
% position_lick_y3(end+1)=position_lick_x3(end)-0.06;

%% Behavior cartoon
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
xl = [0 2680];
yl = [0 1500];
fig1_a = imread([dir_embeded_graphics 'Figure1_behavior_cartoon.tif']);
% fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.2, yl(1)-diff(yl)*0.2, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'vS1','FontSize',8,'FontWeight','bold','Color',[0 1 0],'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;


% %trial 0
% key_tongue_trial0.subject_id=463190;
% key_tongue_trial0.session=2;
% key_tongue_trial0.trial=218; %% 207 %33
% 
% %trial 1
% key_tongue_trial1.subject_id=463190;
% key_tongue_trial1.session=2;
% key_tongue_trial1.trial=177; %% 218 207 %33
% 
% key_tongue_trial2.subject_id=463190;
% key_tongue_trial2.session=2;
% key_tongue_trial2.trial=72; %% 207 %33
% 
% key_tongue_session.subject_id=463190;
% key_tongue_session.session=2;

%trial 0
key_tongue_trial0.subject_id=462458;
key_tongue_trial0.session=5;
key_tongue_trial0.trial=288; %% 207 %33

%trial 1
key_tongue_trial1.subject_id=462458;
key_tongue_trial1.session=5;
key_tongue_trial1.trial=288; %% 218 207 %33

key_tongue_trial2.subject_id=462458;
key_tongue_trial2.session=5;
key_tongue_trial2.trial=757;% 863; %% 207 %33

key_tongue_session.subject_id=462458;
key_tongue_session.session=5;



%z- motor
zaber_to_mm_z_motor = 1/1000; %1,000 in zaber motor units == 1 mm
%x- motor, and y-motor
zaber_to_mm_x_motor = 1.25/50000; %50,000 in zaber motor units ==1.25 mm

% from Zaber trial 1
lickport_pos_x1_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial1, 'lickport_pos_x')*zaber_to_mm_x_motor;
lickport_pos_z1_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial1, 'lickport_pos_z')*zaber_to_mm_z_motor;
% lickport_pos_y1=fetchn(EXP2.TrialLickPort & key_tongue_trial1, 'lickport_pos_y')*zaber_to_mm_x_motor;
% from video trial 1
lickport_pos_x1_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial1, 'lickport_x');
lickport_pos_z1_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial1, 'lickport_z');
% lickport_pos_y1=fetchn(EXP2.TrialLickPort & key_tongue_trial1, 'lickport_pos_y')*zaber_to_mm_x_motor;

% from Zaber trial 2
lickport_pos_x2_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial2, 'lickport_pos_x')*zaber_to_mm_x_motor;
lickport_pos_z2_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial2, 'lickport_pos_z')*zaber_to_mm_z_motor;
% lickport_pos_y2=fetchn(EXP2.TrialLickPort & key_tongue_trial2, 'lickport_pos_y')*zaber_to_mm_x_motor;
% from video trial 2
lickport_pos_x2_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial2, 'lickport_x');
lickport_pos_z2_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial2, 'lickport_z');
% lickport_pos_y2=fetchn(EXP2.TrialLickPort & key_tongue_trial2, 'lickport_pos_y')*zaber_to_mm_x_motor;

z_delta_pixels=(lickport_pos_z2_video - lickport_pos_z1_video);
z_delta_mm=(lickport_pos_z2_zaber - lickport_pos_z1_zaber);

pixels_z_to_mm_slope = 1; %z_delta_mm/z_delta_pixels;
pixels_z_to_mm_offset = 1; %lickport_pos_z1_zaber - pixels_z_to_mm_slope*lickport_pos_z1_video;


% from Zaber trial 0
lickport_pos_z0_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial0, 'lickport_pos_z')*zaber_to_mm_z_motor;
% from video trial 0
lickport_pos_z0_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial0, 'lickport_z');

% lickport_pos_z0_video*pixels_z_to_mm_slope + pixels_z_to_mm_offset;

%% Lick trial
axes('position',[position_lick_x1(1),position_lick_y1(1), panel_lick_width1, panel_lick_height1])
hold on;

key_tongue_trial0.bodypart_name='tongue';
rel_behavior_trial = (EXP2.BehaviorTrialEvent & key_tongue_trial0 & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;

%get time
[t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue_trial0);
traj_z_tongue=(fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial0,'traj_z').*pixels_z_to_mm_slope)+pixels_z_to_mm_offset;
traj_lickport_z=(fetch1(TRACKING.VideoLickportPositionTrajectTrial  & key_tongue_trial0, 'lickport_z_traj').*pixels_z_to_mm_slope)+pixels_z_to_mm_offset;


plot(t ,traj_lickport_z ,'-b')
yl = [nanmin([traj_z_tongue,0]), ceil(1.2*(nanmax(traj_z_tongue)))];
xl = [-0.5,2];
text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*0.8,sprintf('Position \n (mm)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.6,sprintf('Time to 1st tongue \ncontact (s)'), 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.25,sprintf('Tongue position,\n vertical '), 'FontSize',6,'HorizontalAlignment','center','FontWeight','bold');
text(xl(1)-diff(xl)*0.4, yl(1)-diff(yl)*0.6, 'b', 'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlim(xl);
ylim(yl);
set(gca,'XTick',[ 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
 set(gca,'YDir', 'reverse');

%  colormap_g=winter(numel(idx_licks_time_onset));
 colormap_g=pink(numel(idx_licks_time_onset)*2);
 for i_l=1:1:numel(idx_licks_time_onset)
     idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
     plot(t(idx_current_lick),traj_z_tongue(idx_current_lick),'-','Color',[colormap_g(i_l,:)])
 end
 plot(t(idx_lick_contact_time),traj_z_tongue(idx_lick_contact_time),'.c','MarkerSize',10);

%% Lick trial 2D Example 1
% Lick trial trajectory Z-Y1
axes('position',[position_lick_x2(1),position_lick_y2(1), panel_lick_width2, panel_lick_height2])
hold on;
key_tongue_trial1.bodypart_name='tongue';
rel_behavior_trial = (EXP2.BehaviorTrialEvent & key_tongue_trial1 & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;
tongue_z_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_z');
tongue_y1_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_y1');
lickport_y1_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_y1');
lickport_z_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_z');

lickport_y1_center=fetchn(TRACKING.VideoLickportPositionTrial  & key_tongue_session, 'lickport_y1');
lickport_z_center=fetchn(TRACKING.VideoLickportPositionTrial  & key_tongue_session, 'lickport_z');

plot(lickport_y1_center,lickport_z_center,'ob','MarkerSize',10);

[t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue_trial1);
%  colormap_g=winter(numel(idx_licks_time_onset));
  colormap_g=pink(numel(idx_licks_time_onset)*2);
 for i_l=1:1:numel(idx_licks_time_onset)
     idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
%      plot(tongue_y1_traj(idx_current_lick),tongue_z_traj(idx_current_lick),'.','Color',[colormap_g(i_l,:)],'MarkerSize',2)
      plot(tongue_y1_traj(idx_current_lick),tongue_z_traj(idx_current_lick),'-','Color',[colormap_g(i_l,:)],'LineWidth',1)
 end
 plot(tongue_y1_traj(idx_lick_contact_time),tongue_z_traj(idx_lick_contact_time),'.c','MarkerSize',5);
set(gca,'YDir', 'reverse');
xl=[0,35];
xlim(xl);
yl=[0,45];
ylim(yl);
set(gca,'XTick',[ 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;

% Lick trial trajectory X-Y2
axes('position',[position_lick_x2(2),position_lick_y2(1), panel_lick_width2, panel_lick_height2])
hold on;
tongue_x_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_x');
tongue_y2_traj =fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_y2');
lickport_y2_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_y2');
lickport_x_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_x');
% plot(tongue_x_traj,tongue_y2_traj);
plot(lickport_x_center,lickport_y2_center,'ob','MarkerSize',10);
% colormap_g=winter(numel(idx_licks_time_onset));
 colormap_g=pink(numel(idx_licks_time_onset)*2);
 for i_l=1:1:numel(idx_licks_time_onset)
     idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
%      plot(tongue_x_traj(idx_current_lick),tongue_y2_traj(idx_current_lick),'.','Color',[colormap_g(i_l,:)],'MarkerSize',2)
 plot(tongue_x_traj(idx_current_lick),tongue_y2_traj(idx_current_lick),'-','Color',[colormap_g(i_l,:)],'LineWidth',1)
 end
 plot(tongue_x_traj(idx_lick_contact_time),tongue_y2_traj(idx_lick_contact_time),'.c','MarkerSize',5);
xl=[-15,15];
xlim(xl);
yl=[0,50];
ylim(yl);
set(gca,'YDir', 'reverse');
set(gca,'XTick',[xl(1) 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;


%% Lick trial 2D Example 2
% Lick trial trajectory Z-Y1
axes('position',[position_lick_x2(1),position_lick_y2(2), panel_lick_width2, panel_lick_height2])
hold on;
key_tongue_trial2.bodypart_name='tongue';
rel_behavior_trial = (EXP2.BehaviorTrialEvent & key_tongue_trial2 & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;
tongue_z_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial2,'traj_z');
tongue_y1_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial2,'traj_y1');
lickport_y1_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial2, 'lickport_y1');
lickport_z_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial2, 'lickport_z');
plot(lickport_y1_center,lickport_z_center,'ob','MarkerSize',10);

[t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue_trial2);

%  colormap_g=winter(numel(idx_licks_time_onset));
 colormap_g=pink(numel(idx_licks_time_onset)*2);
 for i_l=1:1:numel(idx_licks_time_onset)
     idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
%      plot(tongue_y1_traj(idx_current_lick),tongue_z_traj(idx_current_lick),'.','Color',[colormap_g(i_l,:)],'MarkerSize',2)
      plot(tongue_y1_traj(idx_current_lick),tongue_z_traj(idx_current_lick),'-','Color',[colormap_g(i_l,:)],'LineWidth',1)
 end
 plot(tongue_y1_traj(idx_lick_contact_time),tongue_z_traj(idx_lick_contact_time),'.c','MarkerSize',5);
xl=[0,35];
xlim(xl);
yl=[0,45];
ylim(yl);
set(gca,'YDir', 'reverse');
set(gca,'XTick',[ 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;

% Lick trial trajectory X-Y2
axes('position',[position_lick_x2(2),position_lick_y2(2), panel_lick_width2, panel_lick_height2])
hold on;
tongue_x_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial2,'traj_x');
tongue_y2_traj =fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial2,'traj_y2');
lickport_y2_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial2, 'lickport_y2');
lickport_x_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial2, 'lickport_x');
% plot(tongue_x_traj,tongue_y2_traj);
plot(lickport_x_center,lickport_y2_center,'ob','MarkerSize',10);
% colormap_g=winter(numel(idx_licks_time_onset));
 colormap_g=pink(numel(idx_licks_time_onset)*2);
 for i_l=1:1:numel(idx_licks_time_onset)
     idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
%      plot(tongue_x_traj(idx_current_lick),tongue_y2_traj(idx_current_lick),'.','Color',[colormap_g(i_l,:)],'MarkerSize',2)
 plot(tongue_x_traj(idx_current_lick),tongue_y2_traj(idx_current_lick),'-','Color',[colormap_g(i_l,:)],'LineWidth',1)
 end
 plot(tongue_x_traj(idx_lick_contact_time),tongue_y2_traj(idx_lick_contact_time),'.c','MarkerSize',5);
xl=[-15,15];
xlim(xl);
yl=[0,50];
ylim(yl);
 set(gca,'YDir', 'reverse');
set(gca,'XTick',[ 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;

 
 %% FOV
ax1=axes('position',[position_x1_fov(4),position_y1_fov(4), panel_width1_fov, panel_height1_fov]);
plane4=fetch1(IMG.Plane & key_fov_example & 'plane_num=4','mean_img');
imagesc(flip(plane4));
xl=[0,size(plane4,1)];
yl=[0,size(plane4,2)];
caxis([0 max(plane4(:))*0.4])
axis off;
axis tight;
axis equal;
colormap(ax1,gray)

ax2=axes('position',[position_x1_fov(3),position_y1_fov(3), panel_width1_fov, panel_height1_fov]);
plane3=fetch1(IMG.Plane & key_fov_example & 'plane_num=3','mean_img');
imagesc(flip(plane3));
caxis([0 max(plane3(:))*0.6])
axis off;
axis tight;
axis equal;
colormap(ax2,gray)

ax3=axes('position',[position_x1_fov(2),position_y1_fov(2), panel_width1_fov, panel_height1_fov]);
plane2=fetch1(IMG.Plane & key_fov_example & 'plane_num=2','mean_img');
imagesc(flip(plane2));
caxis([0 max(plane2(:))*0.8])
axis off;
axis tight;
axis equal;
colormap(ax3,gray)

ax4=axes('position',[position_x1_fov(1),position_y1_fov(1), panel_width1_fov, panel_height1_fov]);
hold on
plane1=fetch1(IMG.Plane & key_fov_example & 'plane_num=1','mean_img');
imagesc(flip(plane1));
caxis([0 max(plane1(:))*1.0])
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.1, 'b', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
axis off;
axis tight;
axis equal;
colormap(ax4,gray)
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Volumetric imaging'),'FontSize',6, 'fontweight', 'bold')
text(xl(1)-diff(xl)*0.25,yl(1)-diff(yl)*0.55,sprintf('Anterior Lateral \nMotor cortex (ALM)'), 'FontSize',6,'HorizontalAlignment','left');

try
    zoom =fetch1(IMG.FOVEpoch & key_fov_example,'zoom');
    kkk.scanimage_zoom = zoom;
    pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_x') / fetch1(IMG.FOV & key_fov_example, 'fov_x_size');
catch
    pix2dist= fetch1(IMG.Parameters & 'parameter_name="fov_size_microns_z1.1"', 'parameter_value')/fetch1(IMG.FOV & key_fov_example, 'fov_x_size');
end
scalebar=100/pix2dist; %100 microns

plot([100,100+scalebar],[50,50],'-w','LineWidth',2)
text((100+scalebar)*1.25,50,['100 \mum'],'FontSize',6, 'fontweight', 'bold','Color',[1 1 1])

%% ROI traces
axes('position',[position_x1_trace(1),position_y1_trace(1), panel_width1_trace, panel_height1_trace]);
hold on
imaging_frame_rate = fetchn(IMG.FOVEpoch & key_fov_example,'imaging_frame_rate');
key_fov_example_roi.roi_number=3;
dff1 = fetch1(IMG.ROIdeltaF & key_fov_example & key_fov_example_roi & 'plane_num=1','dff_trace');
time_trace = [0:1:numel(dff1)-1]/imaging_frame_rate;
idx_time_2plot=(time_trace>10 & time_trace<=70);
time_trace = time_trace(idx_time_2plot)-10;
dff1 = dff1(idx_time_2plot);
plot(time_trace,dff1,'Color',[0 0.5 0]);
spikes1 = fetch1(IMG.ROISpikes & key_fov_example & key_fov_example_roi & 'plane_num=1','spikes_trace');
spikes1 = spikes1(idx_time_2plot);
spikes1=max(dff1)*(spikes1/max(spikes1));
plot(time_trace,spikes1,'Color',[0 0 0]);
box off
xl=[0 ceil(max(time_trace))];
yl=double([min(dff1), max(dff1)]);
xlim(xl);
ylim(yl);
text(xl(1)-diff(xl)*0.3, yl(1)+diff(yl)*1.25, 'c', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*1.25, sprintf('Plane 1'), ...
    'fontsize', 6, 'fontname', 'helvetica','HorizontalAlignment','left');
set(gca,'Xtick',xl,'XTickLabel',[],'Ytick',[0, floor(yl(2))],'FontSize',6)

axes('position',[position_x1_trace(1),position_y1_trace(2), panel_width1_trace, panel_height1_trace]);
hold on
key_fov_example_roi.roi_number=794;
dff1 = fetch1(IMG.ROIdeltaF & key_fov_example & 'plane_num=2' & key_fov_example_roi & key_fov_example_roi,'dff_trace');
dff1 = dff1(idx_time_2plot);
yl=double([min(dff1), max(dff1)]);
plot(time_trace,dff1,'Color',[0 0.5 0]);
spikes1 = fetch1(IMG.ROISpikes & key_fov_example &  'plane_num=2' & key_fov_example_roi ,'spikes_trace');
spikes1 = spikes1(idx_time_2plot);
spikes1=max(dff1)*(spikes1/max(spikes1));
plot(time_trace,spikes1,'Color',[0 0 0]);
box off
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*1.25, sprintf('Plane 2'), ...
    'fontsize', 6, 'fontname', 'helvetica','HorizontalAlignment','left');
xl=[0 ceil(max(time_trace))];
yl=double([min(dff1), max(dff1)]);
xlim(xl);
ylim(yl);
set(gca,'Xtick',xl,'XTickLabel',[],'Ytick',[0, floor(yl(2))],'FontSize',6)

axes('position',[position_x1_trace(1),position_y1_trace(3), panel_width1_trace, panel_height1_trace]);
hold on
key_fov_example_roi.roi_number=1520;
dff1 = fetch1(IMG.ROIdeltaF & key_fov_example  & 'plane_num=3' & key_fov_example_roi,'dff_trace');
dff1 = dff1(idx_time_2plot);
yl=double([min(dff1), max(dff1)]);
plot(time_trace,dff1,'Color',[0 0.5 0]);
spikes1 = fetch1(IMG.ROISpikes & key_fov_example & 'plane_num=3' & key_fov_example_roi ,'spikes_trace');
spikes1 = spikes1(idx_time_2plot);
spikes1=max(dff1)*(spikes1/max(spikes1));
plot(time_trace,spikes1,'Color',[0 0 0]);
box off
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*1.25, sprintf('Plane 3'), ...
    'fontsize', 6, 'fontname', 'helvetica','HorizontalAlignment','left');
yl=double([min(dff1), max(dff1)]);
xlim(xl);
ylim(yl);
set(gca,'Xtick',xl,'XTickLabel',[],'Ytick',[0, floor(yl(2))],'FontSize',6)

axes('position',[position_x1_trace(1),position_y1_trace(4), panel_width1_trace, panel_height1_trace]);
hold on
key_fov_example_roi.roi_number=2224;
dff1 = fetch1(IMG.ROIdeltaF & key_fov_example & 'plane_num=4' & key_fov_example_roi ,'dff_trace','LIMIT 1');
dff1 = dff1(idx_time_2plot);
yl=double([min(dff1), max(dff1)]);
plot(time_trace,dff1,'Color',[0 0.5 0]);
spikes1 = fetch1(IMG.ROISpikes & key_fov_example & 'plane_num=4' & key_fov_example_roi ,'spikes_trace','LIMIT 1');
spikes1 = spikes1(idx_time_2plot);
spikes1=max(dff1)*(spikes1/max(spikes1));
plot(time_trace,spikes1,'Color',[0 0 0]);
box off
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*1.25, sprintf('Plane 4'), ...
    'fontsize', 6, 'fontname', 'helvetica','HorizontalAlignment','left');
yl=double([min(dff1), max(dff1)]);
xlim(xl);
ylim(yl);
text(xl(1)-diff(xl)*0.15,yl(1)+diff(yl)*0,sprintf('\\Delta F/F'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,sprintf('Time (s)'), 'FontSize',6,'HorizontalAlignment','center');
set(gca,'Xtick',xl,'XTickLabel',xl,'Ytick',[0, floor(yl(2))],'FontSize',6)

%% PLOT ROIs
ax1_roi=axes('position',[position_x1_roi(1),position_y1_roi(1), panel_width1_roi, panel_height1_roi]);
hold on
key_fov_example_roi.roi_number=3;
R=fetch(IMG.ROI & key_fov_example  & key_fov_example_roi,'*');
fn_plot_roi_image(plane1, 0.5, R, ax1_roi);

%% PLOT ROIs
ax2_roi=axes('position',[position_x1_roi(1),position_y1_roi(2), panel_width1_roi, panel_height1_roi]);
hold on
key_fov_example_roi.roi_number=794;
R=fetch(IMG.ROI & key_fov_example  & key_fov_example_roi,'*');
fn_plot_roi_image(plane2, 0.2, R, ax2_roi);

%% PLOT ROIs
ax3_roi=axes('position',[position_x1_roi(1),position_y1_roi(3), panel_width1_roi, panel_height1_roi]);
hold on
key_fov_example_roi.roi_number=1520;
R=fetch(IMG.ROI & key_fov_example  & key_fov_example_roi,'*');
fn_plot_roi_image(plane3, 0.2, R, ax3_roi);

%% PLOT ROIs
ax4_roi=axes('position',[position_x1_roi(1),position_y1_roi(4), panel_width1_roi, panel_height1_roi]);
hold on
key_fov_example_roi.roi_number=2224;
R=fetch(IMG.ROI & key_fov_example  & key_fov_example_roi,'*');
fn_plot_roi_image(plane4, 0.2, R, ax4_roi);



%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 72456;
cell_number=1;
panel_legend='d';
psth_time = fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1343791;
cell_number=2;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 3 PSTH
axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1255801;
cell_number=3;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1326983;
cell_number=4;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 1, 1,panel_legend, cell_number);

% Example Cell 5 PSTH
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1294286;
cell_number=5;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 6 PSTH
axes('position',[position_x2(3),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1354700;
cell_number=6;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

%% Single cell PSTH by position examples
% Example Cell 1 PSTH
roi_number_uid = 1260924;
cell_number2d=7;
fn_plot_single_cell_psth_by_position_example (rel_example,roi_number_uid , 0, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d);
text(-30, 1.75, 'f', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Example Cell 2 PSTH
roi_number_uid = 1261160; 
cell_number2d=8;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(1), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 1261985;
cell_number2d=9;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(3), position_y1_grid(1), cell_number2d);

% Example Cell 4 PSTH
roi_number_uid = 1261359;
cell_number2d=10;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 1, 1, position_x1_grid(1), position_y1_grid(2), cell_number2d);

% Example Cell 5 PSTH
roi_number_uid = 1260574;
cell_number2d=11;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(2), cell_number2d);

% Example Cell 6 PSTH
roi_number_uid = 1261779; 
cell_number2d=12;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(3), position_y1_grid(2), cell_number2d);


%% 100 cells from one session
fn_PLOTS_Multiple_Cells2DTuning_for_one_session (key_single_session, rel_map_single_session, rel_roi, 10, 10, position_x2_grid(1), position_y2_grid(1))

%colorbar
ax13=axes('position',[position_x2_grid(1)-0.01, position_y2_grid(1)-0.12, panel_width4/3, panel_height4/4]);
caxis([0,1])
colormap(ax13,inferno)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[0, 1],'TickLabels',[{'0','1'}], 'FontSize',6);
text(7,0.5,sprintf('Activity (norm.)'), 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);

%% fetching stats
D=fetch(rel_stats, 'psth_regular_odd_vs_even_corr', ...
    'psth_position_concat_regular_odd_even_corr',...
    'lickmap_regular_odd_vs_even_corr',...
    'information_per_spike_regular',...
    'field_size_regular',...
    'centroid_without_baseline_regular',...
    'preferred_bin_regular',...
    'psth_corr_across_position_regular');


D_tuned=fetch(rel_stats & 'information_per_spike_regular>=0.1', 'psth_regular_odd_vs_even_corr', ...
    'psth_position_concat_regular_odd_even_corr',...
    'lickmap_regular_odd_vs_even_corr',...
    'information_per_spike_regular',...
    'field_size_regular',...
    'centroid_without_baseline_regular',...
    'preferred_bin_regular',...
    'psth_corr_across_position_regular');



%% Plotting Stats
%--------------------------------

%% PSTH of all cells
ax5=axes('position',[position_x2(4),position_y22(1), panel_width3, panel_height3]);
PSTH_all = cell2mat(fetchn(rel_psth,'psth_regular'));
PSTH_all = PSTH_all./max(PSTH_all,[],2);
[~,idx_max_time] = max(PSTH_all,[],2);
[~, idx_neurons_sorted] = sort(idx_max_time);
imagesc(psth_time,[],PSTH_all(idx_neurons_sorted,:))
colormap(ax5,inferno)
xl = [floor(psth_time(1)) ceil(psth_time(end))];
xlabel(sprintf('Time to 1st \ntongue contact (s)'), 'FontSize',6);
text(-2.5,numel(idx_neurons_sorted),sprintf('Neurons'),'Rotation',90, 'FontSize',6);
set(gca,'XTick',[0,5],'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
% set(gca,'XTick',[0,xl(end)],'Ytick',[1, 100000],'YtickLabel',[{'1', '100,000'}],'TickLength',[0.05,0], 'FontSize',6);

%colorbar
ax8=axes('position',[position_x2(5),position_y22(1), panel_width3, panel_height3]);
colormap(ax8,inferno)
cb1 = colorbar();
axis off
set(cb1,'Ticks',[0, 1], 'FontSize',6);
text(4.1,0.5,sprintf('Activity (norm.)'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','Center');
set(gca, 'FontSize',6);

%% Preferred time all PSTHs
axes('position',[position_x2(4),position_y22(1)+0.04, panel_width3, panel_height3*0.5])
% h=histogram(psth_time(idx_max_time),10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
[hhh1,edges]=histcounts(psth_time(idx_max_time),linspace(-1,6,15));
hhh1=100*hhh1/sum(hhh1);
bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh1)];
yl(2)=20;
xl = [floor(psth_time(1)) ceil(psth_time(end))];
text(xl(1)-diff(xl)*0.25,yl(1)-diff(yl)*0.5,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl);
set(gca,'XTick',[],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
title(sprintf('Temporal tuning\n%d cells',numel(idx_max_time)), 'FontSize',6);
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.75, 'e', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Field size
axes('position',[position_x4(1),position_y4(1), panel_width4, panel_height4])
[hhh2,edges]=histcounts([D.field_size_regular],linspace(0,100,10));
hhh2=100*hhh2/sum(hhh2);
bar(edges(1:end-1),hhh2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh2)];
yl(2)=50;
xl = [0,110];
xlabel(sprintf('Field size (%%)'))
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional \ntuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.5, 'h', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');



%% Preferred positions
ax10=axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4]);
bin_mat_coordinate_hor= repmat([1:1:4],4,1);
bin_mat_coordinate_ver= repmat([1:1:4]',1,4);
[preferred_bin_mat] = histcounts2(bin_mat_coordinate_ver([D_tuned.preferred_bin_regular]),bin_mat_coordinate_hor([D_tuned.preferred_bin_regular]),[1:1:4+1],[1:1:4+1]);
preferred_bin_mat=100*preferred_bin_mat./sum(preferred_bin_mat(:));
mmm=imagesc([-1,0,1],[-1,0,1],preferred_bin_mat);
yl=[0, max(20,ceil(nanmax(preferred_bin_mat(:))))];
caxis(yl)
colormap(ax10,jet2);
text(0,2,sprintf('Preferred\npositions'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
axis equal
axis tight
set(gca,'YDir','normal', 'FontSize',6);
axis off
text(-2, 2.7, 'i', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
%colorbar
ax11=axes('position',[position_x4(2)+0.04,position_y4(1), panel_width4, panel_height4]);
caxis(yl)
colormap(ax11,jet2)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[yl],'TickLabels',[yl], 'FontSize',6);
text(4,0.25,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);


%% Temporal tuning similarity,\nacross positions
axes('position',[position_x4(3),position_y4(1), panel_width4, panel_height4])
[hhh3,edges]=histcounts([D_tuned.psth_corr_across_position_regular],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=40;
xl = [-1,1];
xlabel([sprintf('Tuning corr.,') '{\it r}'  newline 'across positions'])
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning,\nsimilarity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.5, 'j', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Tuning versus anatomical dtstance
key_distance.odd_even_corr_threshold=-1;
rel_data_distance= (LICK2D.DistanceCorrConcatSpikes2 *EXP2.SessionID & 'num_cells_included>=100') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrConcatSpikes2Shuffled *EXP2.SessionID & 'num_cells_included>=100') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;

%% Lateral
axes('position',[position_x4(1),position_y4(2), panel_width4, panel_height4])
% all sessions

distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));
% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,lineProps);

distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
lineProps.col={[1 0 0]};
lineProps.LineStyle{1}='-';
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% shadedErrorBar(bins_lateral_center,d_lateral_mean,d_lateral_stem,'lineprops',{'.-','Color',[1 0 0]});

yl = [0, 0.15];
xl = [0,500];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.3,yl(1)+diff(yl)*1.2,sprintf('Tuning similarity vs. anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'k', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Lateral',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

%% Axial 
axes('position',[position_x4(2),position_y4(2), panel_width4, panel_height4])
hold on
% all sessions
idx_column_radius=2; %10 to 30 microns
distance_axial_all=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
yl = [0, 0.15];
xl = [0,120];
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% shadedErrorBar(bins_axial_distance,d_axial_mean1,d_axial_stem1,'lineprops',{'.-','Color',[0 0 1]})
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1_shuffled,d_axial_stem_shuffled1,lineProps);
% shadedErrorBar(bins_axial_distance,d_axial_mean1_shuffled,d_axial_stem_shuffled1,'lineprops',{'.-','Color',[0 0 0]})
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60, 120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
 text(xl(1)+diff(xl)*0.1, yl(1)+diff(yl)*0.55, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[.25 .25 1]);
 
%% Axial vs Lateral

axes('position',[position_x4(3)-0.04,position_y4(2), panel_width4, panel_height4])
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% shadedErrorBar(bins_lateral_center,d_lateral_mean,d_lateral_stem,'lineprops',{'.-','Color',[1 0 0]})
% shadedErrorBar(bins_axial_distance,d_axial_mean1,d_axial_stem1,'lineprops',{'.-','Color',[0 0 1]})
% plot(bins_lateral_center,d_lateral_mean,'.-r')
% plot(bins_axial_distance,d_axial_mean1,'.-b')
yl = [0.05, 0.15];
xl = [0,120];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.9, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
 
if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




