function [psth_time, psth_max] = fn_plot_single_cell_psth_example_reward_real (rel_example, roi_number_uid, xlabel_flag, ylabel_flag,panel_legend, cell_number, order)
key_roi.roi_number_uid =roi_number_uid;
P =fetch(rel_example & key_roi,'*');

psth_time = P.psth_time;
psth_max = max([max([P.psth_regular+P.psth_regular_stem]), max([P.psth_small+P.psth_small_stem]), max([P.psth_large+P.psth_large_stem])]);
psth_regular= P.psth_regular/psth_max;
psth_regular_stem= P.psth_regular_stem/psth_max;
psth_small= P.psth_small/psth_max;
psth_small_stem= P.psth_small_stem/psth_max;
psth_large= P.psth_large/psth_max;
psth_large_stem= P.psth_large_stem/psth_max;
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
    set(gca,'XTick',[0,4],'TickLength',[0.05,0], 'FontSize',6);
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
    text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*2.5, sprintf('%s',panel_legend), ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
end
text(xl(1)+diff(xl)*0.2,yl(1)+diff(yl)*1.2,sprintf('Cell %d',cell_number),'HorizontalAlignment','left', 'FontSize',6);
