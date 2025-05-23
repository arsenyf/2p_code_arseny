function [psth_time] = fn_plot_single_cell_psth_example_reward_GLM2 (rel_example, roi_number_uid, xlabel_flag, ylabel_flag,panel_legend, cell_number, psth_max)
key_roi.roi_number_uid =roi_number_uid;
P =fetch(rel_example & key_roi,'*');

psth_time = P.psth_time_glm;
% psth_max = max([max([P.psth_regular_poisson+P.psth_regular_stem_poisson]), max([P.psth_small_poisson+P.psth_small_stem_poisson]), max([P.psth_large_poisson+P.psth_large_stem_poisson])]);
% we normalize relative to the non-Poisson (e.g. real tuning )maximum across conditions
psth_regular= P.psth_regular_glm2/psth_max;
psth_regular_stem= P.psth_regular_stem__glm2/psth_max;
psth_small= P.psth_small__glm2/psth_max;
psth_small_stem= P.psth_small_stem__glm2/psth_max;
psth_large= P.psth_large__glm2/psth_max;
psth_large_stem= P.psth_large_stem__glm2/psth_max;
hold on;
% plot([0,0],[0,1],'-k','linewidth',0.25)
lineProps.style='-';
lineProps.width=0.05;

lineProps.col={[ 1 0.3 0]};
mseb(psth_time,psth_large, psth_large_stem,lineProps);




lineProps.col={[0 0.7 0.2]};
mseb(psth_time,psth_small, psth_small_stem,lineProps);

lineProps.col={[ 0 0 0.8]};
mseb(psth_time,psth_regular, psth_regular_stem,lineProps);


% xl = [floor(psth_time(1)) ceil(psth_time(end))];
xl = [0 ceil(psth_time(end))];
xlim(xl);
yl=[0,1];
ylim(yl);
if xlabel_flag ==1
    text(xl(1)-diff(xl)*0.2,yl(1)-diff(yl)*0.5,sprintf('Time to 1st contact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
    set(gca,'XTick',[0,5],'TickLength',[0.05,0], 'FontSize',6);
else
    set(gca,'XTick',[],'TickLength',[0.05,0], 'FontSize',6);
end

if ylabel_flag==1
    text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.2,sprintf('Activity (norm.)'),'HorizontalAlignment','left','Rotation',90, 'FontSize',6);
    set(gca,'Ytick',[0, 1],'TickLength',[0.05,0], 'FontSize',6);
else
    set(gca,'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
end
if ~isempty(panel_legend)
    text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*2.5, sprintf('%s',panel_legend), ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
end
% text(xl(1)+diff(xl)*0.2,yl(1)+diff(yl)*1.2,sprintf('Cell %d',cell_number),'HorizontalAlignment','left', 'FontSize',6, 'fontweight', 'bold');
