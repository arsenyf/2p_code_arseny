function Figure2_v1
close all;

rel_roi=(IMG.ROIGood-IMG.ROIBad) -IMG.Mesoscope;
% rel_stats= LICK2D.ROILick2DmapStatsSpikes3bins*LICK2D.ROILick2DPSTHStatsSpikes* LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins & rel_roi;
% rel_stats= LICK2D.ROILick2DmapStatsSpikes*LICK2D.ROILick2DPSTHStatsSpikes* LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes2 & rel_roi ...
%     & 'number_of_bins=4';

% rel_roi2= rel_roi & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>0.5');
rel_stats1= LICK2D.ROILick2DPSTHStatsSpikesLongerInterval*IMG.ROIID & rel_roi & 'psth_regular_odd_vs_even_corr>=-1';
rel_stats2= LICK2D.ROILick2DmapStatsSpikes3bins*IMG.ROIID & rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>=-1') ;
rel_stats3= LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins*IMG.ROIID & rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>=-1') ;

rel_stats3_4bins= (LICK2D.ROILick2DmapStatsSpikes & 'number_of_bins=4')*IMG.ROIID & rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>=-1') ;


rel_psth = LICK2D.ROILick2DPSTHSpikesLongerInterval*IMG.ROIID & rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'psth_regular_odd_vs_even_corr>=-1') ;

% rel_stats=rel_stats & 'psth_position_concat_regular_odd_even_corr>0.1';

rel_example = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesExample*LICK2D.ROILick2DmapSpikesExample*LICK2D.ROILick2DmapPSTHSpikesExample*LICK2D.ROILick2DmapPSTHStabilitySpikesExample*LICK2D.ROILick2DmapStatsSpikesExample;
rel_example_psth = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesLongerInterval;


rel_map_single_session    = (LICK2D.ROILick2DmapSpikes*LICK2D.ROILick2DmapStatsSpikes *IMG.ROIID) & rel_roi & 'psth_position_concat_regular_odd_even_corr>=0.5';
key_single_session.subject_id = 486668;
key_single_session.session = 5;

key_fov_example.subject_id = 480483;
key_fov_example.session = 2;
key_fov_example.session_epoch_type='behav_only';


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure2')];
%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

%% behavior cartoon
panel_width1=0.12;
panel_height1=0.12;
horizontal_dist1=0.1;
vertical_dist1=0.1;
position_x1(1)=0.0675;
position_y1(1)=0.78;



% PSTH - position averaged
panel_width2=0.03;
panel_height2=0.03;
horizontal_dist2=0.04;
vertical_dist2=0.045;
position_x2(1)=0.47+0.12;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2*1.9;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.82;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

position_y22=0.784;

% Histograms
panel_width3=0.05;
panel_height3=0.04;
horizontal_dist3=0.1;
vertical_dist3=0.1;
position_x3(1)=0.1;
position_x3(end+1)=position_x3(end)+horizontal_dist3*0.4;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;

position_y3(1)=0.5;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;


% 2d tuning on grid
horizontal_dist_between_cells_grid1=0.085;
vertical_dist_between_cells_grid1=0.09;

position_x1_grid(1)=0.1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;

position_y1_grid(1)=0.67;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;



%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 72456;
cell_number=1;
panel_legend='f';
psth_time = fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1343791;
cell_number=2;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 3 PSTH
axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1255801;
cell_number=3;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1326983;
cell_number=4;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 1, 1,panel_legend, cell_number);

% Example Cell 5 PSTH
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1294286;
cell_number=5;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 6 PSTH
axes('position',[position_x2(3),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1354700;
cell_number=6;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

%% Single cell PSTH by position examples
% Example Cell 1 PSTH
roi_number_uid = 1260924;
cell_number2d=7;
fn_plot_single_cell_psth_by_position_example (rel_example,roi_number_uid , 0, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d);
text(-30, 1.75, 'h', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Example Cell 2 PSTH
roi_number_uid = 1261160; 
cell_number2d=8;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(1), cell_number2d);

% Example Cell 3 PSTH
roi_number_uid = 1261985;
cell_number2d=9;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(3), position_y1_grid(1), cell_number2d);

% Example Cell 4 PSTH
roi_number_uid = 1261359;
cell_number2d=10;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 1, 1, position_x1_grid(1), position_y1_grid(2), cell_number2d);

% Example Cell 5 PSTH
roi_number_uid = 1260574;
cell_number2d=11;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(2), position_y1_grid(2), cell_number2d);

% Example Cell 6 PSTH
roi_number_uid = 1261779; 
cell_number2d=12;
fn_plot_single_cell_psth_by_position_example(rel_example,roi_number_uid, 0, 0, position_x1_grid(3), position_y1_grid(2), cell_number2d);



%% fetching stats

% D.psth_regular_odd_vs_even_corr=fetchn(rel_stats1, 'psth_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
% D.psth_position_concat_regular_odd_even_corr=fetchn(rel_stats2, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
% D.information_per_spike_regular=fetchn(rel_stats2, 'information_per_spike_regular','ORDER BY roi_number_uid');
% D.field_size_regular=fetchn(rel_stats2, 'field_size_regular','ORDER BY roi_number_uid');
% D.preferred_bin_regular=fetchn(rel_stats2, 'preferred_bin_regular','ORDER BY roi_number_uid');
D.lickmap_regular_odd_vs_even_corr=fetchn(rel_stats2, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
% D.psth_corr_across_position_regular=fetchn(rel_stats3, 'psth_corr_across_position_regular','ORDER BY roi_number_uid');

D_tuned.field_size_regular=fetchn(rel_stats2 & 'lickmap_regular_odd_vs_even_corr>=0.75', 'field_size_regular','ORDER BY roi_number_uid');
D_tuned.psth_corr_across_position_regular=fetchn(rel_stats3 & (LICK2D.ROILick2DmapStatsSpikes3bins & 'lickmap_regular_odd_vs_even_corr>=0.75'), 'psth_corr_across_position_regular','ORDER BY roi_number_uid');

D_tuned_4bins.preferred_bin_regular=fetchn(rel_stats3_4bins & 'lickmap_regular_odd_vs_even_corr>=0.75', 'preferred_bin_regular','ORDER BY roi_number_uid');

%% Plotting Stats
%--------------------------------

%% PSTH of all cells
ax5=axes('position',[position_x2(4),position_y22(1), panel_width3, panel_height3]);
PSTH_all = cell2mat(fetchn(rel_psth,'psth_regular','ORDER BY roi_number_uid'));
PSTH_all2 = fetch(rel_psth,'psth_regular','ORDER BY roi_number_uid');

PSTH_all = PSTH_all./max(PSTH_all,[],2);
[~,idx_max_time] = max(PSTH_all,[],2);
peaktime_psth=psth_time(idx_max_time)';

[~, idx_neurons_sorted] = sort(idx_max_time);
imagesc(psth_time,[],PSTH_all(idx_neurons_sorted,:))
colormap(ax5,inferno)
xl = [floor(psth_time(1)) ceil(psth_time(end))];
yl =[0 numel(idx_neurons_sorted)];
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.5, sprintf('Time to 1st \ncontact-lick (s)'), 'FontSize',6,'HorizontalAlignment','Center');
text(-2.5,numel(idx_neurons_sorted),sprintf('Neurons'),'Rotation',90, 'FontSize',6);
set(gca,'XTick',[0,5],'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
% set(gca,'XTick',[0,xl(end)],'Ytick',[1, 100000],'YtickLabel',[{'1', '100,000'}],'TickLength',[0.05,0], 'FontSize',6);

%colorbar
ax8=axes('position',[position_x2(5),position_y22(1), panel_width3, panel_height3]);
colormap(ax8,inferno)
cb1 = colorbar();
axis off
set(cb1,'Ticks',[0, 1], 'FontSize',6);
text(4.1,0.5,sprintf('Activity (norm.)'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','Center');
set(gca, 'FontSize',6);

%% Preferred time all PSTHs
axes('position',[position_x2(4),position_y22(1)+0.04, panel_width3, panel_height3*0.5])
% h=histogram(psth_time(idx_max_time),10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
[hhh1,edges]=histcounts(peaktime_psth,linspace(-1,6,15));
hhh1=100*hhh1/sum(hhh1);
bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh1)];
yl(2)=20;
xl = [floor(psth_time(1)) ceil(psth_time(end))];
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.5,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl);
set(gca,'XTick',[],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
title(sprintf('Temporal tuning\n%d cells',numel(peaktime_psth)), 'FontSize',6);
text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.75, 'g', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

%% Preferred time histogram
axes('position',[position_x4(1),position_y4(2), panel_width4, panel_height4])
hold on
time_bin_size=0.5;
time_bins1 = floor(psth_time(1)):time_bin_size:ceil(psth_time(end));
time_bins=time_bins1(1):time_bin_size:time_bins1(end);
% time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
% a=histogram(peaktime_psth,time_bins);
% y =100*a.BinCounts/numel(peaktime_psth);
% % y =100*a.BinCounts/sum(a.BinCounts);
% % BinCounts=a.BinCounts;
% yyaxis left
% bar(time_bins_centers,y);
% % title(sprintf('Response time of tuned neurons'));
% xlabel(sprintf('Peak response time of neurons\n relative to first lick ,\nafter lickport move (s)'));
% 
% ylabel(sprintf('Temporally tuned\n neurons (%%)'));
% set(gca,'Xtick',[time_bins(1),0,time_bins(end)],'TickLength',[0.05,0.05],'TickDir','out');
% box off
% xlim([time_bins(1),time_bins(end)]);
% ylim([0 ceil(max(y))]);
% 
% % of directionally tuned cells as a function of preferred PSTH time
% % axes('position',[position_x2(4)+0.15, position_y2(2), panel_width2, panel_height2]);
% %     idx_directional = M.theta_tuning_odd_even_corr>threshold_theta_tuning_odd_even_corr & M.goodness_of_fit_vmises>threshold_goodness_of_fit_vmises & M.rayleigh_length>threshold_rayleigh_length;
% % idx_positional = [D.lickmap_regular_odd_vs_even_corr]>=0.5; [D.information_per_spike_regular]>=0.05 & [D.psth_position_concat_regular_odd_even_corr]>=0.25;
idx_positional =[D.lickmap_regular_odd_vs_even_corr>=0.75];

tuned_in_time_bins=[];
for ib = 1:1:numel(time_bins)-1
    idx_time_bin = peaktime_psth>=time_bins(ib) & peaktime_psth<time_bins(ib+1);
    % percentage tuned in each time bin
    if (100*sum(idx_time_bin)/numel(idx_time_bin))>1 % if there are less than 1% of total cells in the bin we set it to NaN, to avoid spurious values
        tuned_in_time_bins(ib) =100*sum(idx_time_bin & idx_positional)/sum(idx_time_bin);
    else
        tuned_in_time_bins(ib)=NaN;
    end
end
% yyaxis right

time_bins=time_bins1(1):time_bin_size:time_bins1(end);
time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
% plot(time_bins_centers,tuned_in_time_bins,'.-','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
bar(time_bins_centers,tuned_in_time_bins,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
% xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
xl=[time_bins(1),time_bins(end)];
xlim(xl);
yl=[0 ceil(max(tuned_in_time_bins))];
ylim(yl);
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.3, sprintf('Position neurons\n              (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*1.3,sprintf('Preferred \nresponse-time',numel(peaktime_psth)),'HorizontalAlignment','left', 'FontSize',6,'FontWeight','bold');
text(xl(1)+diff(xl)*0,yl(1)-diff(yl)*0.5,sprintf('Time to 1st \ncontact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
set(gca,'Xtick',[0,5],'TickLength',[0.05,0.05],'TickDir','out');
box off
set(gca,'XTick',[0,5],'Ytick',[yl(1), yl(2)],'TickLength',[0.05,0], 'FontSize',6);
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.35, 'm', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
    shuffle_value=100*sum(idx_positional)/numel(idx_positional);
plot([time_bins_centers(1),time_bins_centers(end)],[shuffle_value shuffle_value],'-','LineWidth',1,'MarkerSize',5,'Color',[0.5 0.5 0.5])
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.7,sprintf('Expected'),'HorizontalAlignment','left', 'FontSize',6,'Color',[0.5 0.5 0.5]);



%% Field size
axes('position',[position_x4(1),position_y4(1), panel_width4, panel_height4])
[hhh2,edges]=histcounts([D_tuned.field_size_regular],linspace(0,100,10));
hhh2=100*hhh2/sum(hhh2);
bar(edges(1:end-1),hhh2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh2)];
yl(2)=50;
xl = [0,110];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4,sprintf('Field size (%%)'), 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional \ntuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.5, 'j', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');



%% Preferred positions
ax10=axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4]);
bin_mat_coordinate_hor= repmat([1:1:4],4,1);
bin_mat_coordinate_ver= repmat([1:1:4]',1,4);
[preferred_bin_mat] = histcounts2(bin_mat_coordinate_ver([D_tuned_4bins.preferred_bin_regular]),bin_mat_coordinate_hor([D_tuned_4bins.preferred_bin_regular]),[1:1:4+1],[1:1:4+1]);
preferred_bin_mat=100*preferred_bin_mat./sum(preferred_bin_mat(:));
mmm=imagesc([-1,0,1],[-1,0,1],preferred_bin_mat);
yl=[0, max(20,ceil(nanmax(preferred_bin_mat(:))))];
caxis(yl)
colormap(ax10,jet2);
text(0,2,sprintf('Preferred\npositions'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
axis equal
axis tight
set(gca,'YDir','normal', 'FontSize',6);
axis off
text(-2, 2.7, 'k', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
%colorbar
ax11=axes('position',[position_x4(2)+0.035,position_y4(1), panel_width4, panel_height4]);
caxis(yl)
colormap(ax11,jet2)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[yl],'TickLabels',[yl], 'FontSize',6);
text(4.5,0.3,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);


%% Temporal tuning similarity,\nacross positions
axes('position',[position_x4(3),position_y4(1), panel_width4, panel_height4])
[hhh3,edges]=histcounts([D_tuned.psth_corr_across_position_regular],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=20;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') '{\it r}'  newline 'across positions'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning,\nsimilarity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.5, 'l', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Tuning versus anatomical dtstance
key_distance.odd_even_corr_threshold=0.25;
rel_data_distance= (LICK2D.DistanceCorrConcatSpikes2 *EXP2.SessionID & 'num_cells_included>=100') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrConcatSpikes2Shuffled *EXP2.SessionID & 'num_cells_included>=100') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;

%% Lateral
axes('position',[position_x5(1),position_y5(2), panel_width5, panel_height5])
% all sessions

distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));
% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,lineProps);

distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
lineProps.col={[1 0 0]};
lineProps.LineStyle{1}='-';
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
% shadedErrorBar(bins_lateral_center,d_lateral_mean,d_lateral_stem,'lineprops',{'.-','Color',[1 0 0]});

% yl = [0, 0.15];
yl = [0, 0.25];

xl = [0,500];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.3,sprintf('Tuning similarity vs. anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'n', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.25, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Lateral',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

%% Axial 
axes('position',[position_x5(2),position_y5(2), panel_width5, panel_height5])
hold on
% all sessions
idx_column_radius=2; %10 to 30 microns
distance_axial_all=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
% yl = [0, 0.15];
yl = [0, 0.25];
xl = [0,120];
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% shadedErrorBar(bins_axial_distance,d_axial_mean1,d_axial_stem1,'lineprops',{'.-','Color',[0 0 1]})
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1_shuffled,d_axial_stem_shuffled1,lineProps);
% shadedErrorBar(bins_axial_distance,d_axial_mean1_shuffled,d_axial_stem_shuffled1,'lineprops',{'.-','Color',[0 0 0]})
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60, 120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.25, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
 text(xl(1)+diff(xl)*0.1, yl(1)+diff(yl)*0.6, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[.25 .25 1]);
 
%% Axial vs Lateral

axes('position',[position_x5(3),position_y5(2), panel_width5, panel_height5])
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
% shadedErrorBar(bins_lateral_center,d_lateral_mean,d_lateral_stem,'lineprops',{'.-','Color',[1 0 0]})
% shadedErrorBar(bins_axial_distance,d_axial_mean1,d_axial_stem1,'lineprops',{'.-','Color',[0 0 1]})
% plot(bins_lateral_center,d_lateral_mean,'.-r')
% plot(bins_axial_distance,d_axial_mean1,'.-b')
% yl = [0.05, 0.15];
yl = [0.1, 0.25];
xl = [0,120];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.9, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
 
if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




