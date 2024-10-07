function Supplementary_Figure_7_like2like_and_noise_correlations_v2()
close all
% clf;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Supplementary_Figure_7_v2')];



DefaultFontSize =6;
figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

panel_width1=0.07;
panel_height1=0.07;
horizontal_dist1=0.15;
vertical_dist2=0.1;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1*1.4;
position_x1(end+1)=position_x1(end)+horizontal_dist1*0.7;
position_x1(end+1)=position_x1(end)+horizontal_dist1*1.4;
position_x1(end+1)=position_x1(end)+horizontal_dist1*0.7;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2*1.75;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;

min_pairs_in_influence_bin=50;
min_pairs_in_corr_bin=50;
key.num_svd_components_removed_corr=0;
key.response_p_val=1;
min_session_per_bin=5;


%% At rest
%------------------------------------------------
rel_data = STIMANAL.InfluenceVsCorrTraceSpont*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );

rel_shuffled = STIMANAL.InfluenceVsCorrTraceSpontShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );

% Data, Distance shuffled   corr (y) vs connectivity (x)
%------------------------------------------------
axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[0,0.08];
xl=[-0.02,1.7];
ylim(yl);
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'b', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Noise correlation, \n') ' \itr']);
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.9,sprintf('Data'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 0]);
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.5,sprintf('Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.08], 'YtickLabel',[0,0.08],'TickLength',[0.05,0.05], 'FontSize',6)
plot([0,0],[yl],'-k');

% Residual corr (y) vs connectivity (x) 
%------------------------------------------------
axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[0 0 1];
supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.005,0.03];
ylim(yl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Noise correlation, \n residual') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',[0,0.03],'TickLength',[0.05,0.05], 'FontSize',6)


% Opposite:  Data Distance shuffled  connectivity  (y) vs  corr  (x)
%------------------------------------------------
axes('position',[position_x1(4),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_connectivity_vs_corr_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.01,0.1];
xl=[-0.15,0.5];
ylim(yl);
xlim(xl);
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'd', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel (['Connection strength' newline '(\Delta z-score activity)']);
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.9,sprintf('Data'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 0]);
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.5,sprintf('Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.1], 'YtickLabel',[0,0.1],'TickLength',[0.05,0.05], 'FontSize',6)



% Opposite:  Residual  connectivity (y) vs corr (y) 
%------------------------------------------------
axes('position',[position_x1(4),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[0 0 1];
supfig7_fn_plot_connectivity_vs_corr_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.005,0.06];
xl=[-0.15,0.5];
ylim(yl);
xlim(xl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
ylabel (['Residual' newline 'Connection strength' newline '(\Delta z-score activity)']);
xlabel([sprintf('Noise correlation, \n') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.05], 'YtickLabel',[0,0.05],'TickLength',[0.05,0.05], 'FontSize',6)










%% Behavior
rel_data = STIMANAL.InfluenceVsCorrTraceBehav*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );

rel_shuffled = STIMANAL.InfluenceVsCorrTraceBehavShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );


% Data, Distance shuffled corr (y) vs connectivity (x)
%------------------------------------------------
axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[0,0.08];
xl=[-0.02,1.7];
ylim(yl);
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'c', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% xlabel (['Connection strength' newline '(\Delta z-score activity)']);
% ylabel([sprintf('Noise correlation, \n') ' \itr']);
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('During Behavior'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.9,sprintf('Data'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 0]);
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.5,sprintf('Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.08], 'YtickLabel',['',''],'TickLength',[0.05,0.05], 'FontSize',6)
plot([0,0],[yl],'-k');




% Residual corr (y) vs connectivity (x)
%------------------------------------------------
axes('position',[position_x1(3),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[0 0 1];
supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.005,0.03];
ylim(yl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
% ylabel([sprintf('Noise correlation, \n residual') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',['',''],'TickLength',[0.05,0.05], 'FontSize',6)





% Opposite:  Data Distance shuffled  connectivity  (y) vs  corr  (x)
%------------------------------------------------
axes('position',[position_x1(5),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_connectivity_vs_corr_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.01,0.1];
xl=[-0.15,0.5];
ylim(yl);
xlim(xl);
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'e', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% xlabel (['Connection strength' newline '(\Delta z-score activity)']);
% ylabel (['Connection strength' newline '(\Delta z-score activity)']);
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('During Behavior'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.9,sprintf('Data'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 0]);
% text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.5,sprintf('Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.1], 'YtickLabel',[0,0.1],'TickLength',[0.05,0.05], 'FontSize',6)



% Opposite:  Residual  connectivity (y) vs corr (y) 
%------------------------------------------------
axes('position',[position_x1(5),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[0 0 1];
supfig7_fn_plot_connectivity_vs_corr_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.005,0.06];
xl=[-0.15,0.5];
ylim(yl);
xlim(xl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% ylabel (['Connection strength' newline '(\Delta z-score activity)']);
xlabel([sprintf('Noise correlation, \n') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.05], 'YtickLabel',[0,0.05],'TickLength',[0.05,0.05], 'FontSize',6)






%% Location tuning
min_pairs_in_influence_bin=25;
min_pairs_in_corr_bin=25;
min_session_per_bin=5;
rel_data = STIMANAL.InfluenceVsCorrMap4*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );

rel_shuffled = STIMANAL.InfluenceVsCorrMapShuffled4*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );


% Data, Distance shuffled  (y) versus connectivity (x)
%------------------------------------------------
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_data_and_distanceshuffle(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[0.04,0.1];
xl=[-0.02,1];
ylim(yl);
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Tuning correlation, \n') ' \itr']);
text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('Location tuning'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.9,sprintf('Data'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 0]);
text(xl(1)+diff(xl)*1,yl(1)+diff(yl)*0.4,sprintf('Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0.5 0.5 0.5]);
set(gca,'Xtick',[0,1], 'XtickLabel',[0,1])
set(gca,'Ytick',[0.05,0.1], 'YtickLabel',[0.05,0.1],'TickLength',[0.05,0.05], 'FontSize',6)


% Residual (y) versus connectivity (x)
%------------------------------------------------
axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[0 0 1];
supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.005,0.04];
ylim(yl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
ylabel([sprintf('Tuning correlation, \n residual') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1], 'XtickLabel',[0,1])
set(gca,'Ytick',[0,0.03], 'YtickLabel',[0,0.03],'TickLength',[0.05,0.05], 'FontSize',6)





if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end



if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);


