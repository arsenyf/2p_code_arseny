function Supplementary_Figure_7_for_ERC_noise_corr_vs_conn_across_states()
close all
% clf;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Supplementary_Figure_7_for_ERC_noise_corr_vs_conn_across_states')];



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
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1*1.4;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

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
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

rel_shuffled = STIMANAL.InfluenceVsCorrTraceSpontShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

% Data, Distance shuffled   corr (y) vs connectivity (x)
%------------------------------------------------

% Residual corr (y) vs connectivity (x) 
%------------------------------------------------
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
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
ylabel([sprintf('Noise correlation,') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])
xl=[-0.15,1.7];
% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',[0,0.03],'TickLength',[0.03,0.03], 'FontSize',6)




%% Behavior
rel_data = STIMANAL.InfluenceVsCorrTraceBehav*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

rel_shuffled = STIMANAL.InfluenceVsCorrTraceBehavShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=0' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2');

% Residual corr (y) vs connectivity (x)
%------------------------------------------------
% axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1])
key.neurons_or_control=1;
colormap=[1 0 0];
supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
% key.neurons_or_control=0;
% colormap=[0 1 1];
% supfig7_fn_plot_corr_vs_connectivity_residual(rel_data, rel_shuffled, key,colormap,  min_pairs_in_influence_bin, min_pairs_in_corr_bin, min_session_per_bin);
yl=[-0.002,0.03];
ylim(yl);
% text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.3, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
xlabel (['Connection strength' newline '(\Delta z-score activity)']);
% ylabel([sprintf('Noise correlation, \n residual') ' \itr']);
% text(xl(1)+diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('At rest'),'FontSize',7,'HorizontalAlignment','left','Color',[0 0 0])

% text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*1.1,sprintf('Residual = Data - Distance shuffled'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 1]);
set(gca,'Xtick',[0,1.5], 'XtickLabel',[0,1.5])
set(gca,'Ytick',[0,0.03], 'YtickLabel',[0,0.03],'TickLength',[0.03,0.03], 'FontSize',6)
xlim(xl)




if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);


