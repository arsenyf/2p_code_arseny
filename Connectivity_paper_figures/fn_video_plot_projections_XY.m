function fn_video_plot_projections_XY (key_tongue_trial1,Zpix2mm, Xpix2mm, key_tongue_session, y1_tongue_range, y1_target)

% Lick trial trajectory X-Y2
hold on;
key_tongue_trial1.bodypart_name='tongue';
rel_behavior_trial = (EXP2.BehaviorTrialEvent & key_tongue_trial1 & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;


tongue_x_traj=fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_x').*Xpix2mm.slope + Xpix2mm.intercept;
lickport_x_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_x').*Xpix2mm.slope + Xpix2mm.intercept;
lickport_x_center_all=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session,'lickport_x').*Xpix2mm.slope + Xpix2mm.intercept;
x_offset = prctile(lickport_x_center_all(100:end),2)  + [prctile(lickport_x_center_all(100:end),98) - prctile(lickport_x_center_all(100:end),2)]/2;
tongue_x_traj =  tongue_x_traj - x_offset;
lickport_x_center =  lickport_x_center- x_offset;



tongue_y_traj =fetch1(TRACKING.VideoBodypartTrajectTrial & key_tongue_trial1,'traj_y2').*Xpix2mm.slope + Xpix2mm.intercept;
lickport_y_center=fetch1(TRACKING.VideoLickportPositionTrial  & key_tongue_trial1, 'lickport_y2').*Xpix2mm.slope + Xpix2mm.intercept;
lickport_y_center_all=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session,'lickport_y2').*Xpix2mm.slope + Xpix2mm.intercept;
y_lickport_median = prctile(lickport_y_center_all(100:end),50);
y_offset = prctile(lickport_y_center_all(100:end),2) -3;
tongue_y_traj = ((tongue_y_traj) /(lickport_y_center/y_lickport_median))  -y_offset;
lickport_y_center = ((lickport_y_center) /(lickport_y_center/y_lickport_median)) -y_offset;

% y1_tongue_range
% y2_tongue_range = [nanmin(tongue_y_traj),nanmax(tongue_y_traj)];
tongue_y_traj=tongue_y_traj-nanmin(tongue_y_traj);
tongue_y_traj=tongue_y_traj/nanmax(tongue_y_traj);
tongue_y_traj=tongue_y_traj*y1_tongue_range(2);

% tongue_y_traj = tongue_y_traj-(y1_tongue_range(1)/y1_tongue_range(2));

lickport_y_center = y1_target;

[t,idx_lick_contact_time, idx_licks_time_onset, idx_licks_time_ends ] = fn_lick_time_alignment (rel_behavior_trial, key_tongue_trial1);

idx_non_early = t(idx_licks_time_onset)>=-0.1;
idx_licks_time_onset = idx_licks_time_onset(idx_non_early);
idx_licks_time_ends = idx_licks_time_ends(idx_non_early);
idx_lick_contact_time = idx_lick_contact_time(idx_non_early);
idx_lick_contact_time(idx_lick_contact_time==1)=[];


% colormap_g=winter(numel(idx_licks_time_onset));
colormap_g=pink(numel(idx_licks_time_onset)*2);
for i_l=1:1:numel(idx_licks_time_onset)
    idx_current_lick = idx_licks_time_onset(i_l):1: idx_licks_time_ends (i_l);
    plot(tongue_x_traj(idx_current_lick),tongue_y_traj(idx_current_lick),'-','Color',[colormap_g(i_l,:)],'LineWidth',0.75)
end
% plot(tongue_x_traj(idx_lick_contact_time),tongue_y_traj(idx_lick_contact_time),'.c','MarkerSize',5);
xl=[-2.5,2.5];
xlim(xl);
yl=[0,4];
ylim(yl);
set(gca,'YDir', 'reverse');
set(gca,'XTick',[xl(1) 0, xl(2)],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
plot(lickport_x_center,lickport_y_center,'ob','MarkerSize',5);
