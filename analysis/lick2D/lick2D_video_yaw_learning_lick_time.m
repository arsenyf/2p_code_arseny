function    lick2D_video_yaw_learning_lick_time()
clf







x_tong_port_corr=[];
%% BEFORE LICKPORT ENTRANCE
T= fetch((TRACKING.VideoNthLickTrial*TRACKING.VideoLickportTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPort )-TRACKING.VideoGroomingTrial & 'trial>100' ,'lick_peak_x','lickport_x', 'lick_time_onset','lickport_t_entrance_start');
mean_lickport_t_entrance=mean([T.lickport_t_entrance_start]);

lickport_x=[T.lickport_x];
lick_peak_x=[T.lick_peak_x];

lick_peak_x_shuffled=lick_peak_x(randperm(numel(lick_peak_x)));

[~,edges,bins]=histcounts([T.lick_time_onset],[-1:0.2:4]);


for i_b=1:1:max(bins)
    idx=find(bins==i_b);
    corr_mean(i_b)=mean(corr([lickport_x(idx)]',[lick_peak_x(idx)]','Rows','pairwise'));
    corr_mean_shuffled(i_b)=mean(corr([lickport_x(idx)]',[lick_peak_x_shuffled(idx)]','Rows','pairwise'));
end

subplot(2,2,[1])
hold on
plot(edges(1:end-1),corr_mean)
plot(edges(1:end-1),corr_mean_shuffled)
plot([mean_lickport_t_entrance,mean_lickport_t_entrance],[0,1])
% plot(across_training{1}.within_block,'-','Color',[0.00,0.45,0.74])
xlabel('Licks, relative to target entrance');
ylabel(sprintf('Correlation in (tongue,target)\n horizontal position'));
ylim([0,1])
xlim([min(edges) max(edges)])


end