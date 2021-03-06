%{
#
-> EXP2.SessionTrial
-> TRACKING.TrackingDevice
---
tracking_datafile_num  = null        : int                        # tracking data file number associated with this trial
tracking_datafile_path = null        : varchar(1000)              #
tracking_start_time = null           : decimal(8,4)               # (s) from trial start
tracking_duration = null             : decimal(8,4)               # (s)
tracking_sampling_rate = null        : decimal(8,4)               # Hz
tracking_num_samples = null          : int                        #
%}


classdef TrackingTrial < dj.Imported
    properties
%                 keySource = (EXP2.Session  & IMG.Mesoscope  &  (EXP2.SessionEpoch& 'session_epoch_type="behav_only"') )  * (TRACKING.TrackingDevice & 'tracking_device_id=4 OR tracking_device_id=3');
        keySource = (EXP2.Session   & EXP2.BehaviorTrial)  * (TRACKING.TrackingDevice & 'tracking_device_id=0 OR tracking_device_id=1');
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            tracking_sampling_rate=250; % Hz
            
            
            %% Reading CSV files
            dir_base =fetch1(IMG.Parameters & 'parameter_name="dir_video_processed"', 'parameter_value');
            device = [key.tracking_device_type num2str(key.tracking_device_id)];
            temp = dir(dir_base); %gets  the names of all files and nested directories in this folder
            DirNames = {temp([temp.isdir]).name}; %gets only the names of all files
            DirNames =DirNames{contains(DirNames,device)};
            
            dir_data1 = [dir_base DirNames '\'];
            temp = dir(dir_data1); %gets  the names of all files and nested directories in this folder
            DirNames = {temp([temp.isdir]).name}; %gets only the names of all files
            if sum(contains(DirNames,num2str(key.subject_id)))==0
                return
            end
            DirNames =DirNames{contains(DirNames,num2str(key.subject_id))};
            
            date=fetch1(EXP2.Session & key,'session_date');
            dir_data2 = [dir_data1 DirNames '\' date '\'];
            temp = dir(dir_data2); %gets  the names of all files and nested directories in this folder
            FileNames = {temp(~[temp.isdir]).name}; %gets only the names of all files
            FileNames =FileNames(contains(FileNames,'.csv'))';
            
            % B = fetch(EXP2.BehaviorTrial*EXP2.BehaviorTrialEvent & 'trial_event_type="trialend"' & key,'*');
            
            % Debug Arseny: for the original mesoscope video I used the line above with 'trial_event_type="trialend"', but not all sessions had this event so I changed it

            B = fetch(EXP2.BehaviorTrial*EXP2.BehaviorTrialEvent & 'trial_event_type="trigger imaging"' & key,'*');

            %% DEBUG we assume her that behavior epoch is the last epoch (e.g. spontaneous session epoch, if exists, comes before behavior), so it won't work if there is a spontaneous ecpoch after the behavioral one
            if isempty(FileNames)
                return
            end
            
            %% For more then 1000 files, the order of the files get messed up, so we  reorder it here:
            for i=1:1:numel(FileNames)
                ss=FileNames{i};
                temp_FileName_order(i)=str2num( ss(strfind(ss,'_v')+2:strfind(ss,'.csv')-1));
            end
            [~,FileName_order_idx]=sort(temp_FileName_order,'ascend');
            FileNames=FileNames(FileName_order_idx);
            
            num_trials = numel(FileNames);

%             %   \FileNames = FileNames(end-num_trials+1:end);
%             if num_trials>numel(FileNames)
%                 num_trials=numel(FileNames);
%             else
%                num_trials=numel(FileNames);
%             end
% %             FileNames = FileNames(1:1:num_trials);
            
            parfor i=1:num_trials
                frames = csvread([dir_data2  FileNames{i}],3,1);
                num_frames_trials(i)=size(frames,1);
            end
            
            idx_trials_spont=num_frames_trials>=5000; % spontaneous trial are longer
            idx_trials_behav=num_frames_trials<5000;

            num_trials_behav=sum(idx_trials_behav);
            num_frames_trials_behav = num_frames_trials(idx_trials_behav);
            FileNames_behav = FileNames (idx_trials_behav);
            
            if  num_trials_behav ~=numel(B)
                warning('Missing\Extra behavioral in video trials');
                return
            end
            
            for i=1:num_trials_behav
                
                tracking_duration=num_frames_trials_behav(i)/tracking_sampling_rate;
%                 tracking_start_time = B(i).trial_event_time-tracking_duration;
                tracking_start_time = 2*1/tracking_sampling_rate; %assuming the first two frames are not captured, 

                key(i).subject_id=key(1).subject_id; % repmat((key.subject_id),numel(trial),1);
                key(i).session=key(1).session;    % repmat(key.session,numel(trial),1);
                key(i).trial=B(i).trial;
                key(i).rig=key(1).rig; %repmat({key.rig},numel(trial),1);
                key(i).tracking_device_type=key(1).tracking_device_type;   %repmat({key.tracking_device_type},numel(trial),1);
                key(i).tracking_device_id=key(1).tracking_device_id; %repmat(key.tracking_device_id,numel(trial),1);
                key(i).tracking_datafile_num=str2num( FileNames_behav{i}(strfind(FileNames_behav{i},'_v')+2:strfind(FileNames_behav{i},'.csv')-1));
                key(i).tracking_datafile_path=[dir_data2  FileNames_behav{i}];
                key(i).tracking_start_time=tracking_start_time;
                key(i).tracking_duration=tracking_duration;
                key(i).tracking_sampling_rate=tracking_sampling_rate;
                key(i).tracking_num_samples=num_frames_trials_behav(i);
            end
            
            insert(self,key)
            
            
        end
    end
    
end