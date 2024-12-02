function Supplementary_Figure_1__Behavior_Revision_performanceRT()
close all;
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename='Supplementary_Figure_1__Behavior_Revision_performance';


% key.subject_id = 464725;
% key.session =4;

% key.subject_id = 463190;
% key.session =8;

key.number_of_bins=3;

rel_reaction_time  = (TRACKING.VideoNthLickTrial*EXP2.TrialLickPortPositionRescale*EXP2.BehaviorTrial*EXP2.SessionTrialUniqueIDCorrect & key & 'lick_touch_number=1') -TRACKING.VideoGroomingTrial ;

% rel_test = ((TRACKING.VideoLickCountTrial*EXP2.TrialLickPortPositionRescale*TRACKING.VideoNthLickTrial*EXP2.SessionTrial*EXP2.BehaviorTrial) & key)  - 'outcome ="ignore"')  - TRACKING.VideoGroomingTrial ;

%  
% % ,'lick_time_onset'
% & 'trial>100' 

%% Rescaling, rotation, and binning
% [POS] = fn_rescale_and_rotate_lickport_pos (key);
% pos_x = POS.pos_x;
% pos_z = POS.pos_z;
pos_x = fetchn(rel_reaction_time,'lickport_pos_x','ORDER BY trial_uid_correct');
pos_z = fetchn(rel_reaction_time,'lickport_pos_z','ORDER BY trial_uid_correct');
x_bins = linspace(-1, 1,key.number_of_bins+1);
x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;
z_bins = linspace(-1,1,key.number_of_bins+1);
z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;
x_bins(1)= -inf;
x_bins(end)= inf;
z_bins(1)= -inf;
z_bins(end)= inf;




% L_video_RT2 = fetchn( rel_reaction_time,'lick_time_onset','ORDER BY trial_uid');
% 
[L_video_RT,L_video_RT2] = fetchn( rel_reaction_time,'lick_time_onset','lick_time_electric','ORDER BY trial_uid_correct');
% L_video_RT2 = fetchn( rel_reaction_time,'lick_time_electric','ORDER BY trial_uid');

sum(L_video_RT~=L_video_RT2)

plot(L_video_RT,L_video_RT2,'.')

%% Compute maps
[~, ~, ~, x_idx, z_idx] = histcounts2(pos_x,pos_z,x_bins,z_bins);

for i_x=1:1:numel(x_bins_centers)
    for i_z=1:1:numel(z_bins_centers)
        idx = find((x_idx==i_x)  &  (z_idx==i_z));
      num_response(i_z,i_x) = numel(idx);
      lick_RT_binned(i_z,i_x) = sum(L_video_RT(idx));
    end
end


%% Maps
subplot(2,2,1)
imagescnan(x_bins_centers, z_bins_centers, lick_RT_binned./num_response)
map_xz_lick_RT = lick_RT_binned./num_response;
max_map=max(map_xz_lick_RT(:));
caxis([0.5 max_map]); % Scale the lowest value (deep blue) to 0
colormap(inferno)
%     title(sprintf('ROI %d anm%d %s\n \n Positional (2D) tuning  \n I = %.2f bits/spike  \n  p-val = %.4f  ',roi_number(i_roi),key.subject_id, session_date, M(i_roi).information_per_spike, M(i_roi).pval_information_per_spike ), 'FontSize',10);
axis xy
axis equal;
axis tight
colorbar
xlabel(sprintf('Lickport X-pos \n(normalized)'), 'FontSize',10);
ylabel(sprintf('Lickport  Z-pos '), 'FontSize',10);
set(gca,'YDir','normal');
set(gca, 'FontSize',10);
title('% Reaction time (s)');


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);

