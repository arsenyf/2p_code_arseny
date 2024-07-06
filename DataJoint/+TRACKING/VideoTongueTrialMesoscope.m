%{
# units are in mm, deg, and seconds. This code parse tongue trajectory into individual licks. It also populates trajectories of other body parts
-> EXP2.BehaviorTrial
---

licks_peak_x = null            : blob              # tongue Medio-Lateral coordinate at the peak of the lick, relative to midline. Left negative, Right positive. Measured based on tongue center
licks_peak_y1 = null           : blob              # tongue Anterior-Posterior coordinate at the peak of the lick. Positive is forward. Measured based on tongue tip
licks_peak_y2 = null           : blob              # tongue Anterior-Posterior coordinate at the peak of the lick. Positive is forward. Measured based on tongue center
licks_peak_z = null            : blob              # tongue Dorso-Ventral coordinate at the peak of the lick. Positive is downwards. Measured based on tongue tip
licks_peak_yaw = null          : blob              # tongue yaw at the peak of the lick. Left negative, Right positive


licks_touch_x = null            : blob              # tongue Medio-Lateral coordinate during electric touch, relative to midline. Left negative, Right positive. Measured based on tongue center
licks_touch_y1 = null           : blob              # tongue Anterior-Posterior coordinate during electric touch. Positive is forward. Measured based on tongue tip
licks_touch_y2 = null           : blob              # tongue Anterior-Posterior coordinate during electric touch. Positive is forward. Measured based on tongue center
licks_touch_z = null            : blob              # tongue Dorso-Ventral coordinate during electric touch. Positive is downwards. Measured based on tongue tip
licks_touch_yaw = null          : blob              # tongue yaw during electric touch. Left negative, Right positive


licks_yaw_lickbout_avg = null           : blob              # median tongue yaw during the entire outbound lick, i.e. from onset to peak

licks_vel_x_lickbout_avg = null         : blob              # median tongue linear velocity during the entire outbound lick, i.e. from onset to peak
licks_vel_y1_lickbout_avg = null        : blob              # median tongue angular velocity during the entire outbound lick, i.e. from onset to peak
licks_vel_y2_lickbout_avg = null        : blob              # median tongue angular velocity during the entire outbound lick, i.e. from onset to peak
licks_vel_z_lickbout_avg = null         : blob              # median tongue angular velocity during the entire outbound lick, i.e. from onset to peak

licks_time_onset = null        : blob              # lick onset time, lick onset time, relative to Go cue/ or movinglickport entrance in case lickport is moving
licks_time_peak = null         : blob              # lick peak time, lick onset time, relative to Go cue/ or movinglickport entrance in case lickport is moving
licks_duration_total = null    : blob              # time from onset to end, i.e. complete retraction
licks_time_electric = null     : blob              # timings of electric lick port detection, lick onset time, relative to Go cue/ or movinglickport entrance in case lickport is moving

licks_delta_x = null          : blob               # maximal change in the tongue coordinate during the lick
licks_delta_y1 = null         : blob               # maximal change in the tongue coordinate during the lick
licks_delta_y2 = null         : blob               # maximal change in the tongue coordinate during the lick
licks_delta_z = null          : blob               # maximal change in the tongue coordinate during the lick


%}

classdef VideoTongueTrialMesoscope < dj.Computed
    properties
        keySource = (EXP2.Session  & TRACKING.VideoFiducialsTrial & IMG.Mesoscope) ;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            % Rig specific settings
            %--------------------------------------------------------------
            k_camera1.tracking_device_id = 3; %side camera
            k_camera2.tracking_device_id = 4; %bottom (or top/front) camera
            side_camera_facing = 'left'; %'left' or 'right' mouse-facing direction as seen from the side view camera
            bottom_or_front_camera_facing = 'up'; %'up' or 'down' mouse-facing direction as seen from the front/bottom view camera
            % For the Mesoscope (Camera tracking_device_id =4, front) we set mouse-facing direction to 'up', because after intital clockwise 90 rotation in TRACKING.VideoFiducialsTrial the mouse appears to face 'up'
            reverse_cam2_x = -1; % '-1' left/right flip along the midline' '1' - no flip
            
            camera1_pixels_to_mm = 1; %% UPDATE
            camera2_pixels_to_mm=1; %% UPDATE
            flag_moving_lickport = 1; % 1 in case of moving lickport, 0 othewise. In case of moving lickport time would be aligned to moving lickport onset, otherwise to Go cue
            
            % Analysis Parameters
            %--------------------------------------------------------------
            flag_plot=1;
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\video_tracking\'];
            
            p_threshold =0.99999;
            MinPeakInterval=0.075; %minimal time interval between peaks (licks) in time (seconds)
            MinPeakProminence=5; %pixels
            tinterval_lickport_lickable =[0.5 1.5]; % (s) time interval in which we expect to see the lickport in lickable position (in case its a moving lickport). It doesn't have to be the full time interval
            smooth_velocity_frames = 3; %smoothing the trajectory for velocity calculation
            smooth_interpolation_frames=3; % we use it to interpolate between missing frames,  typically 1 missing frame due to occlusion. We use it only to measure values at peak of the lick
            smooth_window_whiskers=3; %whiskers detection is noisy, and we therefore smooth it
            
            %grooming detection, based on side view camera
            grooming_x_threshold =0; %if paws are in the specified by quandrant location grooming_x_threshold, grooming_y_threshold we will consider it to be a grooming frame
            grooming_y_threshold =50;
            minimal_num_grooming_frames=25; %if there are more than this number of grooming frames, this trial would be considered as grooming trial
            
            %-------------------------------------------------------------------------------------------------------------
            
            
            % Graphics for plotting
            close all;
            if flag_plot==1
                figure1=figure("Visible",false);
                set(gcf,'DefaultAxesFontName','helvetica');
                set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
                set(gcf,'PaperOrientation','portrait');
                set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
            end
            
            panel_width1=0.3;
            panel_height1=0.065;
            
            panel_width2=0.14;
            panel_height2=0.15;
            
            horizontal_distance1=0.4;
            vertical_distance1=0.10;
            
            horizontal_distance2=0.18;
            vertical_distance2=0.25;
            
            position_x1(1)=0.07;
            position_x1(2)=position_x1(1)+horizontal_distance1;
            
            position_y1(1)=0.85;
            position_y1(2)=position_y1(1)-vertical_distance1;
            position_y1(3)=position_y1(2)-vertical_distance1;
            position_y1(4)=position_y1(3)-vertical_distance1;
            position_y1(5)=position_y1(4)-vertical_distance1;
            position_y1(6)=position_y1(5)-vertical_distance1;
            position_y1(7)=position_y1(6)-vertical_distance1;
            position_y1(8)=position_y1(7)-vertical_distance1;
            position_y1(9)=position_y1(8)-vertical_distance1;
            
            position_x2(1)=0.42;
            position_x2(2)=position_x2(1)+horizontal_distance2;
            position_x2(3)=position_x2(2)+horizontal_distance2;
            
            position_y2(1)=0.8;
            position_y2(2)=position_y2(1)-vertical_distance2;
            position_y2(3)=position_y2(2)-vertical_distance2;
            position_y2(4)=position_y2(3)-vertical_distance2;
            position_y2(5)=position_y2(4)-vertical_distance2;
            position_y2(6)=position_y2(5)-vertical_distance2;
            
            %% Fetching trial and camera information
            rel_behavior_trial = (EXP2.BehaviorTrialEvent & key & 'trial_event_type="go"') - TRACKING.TrackingTrialBad ;
            rel_video_trial = (TRACKING.TrackingTrial & key & k_camera1) - TRACKING.TrackingTrialBad ;
            
            if rel_video_trial.count==0
                return
            end
            
            rel_fiducials_trial_cam1 = (TRACKING.VideoFiducialsTrial & key & k_camera1) - TRACKING.TrackingTrialBad ;
            rel_fiducials_session_cam1 =(TRACKING.VideoFiducialsSessionAvg & key & k_camera1);
            
            rel_fiducials_trial_cam2 = (TRACKING.VideoFiducialsTrial & key & k_camera2) - TRACKING.TrackingTrialBad ;
            rel_fiducials_session_cam2 =(TRACKING.VideoFiducialsSessionAvg & key & k_camera2);
            
            
            time_go = fetchn(rel_behavior_trial ,'trial_event_time','ORDER BY trial'); %relative to trial start
            tracking_start_time = fetchn(rel_video_trial ,'tracking_start_time','ORDER BY trial'); % relative to trial start
            num_frames = fetchn(rel_video_trial ,'tracking_num_samples','ORDER BY trial');
            tracking_datafile_num = fetchn(rel_video_trial ,'tracking_datafile_num','ORDER BY trial');
            tracking_datafile_path = fetchn(rel_video_trial ,'tracking_datafile_path','ORDER BY trial');
            
            trials = fetchn(rel_behavior_trial ,'trial','ORDER BY trial'); %relative to trial start
            frame_rate = fetch1(rel_video_trial ,'tracking_sampling_rate','LIMIT 1');
            
            MinPeakInterval = MinPeakInterval*frame_rate;
            
            %% Fiducial Tongue
            num=1;
            k.video_fiducial_name='TongueTip'; %from Camera1
            switch side_camera_facing
                case 'left'
                    offset_cam1_x =  fetchn(rel_fiducials_session_cam1& k,'fiduical_x_max_session');
                    reverse_cam1_x  = -1 ; %reverse
                case 'right'
                    offset_cam1_x =  fetchn(rel_fiducials_session_cam1& k,'fiduical_x_min_session');
                    reverse_cam1_x  = 1; % no reverse
            end
            offset_cam1_y =  fetchn(rel_fiducials_session_cam1 & k,'fiduical_y_min_session');
            reverse_cam1_y=1; % no reverse
            
            
            num=2;
            k.video_fiducial_name='TongueTip'; %from Camera2
            offset_cam2_x =  fetchn(rel_fiducials_session_cam2 & k,'fiduical_x_median_session');
            switch bottom_or_front_camera_facing
                case 'up'
                    offset_cam2_y =  fetchn(rel_fiducials_session_cam2& k,'fiduical_y_max_session');
                    reverse_cam2_y = -1 ; %reverse
                case 'down'
                    offset_cam2_y =  fetchn(rel_fiducials_session_cam2& k,'fiduical_y_min_session');
                    reverse_cam2_y = 1 ; % no reverse
            end
            fSession=[];
            fTrial=[];
            
            
            %Camera 1
            num=0;
            
            camera_num = 1;
            fiducial_names = fetchn(TRACKING.VideoFiducialsType & k_camera1,'video_fiducial_name');
            for i_f = 1:1:numel(fiducial_names)
                num = num+1;
                k.video_fiducial_name = fiducial_names{i_f};
                [fSession,fTrial] = fn_TRACKING_extract_and_center_fiducials (fSession, fTrial, rel_fiducials_session_cam1, rel_fiducials_trial_cam1, k, num, offset_cam1_x, offset_cam1_y, reverse_cam1_x, reverse_cam1_y,camera_num, camera1_pixels_to_mm, p_threshold);
            end
            
            %Camera 2
            camera_num = 2;
            fiducial_names = fetchn(TRACKING.VideoFiducialsType & k_camera2,'video_fiducial_name');
            for i_f = 1:1:numel(fiducial_names)
                num = num+1;
                k.video_fiducial_name = fiducial_names{i_f};
                [fSession,fTrial] = fn_TRACKING_extract_and_center_fiducials (fSession, fTrial, rel_fiducials_session_cam2, rel_fiducials_trial_cam2, k, num, offset_cam2_x, offset_cam2_y, reverse_cam2_x, reverse_cam2_y,camera_num, camera2_pixels_to_mm, p_threshold);
            end
            
            
            
            
            %% Looping over individual trials
            % Number of trials, filenames etc.
            key.session_date=fetch1(EXP2.Session & key,'session_date');
            insert_key_grooming=[];
            insert_key_lickport = [];
            insert_key_trajectory_tongue = [];
            insert_key_trajectory_whiskers= [];
            insert_key_trajectory_PawLeft= [];
            insert_key_trajectory_PawRight= [];
            insert_key_trajectory_NOSE=[];
            insert_key_trajectory_JAW=[];
            insert_key_lickport_position=[];
            
            for ii =1:1:numel(trials)
                
                
                insert_key_licks(ii).subject_id = key.subject_id;
                insert_key_licks(ii).session = key.session;
                insert_key_licks(ii).trial = trials(ii);
                
                % time vector
                t_relative_trial_start = [0:(1/frame_rate): (num_frames(ii)-1)/frame_rate] + tracking_start_time(ii);
                t  =t_relative_trial_start- time_go(ii); % relative to Go cue. We will set it later relative to lickport move onset, in case of moving lickport
                
                
                %% Extracting lickport entrance/exit timing, in case there was a moving lickport
                if flag_moving_lickport ==1
                    time_label = 'Time from Lickport move (s)';
                    num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','lickport')');
                    LICKPORT_AP_Cam1 = fTrial(num1).x{ii};
                    LICKPORT_Z_Cam1 = fTrial(num1).y{ii};
                    
                    
                    LICKPORT_Z_Cam1_smoothed = smooth(LICKPORT_Z_Cam1,5); % we smooth only for estimation of tongue entrance/exit timing
                    
                    
                    num2=find([fTrial.camera]==2 & strcmp({fTrial.label}','lickport')');
                    LICKPORT_ML_Cam2 = fTrial(num2).x{ii};
                    LICKPORT_AP_Cam2 = fTrial(num2).y{ii};
                    
                    idx_lickport_in = t>=tinterval_lickport_lickable(1) & t<tinterval_lickport_lickable(2);
                    Z_lickport_in  = nanmedian(LICKPORT_Z_Cam1_smoothed(idx_lickport_in));
                    Z_lickport_before  = nanmedian(LICKPORT_Z_Cam1_smoothed(t<0));
                    %                 y_lickport_end  = nanmedian(y(end-100:end));
                    
                    idx_lickport_t_entrance_start = find(LICKPORT_Z_Cam1_smoothed(t>0) < (Z_lickport_before -(Z_lickport_before - Z_lickport_in)*0.2),1,'first') + find(t>0,1,'first')-1;
                    idx_lickport_t_entrance_end = find(LICKPORT_Z_Cam1_smoothed(t>0)< (Z_lickport_in +(Z_lickport_before - Z_lickport_in)*0.2),1,'first') + find(t>0,1,'first')-1;
                    idx_lickport_t_exit_start = find(LICKPORT_Z_Cam1_smoothed(t>1)> (Z_lickport_in +(Z_lickport_before - Z_lickport_in)*0.2),1,'first') + find(t>1,1,'first');
                    idx_lickport_t_exit_end = find(LICKPORT_Z_Cam1_smoothed(t>1)> (Z_lickport_before -(Z_lickport_before - Z_lickport_in)*0.2),1,'first') + + find(t>1,1,'first');
                    
                    lickport_t_entrance_avg = nanmean([t(idx_lickport_t_entrance_start);t(idx_lickport_t_entrance_end)]);
                    
                    insert_key_lickport(ii).subject_id = key.subject_id;
                    insert_key_lickport(ii).session = key.session;
                    insert_key_lickport(ii).trial = trials(ii);
                    insert_key_lickport(ii).lickport_t_entrance = lickport_t_entrance_avg;
                    insert_key_lickport(ii).lickport_t_entrance_relative_to_trial_start = lickport_t_entrance_avg + time_go(ii);
                    insert_key_lickport(ii).lickport_t_entrance_start = t(idx_lickport_t_entrance_start);
                    insert_key_lickport(ii).lickport_t_entrance_end = t(idx_lickport_t_entrance_end);
                    
                    insert_key_lickport(ii).lickport_lickable_duration =    nanmean([t(idx_lickport_t_exit_start);t(idx_lickport_t_exit_end)]) - lickport_t_entrance_avg;
                else
                    lickport_t_entrance_avg=0;
                    time_label = 'Time from Go cue (s)';
                end
                
                
                idx_lickport_lickable = idx_lickport_t_entrance_start:1:idx_lickport_t_exit_start;
                
                %% Lickport averge positon
                insert_key_lickport_position (ii).subject_id = key.subject_id;
                insert_key_lickport_position(ii).session = key.session;
                insert_key_lickport_position(ii).trial = trials(ii);
                insert_key_lickport_position(ii).lickport_x = nanmedian(LICKPORT_ML_Cam2(idx_lickport_lickable));
                insert_key_lickport_position(ii).lickport_y1 = nanmedian(LICKPORT_AP_Cam1(idx_lickport_lickable));
                insert_key_lickport_position(ii).lickport_y2 = nanmedian(LICKPORT_AP_Cam2(idx_lickport_lickable));
                insert_key_lickport_position(ii).lickport_z = nanmedian(LICKPORT_Z_Cam1(idx_lickport_lickable));
                
                
                LICKPORT_Z_Cam1_mean(ii) = nanmedian(LICKPORT_Z_Cam1(idx_lickport_lickable));
                LICKPORT_AP_Cam1_mean(ii) = nanmedian(LICKPORT_AP_Cam1(idx_lickport_lickable));
                LICKPORT_ML_Cam2_mean(ii) = nanmedian(LICKPORT_ML_Cam2(idx_lickport_lickable));
                LICKPORT_AP_Cam2_mean(ii) = nanmedian(LICKPORT_AP_Cam2(idx_lickport_lickable));
                
                
                
                
                % Extracting lick times based on electric lick port
                k.trial=trials(ii);
                licks_time_electric = [sort(fetchn(EXP2.BehaviorTrial * EXP2.ActionEvent * EXP2.Session & key & k,'action_event_time'))-time_go(ii)]'  - lickport_t_entrance_avg; %relative to Go cue or to moving lickport onset, in case of moving lickport
                
                % defining time 0 relative to lickport move onset, in case of moving lickport
                t= t - lickport_t_entrance_avg;
                
                
                
                
                %% Extracting Whiskers based on Camera0 (side view)
                % We do it based on average of three fiducials, corresponding to thee whiskers( anterior, medial, and posterior whiskers)
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','W1')');
                WHISKERS_idx_P_f1 = fTrial(num1).p{ii}>=p_threshold;
                num2=find([fTrial.camera]==1 & strcmp({fTrial.label}','W2')');
                WHISKERS_idx_P_f2 = fTrial(num2).p{ii}>=p_threshold;
                num3=find([fTrial.camera]==1 & strcmp({fTrial.label}','W3')');
                WHISKERS_idx_P_f3 = fTrial(num3).p{ii}>=p_threshold;
                
                WHISKERS_idx_P = WHISKERS_idx_P_f1 & WHISKERS_idx_P_f2 & WHISKERS_idx_P_f3;
                
                WHISKERS_AP_Cam1 = nanmean([fTrial(num1).x{ii}'; fTrial(num2).x{ii}';fTrial(num3).x{ii}']);
                WHISKERS_AP_Cam1(~WHISKERS_idx_P)=NaN;
                WHISKERS_AP_Cam1=smooth(WHISKERS_AP_Cam1,smooth_window_whiskers);
                WHISKERS_AP_Cam1(~WHISKERS_idx_P)=NaN;
                
                WHISKERS_Z_Cam1 = nanmean([fTrial(num1).y{ii}'; fTrial(num2).y{ii}';fTrial(num3).y{ii}']);
                WHISKERS_Z_Cam1(~WHISKERS_idx_P)=NaN;
                WHISKERS_Z_Cam1=smooth(WHISKERS_Z_Cam1,smooth_window_whiskers);
                WHISKERS_Z_Cam1(~WHISKERS_idx_P)=NaN;
                
                % populating bodypart trajectory for the whiskers
                insert_key_trajectory_whiskers (ii).subject_id = key.subject_id;
                insert_key_trajectory_whiskers(ii).session = key.session;
                insert_key_trajectory_whiskers(ii).trial = trials(ii);
                insert_key_trajectory_whiskers(ii).bodypart_name= 'whiskers';
                insert_key_trajectory_whiskers(ii).traj_x = NaN;
                insert_key_trajectory_whiskers(ii).traj_y1 = WHISKERS_AP_Cam1;
                insert_key_trajectory_whiskers(ii).traj_y2 = NaN;
                insert_key_trajectory_whiskers(ii).traj_z = WHISKERS_Z_Cam1;
                insert_key_trajectory_whiskers(ii).time_first_frame = t(1);
                
                
                %% Extracting Left Front Paw
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawL')');
                idx_P = fTrial(num1).p{ii}>=p_threshold;
                PAWleft_AP_Cam1 = [fTrial(num1).x{ii}];
                PAWleft_AP_Cam1(~idx_P)=NaN;
                PAWleft_Z_Cam1 = [fTrial(num1).y{ii}];
                PAWleft_Z_Cam1(~idx_P)=NaN;
                
                num2=find([fTrial.camera]==2 & strcmp({fTrial.label}','PawL')');
                idx_P = fTrial(num2).p{ii}>=p_threshold;
                PAWleft_ML_Cam2= [fTrial(num2).x{ii}];
                PAWleft_ML_Cam2(~idx_P)=NaN;
                PAWleft_AP_Cam2= [fTrial(num2).y{ii}];
                PAWleft_AP_Cam2(~idx_P)=NaN;
                
                % populating bodypart trajectory for the whiskers
                insert_key_trajectory_PawLeft (ii).subject_id = key.subject_id;
                insert_key_trajectory_PawLeft(ii).session = key.session;
                insert_key_trajectory_PawLeft(ii).trial = trials(ii);
                insert_key_trajectory_PawLeft(ii).bodypart_name= 'pawfrontleft';
                insert_key_trajectory_PawLeft(ii).traj_x = PAWleft_ML_Cam2;
                insert_key_trajectory_PawLeft(ii).traj_y1 = PAWleft_AP_Cam1;
                insert_key_trajectory_PawLeft(ii).traj_y2 = PAWleft_AP_Cam2;
                insert_key_trajectory_PawLeft(ii).traj_z = PAWleft_Z_Cam1;
                insert_key_trajectory_PawLeft(ii).time_first_frame = t(1);
                
                %% Extracting Right Front Paw
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawR')');
                idx_P = fTrial(num1).p{ii}>=p_threshold;
                PAWright_AP_Cam1 = [fTrial(num1).x{ii}];
                PAWright_AP_Cam1(~idx_P)=NaN;
                PAWright_Z_Cam1 = [fTrial(num1).y{ii}];
                PAWright_Z_Cam1(~idx_P)=NaN;
                
                num2=find([fTrial.camera]==2 & strcmp({fTrial.label}','PawR')');
                idx_P = fTrial(num2).p{ii}>=p_threshold;
                PAWright_ML_Cam2= [fTrial(num2).x{ii}];
                PAWright_ML_Cam2(~idx_P)=NaN;
                PAWright_AP_Cam2= [fTrial(num2).y{ii}];
                PAWright_AP_Cam2(~idx_P)=NaN;
                
                % populating bodypart trajectory for the whiskers
                insert_key_trajectory_PawRight (ii).subject_id = key.subject_id;
                insert_key_trajectory_PawRight(ii).session = key.session;
                insert_key_trajectory_PawRight(ii).trial = trials(ii);
                insert_key_trajectory_PawRight(ii).bodypart_name= 'pawfrontright';
                insert_key_trajectory_PawRight(ii).traj_x = PAWright_ML_Cam2;
                insert_key_trajectory_PawRight(ii).traj_y1 = PAWright_AP_Cam1;
                insert_key_trajectory_PawRight(ii).traj_y2 = PAWright_AP_Cam2;
                insert_key_trajectory_PawRight(ii).traj_z = PAWright_Z_Cam1;
                insert_key_trajectory_PawRight(ii).time_first_frame = t(1);
                
                
                %% Finding if there was grooming during the trial, based on side view
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawL')');
                num2=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawR')');
                num_grooming_frames=  sum((fTrial(num1).x{ii}>grooming_x_threshold & fTrial(num1).y{ii}<grooming_y_threshold)   | (fTrial(num2).x{ii}>grooming_x_threshold & fTrial(num2).y{ii}<grooming_y_threshold));
                if  num_grooming_frames> minimal_num_grooming_frames
                    counter = numel(insert_key_grooming)+1;
                    insert_key_grooming(counter).subject_id = key.subject_id;
                    insert_key_grooming(counter).session = key.session;
                    insert_key_grooming(counter).trial = trials(ii);
                end
                
                
                
                
                %% Extracting nose
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','nosetip')');
                NOSE_idx_P_Cam1 = fTrial(num1).p{ii}>=p_threshold;
                
                NOSE_AP_Cam1 = [fTrial(num1).x{ii}];
                NOSE_AP_Cam1(~NOSE_idx_P_Cam1)=NaN;
                
                NOSE_Z_Cam1 = [fTrial(num1).y{ii}];
                NOSE_Z_Cam1(~NOSE_idx_P_Cam1)=NaN;
                
                % populating bodypart trajectory for the whiskers
                insert_key_trajectory_NOSE (ii).subject_id = key.subject_id;
                insert_key_trajectory_NOSE(ii).session = key.session;
                insert_key_trajectory_NOSE(ii).trial = trials(ii);
                insert_key_trajectory_NOSE(ii).bodypart_name= 'nose';
                insert_key_trajectory_NOSE(ii).traj_x = NaN;
                insert_key_trajectory_NOSE(ii).traj_y1 = NOSE_AP_Cam1;
                insert_key_trajectory_NOSE(ii).traj_y2 = NaN;
                insert_key_trajectory_NOSE(ii).traj_z = NOSE_Z_Cam1;
                insert_key_trajectory_NOSE(ii).time_first_frame = t(1);
                
                
                
                
                %% Extracting jaw
                num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','jaw')');
                JAW_idx_P_Cam1 = fTrial(num1).p{ii}>=p_threshold;
                
                JAW_AP_Cam1 = [fTrial(num1).x{ii}];
                JAW_AP_Cam1(~JAW_idx_P_Cam1)=NaN;
                
                JAW_Z_Cam1 = [fTrial(num1).y{ii}];
                JAW_Z_Cam1(~JAW_idx_P_Cam1)=NaN;
                
                % populating bodypart trajectory for the whiskers
                insert_key_trajectory_JAW (ii).subject_id = key.subject_id;
                insert_key_trajectory_JAW(ii).session = key.session;
                insert_key_trajectory_JAW(ii).trial = trials(ii);
                insert_key_trajectory_JAW(ii).bodypart_name= 'jaw';
                insert_key_trajectory_JAW(ii).traj_x = NaN;
                insert_key_trajectory_JAW(ii).traj_y1 = JAW_AP_Cam1;
                insert_key_trajectory_JAW(ii).traj_y2 = NaN;
                insert_key_trajectory_JAW(ii).traj_z = JAW_Z_Cam1;
                insert_key_trajectory_JAW(ii).time_first_frame = t(1);
                
                
                
                %% Extracting tongue coordinates
                % Extracting coordinates based on Camera1 (side view)
                num=find([fTrial.camera]==1 & strcmp({fTrial.label}','TongueTip')');
                TONGUE_idx_P_Cam1 = fTrial(num).p{ii}>=p_threshold;
                TONGUE_AP_Cam1= fTrial(num).x{ii}';
                TONGUE_Z_Cam1 = fTrial(num).y{ii}';
                
                
                % Extracting coordinates based on Camera2 (bottom/top view)
                % We do it based on average of two fiducials, corresponding to the right and left edges of the tongue, and only if both are seen
                num1=find([fTrial.camera]==2 & strcmp({fTrial.label}','LFtongue')');
                TONGUE_idx_P_Cam2_f1 = fTrial(num1).p{ii}>=p_threshold;
                
                num2=find([fTrial.camera]==2 & strcmp({fTrial.label}','RFtongue')');
                TONGUE_idx_P_Cam2_f2 = fTrial(num2).p{ii}>=p_threshold;
                
                TONGUE_idx_P_Cam2 = TONGUE_idx_P_Cam2_f1 & TONGUE_idx_P_Cam2_f2;
                TONGUE_ML_Cam2= nanmean([fTrial(num1).x{ii}'; fTrial(num2).x{ii}']);
                TONGUE_AP_Cam2 = nanmean([fTrial(num1).y{ii}'; fTrial(num2).y{ii}']);
                
                
                
                % Setting frames in which the tongue was not seen to NaN,
                % its also done in fn_TRACKING_extract_and_center_fiducials for every fiducial
                TONGUE_AP_Cam1(~TONGUE_idx_P_Cam1)=NaN;
                TONGUE_Z_Cam1(~TONGUE_idx_P_Cam1)=NaN;
                
                TONGUE_ML_Cam2(~TONGUE_idx_P_Cam2 | ~TONGUE_idx_P_Cam1)=NaN;
                TONGUE_AP_Cam2(~TONGUE_idx_P_Cam2 | ~TONGUE_idx_P_Cam1)=NaN;
                
                
                %  %For debug
                %                 hold on
                %                 plot(t,TONGUE_AP_Cam1,'-b')
                %                 plot(t,TONGUE_Z_Cam1,'-g')
                %                 plot(t,TONGUE_AP_Cam2,'-c')
                %                 plot(t,TONGUE_ML_Cam2,'-r')
                
                % Computing trajectory kinematics based on video finding tongue angle, amplitude and vel
                [tongue_yaw, ~] = cart2pol(TONGUE_ML_Cam2,TONGUE_AP_Cam2);
                tongue_yaw=rad2deg(tongue_yaw)-90;
                tongue_vel_x = [0,diff(smoothdata(TONGUE_ML_Cam2,'gaussian',smooth_velocity_frames,'omitnan'))];
                tongue_vel_y1 = [0,diff(smoothdata(TONGUE_AP_Cam1,'gaussian',smooth_velocity_frames,'omitnan'))];
                tongue_vel_y2 = [0,diff(smoothdata(TONGUE_AP_Cam2,'gaussian',smooth_velocity_frames,'omitnan'))];
                tongue_vel_z = [0,diff(smoothdata(TONGUE_Z_Cam1,'gaussian',smooth_velocity_frames,'omitnan'))];
                
                
                % populating bodypart trajectory for the tongue
                insert_key_trajectory_tongue (ii).subject_id = key.subject_id;
                insert_key_trajectory_tongue(ii).session = key.session;
                insert_key_trajectory_tongue(ii).trial = trials(ii);
                insert_key_trajectory_tongue(ii).bodypart_name= 'tongue';
                insert_key_trajectory_tongue(ii).traj_x = TONGUE_ML_Cam2;
                insert_key_trajectory_tongue(ii).traj_y1 = TONGUE_AP_Cam1;
                insert_key_trajectory_tongue(ii).traj_y2 = TONGUE_AP_Cam2;
                insert_key_trajectory_tongue(ii).traj_z = TONGUE_Z_Cam1;
                insert_key_trajectory_tongue(ii).time_first_frame = t(1);
                
                
                
                
                
                %% Parsing trajectory into individual licks bouts, only in case there were licks
                
                % Finding peak of individual lick bouts
                xxx = TONGUE_Z_Cam1;
                xxx(isnan(TONGUE_Z_Cam1))=0;
                [~,idx_licks_peak, halfwidth] = findpeaks(xxx, 'MinPeakDistance',MinPeakInterval,'MinPeakProminence',MinPeakProminence,'WidthReference','halfheight');
                idx_licks_peak(halfwidth==1)=[]; % remove if peak is too narrow (i.e. the lick was too short)
                
                % Finding onset of individual lick bouts
                idx_licks_onset=[];
                for ip = 1:1:numel(idx_licks_peak)
                    temp  = find(isnan(TONGUE_Z_Cam1(1:idx_licks_peak(ip))),1,'last') +1;
                    if isempty(temp)
                        idx_licks_onset(ip)=1;
                    else
                        idx_licks_onset(ip) = temp;
                    end
                end
                
                idx_too_short =  (idx_licks_peak==idx_licks_onset); % remove if peak is too narrow
                idx_licks_peak(idx_too_short)=[];
                idx_licks_onset(idx_too_short)=[];
                
                idx_same_onset = find(diff(idx_licks_onset)==0) +1; % in case the tongue was not fully inserted back into the mouth in between licks
                for io = 1:1:numel(idx_same_onset)
                    [~,idx_temp_min]= min(TONGUE_Z_Cam1(idx_licks_peak(idx_same_onset(io)-1):idx_licks_peak(idx_same_onset(io))));
                    idx_licks_onset(idx_same_onset(io)) = idx_licks_peak(idx_same_onset(io)-1) +idx_temp_min;
                end
                
                
                
                if isempty(idx_licks_peak) % in case there were no licks
                    continue;
                end
                
                
                % Finding the end of individual lick bouts
                idx_licks_end=[];
                for ip = 1:1:numel(idx_licks_peak)
                    temp  = find(isnan(TONGUE_Z_Cam1(idx_licks_peak(ip):end)),1,'first') + idx_licks_peak(ip) -2;
                    if isempty(temp)
                        idx_licks_end(ip)=numel(TONGUE_Z_Cam1);
                    else
                        idx_licks_end(ip) = temp;
                    end
                end
                
                
                idx_same_end = find(diff(idx_licks_end)==0); % in case the tongue was not fully inserted back into the mouth in between licks
                for ie = 1:1:numel(idx_same_end)
                    idx_licks_end(idx_same_end(ie)) = idx_licks_onset(idx_same_end(ie)+1) -1;
                end
                
                
                idx_noearly_licks= (t(idx_licks_onset)>0);
                
                
                %% Lick timings
                %----------------------------------------------------------
                licks_time_onset = t(idx_licks_onset)';
                licks_time_peak =  t(idx_licks_peak)';
                licks_duration_total = t(idx_licks_end)' - t(idx_licks_onset)';
                
                
                %% Angle and velocity averaged (median) for the entire outbound lick trajectory, i.e. from onset to peak
                % also maximal change in tongue coordinates during each lick (from onset to full retraction)
                %----------------------------------------------------------
                licks_yaw_avg=[];
                licks_vel_x_avg=[];
                licks_vel_y1_avg=[];
                licks_vel_y2_avg=[];
                licks_vel_z_avg=[];
                licks_delta_x=[];
                licks_delta_y1=[];
                licks_delta_y2=[];
                licks_delta_z=[];
                
                for ll=1:1:numel(idx_licks_peak)
                    idx_outbound_lick=idx_licks_onset(ll):idx_licks_peak(ll);
                    idx_full_lick=idx_licks_onset(ll):idx_licks_end(ll);
                    
                    licks_yaw_avg(ll)=nanmedian(tongue_yaw(idx_outbound_lick));
                    licks_vel_x_avg(ll)=nanmedian(tongue_vel_x(idx_outbound_lick));
                    licks_vel_y1_avg(ll)=nanmedian(tongue_vel_y1(idx_outbound_lick));
                    licks_vel_y2_avg(ll)=nanmedian(tongue_vel_y2(idx_outbound_lick));
                    licks_vel_z_avg(ll)=nanmedian(tongue_vel_z(idx_outbound_lick));
                    
                    licks_delta_x(ll)=nanmax(TONGUE_ML_Cam2(idx_full_lick)) - nanmin(TONGUE_ML_Cam2(idx_full_lick));
                    licks_delta_y1(ll)=nanmax(TONGUE_AP_Cam1(idx_full_lick)) - nanmin(TONGUE_AP_Cam1(idx_full_lick));
                    licks_delta_y2(ll)=nanmax(TONGUE_AP_Cam2(idx_full_lick)) - nanmin(TONGUE_AP_Cam2(idx_full_lick));
                    licks_delta_z(ll)=nanmax(TONGUE_Z_Cam1(idx_full_lick)) - nanmin(TONGUE_Z_Cam1(idx_full_lick));
                    
                end
                
                %% Insert into structure
                %parsed by licks
                
                %interpolating values around peak when they are missing frames by taking the average values of the closest visible frames before and after the peak
                
                idx_t_electric_valid =[];
                for i_p=1:1:numel(idx_licks_peak)
                    temp_idx_peak = idx_licks_peak(i_p);
                    
                    max_frames_interp=10;
                    
                    [TONGUE_ML_Cam2] = fn_interpolate_lick (TONGUE_ML_Cam2, max_frames_interp, temp_idx_peak);
                    [TONGUE_AP_Cam1] = fn_interpolate_lick (TONGUE_AP_Cam1, max_frames_interp, temp_idx_peak);
                    [TONGUE_AP_Cam2] = fn_interpolate_lick (TONGUE_AP_Cam2, max_frames_interp, temp_idx_peak);
                    [tongue_yaw] = fn_interpolate_lick (tongue_yaw, max_frames_interp, temp_idx_peak);
                    
                    
                    
                    
                    t_current_electric =licks_time_electric( find( t(idx_licks_onset(i_p)) <= licks_time_electric     &     licks_time_electric <=      t(idx_licks_end(i_p))));
                    
                    for ii_el=1:1:numel(t_current_electric)
                        [temp,idx_current_t_electric] = min(abs(t-t_current_electric(ii_el)));
                        idx_t_electric_valid = [idx_t_electric_valid,idx_current_t_electric];
                        [TONGUE_ML_Cam2] = fn_interpolate_lick (TONGUE_ML_Cam2, max_frames_interp, idx_current_t_electric);
                        [TONGUE_AP_Cam1] = fn_interpolate_lick (TONGUE_AP_Cam1, max_frames_interp, idx_current_t_electric);
                        [TONGUE_AP_Cam2] = fn_interpolate_lick (TONGUE_AP_Cam2, max_frames_interp, idx_current_t_electric);
                        [TONGUE_Z_Cam1] = fn_interpolate_lick (TONGUE_Z_Cam1, max_frames_interp, idx_current_t_electric);
                        [tongue_yaw] = fn_interpolate_lick (tongue_yaw, max_frames_interp, idx_current_t_electric);
                    end
                    
                    
                    
                    
                end %end loop individual licks
                
                insert_key_licks(ii).licks_peak_x = TONGUE_ML_Cam2(idx_licks_peak);
                insert_key_licks(ii).licks_peak_y1 = TONGUE_AP_Cam1(idx_licks_peak);
                insert_key_licks(ii).licks_peak_y2 = TONGUE_AP_Cam2(idx_licks_peak);
                insert_key_licks(ii).licks_peak_z = TONGUE_Z_Cam1(idx_licks_peak);
                insert_key_licks(ii).licks_peak_yaw = tongue_yaw(idx_licks_peak);
                
                
                if ~isempty(idx_t_electric_valid)
                    insert_key_licks(ii).licks_touch_x =  TONGUE_ML_Cam2(idx_t_electric_valid);
                    insert_key_licks(ii).licks_touch_y1 = TONGUE_AP_Cam1(idx_t_electric_valid);
                    insert_key_licks(ii).licks_touch_y2 =TONGUE_AP_Cam2(idx_t_electric_valid);
                    insert_key_licks(ii).licks_touch_z = TONGUE_Z_Cam1(idx_t_electric_valid);
                    insert_key_licks(ii).licks_touch_yaw = tongue_yaw(idx_t_electric_valid);
                else
                    insert_key_licks(ii).licks_touch_x = NaN;
                    insert_key_licks(ii).licks_touch_y1 = NaN;
                    insert_key_licks(ii).licks_touch_y2 = NaN;
                    insert_key_licks(ii).licks_touch_z = NaN;
                    insert_key_licks(ii).licks_touch_yaw = NaN;
                end
                
                
                insert_key_licks(ii).licks_yaw_lickbout_avg = licks_yaw_avg';
                insert_key_licks(ii).licks_vel_x_lickbout_avg = licks_vel_x_avg';
                insert_key_licks(ii).licks_vel_y1_lickbout_avg = licks_vel_y1_avg';
                insert_key_licks(ii).licks_vel_y2_lickbout_avg = licks_vel_y2_avg';
                insert_key_licks(ii).licks_vel_z_lickbout_avg = licks_vel_z_avg';
                
                insert_key_licks(ii).licks_time_onset = licks_time_onset;
                insert_key_licks(ii).licks_time_peak =  licks_time_peak;
                insert_key_licks(ii).licks_duration_total = licks_duration_total;
                insert_key_licks(ii).licks_time_electric = licks_time_electric;
                
                insert_key_licks(ii).licks_delta_x = licks_delta_x';
                insert_key_licks(ii).licks_delta_y1 = licks_delta_y1';
                insert_key_licks(ii).licks_delta_y2 = licks_delta_y2';
                insert_key_licks(ii).licks_delta_z = licks_delta_z';
                
                
                
                
                
                %% Plot
                if flag_plot==1
                    
                    %% Time series, entire trial
                    xl=[t(1) t(end)];
                    
                    
                    %Tongue Z axis Camera1
                    xxx = TONGUE_Z_Cam1;
                    axes('position',[position_x1(1), position_y1(1), panel_width1, panel_height1]);
                    hold on;
                    plot(t,xxx,'-b');
                    if ~isempty(licks_time_electric)
                        plot(licks_time_electric, interp1(t,xxx,licks_time_electric),'og','LineWidth',1)
                    end
                    xlim(xl);
                    plot(t(idx_licks_peak),xxx(idx_licks_peak),'xr','LineWidth',1);
                    plot(t(idx_licks_onset),xxx(idx_licks_onset),'xk','LineWidth',1);
                    plot(t(idx_licks_end),xxx(idx_licks_end),'x','LineWidth',1,'Color',[0.5 0.5 0.5]);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Tongue D-V\nSide (px)'));
                    title(sprintf('ANM%d %s Session %d Trial %d Video %d \n',key.subject_id,key.session_date, key.session, trials(ii), tracking_datafile_num(ii)))
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')');
                    ylim([ fSession(num).y_min , fSession(num).y_max*1.25   ]);
                    %                     ylim([0,50]);
                    
                    %Tongue A-P axis Camera1
                    xxx = TONGUE_AP_Cam1;
                    axes('position',[position_x1(1), position_y1(2), panel_width1, panel_height1]);
                    hold on;
                    plot(t,xxx,'-b');
                    if ~isempty(licks_time_electric)
                        plot(licks_time_electric, interp1(t,xxx,licks_time_electric),'og','LineWidth',1)
                    end
                    xlim(xl);
                    plot(t(idx_licks_peak),xxx(idx_licks_peak),'xr','LineWidth',1);
                    plot(t(idx_licks_onset),xxx(idx_licks_onset),'xk','LineWidth',1);
                    plot(t(idx_licks_end),xxx(idx_licks_end),'x','LineWidth',1,'Color',[0.5 0.5 0.5]);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Tongue A-P\nSide (px)'));
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')');
                    ylim([ fSession(num).x_min , fSession(num).x_max*1.25   ]);
                    %                     ylim([0,50]);
                    
                    %Tongue M-L axis Camera2
                    xxx = TONGUE_ML_Cam2;
                    axes('position',[position_x1(1), position_y1(3), panel_width1, panel_height1]);
                    hold on;
                    plot(t,xxx,'-b');
                    if ~isempty(licks_time_electric)
                        plot(licks_time_electric, interp1(t,xxx,licks_time_electric),'og','LineWidth',1)
                    end
                    xlim(xl);
                    ylim([-15,15]);
                    plot(t(idx_licks_peak),xxx(idx_licks_peak),'xr','LineWidth',1);
                    plot(t(idx_licks_onset),xxx(idx_licks_onset),'xk','LineWidth',1);
                    plot(t(idx_licks_end),xxx(idx_licks_end),'x','LineWidth',1,'Color',[0.5 0.5 0.5]);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Tongue M-L\nTop (px)'));
                    plot([xl],[0 0],'-k','LineWidth',1);
                    
                    %                     %Tongue Yaw (azimuth) Camera2
                    %                     xxx = tongue_yaw;
                    %                     axes('position',[position_x1(2), position_y1(5), panel_width1, panel_height1]);
                    %                     hold on;
                    %                     plot(t,xxx,'-b');
                    %                     if ~isempty(licks_time_electric)
                    %                         plot(licks_time_electric, interp1(t,xxx,licks_time_electric),'og','LineWidth',1)
                    %                     end
                    %                     xlim(xl);
                    % %                     ylim([-30,30]);
                    %                     plot(t(idx_licks_peak),xxx(idx_licks_peak),'xr','LineWidth',1);
                    %                     plot(t(idx_licks_onset),xxx(idx_licks_onset),'xk','LineWidth',1);
                    %                     plot(t(idx_licks_end),xxx(idx_licks_end),'x','LineWidth',1,'Color',[0.5 0.5 0.5]);
                    %                     xlabel(sprintf('%s', time_label));
                    %                     ylabel(sprintf('Tognue yaw  \n (deg) '));
                    %                     plot([xl],[0 0],'-k','LineWidth',1);
                    
                    
                    %Tongue A-P axis Camera2
                    xxx = TONGUE_AP_Cam2;
                    axes('position',[position_x1(1), position_y1(4), panel_width1, panel_height1]);
                    hold on;
                    plot(t,xxx,'-b');
                    if ~isempty(licks_time_electric)
                        plot(licks_time_electric, interp1(t,xxx,licks_time_electric),'og','LineWidth',1)
                    end
                    xlim(xl);
                    num=find([fSession.camera]==2 & strcmp({fSession.label}','TongueTip')');
                    %                     ylim([min([fSession(num).y_min, fSession(num).y_max]), max([fSession(num).y_min, fSession(num).y_max])*1.25]);
                    ylim([0,50]);
                    plot(t(idx_licks_peak),xxx(idx_licks_peak),'xr','LineWidth',1);
                    plot(t(idx_licks_onset),xxx(idx_licks_onset),'xk','LineWidth',1);
                    plot(t(idx_licks_end),xxx(idx_licks_end),'x','LineWidth',1,'Color',[0.5 0.5 0.5]);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Tongue A-P\nTop (px)'));
                    
                    % Jaw, Camera 1
                    axes('position',[position_x1(1), position_y1(5), panel_width1, panel_height1]);
                    hold on
                    %                     num=find([fTrial.camera]==1 & strcmp({fTrial.label}','jaw')');
                    plot(t, JAW_Z_Cam1,'.k','MarkerSize',1,'LineWidth',1);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Jaw D-V\n Side view (px)'));
                    xlim(xl);
                    %                     ylim([0,50]);
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','jaw')'); % we set the limits based on tongue tip for simplicity because whiskers are estimaged using 3 fiducials
                    ylim([ fSession(num).y_min, fSession(num).y_max   ]);
                    
                    % Whiskers, Camera 1
                    axes('position',[position_x1(1), position_y1(6), panel_width1, panel_height1]);
                    hold on
                    plot(t, WHISKERS_AP_Cam1,'.k','MarkerSize',1,'LineWidth',1);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Whiskers A-P\n Side(px)'));
                    xlim(xl);
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')'); % we set the limits based on tongue tip for simplicity because whiskers are estimaged using 3 fiducials
                    ylim([ -fSession(num).x_max*2 , fSession(num).x_max*2   ]);
                    
                    % Nose, Camera 1
                    axes('position',[position_x1(1), position_y1(7), panel_width1, panel_height1]);
                    hold on
                    %                     num=find([fTrial.camera]==1 & strcmp({fTrial.label}','jaw')');
                    plot(t, NOSE_Z_Cam1,'.k','MarkerSize',1,'LineWidth',1);
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Nose D-V\nSide (px)'));
                    xlim(xl);
                    %                     ylim([-60,-20]);
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','nosetip')'); % we set the limits based on tongue tip for simplicity because whiskers are estimaged using 3 fiducials
                    ylim([ fSession(num).y_min, fSession(num).y_max   ]);
                    
                    
                    % Paws, Camera2
                    axes('position',[position_x1(1), position_y1(8), panel_width1, panel_height1]);
                    hold on
                    plot(t, PAWleft_ML_Cam2,'.r','MarkerSize',1,'LineWidth',1); %
                    plot(t, PAWleft_AP_Cam2,'.m','MarkerSize',1,'LineWidth',1); %
                    plot(t, PAWright_ML_Cam2,'.b','MarkerSize',1,'LineWidth',1); %
                    plot(t, PAWright_AP_Cam2,'.c','MarkerSize',1,'LineWidth',1); %
                    %                     xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Paws\nTop (px)'));
                    xlim(xl);
                    ylim([-100,100]);
                    
                    
                    % Lickport, Camera 1
                    axes('position',[position_x1(1), position_y1(9), panel_width1, panel_height1]);
                    hold on
                    num=find([fTrial.camera]==1 & strcmp({fTrial.label}','lickport')');
                    plot(t, fTrial(num).y{ii},'.k','MarkerSize',1,'LineWidth',1);
                    xlabel(sprintf('%s', time_label));
                    ylabel(sprintf('Lickport D-V\nSide (px)'));
                    xlim(xl);
                    ylim([0,100]);
                    plot(t(idx_lickport_t_entrance_start), fTrial(num).y{ii}(idx_lickport_t_entrance_start),'or','MarkerSize',5,'LineWidth',1); % lickport camera 1
                    plot(t(idx_lickport_t_entrance_end), fTrial(num).y{ii}(idx_lickport_t_entrance_end),'or','MarkerSize',5,'LineWidth',1); % lickport camera 1
                    plot(t(idx_lickport_t_exit_start), fTrial(num).y{ii}(idx_lickport_t_exit_start),'or','MarkerSize',5,'LineWidth',1); % lickport camera 1
                    plot(t(idx_lickport_t_exit_end), fTrial(num).y{ii}(idx_lickport_t_exit_end),'or','MarkerSize',5,'LineWidth',1); % lickport camera 1
                    
                    
                    %% 2D tongue trajectories, before Go cue
                    idx_t_before_go = t<0;
                    idx_peaks_before_go = t(idx_licks_peak)<0 ;
                    
                    % Camera 1
                    axes('position',[position_x2(1), position_y2(1), panel_width2, panel_height2]);
                    hold on;
                    plot(TONGUE_AP_Cam1(idx_t_before_go), TONGUE_Z_Cam1(idx_t_before_go),'.-');
                    %                     plot(interp1(t,AP_Cam1,licks_time_electric),interp1(t,Z_Cam1,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    plot(TONGUE_AP_Cam1(idx_licks_peak(idx_peaks_before_go)),TONGUE_Z_Cam1(idx_licks_peak(idx_peaks_before_go)),'xr','LineWidth',1);
                    xlabel('A-P axis (px)');
                    ylabel('D-V axis (px)');
                    title('Side view, before t=0');
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')');
                    xlim([ fSession(num).x_min , fSession(num).x_max*1.25   ]);
                    ylim([  fSession(num).y_min, fSession(num).y_max*1.25  ]);
                    %                     ylim([0,50]);
                    %                     xlim([0,50]);
                    num=find([fTrial.camera]==1 & strcmp({fTrial.label}','lickport')');
                    if ii>=2
                        plot(LICKPORT_AP_Cam1_mean(ii-1),LICKPORT_Z_Cam1_mean(ii-1),'o','MarkerSize',20,'LineWidth',3, 'Color',[0.75 0.75 0.75]); % lickport position on previos trial
                    end
                    plot(LICKPORT_AP_Cam1_mean(ii),LICKPORT_Z_Cam1_mean(ii),'ok','MarkerSize',20,'LineWidth',3); % lickport
                    
                    % Camera 2
                    axes('position',[position_x2(2), position_y2(1), panel_width2, panel_height2]);
                    hold on;
                    plot(TONGUE_ML_Cam2(idx_t_before_go), TONGUE_AP_Cam2(idx_t_before_go),'.-');
                    %                     plot(interp1(t,ML_Cam2,licks_time_electric),interp1(t,AP_Cam2,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    plot(TONGUE_ML_Cam2(idx_licks_peak(idx_peaks_before_go)),TONGUE_AP_Cam2(idx_licks_peak(idx_peaks_before_go)),'xr','LineWidth',1);
                    xlabel('M-L axis (px)');
                    ylabel('A-P axis (px)');
                    title('Top view, before t=0');
                    num=find([fSession.camera]==2 & strcmp({fSession.label}','TongueTip')');
                    ylim([0,50]);
                    xlim([-20,20]);
                    num=find([fTrial.camera]==2 & strcmp({fTrial.label}','lickport')');
                    if ii>=2
                        plot(LICKPORT_ML_Cam2_mean(ii-1),LICKPORT_AP_Cam2_mean(ii-1),'o','MarkerSize',20,'LineWidth',3, 'Color',[0.75 0.75 0.75]); % lickport position on previos trial
                    end
                    plot(LICKPORT_ML_Cam2_mean(ii),LICKPORT_AP_Cam2_mean(ii),'ok','MarkerSize',20,'LineWidth',3); % lickport
                    
                    
                    %% 2D tongue trajectories, after Go cue
                    idx_t_after_go = t>=0;
                    idx_peaks_after_go = t(idx_licks_peak)>0;
                    
                    % Camera 1
                    axes('position',[position_x2(1), position_y2(2), panel_width2, panel_height2]);
                    hold on;
                    plot(TONGUE_AP_Cam1(idx_t_after_go), TONGUE_Z_Cam1(idx_t_after_go),'.-');
                    plot(interp1(t,TONGUE_AP_Cam1,licks_time_electric),interp1(t,TONGUE_Z_Cam1,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    plot(TONGUE_AP_Cam1(idx_licks_peak(idx_peaks_after_go)),TONGUE_Z_Cam1(idx_licks_peak(idx_peaks_after_go)),'xr','LineWidth',1);
                    xlabel('A-P axis (px)');
                    ylabel('D-V axis (px)');
                    title('Side view, after t=0');
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')');
                    xlim([ fSession(num).x_min , fSession(num).x_max*1.25   ]);
                    ylim([  fSession(num).y_min, fSession(num).y_max*1.25  ]);
                    %                     ylim([0,50]);
                    %                     xlim([0,50]);
                    num=find([fTrial.camera]==1 & strcmp({fTrial.label}','lickport')');
                    if ii>=2
                        plot(LICKPORT_AP_Cam1_mean(ii-1),LICKPORT_Z_Cam1_mean(ii-1),'o','MarkerSize',20,'LineWidth',3, 'Color',[0.75 0.75 0.75]); % lickport position on previos trial
                    end
                    plot(LICKPORT_AP_Cam1_mean(ii),LICKPORT_Z_Cam1_mean(ii),'ok','MarkerSize',20,'LineWidth',3); % lickport
                    
                    % Camera 2
                    axes('position',[position_x2(2), position_y2(2), panel_width2, panel_height2]);
                    hold on;
                    plot(TONGUE_ML_Cam2(idx_t_after_go), TONGUE_AP_Cam2(idx_t_after_go),'.-');
                    plot(interp1(t,TONGUE_ML_Cam2,licks_time_electric),interp1(t,TONGUE_AP_Cam2,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    plot(TONGUE_ML_Cam2(idx_licks_peak(idx_peaks_after_go)),TONGUE_AP_Cam2(idx_licks_peak(idx_peaks_after_go)),'xr','LineWidth',1);
                    xlabel('M-L axis (px)');
                    ylabel('A-P axis (px)');
                    title('Top view, after t=0');
                    %                     num=find([fSession.camera]==2 & strcmp({fSession.label}','TongueTip')');
                    %                     xlim([  fSession(num).x_min, fSession(num).x_max*1.25   ]);
                    %                     xlim([  fSession(num).y_min, fSession(num).y_max*1.25  ]);
                    ylim([0,50]);
                    xlim([-20,20]);
                    num=find([fTrial.camera]==2 & strcmp({fTrial.label}','lickport')');
                    if ii>=2
                        plot(LICKPORT_ML_Cam2_mean(ii-1),LICKPORT_AP_Cam2_mean(ii-1),'o','MarkerSize',20,'LineWidth',3, 'Color',[0.75 0.75 0.75]); % lickport position on previos trial
                    end
                    plot(LICKPORT_ML_Cam2_mean(ii),LICKPORT_AP_Cam2_mean(ii),'ok','MarkerSize',20,'LineWidth',3); % lickport
                    
                    
                    
                    %% 2D Paw Left and Right, all trial
                    
                    % Camera 1
                    num1=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawL')');
                    num2=find([fTrial.camera]==1 & strcmp({fTrial.label}','PawR')');
                    axes('position',[position_x2(1), position_y2(3), panel_width2, panel_height2]);
                    hold on;
                    plot(PAWleft_AP_Cam1, PAWleft_Z_Cam1,'.r');
                    plot(PAWright_AP_Cam1, PAWright_Z_Cam1,'.b');
                    %                     plot(interp1(t,AP_Cam1,licks_time_electric),interp1(t,Z_Cam1,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    xlabel('A-P axis (px)');
                    ylabel('D-V axis (px)');
                    title(sprintf('Side view, Front Paws\n %d grooming frames ',num_grooming_frames));
                    xl = [-150,150];
                    yl=[-150,150];
                    xlim(xl);
                    ylim(yl);
                    plot([   grooming_x_threshold, grooming_x_threshold],yl,'-k');
                    plot(xl, [grooming_y_threshold grooming_y_threshold],'-k');
                    %                     xlim(([min([fSession(num1).x_min, fSession(num2).x_min]), max([fSession(num1).x_max, fSession(num2).x_max])]));
                    %                     ylim(([min([fSession(num1).y_min, fSession(num2).y_min]), max([fSession(num1).y_max, fSession(num2).y_max])]));
                    
                    
                    
                    
                    % Camera 2
                    num1=find([fTrial.camera]==2 & strcmp({fTrial.label}','PawL')');
                    num2=find([fTrial.camera]==2 & strcmp({fTrial.label}','PawR')');
                    axes('position',[position_x2(2), position_y2(3), panel_width2, panel_height2]);
                    hold on;
                    plot(PAWleft_ML_Cam2, PAWleft_AP_Cam2,'.r');
                    plot(PAWright_ML_Cam2, PAWright_AP_Cam2,'.b');
                    %                     plot(interp1(t,AP_Cam1,licks_time_electric),interp1(t,Z_Cam1,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    xlabel('M-L axis (px)');
                    ylabel('A-P axis (px)');
                    title('Top view, Front Paws');
                    %                     ylim([-50,50]);
                    %                     xlim([-100,100]);
                    xlim(([min([fSession(num1).x_min, fSession(num2).x_min])*1.25, max([fSession(num1).x_max, fSession(num2).x_max])*1.25]));
                    ylim(([min([fSession(num1).y_min, fSession(num2).y_min]), max([fSession(num1).y_max, fSession(num2).y_max])*1.25]));
                    
                    
                    
                    %% 2D Whiskers
                    % Camera 1
                    axes('position',[position_x2(3), position_y2(3), panel_width2, panel_height2]);
                    hold on;
                    plot(WHISKERS_AP_Cam1, WHISKERS_Z_Cam1,'.k');
                    %                     plot(interp1(t,AP_Cam1,licks_time_electric),interp1(t,Z_Cam1,licks_time_electric),'og','Clipping','off','LineWidth',1);
                    set(gca,'Ydir','reverse')
                    axis equal
                    xlabel('A-P axis (px)');
                    ylabel('D-V axis (px)');
                    title(sprintf('Side view, Whiskers '));
                    %                     ylim([25,75]);
                    %                     xlim([-50,50]);
                    num=find([fSession.camera]==1 & strcmp({fSession.label}','TongueTip')'); % we set the limits based on tongue tip for simplicity because whiskers are estimaged using 3 fiducials
                    xlim([ -fSession(num).x_max*2 , fSession(num).x_max*2   ]);
                    ylim([  fSession(num).y_min, fSession(num).y_max*2   ]);
                    
                    
                    %% Save figure
                    filename = ['trial' num2str(trials(ii))  'vid' num2str(tracking_datafile_num(ii)) ];
                    dir_save_figure_full=[dir_current_fig 'anm' num2str(key.subject_id) '\' [key.session_date 's' num2str(key.session)] '\'];
                    if isempty(dir(dir_save_figure_full))
                        mkdir (dir_save_figure_full)
                    end
                    figure_name_out=[dir_save_figure_full  filename];
                    eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
                    %                      eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r500']);
                    
                    clf;
                end
                
            end
            
            insert(self,insert_key_licks);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_tongue);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_whiskers);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_PawLeft);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_PawRight);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_JAW);
            insert(TRACKING.VideoBodypartTrajectTrial ,insert_key_trajectory_NOSE);
            
            insert(TRACKING.VideoLickportTrial,insert_key_lickport);
            
            insert(TRACKING.VideoLickportPositionTrial,insert_key_lickport_position);
            
            if ~isempty(insert_key_grooming)
                insert(TRACKING.VideoGroomingTrial,insert_key_grooming);
            end
            
        end
        
    end
end

