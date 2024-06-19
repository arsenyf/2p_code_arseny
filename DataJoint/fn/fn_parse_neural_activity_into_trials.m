function [psth_all,time] = fn_parse_neural_activity_into_trials(spikes, time_resample_bin, start_file,end_file, smooth_window_frames, frame_rate, fr_interval, idx_response )
psth_all=cell(1, numel(start_file)); %allocation

    if isempty(time_resample_bin)
        for i_tr = 1:1:numel(start_file)
            if idx_response(i_tr)==0 %its an ignore trial
                psth_all{i_tr}=NaN;
                continue
            end
            s=spikes(start_file(i_tr):end_file(i_tr));
            s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
            time=(1:1:numel(s))/frame_rate + fr_interval(1);
            %         s_interval=s(time>fr_interval(1) & time<=fr_interval(2));
            %         fr_all(i_roi,i_tr)= max(s_interval); %taking the max
            psth_all{i_tr}=s;
        end
    else
        time_new_bins = [fr_interval(1):time_resample_bin:fr_interval(end)];
        time_new = time_new_bins(1:end-1)+mean(diff(time_new_bins)/2);
        for i_tr = 1:1:numel(start_file)
            if idx_response(i_tr)==0 %its an ignore trial
                psth_all{i_tr}=NaN;
                continue
            end
            s=spikes(start_file(i_tr):end_file(i_tr));
            s=movmean(s,[smooth_window_frames 0],'omitnan','Endpoints','shrink');
            time=(1:1:numel(s))/frame_rate + fr_interval(1);
            for i_t = 1:numel(time_new_bins)-1
                idx_t = time>time_new_bins(i_t) & time<=time_new_bins(i_t+1);
                s_resampled(i_t) = mean(s(idx_t));
            end
            psth_all{i_tr}=s_resampled;
        end
        time = time_new;
    end
    
    
    
  