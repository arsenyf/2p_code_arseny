function [xl] = fn_plot_tuning_vs_connectivity_figure4(rel_data, rel_shuffled, key,title_string, colormap, min_pairs_in_influence_bin, min_session_per_bin)


DATA=struct2table(fetch(rel_data & key,'*', 'ORDER BY session_uid'));
DATA_SHUFFLED=struct2table(fetch(rel_shuffled & key,'*', 'ORDER BY session_uid'));
bins_corr_edges = DATA.bins_corr_edges(1,:);
bins_corr_centers = bins_corr_edges(1:1:end-1) + diff(bins_corr_edges)/2;

bins_influence_edges = DATA.bins_influence_edges(1,:);
if bins_influence_edges(1)==-inf
    bins_influence_edges(1)=bins_influence_edges(2) - (bins_influence_edges(3) - bins_influence_edges(2));
    bins_influence_edges(end)=bins_influence_edges(end-1) + (bins_influence_edges(end-2) - bins_influence_edges(end-3));
end
bins_influence_centers = bins_influence_edges(1:1:end-1) + diff(bins_influence_edges)/2;


idx_subplot = 0;
% %% Correlation versus connectivity
% subplot(2,2,idx_subplot+1)
% hold on
% y=DATA.corr_binned_by_influence;
% y_mean = nanmean(y,1);
% y_stem = nanstd(y,1)./sqrt(size(DATA,1));
% y_shuf=DATA_SHUFFLED.corr_binned_by_influence;
% y_mean_shuf = nanmean(y_shuf,1);
% y_stem_shuf = nanstd(y_shuf,1)./sqrt(size(DATA_SHUFFLED,1));
% %     y_min_max=[min([y_mean,y_mean_shuf]), max([y_mean,y_stem_shuf])];
% if i_c ==1
%     %         plot([bins_influence_centers(1),bins_influence_centers(end)],[0,0],'-k');
%     plot([0,0],[min(y_mean-y_stem),max(y_mean+y_stem)],'-k');
% end
% shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',colormap(i_c,:)})
% shadedErrorBar(bins_influence_centers,y_mean_shuf,y_stem_shuf,'lineprops',{'-','Color',[0.5 0.5 0.5]})
% plot(bins_influence_centers,y_mean_shuf,'.-','Color',[0.5 0.5 0.5])
% plot(bins_influence_centers,y_mean,'.-','Color',colormap)
% 
% xlabel (['Connection stength' newline '(\Delta z-score activity)']);
% ylabel('Tuning Similarity, \itr');
% title(sprintf(title_string));
% box off
% xlim([bins_influence_edges(1), bins_influence_edges(end)]);
% %% Connectivity versus correlation
% subplot(2,2,idx_subplot+2)
% hold on
% y=DATA.influence_binned_by_corr;
% y_mean = nanmean(y,1);
% y_stem = nanstd(y,1)./sqrt(size(DATA,1));
% y_shuf=DATA_SHUFFLED.influence_binned_by_corr;
% y_mean_shuf = nanmean(y_shuf,1);
% y_stem_shuf = nanstd(y_shuf,1)./sqrt(size(DATA_SHUFFLED,1));
% y_min_max=[min([y_mean,y_mean_shuf]), max([y_mean,y_stem_shuf])];
% %     y_min_max_tick=[-0.005, 0.02];
% if i_c ==1
%     %         plot([bins_corr_edges(1),bins_corr_edges(end)],[0,0],'-k');
%     %         plot([0,0],[min(y_mean-y_stem),max(y_mean+y_stem)],'-k');
%     plot([0,0],[y_min_max(1),y_min_max(2)],'-k');
%     xlim([bins_corr_edges(1), bins_corr_edges(end)]);
% end
% %     shadedErrorBar(bins_corr_centers,y_mean,y_stem,'lineprops',{'-','Color',colormap(i_c,:)})
% shadedErrorBar(bins_corr_centers,y_mean,y_stem,'lineprops',{'-','Color',colormap})
% shadedErrorBar(bins_corr_centers,y_mean_shuf,y_stem_shuf,'lineprops',{'-','Color',[0.5 0.5 0.5]})
% plot(bins_corr_centers,y_mean_shuf,'.-','Color',[0.5 0.5 0.5])
% plot(bins_corr_centers,y_mean,'.-','Color',colormap)
% 
% xlabel('Tuning Similarity, \itr');
% ylabel (['Connection stength' newline '(\Delta z-score activity)']);
% title(sprintf(title_string));
% box off
% %     ylim(y_min_max)
% %     set(gca,'Ytick',[y_min_max_tick(1), 0, y_min_max_tick(2)])
% 


%% Residual correlation (i.e. Shuffled subtracted) versus connectivity
xl=[bins_influence_edges(1), bins_influence_edges(end)];
hold on
% y=DATA.corr_binned_by_influence;% - DATA_SHUFFLED.corr_binned_by_influence;
y=DATA.corr_binned_by_influence - DATA_SHUFFLED.corr_binned_by_influence;

try
    idx_influence_pairs_exclude=DATA.num_pairs_in_each_influence_bin<min_pairs_in_influence_bin;
    y(idx_influence_pairs_exclude)=NaN;
catch
end
idx_bins_exclude = sum(~isnan(y))<min_session_per_bin;
y(:,idx_bins_exclude)=NaN;



y_mean = nanmean(y,1);
y_stem = nanstd(y,1)./sqrt(sum(~isnan(y)));
% if i_c ==1
%     plot([bins_influence_centers(1),bins_influence_centers(end)],[0,0],'-k');
%     plot([0,0],[min(y_mean-y_stem),max(y_mean+y_stem)],'-k');
% end
shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',colormap})
plot(bins_influence_centers,y_mean,'.-','Color',colormap)
%     title(sprintf(title_string));
box off
xlim(xl);


