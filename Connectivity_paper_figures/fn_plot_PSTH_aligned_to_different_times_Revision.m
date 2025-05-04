function fn_plot_PSTH_aligned_to_different_times_Revision (plot_x, plot_y, PSTH_all, psth_time, flag_plot_colorbar, title_name, flag_legend)

% PSTH - position averaged
panel_width3=0.05;
panel_height3=0.04;
horizontal_dist2=0.1;
vertical_dist2=0.045;
position_x2(1)=0.05;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;


position_y22(1)=0.784;
position_y22(2)=position_y22(1)-vertical_dist2;




% PSTH of all cells
ax5=axes('position',[position_x2(plot_x),position_y22(plot_y), panel_width3, panel_height3]);
PSTH_all = PSTH_all./max(PSTH_all,[],2);
[~,idx_max_time] = max(PSTH_all,[],2);
peaktime_psth=psth_time(idx_max_time)';

[~, idx_neurons_sorted] = sort(idx_max_time);
imagesc(psth_time,[],PSTH_all(idx_neurons_sorted,:))
colormap(ax5,inferno)
xl = [floor(psth_time(1)) ceil(psth_time(end))];
yl =[0 numel(idx_neurons_sorted)];
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.5, sprintf('Time to \n%s (s)', title_name), 'FontSize',6,'HorizontalAlignment','Center');
text(-2.5,numel(idx_neurons_sorted),sprintf('Neurons'),'Rotation',90, 'FontSize',6);
set(gca,'XTick',[0,5],'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
% set(gca,'XTick',[0,xl(end)],'Ytick',[1, 100000],'YtickLabel',[{'1', '100,000'}],'TickLength',[0.05,0], 'FontSize',6);

if flag_plot_colorbar==1
    %colorbar
    ax8=axes('position',[position_x2(plot_x)+0.05,position_y22(plot_y), panel_width3, panel_height3]);
    colormap(ax8,inferno)
    cb1 = colorbar();
    axis off
    set(cb1,'Ticks',[0, 1], 'FontSize',6);
    text(5,0.5,sprintf('Activity (norm.)'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','Center');
    set(gca, 'FontSize',6);
end

% Preferred time all PSTHs
axes('position',[position_x2(plot_x),position_y22(plot_y)+0.04, panel_width3, panel_height3*1])
% h=histogram(psth_time(idx_max_time),10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
[hhh1,edges]=histcounts(peaktime_psth,linspace(-1,6,15));
hhh1=100*hhh1/sum(hhh1);
bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh1)];
yl(2)=25;
half_bin =mean(diff(edges))/2;
xl = [(psth_time(1)-half_bin), ceil(psth_time(end))];
% xl = [floor(psth_time(1)), ceil(psth_time(end))];

xlim(xl);
ylim(yl);
set(gca,'XTick',[0,5],'XTickLabel',[],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
% title(sprintf('Temporal tuning\n%d cells',numel(peaktime_psth)), 'FontSize',6);
title(sprintf('Temporal tuning\naligned to\n%s\n',title_name), 'FontSize',6);
if flag_legend==1
    text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.75, 'a', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
    text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.25,sprintf('Neurons \n  (%%)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
end
