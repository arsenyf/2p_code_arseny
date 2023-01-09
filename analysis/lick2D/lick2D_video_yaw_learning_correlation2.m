function    lick2D_video_yaw_learning_correlation2()
clf
% key.subject_id = 463189;
% key.subject_id = 464724;
% key.subject_id = 464725;
% key.subject_id = 463190;
% key.subject_id = 462458; %AF17

subject_list=[463189,464724,464725,463190,462458];

x_tong_port_corr_after=[];
x_tong_port_corr_before=[];

for i_sub = 1:1:numel(subject_list)
    %     clf;
    key=[];
    key.subject_id =subject_list(i_sub);
    sessions_list = fetchn(EXP2.Session & TRACKING.VideoNthLickTrial & key, 'session');
    
  
    for i_ses = 1:1:numel(sessions_list)
        
        key.session = sessions_list(i_ses);
        
           
        %% BEFORE LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance<=-1','lick_peak_x','lickport_x');
        x_tong_port_corr_before{i_sub,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');
        
        
        %% AFTER LICKPORT ENTRANCE
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_lickport_entrance>=0','lick_peak_x','lickport_x');
        x_tong_port_corr_after{i_sub,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');

        
        T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_firsttouch=0','lick_peak_x','lickport_x');
        x_tong_port_corr_first_touch{i_sub,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');

         T= fetch((TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort & key )-TRACKING.VideoGroomingTrial & 'trial>100' & 'lick_number_relative_to_firsttouch>0','lick_peak_x','lickport_x');
        x_tong_port_corr_later_touch{i_sub,i_ses}=corr([T.lickport_x]',[T.lick_peak_x]','Rows','pairwise');

        
    end
    
end

for i_s= 1:1:size(x_tong_port_corr_after,2)
    x_corr_mean_after(i_s)=mean([x_tong_port_corr_after{:,i_s}])
    x_corr_stem_after(i_s)=std([x_tong_port_corr_after{:,i_s}])./sqrt(numel([x_tong_port_corr_after{:,i_s}]));
    
    x_corr_mean_before(i_s)=mean([x_tong_port_corr_before{:,i_s}])
    x_corr_stem_before(i_s)=std([x_tong_port_corr_before{:,i_s}])./sqrt(numel([x_tong_port_corr_before{:,i_s}]));
    
        x_corr_mean_first_touch(i_s)=mean([x_tong_port_corr_first_touch{:,i_s}])
    x_corr_stem_first_touch(i_s)=std([x_tong_port_corr_first_touch{:,i_s}])./sqrt(numel([x_tong_port_corr_first_touch{:,i_s}]));
    
    x_corr_mean_later_touch(i_s)=mean([x_tong_port_corr_later_touch{:,i_s}])
    x_corr_stem_later_touch(i_s)=std([x_tong_port_corr_later_touch{:,i_s}])./sqrt(numel([x_tong_port_corr_later_touch{:,i_s}]));

    
end

subplot(2,2,[1,3])
hold on
h(1)=shadedErrorBar(1:1:i_s,smooth(x_corr_mean_before,3) ,smooth(x_corr_stem_before,3),'lineprops',{'-','Color',[0.5 0.5 0.5]});
h(2)=shadedErrorBar(1:1:i_s,smooth(x_corr_mean_after,3) ,smooth(x_corr_stem_after,3),'lineprops',{'-','Color',[0 0 0]});
h(3)=shadedErrorBar(1:1:i_s,smooth(x_corr_mean_first_touch,3) ,smooth(x_corr_stem_first_touch,3),'lineprops',{'-','Color',[1 0 0]});
h(4)=shadedErrorBar(1:1:i_s,smooth(x_corr_mean_later_touch,3) ,smooth(x_corr_stem_later_touch,3),'lineprops',{'-','Color',[0 0 1]});


% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
legend([h(1).mainLine h(2).mainLine h(3).mainLine h(4).mainLine], 'Before target', 'After target', 'First touch', 'Later touches','Location','EastOutside')
xlabel('Session');
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0,1])


end
