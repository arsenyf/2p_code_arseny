%{
# ROI responses to each photostim group. We only take groups based on unique target with signficance response of target, and significant response of connected neurons. Response of connected neurons can be positive or negative. Data is based on z-score traces of deconvolved df/f trace
-> IMG.PhotostimGroup
-> IMG.ROI                # ROI number of the connected neuron
---
roi_number_target                       :int          # ROI number of the target neuron
target_response_p_value1=null           : double      # p_value of the target neuron at peak
target_response_trace_mean=null         : blob        # target neuron response trace , average across trial
connected_response_p_value1=null        : double      # p_value of the response of the connected neuron at peak
connected_response_peak_mean=null       : float       # connected neuron response during the 1s photostimulation time window, average across trial
connected_response_trace_mean=null      : blob        # connected neuron response trace, average across trial
connected_distance_lateral_um=null      : float       # (um) lateral (X-Y) distance from target to a connected neuron
connected_distance_axial_um=null        : float       # (um) axial (Z) distance from target to a connected neuron
connected_distance_3d_um=null           : float       # (um)  3D distance from target to a connected neuron
time_vector=null                        : blob        # time vector (seconds) of the response, 0 is target photostimulation time
%}


classdef TargetAndConnectedResponseTraceDFF2LucaMazucatto < dj.Computed
    properties
        keySource = EXP2.SessionEpoch & (STIM.ROIResponseDirectUnique & 'response_p_value1<=0.05') &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1') & STIM.ROIInfluenceDFF;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
%             %% Example code how to use this table:
%             % Plot response of directly stimulated cells
%             Response_all_direct=fetchn(STIMANAL.TargetAndConnectedResponseTrace & 'target_response_p_value1<0.01' & 'target_response_peak_mean>0','target_response_trace_mean');
%             Response_all_direct = cell2mat(Response_all_direct);
%             time_vector = fetch1(STIMANAL.TargetAndConnectedResponseTrace,'time_vector', 'LIMIT 1');
%             plot(time_vector,mean(Response_all_direct ),'-r');

%             % Plot response of connected cells cells
%             hold on
%             Response_all_connected=fetchn(STIMANAL.TargetAndConnectedResponseTrace & 'connected_response_p_value1<0.01' & 'connected_response_peak_mean>0','connected_response_trace_mean');
%             Response_all_connected = cell2mat(Response_all_connected);
%             time_vector = fetch1(STIMANAL.TargetAndConnectedResponseTrace,'time_vector', 'LIMIT 1')
%             plot(time_vector,mean(Response_all_connected ),'-b')
%             
%            
%             
            
            
            min_distance_to_closest_target=25; % in microns
%             frame_window_long=[56,220]/2;
            frame_window_long=[56,110]/2;

            flag_baseline_trial_or_avg=0; %1 baseline per trial, 0 - baseline averaged across trials
            
            %             rel=STIM.ROIInfluence2 & 'response_p_value1<=0.05' & sprintf('response_distance_lateral_um >%.2f', min_distance_to_closest_target) & 'response_mean>0';
            
            
            
            %%
            distance_to_exclude_all=50; %microns; Excluding all frames during stimulation of other targets in the vicinity (distance_to_exclude_all) of the potentially connected cell
            
            minimal_number_of_clean_trials=20; %to include; trials that are not affected by random stimulations of nearby targets
            
            rel_roi = (IMG.ROI-IMG.ROIBad)  & key;
            rel_roi_xy = (IMG.ROIPositionETL-IMG.ROIBad)  & key; % XYZ coordinate correction of ETL abberations based on ETL callibration
            
            
            rel_data = (IMG.ROIdeltaF -IMG.ROIBad)  & key;
            %             rel_data = IMG.ROIdeltaF;
            
            
            try
                frame_rate= fetch1(IMG.FOVEpoch & key, 'imaging_frame_rate');
            catch
                frame_rate = fetch1(IMG.FOV & key, 'imaging_frame_rate');
            end
            G=fetch(IMG.PhotostimGroupROI & (STIM.ROIResponseDirectUnique & (STIMANAL.NeuronOrControl & 'neurons_or_control=1')) & key ,'*','ORDER BY photostim_group_num');
            group_list=[G.photostim_group_num];
            
            photostim_protocol =  fetch(IMG.PhotostimProtocol & key,'*');
            if ~isempty(photostim_protocol)
                timewind_response=[0.05,2];
%                 timewind_response=[0.05,1];

            else %default, only if protocol is missing
%                 timewind_response=[0.05,0.5];
                  timewind_response=[0.05,2];

            end
            time=(-frame_window_long(1):1:frame_window_long(2)-1)/frame_rate;
            
            %             time =[-3:1:3]./frame_rate;
            
            
            zoom =fetch1(IMG.FOVEpoch & key,'zoom');
            kkk.scanimage_zoom = zoom;
            pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_x') / fetch1(IMG.FOV & key, 'fov_x_size');
            
            %  distance_to_closest_neuron = distance_to_closest_neuron/pix2dist; % in pixels
            
            roi_list=fetchn(rel_roi,'roi_number','ORDER BY roi_number');
            roi_plane_num=fetchn(rel_roi,'plane_num','ORDER BY roi_number');
            roi_z=fetchn(rel_roi*IMG.ROIdepth,'z_pos_relative','ORDER BY roi_number');
            
            % to correct for ETL abberations
            R_x = fetchn(rel_roi_xy ,'roi_centroid_x_corrected','ORDER BY roi_number');
            R_y = fetchn(rel_roi_xy ,'roi_centroid_y_corrected','ORDER BY roi_number');
            
            try
                F_original = fetchn(rel_data ,'dff_trace','ORDER BY roi_number');
            catch
                F_original = fetchn(rel_data ,'spikes_trace','ORDER BY roi_number');
            end
            F_original=cell2mat(F_original);
            
            
            
            temp = fetch(IMG.Plane & key);
            key.fov_num =  temp.fov_num;
            key.plane_num =  1; % we will put the actual plane_num later
            key.channel_num =  temp.channel_num;
            
            %             if time_bin>0
            %                 bin_size_in_frame=ceil(time_bin*frame_rate);
            %                 bins_vector=1:bin_size_in_frame:size(F_original,2);
            %                 bins_vector=bins_vector(2:1:end);
            %                 for  i= 1:1:numel(bins_vector)
            %                     ix1=(bins_vector(i)-bin_size_in_frame):1:(bins_vector(i)-1);
            %                     F_binned(:,i)=mean(F_original(:,ix1),2);
            %                 end
            %                 time = time(1:bin_size_in_frame:end);
            %             else
            %                 F_binned=F_original;
            bin_size_in_frame=1;
            %             end
            
            %             F_binned = gpuArray((F_binned));
            %             F_binned = F_binned-mean(F_binned,2);
            F=zscore(F_original,[],2);
            %             [U,S,V]=svd(F_binned); % S time X neurons; % U time X time;  V neurons x neurons
            
            
            
            rel_all_sites=(IMG.PhotostimGroup& key);
            rel_all_sites=rel_all_sites* IMG.PhotostimGroupROI;
            
            allsites_num =(fetchn(rel_all_sites,'photostim_group_num','ORDER BY photostim_group_num')');
            allsites_center_x =(fetchn(rel_all_sites,'photostim_center_x','ORDER BY photostim_group_num')');
            allsites_center_y =(fetchn(rel_all_sites,'photostim_center_y','ORDER BY photostim_group_num')');
            
            allsites_photostim_frames =(fetchn(rel_all_sites,'photostim_start_frame','ORDER BY photostim_group_num')');
            allsites_photostim_frames_unique = unique(floor(cell2mat(allsites_photostim_frames)./bin_size_in_frame));
            
            
            
            parfor i_g = 1:1:numel(group_list) %parfor
                k1=key;
                k1.photostim_group_num = group_list(i_g);
                k1=rmfield(k1,'plane_num');
                %Response of the directly stimulated cell
                %--------------------------------------------------------------
                roi_number_target = fetch1( STIM.ROIResponseDirectUnique & k1,'roi_number');

                photostim_start_frame = fetch1(IMG.PhotostimGroup &  STIM.ROIResponseDirectUnique & k1,'photostim_start_frame');
                roi_number_direct_unique = fetch1(STIM.ROIResponseDirectUnique & k1,'roi_number');
                target_response_peak_mean = fetch1(STIM.ROIResponseDirectUnique & k1,'response_mean');
                target_response_p_value1 = fetch1(STIM.ROIResponseDirectUnique & k1,'response_p_value1');
                target_photostim_frames = fetch1(IMG.PhotostimGroup & k1,'photostim_start_frame');
                target_photostim_frames=floor(target_photostim_frames./bin_size_in_frame);
                
                f_trace_direct=F(roi_number_direct_unique,:);
                %         global_baseline=mean(movmin(f_trace_direct(i_epoch,:),1009));
                global_baseline=mean( f_trace_direct);
                
                timewind_baseline1 = [ -5 0];
                timewind_baseline2  = [-5 0] ;
                timewind_baseline3  = [ -5 0];
                [StimStat_direct,StimTrace_direct] = fn_compute_photostim_response_variability (f_trace_direct , photostim_start_frame, timewind_response, timewind_baseline1,timewind_baseline2,timewind_baseline3, flag_baseline_trial_or_avg, global_baseline, time);
                
                
                
                g_x = fetch1(IMG.PhotostimGroupROI & k1,'photostim_center_x');
                g_y = fetch1(IMG.PhotostimGroupROI & k1,'photostim_center_y');
                
                
                
                
                rel_connected_cells=STIM.ROIInfluenceDFF & 'response_p_value1<=0.05' & 'response_mean>0' & sprintf('response_distance_lateral_um >%.2f', min_distance_to_closest_target) & sprintf('num_of_target_trials_used >%d', minimal_number_of_clean_trials) & k1;
                CONNECTED = fetch(rel_connected_cells, 'roi_number','response_mean', 'response_p_value1','response_distance_lateral_um','response_distance_axial_um','response_distance_3d_um','num_of_target_trials_used', 'ORDER BY roi_number');
                roi_number_connected = [CONNECTED.roi_number];
                
                
                k_response = repmat(k1,numel(roi_number_connected),1);
                for i_r= 1:1:numel(roi_number_connected)
                    idx_roi_in_list = find(roi_list==roi_number_connected(i_r));
                    k_response(i_r).roi_number_target = roi_number_target;

                    k_response(i_r).roi_number = roi_number_connected(i_r);

                    k_response(i_r).plane_num = roi_plane_num(idx_roi_in_list);
                    f_trace=F(idx_roi_in_list,:);
                    
                    
                    % Excluding all frames during stimulation of other targets in the vicinity of the potentially connected cell
                    dx = allsites_center_x - R_x(idx_roi_in_list);
                    dy = allsites_center_y - R_y(idx_roi_in_list);
                    distance2D = sqrt(dx.^2 + dy.^2)*pix2dist; %
                    idx_allsites_near = distance2D<=distance_to_exclude_all   & ~ (allsites_num== group_list(i_g));
                    allsites_photostim_frames_near = cell2mat(allsites_photostim_frames(idx_allsites_near));
                    allsites_photostim_frames_near = unique(floor(allsites_photostim_frames_near./bin_size_in_frame));
                    %                         idx_allsites_far = distance2D>distance_to_exclude_all   & ~ (allsites_num== group_list(i_g));
                    %                         allsites_photostim_frames_far = cell2mat(allsites_photostim_frames(idx_allsites_far));
                    %                         allsites_photostim_frames_far = unique(floor(allsites_photostim_frames_far./bin_size_in_frame));
                    
                    % Finding baseline frames (not during target stimulation) that are not affected by stimulation of other targets in the vicinity in the vicinity of the potentially connected cell
                    baseline_frames_clean=allsites_photostim_frames_unique(~ismember(allsites_photostim_frames_unique, [allsites_photostim_frames_near-1, allsites_photostim_frames_near, allsites_photostim_frames_near+1]));
                    baseline_frames_clean=baseline_frames_clean(~ismember(baseline_frames_clean, [target_photostim_frames-1, target_photostim_frames, target_photostim_frames+1]));
                    
                    %                         if numel(baseline_frames_clean)<100
                    %                             baseline_frames_clean=allsites_photostim_frames_far;
                    %                             k_response(i_r).num_of_baseline_trials_used =  0;
                    %                         else
                    %                             k_response(i_r).num_of_baseline_trials_used =  numel(baseline_frames_clean);
                    %                         end
                    %                         if numel(baseline_frames_clean)>3
                    %                             baseline_frames_clean(1)=[];
                    %                             baseline_frames_clean(end)=[];
                    %                         end
                    
                    % Finding frames during target stimulation that are not affected by stimulation of other targets in the vicinity of the potentially connected cells
                    target_photostim_frames_clean=target_photostim_frames(~ismember(target_photostim_frames, [allsites_photostim_frames_near-1, allsites_photostim_frames_near, allsites_photostim_frames_near+1]));
                    
                    if numel(target_photostim_frames_clean)<minimal_number_of_clean_trials % if there are too few trials, we don't analyze this pair. We don't suppose to get any such pairs because we include only pairs with more trials then minimal_number_of_clean_trials
                        target_photostim_frames_clean=target_photostim_frames;
%                         k_response(i_r).num_of_target_trials_used =  0;
                    else
%                         k_response(i_r).num_of_target_trials_used =  numel(target_photostim_frames_clean);
                    end
                    legit_trials_index = ismember(target_photostim_frames,target_photostim_frames_clean);
                    
                    dx = g_x - R_x(idx_roi_in_list);
                    dy = g_y - R_y(idx_roi_in_list);
                    distance2D = sqrt(dx.^2 + dy.^2); %pixels
                    distance3D = sqrt( (dx*pix2dist).^2 + (dy*pix2dist).^2 + roi_z(idx_roi_in_list).^2); %um
                    
                    %                         i_r
                    %                         single(distance2D*pix2dist)
%                     k_response(i_r).response_distance_lateral_um = single(distance2D*pix2dist);
%                     k_response(i_r).response_distance_axial_um = single(roi_z(idx_roi_in_list));
%                     k_response(i_r).response_distance_3d_um = single(distance3D);

                    
                    %Response of the connected neuron
                    %----------------------------------------------------------------------------------------------------
                    [StimStat_connected StimTrace_connected] = fn_compute_photostim_delta_influence5_single_trials (f_trace, target_photostim_frames_clean,baseline_frames_clean, timewind_response, time);
                    
%                     k_response(i_r).target_response_peak_mean =target_response_peak_mean;
                    k_response(i_r).target_response_p_value1 =target_response_p_value1;
                    k_response(i_r).target_response_trace_mean = smooth(StimTrace_direct.response_trace_mean,3)';
%                     k_response(i_r).target_response_trace_trials =StimTrace_direct.response_trace_trials;
                    
                    k_response(i_r).connected_response_trace_mean = smooth(StimTrace_connected.response_trace_mean,3)';
%                     k_response(i_r).connected_response_trace_trials =StimTrace_connected.response_trace_trials;
                    k_response(i_r).connected_response_p_value1 = CONNECTED(i_r).response_p_value1;
                    k_response(i_r).connected_response_peak_mean = CONNECTED(i_r).response_mean;
                    k_response(i_r).connected_distance_lateral_um = CONNECTED(i_r).response_distance_lateral_um;
                    k_response(i_r).connected_distance_axial_um = CONNECTED(i_r).response_distance_axial_um;
                    k_response(i_r).connected_distance_3d_um = CONNECTED(i_r).response_distance_3d_um;

%                     k_response(i_r).legit_trials_index =legit_trials_index;
                    k_response(i_r).time_vector =time;
                end
                if numel(roi_number_connected>0)
                    insert(self, k_response);
                end
            end
        end
    end
end

