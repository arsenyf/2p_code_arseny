function Figure4_v5()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure4_v5')];


DefaultFontSize =6;
figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

panel_width1=0.07;
panel_height1=0.07;
horizontal_dist1=0.1;
vertical_dist2=0.1;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1*1.75;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;


%%
key.response_p_val=1;
key.num_svd_components_removed_corr=0;  % this is relevant only if we remove  SVD  components of the ongoing dynamics from the connectivity response, to separate the evoked resposne from ongoing activity
min_pairs_in_influence_bin=50;
min_pairs_in_corr_bin=50;
min_session_per_bin=5;

%% Spont
title_string = 'Noise Correlations, rest';

rel_data = STIMANAL.InfluenceVsCorrTraceSpont*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');
rel_shuffled = STIMANAL.InfluenceVsCorrTraceSpontShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

% Target Neurons
key.neurons_or_control=1;
colormap=[1 0 1];
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
flag_plot=0;
[DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, bins_influence_centers,colormap,bins_influence_edges, yl] ...
    =fn_plot_corr_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_pairs_in_corr_bin,min_session_per_bin, flag_plot);

% axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1])
flag_plot=1;
yl_residual ...
    = fn_plot_corr_vs_connectivity_figure4_residual (DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, min_session_per_bin, bins_influence_centers,colormap,bins_influence_edges, flag_plot)


% Control  Targets
key.neurons_or_control=0;
colormap=[0 1 1];
flag_plot=0;
% axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1])
[DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, bins_influence_centers,colormap,bins_influence_edges] ...
    =fn_plot_corr_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_pairs_in_corr_bin,min_session_per_bin, flag_plot);
ylim(yl);

% axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1])
flag_plot=1;
fn_plot_corr_vs_connectivity_figure4_residual (DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, min_session_per_bin, bins_influence_centers,colormap,bins_influence_edges, flag_plot)
ylim(yl_residual);


xl=[-0.3,1.7];
yl=[-0.005,0.03];


xlim(xl)
ylim(yl)

text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Noise correlation, \n residual') ' \itr']);
text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',[0,0.03],'TickLength',[0.05,0.05], 'FontSize',6)
plot(xl,[0 0],'k')
% plot([0 0],yl,'k')

%% Behav
axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1])

rel_data = STIMANAL.InfluenceVsCorrTraceBehav*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');
rel_shuffled = STIMANAL.InfluenceVsCorrTraceBehavShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

% Target Neurons
key.neurons_or_control=1;
colormap=[1 0 1];
% axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
flag_plot=0;
[DATA,DATA_SHUFFLED,idx_influence_pairs_exclude,  bins_influence_centers,colormap,bins_influence_edges, yl] ...
    =fn_plot_corr_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_pairs_in_corr_bin,min_session_per_bin, flag_plot);

% axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1])
flag_plot=1;
yl_residual ...
    = fn_plot_corr_vs_connectivity_figure4_residual (DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, min_session_per_bin, bins_influence_centers,colormap,bins_influence_edges, flag_plot)


box off
% Hide the y-axis (left y-axis)
ax = gca; % Get the current axes
ax.YAxis.Visible = 'off'; % Hide the y-axis

% Control  Targets
key.neurons_or_control=0;
colormap=[0 1 1];
flag_plot=0;
% axes('position',[position_x1(2),position_y1(1), panel_width1,
% panel_height1])
[DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, bins_influence_centers,colormap,bins_influence_edges] ...
    =fn_plot_corr_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_pairs_in_corr_bin,min_session_per_bin, flag_plot);
ylim(yl);

% axes('position',[position_x1(2),position_y1(2), panel_width1,
% panel_height1])
flag_plot=1;
fn_plot_corr_vs_connectivity_figure4_residual (DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, min_session_per_bin, bins_influence_centers,colormap,bins_influence_edges,  flag_plot)
ylim(yl_residual);


xl=[-0.3,1.7];
yl=[-0.005,0.03];


xlim(xl)
ylim(yl)
box off
plot(xl,[0 0],'k')
% plot([0 0],yl,'k')


% xlim([-0.2,0.15])
% ylim([-0.0005,0.0005])


% axis off;
% axis tight;
% axis equal;

% text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.1,sprintf('Noise correlations, \n during Behavior'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('During behavior'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',{'',''},'TickLength',[0.05,0.05], 'FontSize',6)

% Hide the y-axis (left y-axis)
ax = gca; % Get the current axes
ax.YAxis.Visible = 'off'; % Hide the y-axis


text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.5,sprintf('Target neurons'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 1]);
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.3,sprintf('Control targets'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 1 1]);




%% Tuning
min_pairs_in_influence_bin=25;
min_pairs_in_corr_bin=25;
min_session_per_bin=5;

key.neurons_or_control=1;
key.response_p_val=1;
rel_data = STIMANAL.InfluenceVsCorrMap3*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

rel_shuffled = STIMANAL.InfluenceVsCorrMapShuffled3*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

title_string = 'Positional tuning';
ax5=axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=0;
colormap=[0 1 1];
[xl] = fn_plot_tuning_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_session_per_bin);


key.neurons_or_control=1;
colormap=[1 0 1];
[xl] = fn_plot_tuning_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_session_per_bin);



yl=[-0.01, 0.03]
ylim(yl)
% text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Connection strength' newline ' (\Delta z-score activity)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.4,yl(1)-diff(yl)*0.2,[sprintf('Tuning correlations,') newline '    {residual \it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);

set(gca,'XTick',[0,1],'Ytick',[0, 0.03],'TickLength',[0.05,0.05], 'FontSize',6);
% text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'c', ...
%         'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional tuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');


text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'b', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Tuning correlation, \n residual') ' \itr']);
text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Location tuning'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Positional tuning'),'FontSize',6,'HorizontalAlignment','left','Color',[0 0 0], 'fontweight', 'bold')
plot(xl,[0 0],'k')

fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
% set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);



