function Supplementary_Figure_1__Behavior_Revision_performance()
close all;
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename='Supplementary_Figure_1__Behavior_Revision_performance';


% key.subject_id = 464725;
% key.session =5;

% key.subject_id = 463190;
% key.session =8;

key.number_of_bins=3;

rel_behavior = (EXP2.BehaviorTrial*EXP2.SessionTrialUniqueIDCorrect &  key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale&  key) - TRACKING.VideoGroomingTrial;
B=fetch(rel_behavior, 'outcome','trial_uid_correct', 'ORDER BY trial_uid_correct');

rel_licks_count = (TRACKING.VideoLickCountTrial*EXP2.SessionTrialUniqueIDCorrect & key & TRACKING.VideoNthLickTrial) & (EXP2.TrialLickPortPositionRescale &  key) - TRACKING.VideoGroomingTrial;

rel_lickport_position = (EXP2.TrialLickPortPositionRescale*EXP2.SessionTrialUniqueIDCorrect & key & TRACKING.VideoNthLickTrial) - TRACKING.VideoGroomingTrial;

%% Rescaling, rotation, and binning
% [POS] = fn_rescale_and_rotate_lickport_pos (key);
% pos_x = POS.pos_x;
% pos_z = POS.pos_z;
pos_x = fetchn(rel_lickport_position,'lickport_pos_x','ORDER BY trial_uid_correct');
pos_z = fetchn(rel_lickport_position,'lickport_pos_z','ORDER BY trial_uid_correct');
x_bins = linspace(-1, 1,key.number_of_bins+1);
x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;
z_bins = linspace(-1,1,key.number_of_bins+1);
z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;
x_bins(1)= -inf;
x_bins(end)= inf;
z_bins(1)= -inf;
z_bins(end)= inf;

L_video_licks_count = fetch( rel_licks_count,'*','ORDER BY trial_uid_correct');
% L_video_after_1st_contact = fetch( rel_licks_video_after_1st_contact,'trial_uid_correct','ORDER BY trial_uid_correct');
% L_electric_contacts = fetch( rel_licks_video_contacts_only,'trial_uid_correct','ORDER BY trial_uid_correct');



licks_byvideo_in_trial=[];
licks_byvideo_after_1st_contact_including = [];
licks_byelectric_contact = [];
licks_byvideo_after_lickport_entrance = [];
licks_byvideo_before_lickport_entrance =[];

parfor i_tr=1:1:numel(B)
    curr_trial = B(i_tr).trial_uid_correct;
    idx_current_trial = find([L_video_licks_count.trial_uid_correct]==curr_trial);
    licks_byvideo_in_trial(i_tr) =  L_video_licks_count(idx_current_trial).licks_byvideo_in_trial;
    licks_byvideo_after_1st_contact_including(i_tr) = L_video_licks_count(idx_current_trial).licks_byvideo_after_1st_contact_including;
    licks_byelectric_contact(i_tr) =  L_video_licks_count(idx_current_trial).licks_byelectric_contact;
    licks_byvideo_before_lickport_entrance(i_tr) =  L_video_licks_count(idx_current_trial).licks_byvideo_before_lickport_entrance;
    licks_byvideo_after_lickport_entrance(i_tr) =  L_video_licks_count(idx_current_trial).licks_byvideo_after_lickport_entrance;
    
end

%% Compute maps
[~, ~, ~, x_idx, z_idx] = histcounts2(pos_x,pos_z,x_bins,z_bins);

outcome ={B.outcome};


for i_x=1:1:numel(x_bins_centers)
    for i_z=1:1:numel(z_bins_centers)
        idx = find((x_idx==i_x)  &  (z_idx==i_z));
        percent_ignore = 100*sum(contains(outcome(idx),'ignore'))./numel(idx);
        
        map_xz_percent_response_trials(i_z,i_x) = 100-percent_ignore;
        num_response_trials(i_z,i_x) = sum(~contains(outcome(idx),'ignore'));
        num_trials(i_z,i_x) = numel(idx);
        
        num_licks_byvideo(i_z,i_x) = sum(licks_byvideo_in_trial(idx));
        num_licks_byvideo_after_1st(i_z,i_x) = sum(licks_byvideo_after_1st_contact_including(idx));
        num_licks_byelectric_contact(i_z,i_x) = sum(licks_byelectric_contact(idx));
        num_licks_byvideo_before_lickport_entrance(i_z,i_x) = sum(licks_byvideo_before_lickport_entrance(idx));
        num_licks_byvideo_after_lickport_entrance(i_z,i_x) = sum(licks_byvideo_after_lickport_entrance(idx));
        
    end
end
%
% for i_x=1:1:numel(x_bins_centers)
%     for i_z=1:1:numel(z_bins_centers)
%         idx = find((x_idx==i_x)  &  (z_idx==i_z));
%         percent_ignore = 100*sum(contains(outcome(idx),'ignore'))./numel(idx);
%
%         map_xz_percent_response(i_z,i_x) = 100-percent_ignore;
%         num_response(i_z,i_x) = sum(~contains(outcome(idx),'ignore'));
%         num_trials(i_z,i_x) = numel(idx);
%
%         num_licks_byvideo(i_z,i_x) = sum(licks_byvideo_in_trial(idx));
%         num_licks_byvideo_after_1st(i_z,i_x) = sum(licks_byvideo_after_1st_contact_including(idx));
%         num_licks_byelectric_contact(i_z,i_x) = sum(licks_byelectric_contact(idx));
%
%     end
% end


%% Maps
subplot(3,3,1)
imagescnan(x_bins_centers, z_bins_centers, map_xz_percent_response_trials)
max_map=max(map_xz_percent_response_trials(:));
caxis([0 100]); % Scale the lowest value (deep blue) to 0
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
title('% contact trials');


subplot(3,3,2)
num_licks_per_response_trial = num_licks_byvideo./num_response_trials;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, num_licks_per_response_trial)
max_map=max(num_licks_per_response_trial(:));
caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
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
title('number of total licks per trial');


subplot(3,3,3)
num_licks_after_1st_contact_per_response_trial = num_licks_byvideo_after_1st./num_response_trials;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, num_licks_after_1st_contact_per_response_trial)
max_map=max(num_licks_after_1st_contact_per_response_trial(:));
caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
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
title('number licks after 1st contact per trial');


subplot(3,3,4)
num_contact_licks_per_response_trial = num_licks_byelectric_contact./num_response_trials;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, num_contact_licks_per_response_trial)
max_map=max(num_contact_licks_per_response_trial(:));
caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
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
title('number contact licks per trial');

subplot(3,3,5)
number_licks_before_lickport_entrance_per_response_trial = num_licks_byvideo_before_lickport_entrance./num_response_trials;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, number_licks_before_lickport_entrance_per_response_trial)
max_map=max(number_licks_before_lickport_entrance_per_response_trial(:));
caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
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
title(sprintf('number licks per trial \n before target appearance'));


subplot(3,3,6)
number_licks_after_lickport_entrance_per_response_trial = num_licks_byvideo_after_lickport_entrance./num_response_trials;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, number_licks_after_lickport_entrance_per_response_trial)
max_map=max(number_licks_after_lickport_entrance_per_response_trial(:));
caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
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
title(sprintf('number licks per trial \n after target appearance'));



subplot(3,3,7)
percentage_contact_licks_after_lickport_entrance = 100*num_licks_byelectric_contact./num_licks_byvideo_after_lickport_entrance;
%     axes('position',[position_x2(4),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
imagescnan(x_bins_centers, z_bins_centers, percentage_contact_licks_after_lickport_entrance)
max_map=max(percentage_contact_licks_after_lickport_entrance(:));
caxis([0 90]); % Scale the lowest value (deep blue) to 0
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
title(sprintf('%% contact licks\n after target appearance'));

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);

