function Figure1_v9
close all;

DATA=fetch1(PAPER.ConnectivityPaperFigure1datav4,'figure_data');
lickmap_regular_odd_vs_even_corr_threshold=0.25; % will only affect panel m
%             information_per_spike_regular_threshold=0.02; % will only affect panel m
D_tuned_temporal=DATA.D_tuned_temporal;
D_tuned_positional=DATA.D_tuned_positional;
D_tuned_temporal_and_positional=DATA.D_tuned_temporal_and_positional;
D_all=DATA.D_all;
D_tuned_positional_4bins=DATA.D_tuned_positional_4bins;
PSTH_all=DATA.PSTH_all;
psth_time = DATA.psth_time;

rel_roi=PAPER.ROILICK2DInclusion;

rel_example = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesExample*LICK2D.ROILick2DmapSpikesExample*LICK2D.ROILick2DmapPSTHSpikesExample*LICK2D.ROILick2DmapPSTHStabilitySpikesExample*LICK2D.ROILick2DmapStatsSpikesExample;
rel_example_psth = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesLongerInterval;
rel_map_single_session    = (LICK2D.ROILick2DmapSpikes*LICK2D.ROILick2DmapStatsSpikes *IMG.ROIID) & rel_roi & 'psth_position_concat_regular_odd_even_corr>=0.5';
key_single_session.subject_id = 486668;
key_single_session.session = 5;
key_fov_example.subject_id = 480483;
key_fov_example.session = 2;
key_fov_example.session_epoch_type='behav_only';

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure1_v1')];

PAPER_graphics_definition_Figure1

%% Behavior cartoon
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
xl = [0 2680];
yl = [0 1500];
fig1_a = imread([dir_embeded_graphics 'Figure1_behavior_cartoon.tif']);
% fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.1, yl(1)+diff(yl)*0.1, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'vS1','FontSize',8,'FontWeight','bold','Color',[0 1 0],'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;


%trial 0
key_tongue_trial0.subject_id=463190;
key_tongue_trial0.session=2;
key_tongue_trial0.trial=218; %% 207 %33

%trial 1
key_tongue_trial1.subject_id=463190;
key_tongue_trial1.session=2;
key_tongue_trial1.trial=24; %%123 72 177 218 207 %33

key_tongue_trial2.subject_id=463190;
key_tongue_trial2.session=2;
key_tongue_trial2.trial=273; %% 212 72    207 %33

key_tongue_session.subject_id=463190;
key_tongue_session.session=2;


%z- motor
% zaber_to_mm_z_motor = 1/1000; %1,000 in zaber motor units == 1 mm
zaber_to_mm_z_motor = 1/10000; %1,000 in zaber motor units == 1 mm

%x- motor, and y-motor
zaber_to_mm_x_motor = 1.25/50000; %50,000 in zaber motor units ==1.25 mm

[Xpix2mm, Zpix2mm]  =  fn_video_pixels_to_mm (key_tongue_session, zaber_to_mm_z_motor, zaber_to_mm_x_motor);

% % from Zaber trial 0
% lickport_pos_z0_zaber=fetchn(EXP2.TrialLickPort & key_tongue_trial0, 'lickport_pos_z')*zaber_to_mm_z_motor;
% % from video trial 0
% lickport_pos_z0_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_trial0, 'lickport_z');

% lickport_pos_z0_video*pixels_z_to_mm_slope + pixels_z_to_mm_offset;

%% Lick trial
axes('position',[position_lick_x1(1),position_lick_y1(1), panel_lick_width1, panel_lick_height1])
hold on;

key_tongue_trial0.bodypart_name='tongue';
rel_behavior_trial = (EXP2.BehaviorTrialEvent & key_tongue_trial0 & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;

%get time
[t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue_trial0);
traj_z_tongue=(fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial0,'traj_z').*Zpix2mm.slope)+Zpix2mm.intercept;
traj_lickport_z=(fetch1(TRACKING.VideoLickportPositionTrajectTrial  & key_tongue_trial0, 'lickport_z_traj').*Zpix2mm.slope)+Zpix2mm.intercept;

z_offset = nanmin(traj_z_tongue);
traj_z_tongue =  traj_z_tongue - z_offset;
traj_lickport_z =  traj_lickport_z- z_offset;

plot(t ,traj_lickport_z ,'-b')
yl = [nanmin([traj_z_tongue,0]), ceil(1.2*(nanmax(traj_z_tongue)))];
xl = [-0.5,1.5];
text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*1.2,sprintf('Dorso-Ventral \n     (mm)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.6,sprintf('Time to 1st contact-lick (s)'), 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.25,sprintf('Tongue position'), 'FontSize',6,'HorizontalAlignment','center','FontWeight','bold');
text(xl(1)-diff(xl)*0.6, yl(1)-diff(yl)*0.65, 'b', 'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
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
 idx_lick_contact_time(idx_lick_contact_time==1)=[];
 plot(t(idx_lick_contact_time),traj_z_tongue(idx_lick_contact_time),'.c','MarkerSize',10);

%% Lick trial 2D Example 1
% Lick trial trajectory Z-Y1
axes('position',[position_lick_x2(1),position_lick_y2(1), panel_lick_width2, panel_lick_height2])
hold on;
[y1_tongue_range, y1_target]  = fn_video_plot_projections_ZY (key_tongue_trial1, Zpix2mm, Xpix2mm, key_tongue_session);
xlabel('A-P (mm)','FontSize',6);
ylabel('D-V (mm)','FontSize',6);
title('Trial 1','FontSize',6);
text(-5.5, -2, 'c', 'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Lick trial trajectory X-Y2
axes('position',[position_lick_x2(1),position_lick_y2(2), panel_lick_width2, panel_lick_height2])
hold on;
fn_video_plot_projections_XY (key_tongue_trial1, Zpix2mm, Xpix2mm, key_tongue_session, y1_tongue_range, y1_target);
ylabel('A-P (mm)','FontSize',6);
xlabel('M-L (mm)','FontSize',6);

%% Lick trial 2D Example 1
% Lick trial trajectory Z-Y1
axes('position',[position_lick_x2(2),position_lick_y2(1), panel_lick_width2, panel_lick_height2])
hold on;
[y1_tongue_range, y1_target]  = fn_video_plot_projections_ZY (key_tongue_trial2, Zpix2mm, Xpix2mm, key_tongue_session);
title('Trial 2','FontSize',6);


% Lick trial trajectory X-Y2
axes('position',[position_lick_x2(2),position_lick_y2(2), panel_lick_width2, panel_lick_height2])
hold on;
fn_video_plot_projections_XY (key_tongue_trial2, Zpix2mm, Xpix2mm, key_tongue_session, y1_tongue_range, y1_target);



 
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
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.1, 'd', ...
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
    pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_y') / fetch1(IMG.FOV & key_fov_example, 'fov_x_size');
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
text(xl(1)-diff(xl)*0.3, yl(1)+diff(yl)*1.25, 'e', ...
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
[xl,yl] = fn_plot_roi_image(plane4, 0.2, R, ax4_roi);

scalebar=10/pix2dist; %10 microns
plot([xl(1)+5,xl(1)+scalebar+5],[yl(1)+5,yl(1)+5,],'-w','LineWidth',1)
% text((xl(1)+5+scalebar)*1,yl(1)+10,['10 \mum'],'FontSize',6, 'fontweight', 'bold','Color',[1 1 1])


%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 72456;
cell_number=1;
panel_legend='f';
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1343791;
cell_number=2;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% % Example Cell 3 PSTH
% axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])
% roi_number_uid = 1255801;
% cell_number=3;
% fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1326983;
cell_number=3;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 1, 1,panel_legend, cell_number);

% % Example Cell 5 PSTH
% axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
% roi_number_uid = 1294286;
% cell_number=5;
% fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 6 PSTH
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1354700;
cell_number=4;
fn_plot_single_cell_psth_example(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

%% Single cell PSTH by position examples
% Example Cell 1 PSTH
roi_number_uid = 1260924;
cell_number2d=5;
fn_plot_single_cell_psth_by_position_example (rel_example,roi_number_uid , 0, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d);
text(-30, 1.75, 'h', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Example Cell 2 PSTH
roi_number_uid = 1261160; 
cell_number2d=7;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 1, 1, position_x1_grid(1), position_y1_grid(2), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 1261985;
cell_number2d=6;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(1), cell_number2d);

% % Example Cell 4 PSTH
% roi_number_uid = 1261359;
% cell_number2d=10;
% fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 1, 1, position_x1_grid(1), position_y1_grid(2), cell_number2d);

% Example Cell 5 PSTH
roi_number_uid = 1260574;
cell_number2d=8;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(2), cell_number2d);

% % Example Cell 6 PSTH
% roi_number_uid = 1261779; 
% cell_number2d=12;
% fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(3), position_y1_grid(2), cell_number2d);


%% 100 cells from one session
fn_PLOTS_Multiple_Cells2DTuning_for_one_session (key_single_session, rel_map_single_session, rel_roi, 10, 10, position_x2_grid(1), position_y2_grid(1))

%colorbar
ax13=axes('position',[position_x2_grid(1)-0.01, position_y2_grid(1)-0.125, panel_width4/3, panel_height4/4]);
caxis([0,1])
colormap(ax13,inferno)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[0, 1],'TickLabels',[{'0','1'}], 'FontSize',6);
text(9,0.5,sprintf('Activity (norm.)'), 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);


%% Plotting Stats
%--------------------------------
Figure_1_data_plot_script

%% Tuning versus anatomical dtstance
key_distance.odd_even_corr_threshold=0.25;
rel_data_distance= (LICK2D.DistanceCorrConcatSpikes *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrConcatSpikesShuffled *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;
bins_eucledian_distance=D(1).lateral_distance_bins;
bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;

%lateral
distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));

%axial
idx_column_radius=2; %10 to 30 microns
distance_axial_all=[];
distance_axial_all_shuffled=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));

%eucledian
distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
d_eucledian_mean =  nanmean(distance_eucledian_all,1);
d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));

distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));

%% Eucledian
axes('position',[position_x5(2)+0.0075-0.06,position_y5(2), panel_width5, panel_height5])
% all sessions

% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0.5 0.5  0.5 ]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);

lineProps.col={[1 0 1]};
lineProps.LineStyle{1}='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% yl = [0, 0.15];
yl = [0, 0.25];

xl = [0,500];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.3,sprintf('Tuning similarity vs.\n anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'o', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

%  
%% Axial vs Lateral

axes('position',[position_x5(3)+0.0075-0.06,position_y5(2), panel_width5, panel_height5])
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
yl = [0.1, 0.25];
xl = [0,120];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
 
if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




