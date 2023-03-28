function Figure4_v4()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure4_v2')];


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
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;




key.num_svd_components_removed_corr=0;


rel_data_neurons_spont = STIMANAL.InfluenceVsCorrTraceSpont & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_spont = STIMANAL.InfluenceVsCorrTraceSpont & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_neurons_shuffled_spont = STIMANAL.InfluenceVsCorrTraceSpontShuffled & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');
rel_data_neurons_shuffled_spont = rel_data_neurons_shuffled_spont & (EXP2.SessionEpoch & rel_data_neurons_spont);

rel_data_controls_shuffled_spont = STIMANAL.InfluenceVsCorrTraceSpontShuffled & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_shuffled_spont = rel_data_controls_shuffled_spont & (EXP2.SessionEpoch & rel_data_controls_spont);


DATA_neurons_spont=struct2table(fetch(rel_data_neurons_spont,'*'));
DATA_controls_spont=struct2table(fetch(rel_data_controls_spont,'*'));
DATA_SHUFFLED_neurons_spont=struct2table(fetch(rel_data_neurons_shuffled_spont,'*'));
DATA_SHUFFLED_controls_spont=struct2table(fetch(rel_data_controls_shuffled_spont,'*'));


rel_data_neurons_behav = STIMANAL.InfluenceVsCorrTraceBehav & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_behav = STIMANAL.InfluenceVsCorrTraceBehav & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_neurons_shuffled_behav = STIMANAL.InfluenceVsCorrTraceBehavShuffled & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');
rel_data_neurons_shuffled_behav = rel_data_neurons_shuffled_behav & (EXP2.SessionEpoch & rel_data_neurons_behav);

rel_data_controls_shuffled_behav = STIMANAL.InfluenceVsCorrTraceBehavShuffled & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_shuffled_behav = rel_data_controls_shuffled_behav & (EXP2.SessionEpoch & rel_data_controls_behav);

DATA_neurons_behav=struct2table(fetch(rel_data_neurons_behav,'*'));
DATA_controls_behav=struct2table(fetch(rel_data_controls_behav,'*'));
DATA_SHUFFLED_neurons_behav=struct2table(fetch(rel_data_neurons_shuffled_behav,'*'));
DATA_SHUFFLED_controls_behav=struct2table(fetch(rel_data_controls_shuffled_behav,'*'));



% %%
% bins_corr_edges = DATA_neurons.bins_corr_edges(1,:);
% if bins_corr_edges(1)==-inf
%     bins_corr_edges(1)=bins_corr_edges(2) - (bins_corr_edges(3) - bins_corr_edges(2));
% end
% if bins_corr_edges(end)==inf
%     bins_corr_edges(end)=bins_corr_edges(end-1) + (bins_corr_edges(end-2) - bins_corr_edges(end-3));
% end
% bins_corr_centers = bins_corr_edges(1:1:end-1) + diff(bins_corr_edges)/2;


bins_influence_edges = DATA_neurons_spont.bins_influence_edges(1,:);
if bins_influence_edges(1)==-inf
    bins_influence_edges(1)=bins_influence_edges(2) - (bins_influence_edges(3) - bins_influence_edges(2));
end
if bins_influence_edges(end)==inf
    bins_influence_edges(end)=bins_influence_edges(end-1) + (bins_influence_edges(end-2) - bins_influence_edges(end-3));
end
bins_influence_centers = bins_influence_edges(1:1:end-1) + diff(bins_influence_edges)/2;


%%

axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
xl = [-0.25, 1.25];
yl =[-0.015, 0.07];
hold on
y1=DATA_neurons_spont.corr_binned_by_influence - DATA_SHUFFLED_neurons_spont.corr_binned_by_influence;
y_mean1 = nanmean(y1,1);
y_stem1 = nanstd(y1,1)./sqrt(size(DATA_neurons_spont,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim([bins_influence_edges(1), bins_influence_edges(end)]);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean1,y_stem1,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

y2=DATA_controls_spont.corr_binned_by_influence - DATA_SHUFFLED_controls_spont.corr_binned_by_influence;
y_mean2 = nanmean(y2,1);
y_stem2 = nanstd(y2,1)./sqrt(size(DATA_controls_spont,1));
shadedErrorBar(bins_influence_centers,y_mean2,y_stem2,'lineprops',{'-','Color',[0 0.75 0.75], 'LineWidth',1})
text(xl(1)-diff(xl)*0.4,yl(1)-diff(yl)*0.2,[sprintf('''Noise'' correlations,') newline '    {residual \it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Connection stength' newline ' (\Delta z-score activity)'], 'FontSize',6,'HorizontalAlignment','center');
box off
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Spontaneous activity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.8,yl(1)+diff(yl)*0.8,'Neuron targets','Color',[1 0 1], 'FontSize',6);
text(xl(1)+diff(xl)*0.8,yl(1)+diff(yl)*0.6,sprintf('Control targets'),'Color',[0 0.75 0.75], 'FontSize',6);
ylim(yl);
xlim(xl);
set(gca,'XTick',[0,1],'Ytick',[0, 0.07],'TickLength',[0.05,0.05], 'FontSize',6);
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'a', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
h = rectangle('Position',[-0.05*3,-0.002*4,0.125*3,0.004*4],'LineWidth',0.1);


%% Zoom in
axes('position',[position_x1(2),position_y1(1), panel_width1*0.75, panel_height1*0.75])
xl = [-0.05, 0.075]*3;
yl =[-0.002, 0.002]*4;
hold on
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim(xl);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean1,y_stem1,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})
shadedErrorBar(bins_influence_centers,y_mean2,y_stem2,'lineprops',{'-','Color',[0 0.75 0.75], 'LineWidth',1})
% ylabel('''Noise'' Correlation, Residual \itr');
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Zoom in'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
set(gca,'XTick',[-0.05  0 0.05 ],'XTickLabel',[{'-0.05'  '   0' '0.05'} ],'TickLength',[0.05 0.05]);
axis off;
box off

% h = rectangle('Position',[-0.05*4,-0.002*4,0.125*4,0.004*4],'LineWidth',0.1);





%%
axes('position',[position_x1(3),position_y1(1), panel_width1, panel_height1])
xl = [-0.25, 1.25];
yl =[-0.015, 0.07];
hold on
y3=DATA_neurons_behav.corr_binned_by_influence - DATA_SHUFFLED_neurons_behav.corr_binned_by_influence;
y_mean3 = nanmean(y3,1);
y_stem3 = nanstd(y3,1)./sqrt(size(DATA_neurons_behav,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim([bins_influence_edges(1), bins_influence_edges(end)]);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean3,y_stem3,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

y4=DATA_controls_behav.corr_binned_by_influence - DATA_SHUFFLED_controls_behav.corr_binned_by_influence;
y_mean4 = nanmean(y4,1);
y_stem4 = nanstd(y4,1)./sqrt(size(DATA_controls_behav,1));
shadedErrorBar(bins_influence_centers,y_mean4,y_stem4,'lineprops',{'-','Color',[0 0.75 0.75], 'LineWidth',1})
% ylabel('Trace Correlation, \itr');
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Connection stength' newline ' (\Delta z-score activity)'], 'FontSize',6,'HorizontalAlignment','center');
box off
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Behavioral activity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
% text(0.01,-1.4,'Neuron targets','Color',[1 0 1]);
% text(0.01,-1.2,sprintf('Control targets'),'Color',[0 1 1]);
ylim(yl);
xlim(xl);
set(gca,'XTick',[0,1],'Ytick',[0, 0.07],'TickLength',[0.05,0.05], 'FontSize',6);
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'b', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
h = rectangle('Position',[-0.05*3,-0.002*4,0.125*3,0.004*4],'LineWidth',0.1);


%% Zoom in
axes('position',[position_x1(4),position_y1(1), panel_width1*0.75, panel_height1*0.75])
xl = [-0.05, 0.075]*3;
yl =[-0.002, 0.002]*4;
hold on
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim(xl);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean3,y_stem3,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})
shadedErrorBar(bins_influence_centers,y_mean4,y_stem4,'lineprops',{'-','Color',[0 0.75 0.75], 'LineWidth',1})
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Zoom in'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
set(gca,'XTick',[-0.05  0 0.05 ],'XTickLabel',[{'-0.05'  '   0' '0.05'} ],'TickLength',[0.05 0.05]);
axis off;
box off


%% Tuning

key.neurons_or_control=1;
key.response_p_val=1;
rel_data = STIMANAL.InfluenceVsCorrMap*EXP2.SessionID  & 'num_pairs>=0' & 'num_targets>=50' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2')   ...;

rel_shuffled = STIMANAL.InfluenceVsCorrMapShuffled*EXP2.SessionID & 'num_pairs>=0' & 'num_targets>=50' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2')   ...;
  
title_string = 'Positional tuning';
ax5=axes('position',[position_x1(5)+0.01,position_y1(1), panel_width1, panel_height1])

num_svd_components_removed_vector_corr =[0]; % this is relevant if we remove  SVD  components of the ongoing dynamics from the connectivity response, to separate the evoked resposne from ongoing activity
% colormap=viridis(numel(num_svd_components_removed_vector_corr));
colormap=[1 0 1];
for i_c = 1:1:numel(num_svd_components_removed_vector_corr)
    key.num_svd_components_removed_corr=num_svd_components_removed_vector_corr(i_c);
    [xl] = fn_plot_tuning_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, i_c, ax5);
end
yl=[-0.005, 0.03]
ylim(yl)
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Connection stength' newline ' (\Delta z-score activity)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.4,yl(1)-diff(yl)*0.2,[sprintf('Tuning correlations,') newline '    {residual \it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);

set(gca,'XTick',[0,1],'Ytick',[0, 0.03],'TickLength',[0.05,0.05], 'FontSize',6);
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'c', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional tuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');


fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);



