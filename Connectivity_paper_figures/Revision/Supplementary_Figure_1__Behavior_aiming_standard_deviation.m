function Supplementary_Figure_1__Behavior_aiming_standard_deviation()
close all;
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename='Supplementary_Figure_1__Behavior_aiming_standard_deviation';


% key.subject_id = 464725;
% key.session =5;

% key.subject_id = 463190;
% key.session =8;

key.number_of_bins=3;

rel_behavior = (EXP2.BehaviorTrial*EXP2.SessionTrialUniqueIDCorrect &  key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale&  key) - TRACKING.VideoGroomingTrial;
B=fetch(rel_behavior, 'outcome','trial_uid_correct', 'ORDER BY trial_uid_correct');

rel_licks_count = (TRACKING.VideoLickCountTrial*EXP2.SessionTrialUniqueIDCorrect & key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale &  key) - TRACKING.VideoGroomingTrial;

rel_lickport_position = (EXP2.TrialLickPortPositionRescale*EXP2.SessionTrialUniqueIDCorrect & key & TRACKING.VideoNthLickTrial) - TRACKING.VideoGroomingTrial;



subplot(3,3,1)
distance = [fetchn(TRACKING.VideoLickAimingTrial & key,'aiming_2d_before_1st_contact')];
array3D = cat(3, distance{:});
imagesc(mean(  array3D,3))
title('aiming before 1st contact')
colormap(jet)
colorbar
%caxis([-0.3,0.6])
caxis([0.3,0.7])
colormap(inferno)

subplot(3,3,2)
distance = [fetchn(TRACKING.VideoLickAimingTrial  & key,'aiming_2d_at_1st_contact')];
array3D = cat(3, distance{:});
imagesc(mean(  array3D,3))
colorbar
title('aiming at 1st contact')
%caxis([-0.2,0.6])
caxis([0.3,0.7])
colormap(inferno)

subplot(3,3,3)
distance = [fetchn(TRACKING.VideoLickAimingTrial  & key,'aiming_2d_after_1st_contact_including')];
array3D = cat(3, distance{:});
imagesc(mean(  array3D,3))
colorbar
title('aiming after 1st contact including')
%caxis([-0.2,0.6])
caxis([0.3,0.7])
colormap(inferno)

% subplot(3,3,4)
% distance = [fetchn(TRACKING.VideoLickAimingTrial  & key,'aiming_2d_before_lickport_entrance')];
% array3D = cat(3, distance{:});
% imagesc(mean(  array3D,3))
% colorbar
% title('aiming before lickport entrance')
% %caxis([-0.3,0.6])
% caxis([0,0.7])
% 
% subplot(3,3,5)
% distance = [fetchn(TRACKING.VideoLickAimingTrial  & key,'aiming_2d_after_lickport_entrance')];
% array3D = cat(3, distance{:});
% imagesc(mean(  array3D,3))
% colorbar
% title('aiming after lickport entrance')
% %caxis([-0.3,0.6])
% caxis([0,0.7])
% 


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);