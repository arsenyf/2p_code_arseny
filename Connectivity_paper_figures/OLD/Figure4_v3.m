function Figure4_v2()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('Figure4_v2')];

key.num_svd_components_removed_corr=0;

% rel_data_neurons_residual = STIMANAL.InfluenceVsCorrTraceSpontResidual  & 'neurons_or_control=1' & key ...
%     &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');
% 
% rel_data_control_residual = STIMANAL.InfluenceVsCorrTraceSpontResidual & 'neurons_or_control=0' & key ...
%     &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=0') ...
%     & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=0');



rel_data_neurons_raw = STIMANAL.InfluenceVsCorrTraceSpont & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_raw = STIMANAL.InfluenceVsCorrTraceSpont & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_neurons_shuffled = STIMANAL.InfluenceVsCorrTraceSpontShuffled & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');
rel_data_neurons_shuffled = rel_data_neurons_shuffled & (EXP2.SessionEpoch & rel_data_neurons_raw);

rel_data_controls_shuffled = STIMANAL.InfluenceVsCorrTraceSpontShuffled & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_shuffled = rel_data_controls_shuffled & (EXP2.SessionEpoch & rel_data_controls_raw);


DefaultFontSize =6;
figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);





DATA_neurons=struct2table(fetch(rel_data_neurons_raw,'*'));
DATA_controls=struct2table(fetch(rel_data_controls_raw,'*'));
DATA_SHUFFLED_neurons=struct2table(fetch(rel_data_neurons_shuffled,'*'));
DATA_SHUFFLED_controls=struct2table(fetch(rel_data_controls_shuffled,'*'));

% %%
% bins_corr_edges = DATA_neurons.bins_corr_edges(1,:);
% if bins_corr_edges(1)==-inf
%     bins_corr_edges(1)=bins_corr_edges(2) - (bins_corr_edges(3) - bins_corr_edges(2));
% end
% if bins_corr_edges(end)==inf
%     bins_corr_edges(end)=bins_corr_edges(end-1) + (bins_corr_edges(end-2) - bins_corr_edges(end-3));
% end
% bins_corr_centers = bins_corr_edges(1:1:end-1) + diff(bins_corr_edges)/2;


bins_influence_edges = DATA_neurons.bins_influence_edges(1,:);
if bins_influence_edges(1)==-inf
    bins_influence_edges(1)=bins_influence_edges(2) - (bins_influence_edges(3) - bins_influence_edges(2));
end
if bins_influence_edges(end)==inf
    bins_influence_edges(end)=bins_influence_edges(end-1) + (bins_influence_edges(end-2) - bins_influence_edges(end-3));
end
bins_influence_centers = bins_influence_edges(1:1:end-1) + diff(bins_influence_edges)/2;


%%

subplot(4,4,1)
yl =[-0.015, 0.06];
hold on
y1=DATA_neurons.corr_binned_by_influence - DATA_SHUFFLED_neurons.corr_binned_by_influence;
y_mean = nanmean(y1,1);
y_stem = nanstd(y1,1)./sqrt(size(DATA_neurons,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim([bins_influence_edges(1), bins_influence_edges(end)]);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

y2=DATA_controls.corr_binned_by_influence - DATA_SHUFFLED_controls.corr_binned_by_influence;
y_mean = nanmean(y2,1);
y_stem = nanstd(y2,1)./sqrt(size(DATA_controls,1));
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[0 1 1], 'LineWidth',1})
ylabel('Trace Correlation, \itr');
xlabel (['Connection stength' newline '(\Delta z-score activity)']);
box off
title(sprintf('Spontaneous\n activity'));
text(0.01,-1.4,'Neuron targets','Color',[1 0 1]);
text(0.01,-1.2,sprintf('Control targets'),'Color',[0 1 1]);
xl = [-0.25, 1];
xlim(xl);

%% Zoom in
subplot(4,4,2)
yl =[-0.002, 0.002];
xl = [-0.05, 0.075];
hold on
y_mean = nanmean(y1,1);
y_stem = nanstd(y1,1)./sqrt(size(DATA_neurons,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim(xl);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

% y_mean = nanmean(y2,1);
% y_stem = nanstd(y2,1)./sqrt(size(DATA_controls,1));
% shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[0 1 1], 'LineWidth',1})
ylabel('''Noise'' Correlation, Residual \itr');
% ylabel ('Influence (\Delta Activity)');
box off
title('Zoom in');
set(gca,'XTick',[-0.05  0 0.05 ],'XTickLabel',[{'-0.05'  '   0' '0.05'} ],'TickLength',[0.05 0.05]);




rel_data_neurons_raw = STIMANAL.InfluenceVsCorrTraceBehav & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_raw = STIMANAL.InfluenceVsCorrTraceBehav & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_neurons_shuffled = STIMANAL.InfluenceVsCorrTraceBehavShuffled & 'neurons_or_control=1' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');
rel_data_neurons_shuffled = rel_data_neurons_shuffled & (EXP2.SessionEpoch & rel_data_neurons_raw);

rel_data_controls_shuffled = STIMANAL.InfluenceVsCorrTraceBehavShuffled & 'neurons_or_control=0' & key ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25');

rel_data_controls_shuffled = rel_data_controls_shuffled & (EXP2.SessionEpoch & rel_data_controls_raw);







DATA_neurons=struct2table(fetch(rel_data_neurons_raw,'*'));
DATA_controls=struct2table(fetch(rel_data_controls_raw,'*'));
DATA_SHUFFLED_neurons=struct2table(fetch(rel_data_neurons_shuffled,'*'));
DATA_SHUFFLED_controls=struct2table(fetch(rel_data_controls_shuffled,'*'));

% %%
% bins_corr_edges = DATA_neurons.bins_corr_edges(1,:);
% if bins_corr_edges(1)==-inf
%     bins_corr_edges(1)=bins_corr_edges(2) - (bins_corr_edges(3) - bins_corr_edges(2));
% end
% if bins_corr_edges(end)==inf
%     bins_corr_edges(end)=bins_corr_edges(end-1) + (bins_corr_edges(end-2) - bins_corr_edges(end-3));
% end
% bins_corr_centers = bins_corr_edges(1:1:end-1) + diff(bins_corr_edges)/2;


bins_influence_edges = DATA_neurons.bins_influence_edges(1,:);
if bins_influence_edges(1)==-inf
    bins_influence_edges(1)=bins_influence_edges(2) - (bins_influence_edges(3) - bins_influence_edges(2));
end
if bins_influence_edges(end)==inf
    bins_influence_edges(end)=bins_influence_edges(end-1) + (bins_influence_edges(end-2) - bins_influence_edges(end-3));
end
bins_influence_centers = bins_influence_edges(1:1:end-1) + diff(bins_influence_edges)/2;


%%

subplot(4,4,5)
yl =[-0.015, 0.06];
hold on
y1=DATA_neurons.corr_binned_by_influence - DATA_SHUFFLED_neurons.corr_binned_by_influence;
y_mean = nanmean(y1,1);
y_stem = nanstd(y1,1)./sqrt(size(DATA_neurons,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim([bins_influence_edges(1), bins_influence_edges(end)]);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

y2=DATA_controls.corr_binned_by_influence - DATA_SHUFFLED_controls.corr_binned_by_influence;
y_mean = nanmean(y2,1);
y_stem = nanstd(y2,1)./sqrt(size(DATA_controls,1));
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[0 1 1], 'LineWidth',1})
ylabel('Trace Correlation, \itr');
xlabel (['Connection stength' newline '(\Delta z-score activity)']);
box off
title(sprintf('Behavioral\n activity'));
text(0.01,-1.4,'Neuron targets','Color',[1 0 1]);
text(0.01,-1.2,sprintf('Control targets'),'Color',[0 1 1]);
xl = [-0.25, 1];
xlim(xl);

%% Zoom in
subplot(4,4,6)
yl =[-0.002, 0.002];
xl = [-0.05, 0.075];
hold on
y_mean = nanmean(y1,1);
y_stem = nanstd(y1,1)./sqrt(size(DATA_neurons,1));
plot([bins_influence_edges(1),bins_influence_edges(end)],[0,0],'-k');
plot([0,0],yl,'-k');
xlim(xl);
ylim(yl);
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[1 0 1], 'LineWidth',1})

% y_mean = nanmean(y2,1);
% y_stem = nanstd(y2,1)./sqrt(size(DATA_controls,1));
% shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',[0 1 1], 'LineWidth',1})
ylabel('''Noise'' Correlation, Residual \itr');
% ylabel ('Influence (\Delta Activity)');
box off
title('Zoom in');
set(gca,'XTick',[-0.05  0 0.05 ],'XTickLabel',[{'-0.05'  '   0' '0.05'} ],'TickLength',[0.05 0.05]);





fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);



