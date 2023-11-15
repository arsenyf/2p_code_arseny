function PLOT_CorrPairwiseDistanceSpikes_MesoSinglePlane_for_Fred()
close all;


figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
DefaultFontSize=8;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\POP\corr_distance_pop_for_fred\'];
filename = 'Corr_distance_dff'

rel_data = (POP.CorrPairwiseDistanceSVD & 'num_svd_components_removed=0')  & (IMG.Mesoscope  - IMG.Volumetric);
% rel_data = (POP.CorrPairwiseDistanceSVDSpikes & 'num_svd_components_removed=0')  & (IMG.Mesoscope  - IMG.Volumetric);

Data_dff=fetch(rel_data,'distance_corr_all','distance_bins');
% Data_spikes=fetch(rel_data,'distance_corr_all','distance_bins');

% num_svd_components_removed_vector = [0, 1, 10, 100, 500];
% num_svd_components_removed_vector = [0];

threshold_for_event_vector = [0, 1, 2];
% threshold_for_event_vector = [0];

distance_bins = fetch1(rel_data,'distance_bins','LIMIT 1');

x=distance_bins(1:end-1)+diff(distance_bins)/2;

% colors=fake_parula(numel(num_svd_components_removed_vector)+2);
%     colors=jet(numel(num_svd_components_removed_vector)+2);
colors=[1 0 0];

min_x=0; max_x=4000;


panel_width1=0.1;
panel_height1=0.1;
horizontal_dist2=0.2;
vertical_dist2=0.2;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist2;
position_x1(end+1)=position_x1(end)+horizontal_dist2;
position_x1(end+1)=position_x1(end)+horizontal_dist2;
position_x1(end+1)=position_x1(end)+horizontal_dist2;

position_y1(1)=0.7;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;
position_y1(end+1)=position_y1(end)-vertical_dist2;



for i_t=1:1:numel(threshold_for_event_vector)
    key.threshold_for_event=threshold_for_event_vector(i_t);
    
    
    %% Spontaneous activity
    key.session_epoch_type= 'spont_only';
    D=fetch(rel_data&key,'*');
    
    axes('position',[position_x1(1),position_y1(i_t), panel_width1, panel_height1])
    
    hold on
    %     if  i_t==1
    %         plot([x(1),x(end)],[0,0],'-k');
    %     end
    y = cell2mat({D.distance_corr_all}');
    y=y(:,2:end);
    ymean=nanmean(y,1);
    ystem=nanstd(y,1)/sqrt(size(y,1));
    shadedErrorBar(x(2:end),ymean,ystem,'lineprops',{'-','Color',colors})
    %                 ylim([0,max(ymean+ystem)])
    ylabel(sprintf('Pairwise Correlation'));
    xlim([min_x max_x]);
    xlabel('Lateral Distance (\mum)');
    key.session_epoch_type= 'spont_only';
    D=fetch(rel_data&key,'*');
    title(sprintf('Rest\n Events >= %d  (z-score)',threshold_for_event_vector(i_t)));
    yl=[-0.005 max(ymean+ystem)];
    ylim(yl);
    
    %% Behavior activity
    
    key.session_epoch_type= 'behav_only';
    D=fetch(rel_data&key,'*');
    axes('position',[position_x1(2),position_y1(i_t), panel_width1, panel_height1])
    hold on
    %     if i_t==1
    %         plot([x(1),x(end)],[0,0],'-k');
    %     end
    y = cell2mat({D.distance_corr_all}');
    y=y(:,2:end);
    ymean=nanmean(y,1);
    ystem=nanstd(y,1)/sqrt(size(y,1));
    shadedErrorBar(x(2:end),ymean,ystem,'lineprops',{'-','Color',colors})
    %                 ylim([0,max(ymean+ystem)])
    %     ylabel(sprintf('Pairwise Correlation'));
    xlim([min_x max_x]);
    xlabel('Lateral Distance (\mum)');
    title(sprintf('Behavior\n'));
    %         ylim([-0.005 0.35]);
    ylim(yl);
    
end

fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end

figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);

save([dir_current_fig '\Data_dff.mat'],'Data_dff');
% save([dir_current_fig '\Data_spikes.mat'],'Data_spikes');