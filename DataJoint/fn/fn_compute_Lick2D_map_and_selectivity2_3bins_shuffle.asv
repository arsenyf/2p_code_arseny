function fn_compute_Lick2D_map_and_selectivity2_3bins_shuffle (key,self, rel_data, fr_interval, fr_interval_limit, flag_electric_video, self2)
number_of_bins=3;
smooth_window_sec=0.2; %frames for PSTH
timespent_min=5; %in trials
timespent_min_partial=3; %in trials, for partial conditions (e.g. reward modulation, and trial number in block )
min_percent_coverage=50; % minimal coverage needed for 2D map calculation
%Smoothing parameters for 2D maps
sigma=1;
hsize=1;
num_shuffles=101;

rel_ROI = (IMG.ROI-IMG.ROIBad) & key;

key_ROI1=fetch(rel_ROI,'ORDER BY roi_number'); %2D map
key_ROI2=fetch(rel_ROI,'ORDER BY roi_number'); %2D map PSTH

rel_data =rel_data & rel_ROI & key;


%% Rescaling, rotation, and binning
[POS, ~] = fn_rescale_and_rotate_lickport_pos (key);
key.number_of_bins=number_of_bins;
pos_x = POS.pos_x;
pos_z = POS.pos_z;

x_bins = linspace(-1, 1,key.number_of_bins+1);
x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;

z_bins = linspace(-1,1,key.number_of_bins+1);
z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;

x_bins(1)= -inf;
x_bins(end)= inf;
z_bins(1)= -inf;
z_bins(end)= inf;



%% Compute maps
session_date = fetch1(EXP2.Session & key,'session_date');
filename = [ 'anm' num2str(key.subject_id) '_s' num2str(key.session) '_' session_date];

rand_x_jitter=pos_x+(rand(1,numel(pos_x))-0.5)./3;
rand_z_jitter=pos_z+(rand(1,numel(pos_x))-0.5)./3;

x_bins_original=x_bins;
z_bins_original=z_bins;

x_bins=prctile(rand_x_jitter,[0,33,66,100]);
z_bins=prctile(rand_z_jitter,[0,33,66,100]);

[hhhhh, ~, ~, x_idx, z_idx] = histcounts2(rand_x_jitter,rand_z_jitter,x_bins,z_bins);

%plot(pos_x,pos_z,'.')
subplot(2,2,1)

hold on
plot(pos_x,pos_z,'.b')
plot(rand_x_jitter,rand_z_jitter,'.r')
plot([x_bins(2),x_bins(2)],[z_bins(2)-1,z_bins(3)+1],'-k')
plot([x_bins(3),x_bins(3)],[z_bins(2)-1,z_bins(3)+1],'-k')
plot([x_bins(2)-1,x_bins(3)+1],[z_bins(2),z_bins(2)],'-k')
plot([x_bins(2)-1,x_bins(3)+1],[z_bins(3),z_bins(3)],'-k')
title(sprintf('anm%d %s session %d\nOriginal position',key.subject_id, session_date, key.session),'FontSize',10);

subplot(2,2,2)
imagesc(hhhhh)
caxis([0 max(hhhhh(:))]); % Scale the lowest value (deep blue) to 0
colormap(parula)

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Lick2D\behavior\lickport_position_3binning\'];

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename '_lickport'];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);
close all;

mat_x=repmat(x_bins_centers,key.number_of_bins,1);
mat_z=repmat(z_bins_centers',1,key.number_of_bins);


% go_time=fetchn(EXP2.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time','LIMIT 1');
frame_rate = fetchn(IMG.FOVEpoch & key,'imaging_frame_rate');
smooth_window_frames = ceil(smooth_window_sec*frame_rate); %frames for PSTH

% TrialsStartFrame=fetchn(IMG.FrameStartTrial & key,'session_epoch_trial_start_frame','ORDER BY trial');
% if isempty(TrialsStartFrame) % not mesoscope recordings
%     TrialsStartFrame=fetchn(IMG.FrameStartFile & key,'session_epoch_file_start_frame', 'ORDER BY session_epoch_file_num');
% end

% L=fetch(EXP2.ActionEvent & key,'*');
R=fetch((EXP2.TrialRewardSize & key) - TRACKING.VideoGroomingTrial,'*','ORDER BY trial');

S=fetch(rel_data,'*');
if isfield(S,'spikes_trace') % to be able to run the code both on dff and on deconvulted "spikes" data
    [S.dff_trace] = S.spikes_trace;
    S = rmfield(S,'spikes_trace');
else
end

% num_trials = numel(TrialsStartFrame);
[start_file, end_file ] = fn_parse_into_trials_and_get_lickrate (key,frame_rate, fr_interval, flag_electric_video);

num_trials =numel(start_file);
idx_response = (~isnan(start_file));
try
    % idx reward
    idx_regular = strcmp({R.reward_size_type},'regular')  & idx_response;
    idx_small= strcmp({R.reward_size_type},'omission')  & idx_response;
    idx_large= strcmp({R.reward_size_type},'large')  & idx_response;
    
    idx_odd_regular = find(idx_regular);
    idx_odd_regular = idx_odd_regular(1:2:sum(idx_regular));
    idx_odd_regular = ismember(1:1:num_trials,idx_odd_regular);
    idx_even_regular = find(idx_regular);
    idx_even_regular = idx_even_regular(2:2:sum(idx_regular));
    idx_even_regular = ismember(1:1:num_trials,idx_even_regular);
catch
    idx_regular = 1:1:num_trials  & idx_response;
    idx_odd_regular = ismember(1:1:num_trials,1:2:num_trials) & idx_response;
    idx_even_regular =  ismember(1:1:num_trials,2:2:num_trials) & idx_response;
end
idx_odd_regular = idx_regular(1:2:numel(idx_regular));
idx_even_regular = idx_regular(2:2:numel(idx_regular));


for i_x=1:1:numel(x_bins_centers)
    for i_z=1:1:numel(z_bins_centers)
        idx_xz {i_z,i_x} = find((x_idx==i_x)  & idx_response &  (z_idx==i_z));
    end
end

for i_roi=1:1:size(S,1)
    
    %% PSTH
    spikes=S(i_roi).dff_trace;
    
    
    
    lickmap_regular_odd_vs_even_corr_shuffled=[];
    lickmap_fr_regular_modulation_shuffled=[];
    psth_position_concat_regular_odd_even_corr_shuffled=[];
    
    for i_shuffle = 1:1:num_shuffles
        if i_shuffle==1 % first iteration of the shuffle we don't actually do shuffle but use the original data
            spikes_shuffled=spikes;
        else %we do shuffling
            shift = randi(numel(spikes)-100)+100;
            spikes_shuffled=circshift(spikes,shift);
        end
        
        psth_all=[];
        
        for i_tr = 1:1:numel(start_file)
            if idx_response(i_tr)==0 %its an ignore trial
                fr_all(i_roi,i_tr)=NaN;
                psth_all{i_roi,i_tr}=NaN;
                continue
            end
            s=spikes_shuffled(start_file(i_tr):end_file(i_tr));
            s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
            time=(1:1:numel(s))/frame_rate + fr_interval(1);
            s_interval=s(time>=fr_interval_limit(1) & time<fr_interval_limit(2));
            fr_all(i_roi,i_tr)= sum(s_interval)/numel(s_interval); %taking mean fr
            %         fr_all(i_roi,i_tr)= max(s_interval); %taking the max
            psth_all{i_roi,i_tr}=s;
        end
        
        
        %% PSTH per position, and 2D maps
        for i_x=1:1:numel(x_bins_centers)
            for i_z=1:1:numel(z_bins_centers)
                %             idx = find((x_idx==i_x)  & ~isnan(start_file) &  (z_idx==i_z));
                idx_bin = idx_xz{i_z,i_x};
                
                %% Binning for 2D 2D MAP calculation
                %spikes binned
                map_xz_spikes_regular(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_regular));
                map_xz_spikes_regular_odd(i_z,i_x) = sum(fr_all(i_roi, ismember(1:1:num_trials,idx_bin) & idx_regular & idx_odd_regular   ));
                map_xz_spikes_regular_even(i_z,i_x) = sum(fr_all(i_roi,  ismember(1:1:num_trials,idx_bin) & idx_regular & idx_even_regular   ));
                
                % timespent binned
                map_xz_timespent_regular(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular);
                map_xz_timespent_regular_odd(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular & idx_odd_regular);
                map_xz_timespent_regular_even(i_z,i_x) = sum( ismember(1:1:num_trials,idx_bin) & idx_regular & idx_even_regular);
                
                %% Binning for 2D PSTH calculation
                [psth_per_position_regular{i_z,i_x}, psth_per_position_regular_stem{i_z,i_x},psth_per_position_regular_odd{i_z,i_x},psth_per_position_regular_even{i_z,i_x}] = fn_compute_psth_mean_and_stem(psth_all, i_roi, num_trials, idx_bin, idx_regular, timespent_min, time);
                
            end
        end
        
        
        
        
        %% Actual 2D map calculation
        [~, lickmap_fr_regular] ...
            = fn_compute_generic_2D_field3_short ...
            (x_bins, z_bins, map_xz_timespent_regular, map_xz_spikes_regular, timespent_min, sigma, hsize, 0 ,min_percent_coverage);
        
        [~, lickmap_fr_regular_odd] ...
            = fn_compute_generic_2D_field3_short ...
            (x_bins, z_bins, map_xz_timespent_regular_odd, map_xz_spikes_regular_odd, timespent_min, sigma, hsize, 0, min_percent_coverage);
        
        [~, lickmap_fr_regular_even] ...
            = fn_compute_generic_2D_field3_short ...
            (x_bins, z_bins, map_xz_timespent_regular_even, map_xz_spikes_regular_even, timespent_min, sigma, hsize, 0, min_percent_coverage);
        
        
        %% Correlations between 2D maps
        r=corr([lickmap_fr_regular_odd(:),lickmap_fr_regular_even(:)],'Rows' ,'pairwise');
        lickmap_regular_odd_vs_even_corr_shuffled(i_shuffle) = r(2);
        
        lickmap_fr_regular_modulation_shuffled(i_shuffle) = fn_compute_generic_1D_or_2D_tuning_modulation_depth (lickmap_fr_regular);
        
        
        r=corr([cell2mat(psth_per_position_regular_odd(:)')',cell2mat(psth_per_position_regular_even(:)')'],'Rows' ,'pairwise');
        psth_position_concat_regular_odd_even_corr_shuffled(i_shuffle) = r(2);
        
        
        
    end
    
    key_ROI1(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI1(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI1(i_roi).number_of_bins = key.number_of_bins;
    
    
    key_ROI2(i_roi).session_epoch_type = key.session_epoch_type;
    key_ROI2(i_roi).session_epoch_number = key.session_epoch_number;
    key_ROI2(i_roi).number_of_bins = key.number_of_bins;
    
    
    % Computing p-value: what fraction of observations in the shuffled distribution  were above the true observation (the first entry)
    key_ROI1(i_roi).lickmap_regular_odd_vs_even_corr_pval = sum(lickmap_regular_odd_vs_even_corr_shuffled(2:end)>=lickmap_regular_odd_vs_even_corr_shuffled(1))/num_shuffles;
    key_ROI1(i_roi).lickmap_fr_regular_modulation_pval = sum(lickmap_fr_regular_modulation_shuffled(2:end)>=lickmap_fr_regular_modulation_shuffled(1))/num_shuffles;
    key_ROI1(i_roi).psth_position_concat_regular_odd_even_corr_pval = sum(psth_position_concat_regular_odd_even_corr_shuffled(2:end)>=psth_position_concat_regular_odd_even_corr_shuffled(1))/num_shuffles;
    
    key_ROI2(i_roi).lickmap_regular_odd_vs_even_corr_shuffled = lickmap_regular_odd_vs_even_corr_shuffled(2:end);
    key_ROI2(i_roi).lickmap_fr_regular_modulation_shuffled = lickmap_fr_regular_modulation_shuffled(2:end);
    key_ROI2(i_roi).psth_position_concat_regular_odd_even_corr_shuffled =  psth_position_concat_regular_odd_even_corr_shuffled(2:end);
end

%bulk insertion
insert(self, key_ROI1);
insert(self2, key_ROI2);
