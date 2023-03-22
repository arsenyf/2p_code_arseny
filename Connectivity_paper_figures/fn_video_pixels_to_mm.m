function [Xpix2mm, Zpix2mm]  = fn_video_pixels_to_mm (key_tongue_session, zaber_to_mm_z_motor, zaber_to_mm_x_motor)

% Lickport position based on zaber, in mm
lickport_pos_x_zaber_all=fetchn(EXP2.TrialLickPort & TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_pos_x')*zaber_to_mm_x_motor;
lickport_pos_z_zaber_all=fetchn(EXP2.TrialLickPort & TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_pos_z')*zaber_to_mm_z_motor;

x_zaber_range_mm=max(lickport_pos_x_zaber_all(100:end))- min(lickport_pos_x_zaber_all(100:end));
z_zaber_range_mm=max(lickport_pos_z_zaber_all(100:end))- min(lickport_pos_z_zaber_all(100:end));

x2z_zaber_ratio = x_zaber_range_mm/z_zaber_range_mm;

% Lickport position based on video, in poxels
lickport_pos_x_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_x');
lickport_pos_z_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_z');
lickport_pos_y1_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_y1');
lickport_pos_y2_video=fetchn(TRACKING.VideoLickportPositionTrial & key_tongue_session, 'lickport_y2');

x_video_range_pixels=prctile(lickport_pos_x_video(100:end),98)- prctile(lickport_pos_x_video(100:end),2);
z_video_range_pixels=prctile(lickport_pos_z_video(100:end),98)- prctile(lickport_pos_z_video(100:end),2);
y1_video_range_pixels=prctile(lickport_pos_y1_video(100:end),98)- prctile(lickport_pos_y1_video(100:end),2);
y2_video_range_pixels=prctile(lickport_pos_y2_video(100:end),98)- prctile(lickport_pos_y2_video(100:end),2);


x2z_video_ratio = x_video_range_pixels/z_video_range_pixels;
(y1_video_range_pixels/y2_video_range_pixels)
% (x_video_range_pixels/z_video_range_pixels)*(y1_video_range_pixels/y2_video_range_pixels)

%% Z pixels to mm
temp=fitlm(-lickport_pos_z_video, lickport_pos_z_zaber_all);
Zpix2mm.slope=temp.Coefficients.Estimate(2);
Zpix2mm.intercept=temp.Coefficients.Estimate(1);
% %for debug
% plot((lickport_pos_z_video.*Zpix2mm.slope)+Zpix2mm.intercept,lickport_pos_z_zaber_all, '.')

%% X pixels to mm
temp =fitlm(lickport_pos_x_video, lickport_pos_x_zaber_all);
Xpix2mm.slope=temp.Coefficients.Estimate(2);
Xpix2mm.intercept=temp.Coefficients.Estimate(1);
% %for debug
% plot((lickport_pos_x_video.*Xpix2mm.slope)+Xpix2mm.intercept,lickport_pos_x_zaber_all, '.')
