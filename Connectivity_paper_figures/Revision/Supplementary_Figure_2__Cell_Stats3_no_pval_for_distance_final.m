function Supplementary_Figure_2__Cell_Stats3_no_pval_for_distance_final()
close all;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];

filename=[sprintf('Revision_Supplementary_Figure_2__Cell_Stats')];

rel_roi=PAPER.ROILICK2DInclusion;

DATA=fetch1(PAPER.ConnectivityPaperFigure1datav7shuffle,'figure_data');
lickmap_regular_odd_vs_even_corr_threshold=0.25; % will only affect panel m
psth_regular_modulation_threshold=25; 

%             information_per_spike_regular_threshold=0.02; % will only affect panel m
D_tuned_temporal=DATA.D_tuned_temporal;
D_tuned_positional=DATA.D_tuned_positional;
D_tuned_temporal_and_positional=DATA.D_tuned_temporal_and_positional;
D_all=DATA.D_all;
D_tuned_positional_4bins=DATA.D_tuned_positional_4bins;
PSTH_all_temporal_and_positional=DATA.PSTH_all_temporal_and_positional;
psth_time = DATA.psth_time;

rel_example = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesExample*LICK2D.ROILick2DmapSpikesExample*LICK2D.ROILick2DmapPSTHSpikesExample*LICK2D.ROILick2DmapPSTHStabilitySpikesExample*LICK2D.ROILick2DmapStatsSpikesExample;
rel_example2 = rel_example;

PAPER_graphics_definition_Sup_Figure2

sigfnif_threshold_modulation=25;
sigfnif_threshold_stability=0.25;

% Temporal modulation
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
p_value_threshold=0.05;
hold on
% psth_regular_modulation = D_tuned_temporal.psth_regular_modulation;
% %shuffled
rel_temporal_signif_shuffled = LICK2D.ROILick2DPSTHSpikesShuffledDistribution  & rel_roi;
psth_regular_modulation_shuffled= cell2mat(fetchn(rel_temporal_signif_shuffled,'psth_regular_modulation_shuffled'));
% [hhh3,edges]=histcounts([psth_regular_modulation_shuffled(:)],linspace(0,100,15));
% hhh3=100*hhh3/sum(hhh3);
% bar(edges(1:end-1),hhh3,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5])
plot([mean(psth_regular_modulation_shuffled(:)),mean(psth_regular_modulation_shuffled(:))],[0,30],'Color',[0.5 0.5 0.5],'LineWidth',2);

%actual
psth_regular_modulation = fetchn( LICK2D.ROILick2DPSTHSpikesModulation &  (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi,'psth_regular_modulation');
[hhh3,edges]=histcounts([psth_regular_modulation],linspace(0,100,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor', [0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=30;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning modulation') newline '(%)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nmodulation'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% plot([sigfnif_threshold_modulation,sigfnif_threshold_modulation],yl,'Color',[1 0 0],'LineWidth',2);


% Location modulation
axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1])
hold on
p_value_threshold=0.05;
%shuffled
rel_positional_signif_shuffled = LICK2D.ROILick2DmapSpikesShuffledDistribution2  & rel_roi;
lickmap_fr_regular_modulation_shuffled= cell2mat(fetchn(rel_positional_signif_shuffled,'lickmap_fr_regular_modulation_shuffled'));
% [hhh3,edges]=histcounts([lickmap_fr_regular_modulation_shuffled(:)],linspace(0,100,15));
% hhh3=100*hhh3/sum(hhh3);
% bar(edges(1:end-1),hhh3,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5])
plot([mean(lickmap_fr_regular_modulation_shuffled(:)),mean(lickmap_fr_regular_modulation_shuffled(:))],[0,25],'Color',[0.5 0.5 0.5],'LineWidth',2);

%actual
lickmap_fr_regular_modulation = fetchn( LICK2D.ROILick2DmapSpikes3binsModulation &  (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi,'lickmap_fr_regular_modulation');
[hhh3,edges]=histcounts([lickmap_fr_regular_modulation],linspace(0,100,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor', [0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [0,100];
% text(xl(1)+diff(xl)*0.3, yl(1)+diff(yl)*0.9, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning modulation') newline '(%)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location tuning\nmodulation'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'b', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% plot([sigfnif_threshold_modulation,sigfnif_threshold_modulation],yl,'Color',[1 0 0],'LineWidth',2);


%% Field size
axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1])
% axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4])
[hhh2,edges]=histcounts([D_tuned_positional_4bins.field_size_without_baseline_regular],linspace(0,100,10));
% [hhh2,edges]=histcounts([D_tuned_positional.field_size_without_baseline_regular],linspace(0,100,10));
hhh2=100*hhh2/sum(hhh2);
bar(edges(1:end-1),hhh2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh2)];
yl(2)=30;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,sprintf('Peak width (%%)'), 'FontSize',6,'HorizontalAlignment','center');
            text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location \ntuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)-diff(yl)*0.2, sprintf('Location neurons\n           (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'c', ...
                'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');






%% Temporal tuning similarity,\nacross positions
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
hold on

%shuffled
p_value_threshold=0.05;
hold on
% psth_regular_modulation = D_tuned_temporal.psth_regular_modulation;

% %shuffled
% % rel_temporal_signif_shuffled = LICK2D.ROILick2DPSTHSpikesShuffledDistribution & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi;
% rel_temporal_signif_shuffled = LICK2D.ROILick2DPSTHSpikesShuffledDistribution  & rel_roi;
% psth_regular_odd_vs_even_corr_shuffled= cell2mat(fetchn(rel_temporal_signif_shuffled,'psth_regular_odd_vs_even_corr_shuffled'));
% [hhh3,edges]=histcounts([psth_regular_odd_vs_even_corr_shuffled(:)],linspace(-1,1,15));
% hhh3=100*hhh3/sum(hhh3);
% bar(edges(1:end-1),hhh3,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5])


%actual
psth_regular_odd_vs_even_corr = D_tuned_temporal.psth_regular_odd_vs_even_corr;
% psth_regular_odd_vs_even_corr = fetchn( LICK2D.ROILick2DPSTHStatsSpikes & rel_roi,'psth_regular_odd_vs_even_corr');
[hhh3,edges]=histcounts([psth_regular_odd_vs_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor', [0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=40;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nstability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'f', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% plot([sigfnif_threshold_stability,sigfnif_threshold_stability],yl,'Color',[1 0 0],'LineWidth',2);







axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])

%shuffled
p_value_threshold=0.05;
hold on
% psth_regular_modulation = D_tuned_temporal.psth_regular_modulation;
% 
% %shuffled
% % rel_temporal_signif_shuffled = LICK2D.ROILick2DPSTHSpikesShuffledDistribution & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi;
% rel_temporal_signif_shuffled = LICK2D.ROILick2DmapSpikesShuffledDistribution2  & rel_roi;
% psth_position_concat_regular_odd_even_corr_shuffled= cell2mat(fetchn(rel_temporal_signif_shuffled,'psth_position_concat_regular_odd_even_corr_shuffled'));
% [hhh3,edges]=histcounts([psth_position_concat_regular_odd_even_corr_shuffled(:)],linspace(-1,1,15));
% hhh3=100*hhh3/sum(hhh3);
% bar(edges(1:end-1),hhh3,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5])


%actual
hold on
psth_position_concat_regular_odd_even_corr = D_tuned_temporal_and_positional.psth_position_concat_regular_odd_even_corr;
% psth_position_concat_regular_odd_even_corr = fetchn( LICK2D.ROILick2DmapStatsSpikes3binsShort & rel_roi,'psth_position_concat_regular_odd_even_corr');
sigfnif_threshold=0.25;
[hhh3,edges]=histcounts([psth_position_concat_regular_odd_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor', [0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=30;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location-temporal \ntuning stability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*1, yl(1)+diff(yl)*1.5, 'g', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% plot([sigfnif_threshold_stability,sigfnif_threshold_stability],yl,'Color',[1 0 0],'LineWidth',2);




axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])

%shuffled
p_value_threshold=0.05;
hold on
% psth_regular_modulation = D_tuned_temporal.psth_regular_modulation;
% %shuffled
% % rel_temporal_signif_shuffled = LICK2D.ROILick2DPSTHSpikesShuffledDistribution & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi;
% rel_temporal_signif_shuffled = LICK2D.ROILick2DmapSpikesShuffledDistribution2  & rel_roi;
% lickmap_regular_odd_vs_even_corr_shuffled= cell2mat(fetchn(rel_temporal_signif_shuffled,'lickmap_regular_odd_vs_even_corr_shuffled'));
% [hhh3,edges]=histcounts([lickmap_regular_odd_vs_even_corr_shuffled(:)],linspace(-1,1,15));
% hhh3=100*hhh3/sum(hhh3);
% bar(edges(1:end-1),hhh3,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5])



%actual
hold on
% lickmap_regular_odd_vs_even_corr = fetchn( LICK2D.ROILick2DmapStatsSpikes3binsShort & rel_roi,'lickmap_regular_odd_vs_even_corr');
lickmap_regular_odd_vs_even_corr = D_tuned_positional.lickmap_regular_odd_vs_even_corr;
sigfnif_threshold=0.25;
[hhh3,edges]=histcounts([lickmap_regular_odd_vs_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor', [0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=20;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location tuning\nstability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'h', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% plot([sigfnif_threshold_stability,sigfnif_threshold_stability],yl,'Color',[1 0 0],'LineWidth',2);

% text(xl(1)+diff(xl)*0.9, yl(1)+diff(yl)*0.9, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);






%% Single cell PSTH by position examples -- fist behavioral day
% Example Cell 1 PSTH
roi_number_uid = 61658;
cell_number2d=1;
fn_plot_single_cell_psth_by_position_example_first_day (rel_example2,roi_number_uid , 0, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d);
text(-20, 10.5, 'd', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
title(sprintf('First behavioral session \n\n'), 'FontSize',6);

% Example Cell 2 PSTH
roi_number_uid = 61838; 
cell_number2d=2;
fn_plot_single_cell_psth_by_position_example_first_day(rel_example2,roi_number_uid, 1, 1, position_x1_grid(1), position_y1_grid(2), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 62177;
cell_number2d=3;
fn_plot_single_cell_psth_by_position_example_first_day(rel_example2,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(1), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 62007;
cell_number2d=4;
fn_plot_single_cell_psth_by_position_example_first_day(rel_example2,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(2), cell_number2d);


%colorbar
ax13=axes('position',[position_x1_grid(1)+0.09, position_y1_grid(1)+0.02, panel_width4/3, panel_height4/4]);
caxis([0,1])
colormap(ax13,inferno)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[0, 1],'TickLabels',[{'0','1'}], 'FontSize',6);
text(0.8,-0.8,sprintf('Activity (norm.)'), 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);


% %% What percentage of temporally tuned neurons are positiionally tuned in -- binned according to preferred temporal bin
% PSTH_all = PSTH_all./max(PSTH_all,[],2);
% [~,idx_max_time] = max(PSTH_all,[],2);
% peaktime_psth=psth_time(idx_max_time)';
% axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4])
% hold on
% time_bin_size=0.5;
% time_bins1 = floor(psth_time(1)):time_bin_size:ceil(psth_time(end));
% time_bins=time_bins1(1):time_bin_size:time_bins1(end);
% try
%     idx_positional =[D_tuned_temporal.lickmap_regular_odd_vs_even_corr>=lickmap_regular_odd_vs_even_corr_threshold];
% catch
%     idx_positional =[D_tuned_temporal.information_per_spike_regular>=information_per_spike_regular_threshold];
% end
% tuned_in_time_bins=[];
% for ib = 1:1:numel(time_bins)-1
%     idx_time_bin = peaktime_psth>=time_bins(ib) & peaktime_psth<time_bins(ib+1);
%     % percentage tuned in each time bin
%     if (100*sum(idx_time_bin)/numel(idx_time_bin))>1 % if there are less than 1% of total cells in the bin we set it to NaN, to avoid spurious values
%         tuned_in_time_bins(ib) =100*sum(idx_time_bin & idx_positional)/sum(idx_time_bin);
%     else
%         tuned_in_time_bins(ib)=NaN;
%     end
% end
% % yyaxis right
% 
% time_bins=time_bins1(1):time_bin_size:time_bins1(end);
% time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
% % plot(time_bins_centers,tuned_in_time_bins,'.-','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
% bar(time_bins_centers,tuned_in_time_bins,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
% % xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
% xl=[time_bins(1),time_bins(end)];
% xlim(xl);
% % yl=[0 ceil(max(tuned_in_time_bins))];
% yl=[0 70];
% 
% ylim(yl);
% % text(xl(1)-diff(xl)*0.4,yl(1)-diff(yl)*0.3, sprintf('Location neurons\n              (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
% text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*1.3,sprintf('Peak \nresponse-time',numel(peaktime_psth)),'HorizontalAlignment','left', 'FontSize',6,'FontWeight','bold');
% text(xl(1)+diff(xl)*0,yl(1)-diff(yl)*0.5,sprintf('Time to 1st \ncontact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
% set(gca,'Xtick',[0,5],'TickLength',[0.05,0.05],'TickDir','out');
% box off
% set(gca,'XTick',[0,5],'Ytick',[yl(1), yl(2)],'TickLength',[0.05,0], 'FontSize',6);
% text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.5, 'i', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% shuffle_value=100*sum(idx_positional)/numel(idx_positional);
% plot([time_bins_centers(1),time_bins_centers(end)],[shuffle_value shuffle_value],'-','LineWidth',1,'MarkerSize',5,'Color',[0.5 0.5 0.5])
% text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.85,sprintf('Expected'),'HorizontalAlignment','left', 'FontSize',6,'Color',[0.5 0.5 0.5]);
% text(xl(1)-diff(xl)*0.5,yl(1)-diff(yl)*0.2, sprintf('Location neurons\n           (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);

%% Location neurons that are also temporally tuned -- binned according to preferred temporal bin
PSTH_all_temporal_and_positional = PSTH_all_temporal_and_positional./max(PSTH_all_temporal_and_positional,[],2);
[~,idx_max_time] = max(PSTH_all_temporal_and_positional,[],2);
peaktime_psth=psth_time(idx_max_time)';
axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4])
hold on
% time_bin_size=0.5;
% time_bins1 = floor(psth_time(1)):time_bin_size:ceil(psth_time(end));
% time_bins=time_bins1(1):time_bin_size:time_bins1(end);

   100*sum(peaktime_psth<=1 & peaktime_psth>0)/numel(peaktime_psth)
      100*sum(peaktime_psth>=2)/numel(peaktime_psth)

[hhh1,edges]=histcounts(peaktime_psth,linspace(-1,6,15));
hhh1=100*hhh1/sum(hhh1);
bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh1)];
yl(2)=30;
xl = [floor(psth_time(1)) ceil(psth_time(end))];
xlim(xl);
ylim(yl);
text(xl(1)-diff(xl)*0.5,yl(1)-diff(yl)*0.2, sprintf('Location neurons\n           (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*1.3,sprintf('Peak \nresponse-time',numel(peaktime_psth)),'HorizontalAlignment','left', 'FontSize',6,'FontWeight','bold');
text(xl(1)+diff(xl)*0,yl(1)-diff(yl)*0.5,sprintf('Time to 1st \ncontact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
set(gca,'Xtick',[0,5],'Ytick',[0, yl(2)],'TickLength',[0.05,0.05],'TickDir','out', 'FontSize',6)
box off
text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.5, 'i', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Single cell PSTH by position examples - stability
% Example Cell 1 PSTH
roi_number_uid = 1260924;
cell_number2d=4;
fn_plot_single_cell_psth_by_position_example_with_stability (rel_example,roi_number_uid , 0, 1, position_x2_grid(1), position_y2_grid(1), cell_number2d);
text(-30, 20, 'e', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Example Cell 2 PSTH
roi_number_uid = 1261160; 
cell_number2d=5;
fn_plot_single_cell_psth_by_position_example_with_stability(rel_example,roi_number_uid, 1, 1, position_x2_grid(1), position_y2_grid(2), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 1261985;
cell_number2d=6;
fn_plot_single_cell_psth_by_position_example_with_stability(rel_example,roi_number_uid, 0, 0, position_x2_grid(2), position_y2_grid(1), cell_number2d);

% % Example Cell 4 PSTH
% roi_number_uid = 1261359;
% cell_number2d=10;
% fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 1, 1, position_x2_grid(1), position_y2_grid(2), cell_number2d);

% Example Cell 5 PSTH
roi_number_uid = 1260574;
cell_number2d=7;
fn_plot_single_cell_psth_by_position_example_with_stability(rel_example,roi_number_uid, 0, 0, position_x2_grid(2), position_y2_grid(2), cell_number2d);

% % Example Cell 6 PSTH
% roi_number_uid = 1261779; 
% cell_number2d=12;
% fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x2_grid(3), position_y2_grid(2), cell_number2d);


%% Tuning selection based on modulation/stability criteria (not p_value of shuffling)
idx_column_radius=2; %10 to 30 microns
%% Tuning versus anatomical dtstance   -- PSTH
key_distance.odd_even_corr_threshold=0.25;
rel_data_distance= (LICK2D.DistanceCorrPSTHSpikes4 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrPSTHSpikesShuffled4 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;
bins_eucledian_distance=D(1).lateral_distance_bins;
bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;

%lateral
distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));

%axial
distance_axial_all=[];
distance_axial_all_shuffled=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));

%eucledian
distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
d_eucledian_mean =  nanmean(distance_eucledian_all,1);
d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));

distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));

%% Eucledian
axes('position',[position_x5(1),position_y5(1), panel_width5, panel_height5])
% all sessions

% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0.5 0.5  0.5 ]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);

lineProps.col={[1 0 1]};
lineProps.LineStyle{1}='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% yl = [0, 0.15];
yl = [0, 0.25];

xl = [0,500];
% text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.5,sprintf('Tuning similarity vs.\n anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.1,sprintf('Temporal tuning'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');

xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.7, 'j', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

% %  
% %% Axial vs Lateral
% 
% axes('position',[position_x5(2),position_y5(1), panel_width5, panel_height5])
% hold on
% lineProps.col={[1 0 0]};
% lineProps.style='-';
% lineProps.width=0.25;
% mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% lineProps.col={[0 0 1]};
% lineProps.style='-';
% lineProps.width=0.25;
% mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% yl = [0.1, 0.25];
% xl = [0,120];
% % text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% % text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
% xlim(xl);
% ylim(yl)
% set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% box off;
% text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);


%% Tuning versus anatomical dtstance  -- MAP
key_distance.odd_even_corr_threshold=0.25;
rel_data_distance= (LICK2D.DistanceCorrMapSpikes4 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrMapSpikesShuffled4 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;
bins_eucledian_distance=D(1).lateral_distance_bins;
bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;

%lateral
distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));

%axial
distance_axial_all=[];
distance_axial_all_shuffled=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));

%eucledian
distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
d_eucledian_mean =  nanmean(distance_eucledian_all,1);
d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));

distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));

%% Eucledian
axes('position',[position_x5(1),position_y5(2), panel_width5, panel_height5])
% all sessions

% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0.5 0.5  0.5 ]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);

lineProps.col={[1 0 1]};
lineProps.LineStyle{1}='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% yl = [0, 0.15];
yl = [0, 0.25];

xl = [0,500];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.1,sprintf('    Location tuning'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'k', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.3, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

% %  
% %% Axial vs Lateral
% 
% axes('position',[position_x5(2),position_y5(2), panel_width5, panel_height5])
% hold on
% lineProps.col={[1 0 0]};
% lineProps.style='-';
% lineProps.width=0.16;
% mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% lineProps.col={[0 0 1]};
% lineProps.style='-';
% lineProps.width=0.25;
% mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% yl = [0, 0.16];
% xl = [0,120];
% text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% % text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
% xlim(xl);
% ylim(yl)
% set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% box off;
% text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
% 




%% With p_value for significance of temporally and location tuned cells
% idx_column_radius=2; %10 to 30 microns
% %% Tuning versus anatomical dtstance   -- PSTH
% rel_data_distance= (LICK2D.DistanceCorrConcatSpikes2 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% rel_data_shuffled_distance= (LICK2D.DistanceCorrConcatSpikesShuffled2 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% 
% 
% 
% key_distance.p_value_threshold=0.05;
% rel_data_distance= (LICK2D.DistanceCorrPSTHSpikes3 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% rel_data_shuffled_distance= (LICK2D.DistanceCorrPSTHSpikesShuffled3 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% D=fetch(rel_data_distance	 & key_distance,'*');
% D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
% bins_lateral_distance=D(1).lateral_distance_bins;
% bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
% bins_axial_distance=D(1).axial_distance_bins;
% bins_eucledian_distance=D(1).lateral_distance_bins;
% bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;
% 
% %lateral
% distance_lateral_all = cell2mat({D.distance_corr_lateral}');
% d_lateral_mean =  nanmean(distance_lateral_all,1);
% d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
% distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
% d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
% d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %axial
% distance_axial_all=[];
% distance_axial_all_shuffled=[];
% for i_s=1:1:size(D,1)
%     distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
%     distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
% end
% d_axial_mean1 =  nanmean(distance_axial_all,1);
% d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
% d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
% d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %eucledian
% distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
% d_eucledian_mean =  nanmean(distance_eucledian_all,1);
% d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));
% 
% distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
% d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
% d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %% Eucledian
% axes('position',[position_x5(1),position_y5(1), panel_width5, panel_height5])
% % all sessions
% 
% % shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
% lineProps.col={[0.5 0.5  0.5 ]};
% lineProps.style='-';
% lineProps.width=0.25;
% mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);
% 
% lineProps.col={[1 0 1]};
% lineProps.LineStyle{1}='-';
% lineProps.width=0.25;
% mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% % yl = [0, 0.15];
% yl = [0, 0.25];
% 
% xl = [0,500];
% % text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
% text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.5,sprintf('Tuning similarity vs.\n anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.1,sprintf('Temporal tuning'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
% 
% xlim(xl);
% ylim(yl)
% set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% box off;
% text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.7, 'j', ...
%         'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
% %  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
% 
% % %  
% % %% Axial vs Lateral
% % 
% % axes('position',[position_x5(2),position_y5(1), panel_width5, panel_height5])
% % hold on
% % lineProps.col={[1 0 0]};
% % lineProps.style='-';
% % lineProps.width=0.25;
% % mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% % lineProps.col={[0 0 1]};
% % lineProps.style='-';
% % lineProps.width=0.25;
% % mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% % yl = [0.1, 0.25];
% % xl = [0,120];
% % % text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% % % text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
% % xlim(xl);
% % ylim(yl)
% % set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% % box off;
% % text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
% %  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
% 
% 
% %% Tuning versus anatomical dtstance  -- MAP
% key_distance.p_value_threshold=0.05;
% rel_data_distance= (LICK2D.DistanceCorrMapSpikes3 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% rel_data_shuffled_distance= (LICK2D.DistanceCorrMapSpikesShuffled3 *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
% D=fetch(rel_data_distance	 & key_distance,'*');
% D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
% bins_lateral_distance=D(1).lateral_distance_bins;
% bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
% bins_axial_distance=D(1).axial_distance_bins;
% bins_eucledian_distance=D(1).lateral_distance_bins;
% bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;
% 
% %lateral
% distance_lateral_all = cell2mat({D.distance_corr_lateral}');
% d_lateral_mean =  nanmean(distance_lateral_all,1);
% d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
% distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
% d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
% d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %axial
% distance_axial_all=[];
% distance_axial_all_shuffled=[];
% for i_s=1:1:size(D,1)
%     distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
%     distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
% end
% d_axial_mean1 =  nanmean(distance_axial_all,1);
% d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
% d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
% d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %eucledian
% distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
% d_eucledian_mean =  nanmean(distance_eucledian_all,1);
% d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));
% 
% distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
% d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
% d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));
% 
% %% Eucledian
% axes('position',[position_x5(1),position_y5(2), panel_width5, panel_height5])
% % all sessions
% 
% % shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
% lineProps.col={[0.5 0.5  0.5 ]};
% lineProps.style='-';
% lineProps.width=0.25;
% mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);
% 
% lineProps.col={[1 0 1]};
% lineProps.LineStyle{1}='-';
% lineProps.width=0.25;
% mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% % yl = [0, 0.15];
% yl = [0, 0.25];
% 
% xl = [0,500];
% text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
% text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.1,sprintf('    Location tuning'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
% xlim(xl);
% ylim(yl)
% set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% box off;
% text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'k', ...
%         'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.3, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
% %  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
% 
% % %  
% % %% Axial vs Lateral
% % 
% % axes('position',[position_x5(2),position_y5(2), panel_width5, panel_height5])
% % hold on
% % lineProps.col={[1 0 0]};
% % lineProps.style='-';
% % lineProps.width=0.16;
% % mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% % lineProps.col={[0 0 1]};
% % lineProps.style='-';
% % lineProps.width=0.25;
% % mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% % yl = [0, 0.16];
% % xl = [0,120];
% % text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% % % text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
% % xlim(xl);
% % ylim(yl)
% % set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
% % box off;
% % text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
% %  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
% % 

%% Signficiance across sessions

rel_roi=PAPER.ROILICK2DInclusion & (LAB.Subject & (EXP2.SessionBehavioral & 'behavioral_session_number>=5'));

% significance based on modulation p-value
%---------------------------------------------
p_value_threshold=0.05;

rel_temporal_signif = rel_roi  ...
  &   (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold));

rel_positional_signif = rel_roi  ...
    &  (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

rel_modulation_temporal_signif = (LICK2D.ROILick2DPSTHSpikesModulation) ...
    & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold))  ...
    & rel_roi;

rel_modulation_positional_signif = (LICK2D.ROILick2DmapSpikes3binsModulation)  ...
   & (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold)) ...
    & rel_roi;


percent_signif_days_temporal_mean=[];
percent_signif_days_temporal_stem=[];

percent_signif_days_positional_mean=[];
percent_signif_days_positional_stem=[];

modulation_signif_days_temporal_mean=[];
modulation_signif_days_temporal_stem=[];

modulation_signif_days_positional_mean=[];
modulation_signif_days_positional_stem=[];


max_number_days=5;
for i_d=1:1:max_number_days
    key.behavioral_session_number=i_d;
    rel_current_behavioral_day = EXP2.SessionBehavioral*EXP2.SessionID & rel_roi & key;
    keys=fetch(rel_current_behavioral_day);
    total_count=[];
    temporal_count=[];
    positional_count=[];
    temporal_modulation=[];
    positional_modulation=[];
    % looping across sessions in this day
    for i_k=1:1:numel(keys)
        % percentages of significant cells by day
        temp_rel=rel_roi & rel_current_behavioral_day & keys(i_k);
        total_count(i_k)=temp_rel.count;
        
        temp_rel_temporal=rel_temporal_signif & rel_current_behavioral_day & keys(i_k);
        temporal_count(i_k)=temp_rel_temporal.count;
        
        temp_rel_pos=rel_positional_signif & rel_current_behavioral_day & keys(i_k);
        positional_count(i_k)=temp_rel_pos.count;
        
        % modulation of significant cells by day
        temporal_modulation(i_k)=nanmean(fetchn(rel_modulation_temporal_signif & temp_rel_temporal,'psth_regular_modulation'));
        positional_modulation(i_k)=nanmean(fetchn(rel_modulation_positional_signif & temp_rel_pos,'lickmap_fr_regular_modulation'));
        
        
    end
    
    % mean and stem across sessions on this day (sessions correspond to different animals recorded on this day) 
    percent_signif_days_temporal_mean(i_d)=mean(100*temporal_count./total_count);
    percent_signif_days_temporal_stem(i_d)=std(100*temporal_count./total_count)/sqrt(numel(total_count));
    
    percent_signif_days_positional_mean(i_d)=mean(100*positional_count./total_count);
    percent_signif_days_positional_stem(i_d)=std(100*positional_count./total_count)/sqrt(numel(total_count));

    
    
    modulation_signif_days_temporal_mean(i_d)=mean(temporal_modulation);
    modulation_signif_days_temporal_stem(i_d)=std(temporal_modulation)/sqrt(numel(temporal_modulation));
    
    modulation_signif_days_positional_mean(i_d)=mean(mean(positional_modulation));
    modulation_signif_days_positional_stem(i_d)=std(positional_modulation)/sqrt(numel(positional_modulation));

end

% Percentage of signifcant cells
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1*1.5])
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb(1:max_number_days,percent_signif_days_temporal_mean,percent_signif_days_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb(1:max_number_days,percent_signif_days_positional_mean,percent_signif_days_positional_stem,lineProps);
xlabel('Sessions');
ylabel('Tuned cells (%)');
% legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])
xlim([1,max_number_days]);
set(gca,'Xtick',[1,max_number_days]);

% Modulation of signficant cells
axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1*1.5])
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb(1:max_number_days,modulation_signif_days_temporal_mean,modulation_signif_days_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb(1:max_number_days,modulation_signif_days_positional_mean,modulation_signif_days_positional_stem,lineProps);
xlabel('Sessions');
ylabel('Tuning modulation (%)');
% legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
xlim([1,max_number_days])
ylim([0,100])
set(gca,'Xtick',[1,max_number_days]);





%% Signficiance across blocks
rel_roi=PAPER.ROILICK2DInclusion & (LAB.Subject & (EXP2.SessionBehavioral & 'behavioral_session_number>=5'));

% significance based on modulation p-value
%---------------------------------------------
p_value_threshold=0.05;
rel_signif_temporal = LICK2D.ROILick2DPSTHStatsSpikes & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold)) & rel_roi;
rel_signif_positional = LICK2D.ROILick2DmapStatsSpikes3binsShort & (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold))  & rel_roi;


percent_signif_blocks_temporal_mean=[];
percent_signif_blocks_temporal_stem=[];

percent_signif_blocks_positional_mean=[];
percent_signif_blocks_positional_stem=[];

modulation_signif_blocks_temporal_mean=[];
modulation_signif_blocks_temporal_stem=[];

modulation_signif_blocks_positional_mean=[];
modulation_signif_blocks_positional_stem=[];


keys=   fetch(EXP2.SessionEpoch & rel_roi & 'session_epoch_number=3' & 'session_epoch_type="behav_only"');

number_blocks=4;
for i_b=1:1:number_blocks
   
  
    
    total_count=[];
    temporal_count=[];
    positional_count=[];
    temporal_modulation=[];
    positional_modulation=[];
    
   
    % looping across sessions 
    for i_k=1:1:numel(keys)
        % percentages of significant cells by block
        temp_rel=rel_roi  & keys(i_k);
        total_count(i_k)=temp_rel.count;
        
        temp_rel_temporal= rel_signif_temporal  & keys(i_k);
        temporal_count(i_k)=temp_rel_temporal.count;
        
        temp_rel_pos=rel_signif_positional & keys(i_k);
        positional_count(i_k)=temp_rel_pos.count;
        
        % modulation of significant cells by block
        if i_b==1
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_first_modulation'));
            positional_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_first_modulation'));
        elseif i_b==2
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_begin_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_begin_modulation'));
        elseif i_b==3
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_mid_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_mid_modulation'));
        elseif i_b==4
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_end_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_end_modulation'));
        end
        
        
    end
    
    percent_signif_blocks_temporal_mean(i_b)=mean(100*temporal_count./total_count);
    percent_signif_blocks_temporal_stem(i_b)=std(100*temporal_count./total_count)/sqrt(numel(total_count));
    
    percent_signif_blocks_positional_mean(i_b)=mean(100*positional_count./total_count);
    percent_signif_blocks_positional_stem(i_b)=std(100*positional_count./total_count)/sqrt(numel(total_count));

    
    modulation_signif_blocks_temporal_mean(i_b)=mean(temporal_modulation);
    modulation_signif_blocks_temporal_stem(i_b)=std(temporal_modulation)/sqrt(numel(temporal_modulation));
    
    modulation_signif_blocks_positional_mean(i_b)=mean(nanmean(positional_modulation));
    modulation_signif_blocks_positional_stem(i_b)=nanstd(positional_modulation)/sqrt(numel(positional_modulation));

end

% The percent of significant cells per block doesn't make much sense
% because significance is computed globally (p-value of the entire tuning, not of tuining in block)

% % Percentage of signifcant cells
% subplot(2,2,1)
% hold on
% hold on
% lineProps.col={[1 0 0]};
% lineProps.style='-';
% lineProps.width=0.25;
% %temporal red
% mseb([1,3,4,7],percent_signif_blocks_temporal_mean,percent_signif_blocks_temporal_stem,lineProps);
% lineProps.col={[0 0 1]};
% lineProps.style='-';
% lineProps.width=0.25;
% %positional blue
% mseb([1,3,4,7],percent_signif_blocks_positional_mean,percent_signif_blocks_positional_stem,lineProps);
% xlabel('Trial in Block');
% ylabel('Tuned cells (%)');
% legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
% ylim([0,100])
% xlim([1,7]);
% box off;

% Modulation of signficant cells
axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1*1.5])
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb([1,3,4,7],modulation_signif_blocks_temporal_mean,modulation_signif_blocks_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb([1,3,4,7],modulation_signif_blocks_positional_mean,modulation_signif_blocks_positional_stem,lineProps);
xlabel('Trial number in Block');
ylabel('Tuning modulation (%)');
% legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])
xlim([1,7]);
box off;
text(1.35, 40, 'Temporal tuning', ...
    'fontsize', 9, 'fontname', 'helvetica','Color',[1 0 0],'HorizontalAlignment','left');
text(1.5, 20, 'Location tuning', ...
    'fontsize', 9, 'fontname', 'helvetica','Color',[0 0 1],'HorizontalAlignment','left');


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




