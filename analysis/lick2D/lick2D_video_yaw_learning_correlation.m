function    lick2D_video_yaw_learning_correlation()
clf
% key.subject_id = 463189;
% key.subject_id = 464724;
% key.subject_id = 464725;
% key.subject_id = 463190;
% key.subject_id = 462458; %AF17

subject_list=[463189,464724,464725,463190,462458];


for i_sub = 1:1:numel(subject_list)
%     clf;
    key=[];
    key.subject_id =subject_list(i_sub);
    sessions_list = fetchn(EXP2.Session & TRACKING.VideoNthLickTrial & key, 'session');
    
    yaw_after_mean=[];
    yaw_after_std=[];
    yaw_before_mean=[];
    yaw_before_std=[];
    delta_x_after=[];
    delta_x_before=[];
    x_tong_port_corr_after=[];
    x_tong_port_corr_before=[];
    for i_ses = 1:1:numel(sessions_list)
        
        key.session = sessions_list(i_ses);
        
        %         T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_touch_number>1','lick_yaw_lickbout');
        %         T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_touch_number>1','lick_yaw_lickbout');
        
        
        %% AFTER LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance>=1','lick_yaw_lickbout','lick_peak_x','lick_peak_z','lickport_x','lickport_z');
        
        yaw_after_mean(i_ses)=nanmean(abs([T.lick_yaw_lickbout]));
        yaw_after_std(i_ses)=nanstd(abs([T.lick_yaw_lickbout]));
        
        delta_x_after(i_ses)=nanmean(abs([T.lickport_x]-[T.lick_peak_x]));
        x_tong_port_corr_after(i_ses)=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');

       %% BEFORE LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance<=-1','lick_yaw_lickbout','lick_peak_x','lick_peak_z','lickport_x','lickport_z');
        yaw_before_mean(i_ses)=nanmean(abs([T.lick_yaw_lickbout]));
        yaw_before_std(i_ses)=nanstd(abs([T.lick_yaw_lickbout]));
        x_tong_port_corr_before(i_ses)=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');

        delta_x_before(i_ses)=nanmean(abs([T.lickport_x]-[T.lick_peak_x]));

    end
    
    
    
    
    
    subplot(2,5,i_sub)
    
    hold on
    plot(sessions_list,x_tong_port_corr_after,'.-b')
    plot(sessions_list,x_tong_port_corr_before,'.-','Color',[0.5, 0.5,0.5])
    xlabel('Session');
    ylabel('Tongue/Port X corr');
    ylim([0, ceil(max([x_tong_port_corr_after,x_tong_port_corr_before]))]);
   
    title(['Subject ' num2str(subject_list(i_sub))]);
    
    
    subplot(2,5,i_sub+5)
    
    hold on
    plot(sessions_list,delta_x_after,'.-b')
    plot(sessions_list,delta_x_before,'.-','Color',[0.5, 0.5,0.5])
    xlabel('Session');
    ylabel('|Delta Medio-Lateral distance| (pixels)');
    ylim([0, ceil(max([delta_x_after,delta_x_before]))]);
   
    title(['Subject ' num2str(subject_list(i_sub))]);
    
    
    %         subplot(2,2,2)
    %         hold on
    %         plot(nanmean(pos_x),nanmean([T.lick_yaw_lickbout]),'.','Color',colors(i_p,:),'MarkerSize',25)
    %         xlabel('Theta angle (deg)');
    %         ylabel('ML position (pixels)');
    %
    
    
end
end