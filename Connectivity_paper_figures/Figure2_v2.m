function Figure2_v2
close all;
lickmap_regular_odd_vs_even_corr_threshold=0.25; 

DATA=fetch1(PAPER.ConnectivityPaperFigure2datav1,'figure_data');
DATA.D_positional_and_reward=DATA.D_positional_and_reward;
DATA.D_reward=DATA.D_reward;
DATA.D_venn_reward_positional=DATA.D_venn_reward_positional	;

idx_large1 = [DATA.D_positional_and_reward.reward_mean_pval_regular_large<=0.05];
idx_small1 = [DATA.D_positional_and_reward.reward_mean_pval_regular_small<=0.05];

idx_large2 = [DATA.D_reward.reward_mean_pval_regular_large<=0.05];
idx_small2 = [DATA.D_reward.reward_mean_pval_regular_small<=0.05];

idx_positional =DATA.D_reward.lickmap_regular_odd_vs_even_corr >lickmap_regular_odd_vs_even_corr_threshold;
% idx_positional =DATA.D_reward.psth_position_concat_regular_odd_even_corr >lickmap_regular_odd_vs_even_corr_threshold;
% idx_positional =DATA.D_reward.information_per_spike_regular >0.02;


rel_example = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesExample*LICK2D.ROILick2DmapSpikesExample*LICK2D.ROILick2DmapPSTHSpikesExample*LICK2D.ROILick2DmapPSTHStabilitySpikesExample*LICK2D.ROILick2DmapStatsSpikesExample;
rel_example_psth = IMG.ROIID*LICK2D.ROILick2DPSTHSpikesLongerInterval;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure2_v2')];

PAPER_graphics_definition_Figure2

%% Behavior cartoon
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
xl = [0 2680];
yl = [0 1500];
fig1_a = imread([dir_embeded_graphics 'Figure1_behavior_cartoon.tif']);
% fig1_a=flipdim(fig1_a,1);
imagesc(fig1_a);
set(gca,'Xlim',xl,'Ylim',yl);
text(xl(1)+diff(xl)*0.1, yl(1)+diff(yl)*0.1, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'vS1','FontSize',8,'FontWeight','bold','Color',[0 1 0],'HorizontalAlignment','center');
axis off;
axis tight;
axis equal;

%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 77559;
cell_number=1;
panel_legend='b';
psth_time = fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 1291943;
cell_number=2;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 3 PSTH
axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 77887; %1264855
cell_number=3;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1278002;% 1350575;
cell_number=4;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 1, 1,panel_legend, cell_number);

% Example Cell 5 PSTH
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 1261795;
cell_number=5;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

% Example Cell 6 PSTH
axes('position',[position_x2(3),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 65169;
cell_number=6;
fn_plot_single_cell_psth_example_reward(rel_example_psth,roi_number_uid, 0, 0,panel_legend, cell_number);

%% Single cell PSTH by position examples
% Example Cell 1 PSTH
roi_number_uid = 77559;
cell_number2d=1;
% fn_plot_single_cell_psth_by_position_example_fig2 (rel_example,roi_number_uid , 1, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d);
fn_plot_single_cell_psth_by_position_example_reward (rel_example,roi_number_uid , 1, 1, position_x1_grid(1), position_y1_grid(1), cell_number2d, []);
text(-25, 1.85, 'c', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

% Example Cell 2 PSTH
roi_number_uid = 1291943; 
cell_number2d=2;
fn_plot_single_cell_psth_by_position_example_reward (rel_example,roi_number_uid , 0, 0, position_x1_grid(2), position_y1_grid(1), cell_number2d, []);

% Example Cell 2 PSTH
roi_number_uid = 65169; 
cell_number2d=6;
cell_legend_position_flag=0;
[psth_max_all] = fn_plot_single_cell_psth_by_position_example_reward (rel_example,roi_number_uid , 0, 0, position_x1_grid(4), position_y1_grid(1), cell_number2d, cell_legend_position_flag);
fn_plot_single_cell_psth_by_position_example_fig2 (rel_example,roi_number_uid , 0, 0, position_x1_grid(3), position_y1_grid(1), cell_number2d, psth_max_all);






%% Stats


%% Venn diagram
axes('position',[position_x3(3),position_y3(1)-0.02, panel_width3*1.8, panel_height3*1.8])
DATA.D_venn_reward_positional;
count_total=DATA.D_venn_reward_positional.count_total;
A_count_largereward=DATA.D_venn_reward_positional.A_count_largereward;
B_count_smallreward=DATA.D_venn_reward_positional.B_count_smallreward;
C_count_positional=DATA.D_venn_reward_positional.C_count_positional;
AB=DATA.D_venn_reward_positional.AB;
AC=DATA.D_venn_reward_positional.AC;
BC=DATA.D_venn_reward_positional.BC;
ABC=DATA.D_venn_reward_positional.ABC;

percentage_large_reward = A_count_largereward/count_total
percentage_small_reward = B_count_smallreward/count_total
percentage_reward_position_conjunctive = numel(DATA.D_positional_and_reward.field_size_large)/count_total

[h,v]=venn([A_count_largereward,B_count_smallreward,C_count_positional], [AB, AC, BC, ABC],'FaceColor',{[1 0.5 0],[0 0.7 0.2],[0 0 1]});

%by itself plots circles with total areas A, and intersection area(s) I. 
% A is a three element vector [c1 c2 c3], and I is a four element vector [i12 i13 i23 i123], specifiying the two-circle intersection areas i12, i13, i23, and the three-circle intersection i123.
for i_v=1:1:numel(v.ZonePop)
text(v.ZoneCentroid(i_v,1)-v.ZoneCentroid(i_v,1)*0.2,v.ZoneCentroid(i_v,2),sprintf('%.0f%%',(100*v.ZonePop(i_v)/count_total)),'Color',[1 1 1],'FontSize',5,'HorizontalAlignment','left');
end
axis off
box off
text(v.Position(1,1)-v.Radius(1)*1.9,v.Position(1,2)-v.Radius(1)*1.4,sprintf('Reward-increase\n modulated'),'Color',[1 0.5 0],'FontSize',6);
text(v.Position(2,1)-v.Radius(1)*0.3,v.Position(2,2)-v.Radius(2)*1.6,sprintf('Reward-omission\n modulated'),'Color',[0 0.7 0.2],'FontSize',6);
text(v.Position(3,1)-v.Radius(1)*1.3,v.Position(3,2)+v.Radius(3)*1.2,sprintf('Positionally tuned'),'Color',[0 0 1],'FontSize',6);
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.1, 'd', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

%% Large/Regular reward modulation histogram and percentage of positionally tuned neurons per modulation bin

reward_regular = DATA.D_reward.reward_mean_regular;
reward_small = DATA.D_reward.reward_mean_small;
reward_large= DATA.D_reward.reward_mean_large;
change_peak_largereward_signif = 100*((reward_large(idx_large2)./reward_regular(idx_large2))-1);
change_peak_smallreward_signif = 100*((reward_small(idx_small2)./reward_regular(idx_small2))-1);
step=10;
bins2 = [-inf,-90:step:90,inf];
bins2_centers=[bins2(2)-step/2, bins2(2:end-1)+step/2];

axes('position',[position_x3(4),position_y3(1), panel_width3, panel_height3])
yyaxis left
a=histogram(change_peak_largereward_signif,bins2);
y =100*a.BinCounts/count_total;
bar(bins2_centers,y,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5]);
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,sprintf('Activity change (%%)\n [Large reward - Regular reward] '), 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Reward-increase\n neurons (%%)'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold','Color',[1 0.5 0]);
text(xl(1)-diff(xl)*0.1,yl(1)-diff(yl)*0.2,sprintf('Neurons modulated\n by reward increase\n'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom','Color',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5],'TickLength',[0.05,0]);


% of directionally tuned cells as a function of reward modulation
%-----------------------------------------------------------------
tuned_in_change_bins=[];
for ib = 1:1:numel(bins2)-1
    idx_change_bin = change_peak_largereward_signif>=bins2(ib) & change_peak_largereward_signif<bins2(ib+1);
    % percentage tuned in each time bin
    if sum(idx_change_bin)>50 % to avoid spurious values
        tuned_in_change_bins(ib) =100*sum(idx_change_bin&idx_positional(idx_large2))/sum(idx_change_bin);
    else
        tuned_in_change_bins(ib)=NaN;
    end
end
yyaxis right

plot(bins2_centers,smooth(tuned_in_change_bins,5)'+tuned_in_change_bins*0,'.-','LineWidth',2,'MarkerSize',10,'Color',[0 0 1],'Clipping','off')
% xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)+diff(xl)*1.5,yl(1)-diff(yl)*0.75,sprintf('Positionally tuned\n neurons (%%)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','middle','Color',[0 0 1]);
% ylabel(sprintf('Positionally tuned\n neurons (%%)'),'Color',[0 0 1],'FontSize',6);
set(gca,'Xtick',[-100,0,100],'Ytick',[25,50],'TickLength',[0.05,0.05],'TickDir','in');
box off
xlim([-100,100]);
ylim([25 ceil(max(tuned_in_change_bins))]);
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)-diff(xl)*1.1, yl(1)+diff(yl)*1.5, 'e', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
set(gca,'FontSize',6,'TickLength',[0.05,0.05],'TickDir','in');
set(gca,'Ycolor',[0 0 1]);



%% Small/Regular reward modulation histogram and percentage of positionally tuned neurons per modulation bin
axes('position',[position_x3(4),position_y3(2), panel_width3, panel_height3])
yyaxis left
a=histogram(change_peak_smallreward_signif,bins2);
y =100*a.BinCounts/count_total;
bar(bins2_centers,y,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5]);
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,sprintf('Activity change (%%)\n [Reward Omission - Regular reward] '), 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Reward-omission\n neurons (%%)'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold','Color',[0 0.7 0.2]);
text(xl(1)-diff(xl)*0.1,yl(1)-diff(yl)*0.2,sprintf('Neurons modulated\n by reward omission\n'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom','Color',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5],'TickLength',[0.05,0]);


% of directionally tuned cells as a function of reward modulation
%-----------------------------------------------------------------
tuned_in_change_bins=[];
for ib = 1:1:numel(bins2)-1
    idx_change_bin = change_peak_smallreward_signif>=bins2(ib) & change_peak_smallreward_signif<bins2(ib+1);
    % percentage tuned in each time bin
    if sum(idx_change_bin)>50 % to avoid spurious values
        tuned_in_change_bins(ib) =100*sum(idx_change_bin&idx_positional(idx_small2))/sum(idx_change_bin);
    else
        tuned_in_change_bins(ib)=NaN;
    end
end
yyaxis right

plot(bins2_centers,smooth(tuned_in_change_bins,5)'+tuned_in_change_bins*0,'.-','LineWidth',2,'MarkerSize',10,'Color',[0 0 1],'Clipping','off')
% xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)+diff(xl)*1.5,yl(1)-diff(yl)*0.5,sprintf('Positionally tuned\n neurons (%%)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','middle','Color',[0 0 1]);
set(gca,'Xtick',[-100,0,100],'Ytick',[25,50],'TickLength',[0.05,0.05],'TickDir','in');
box off
xlim([-100,100]);
ylim([25 ceil(max(tuned_in_change_bins))]);
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(xl(1)-diff(xl)*1.1, yl(1)+diff(yl)*1.5, 'f', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
set(gca,'FontSize',6,'TickLength',[0.05,0.05],'TickDir','in');
set(gca,'Ycolor',[0 0 1]);


%% Field size and field correlation across conditions
field_size_regular=DATA.D_positional_and_reward.field_size_without_baseline_regular;
field_size_small=DATA.D_positional_and_reward.field_size_without_baseline_small;
field_size_large=DATA.D_positional_and_reward.field_size_without_baseline_large;


% field_ratio_large = (field_size_large(idx_large1)./field_size_regular(idx_large1));
field_ratio_large = (field_size_large(idx_large1)-field_size_regular(idx_large1))./(field_size_large(idx_large1)+field_size_regular(idx_large1));
nanmean(field_ratio_large)

% field_ratio_small = (field_size_small(idx_small1)./field_size_regular(idx_small1));
field_ratio_small = (field_size_small(idx_small1)-field_size_regular(idx_small1))./(field_size_small(idx_small1)+field_size_regular(idx_small1));
nanmean(field_ratio_small)
% histogram([field_ratio_small;field_ratio_large],linspace(0,2,9))

lickmap_regular_vs_large_corr=DATA.D_positional_and_reward.lickmap_regular_vs_large_corr(idx_large1);
% histogram(lickmap_regular_vs_large_corr)
nanmean(lickmap_regular_vs_large_corr)

lickmap_regular_vs_small_corr=DATA.D_positional_and_reward.lickmap_regular_vs_small_corr(idx_small1);
% histogram(lickmap_regular_vs_small_corr)
nanmean(lickmap_regular_vs_small_corr)

%% Positional tuning corrrelation across reward conditions
axes('position',[position_x3(5),position_y3(1), panel_width3, panel_height3])
[hhh3,edges]=histcounts([lickmap_regular_vs_small_corr;lickmap_regular_vs_large_corr],linspace(-1,1,11));

percentage_of_conjunctive_neurons_with_stable_reward_modulation = sum([lickmap_regular_vs_small_corr;lickmap_regular_vs_large_corr]>0.25)/numel([lickmap_regular_vs_small_corr;lickmap_regular_vs_large_corr])

hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') '{\it r}'  newline 'across reward conditions'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional tuning\nsimilarity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.5, 'g', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

%% Field size changes across reward conditions
axes('position',[position_x3(5),position_y3(2), panel_width3, panel_height3])
[hhh3,edges]=histcounts([field_ratio_small;field_ratio_large],linspace(-1,1,12));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Field size,') '{changes}'  newline 'across reward conditions'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional tuning\nsimilarity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.5, 'h', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




