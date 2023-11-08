function yl = fn_plot_corr_vs_connectivity_figure4_residual(DATA,DATA_SHUFFLED,idx_influence_pairs_exclude, min_session_per_bin, bins_influence_centers,colormap,bins_influence_edges, flag_plot)
% %% Residual correlation (i.e. Shuffled subtracted) versus connectivity

hold on
y=DATA.corr_binned_by_influence - DATA_SHUFFLED.corr_binned_by_influence;
try
    y(idx_influence_pairs_exclude)=NaN;
catch
end
idx_bins_exclude = sum(~isnan(y))<min_session_per_bin;
y(:,idx_bins_exclude)=NaN;

y_mean = nanmean(y,1);
y_stem = nanstd(y,1)./sqrt(sum(~isnan(y)));

% y_stem = nanstd(y,1)./sqrt(size(DATA,1));
yl=[min(y_mean-y_stem),max(y_mean+y_stem)];

if flag_plot==1
%     plot([bins_influence_centers(1),bins_influence_centers(end)],[0,0],'-k');
%     plot([0,0],[min(y_mean-y_stem),max(y_mean+y_stem)],'-k');
    shadedErrorBar(bins_influence_centers,y_mean,y_stem,'lineprops',{'-','Color',colormap(1,:)})
%     plot(bins_influence_centers,y_mean,'.-','Color',colormap)
%     xlabel (['Connection stength' newline '(\Delta z-score activity)']);
%     ylabel([sprintf('Noise correlation, \n residual') ' \itr']);
    %     title(sprintf(title_string));
    box off
    xlim([bins_influence_edges(1), bins_influence_edges(end)]);
    
end