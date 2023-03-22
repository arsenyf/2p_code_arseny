function fn_analysis_position_versus_time4_meso

% rel_stats= LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>0.5';% & (IMG.ROIBrainArea & 'brain_area="MOs"');
rel_roi=(IMG.ROIGood-IMG.ROIBad) & (IMG.ROIBrainArea & 'brain_area="SSp-bfd"');
% rel_roi=(IMG.ROIGood-IMG.ROIBad) & (IMG.ROIBrainArea & 'brain_area="MOs"');
% rel_roi=(IMG.ROIGood-IMG.ROIBad) & (IMG.ROIBrainArea & 'brain_area="MOp"');
% rel_roi=(IMG.ROIGood-IMG.ROIBad) & (IMG.ROIBrainArea & 'brain_area="RSPagl"');


rel_stats= (IMG.ROI*LICK2D.ROILick2DPSTHStatsSpikesLongerInterval*LICK2D.ROILick2DmapStatsSpikes3bins ) & rel_roi;
% rel_stats= (IMG.ROI*LICK2D.ROILick2DPSTHStatsSpikesLongerInterval*LICK2D.ROILick2DmapStatsSpikes3bins & 'psth_regular_odd_vs_even_corr>0.5') & rel_roi;

% key.subject_id = 464725;
% rel_stats=rel_stats & key;

% rel_stats2=LICK2D.ROILick2DmapStatsSpikes3bins  & rel_stats;

psth_time = fetch1(LICK2D.ROILick2DPSTHSpikesLongerInterval  & rel_stats, 'psth_time','LIMIT 1');


peaktime_psth = fetchn(rel_stats, 'peaktime_psth_regular','ORDER BY roi_number_uid');
information_per_spike_regular = fetchn(rel_stats, 'information_per_spike_regular','ORDER BY roi_number_uid');
psth_position_concat_regular_odd_even_corr = fetchn(rel_stats, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
lickmap_regular_odd_vs_even_corr = fetchn(rel_stats, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid');




time_bins1 = floor(psth_time(1)):1:ceil(psth_time(end));
time_bins=time_bins1(1):1:time_bins1(end);
time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
a=histogram(peaktime_psth,time_bins);
y =100*a.BinCounts/numel(peaktime_psth);
% y =100*a.BinCounts/sum(a.BinCounts);
% BinCounts=a.BinCounts;
yyaxis left
bar(time_bins_centers,y);
% title(sprintf('Response time of tuned neurons'));
xlabel(sprintf('Peak response time of neurons\n relative to first lick ,\nafter lickport move (s)'));

ylabel(sprintf('Temporally tuned\n neurons (%%)'));
set(gca,'Xtick',[time_bins(1),0,time_bins(end)],'TickLength',[0.05,0.05],'TickDir','out');
box off
xlim([time_bins(1),time_bins(end)]);
ylim([0 ceil(max(y))]);

%% of directionally tuned cells as a function of preferred PSTH time
% axes('position',[position_x2(4)+0.15, position_y2(2), panel_width2, panel_height2]);
%     idx_directional = M.theta_tuning_odd_even_corr>threshold_theta_tuning_odd_even_corr & M.goodness_of_fit_vmises>threshold_goodness_of_fit_vmises & M.rayleigh_length>threshold_rayleigh_length;
idx_positional = information_per_spike_regular>=0.1 & psth_position_concat_regular_odd_even_corr>0.5;

for ib = 1:1:numel(time_bins)-1
    idx_time_bin = peaktime_psth>=time_bins(ib) & peaktime_psth<time_bins(ib+1);
    % percentage tuned in each time bin
    if (100*sum(idx_time_bin)/numel(idx_time_bin))>1 % if there are less than 1% of total cells in the bin we set it to NaN, to avoid spurious values
        tuned_in_time_bins(ib) =100*sum(idx_time_bin & idx_positional)/sum(idx_time_bin);
    else
        tuned_in_time_bins(ib)=NaN;
    end
end
yyaxis right

time_bins=time_bins1(1):1:time_bins1(end);
time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
plot(time_bins_centers,tuned_in_time_bins,'.-','LineWidth',1,'MarkerSize',5)
% xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
ylabel(sprintf('Positionally tuned\n neurons (%%)'));
set(gca,'Xtick',[time_bins(1),0,time_bins(end)],'TickLength',[0.05,0.05],'TickDir','out');
box off
xlim([time_bins(1),time_bins(end)]);
ylim([0 ceil(max(tuned_in_time_bins))]);

a=1