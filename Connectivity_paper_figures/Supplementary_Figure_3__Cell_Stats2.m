function Supplementary_Figure_3__Cell_Stats2
close all;

%% Stability all PSTHs
axes('position',[position_x2(4),position_y2(2), panel_width4, panel_height4])
h=histogram([D.psth_regular_odd_vs_even_corr],10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
yl = [0, max(h.Values)];
xl = [-1,1];
xlabel(sprintf('Tuning stability, \\itr\\it'))
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Counts'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
title(sprintf('Response-time\n tuning'), 'FontSize',6);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1, 0, 1],'Ytick',[0, 50000],'YtickLabel',[{'0', '50,000'}],'TickLength',[0.05,0], 'FontSize',6);
box off


axes('position',[position_x4(1),position_y4(1), panel_width4, panel_height4])
h=histogram([D.psth_position_concat_regular_odd_even_corr],10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% xlabel(sprintf('Stability across position and response time\n r (odd trials,even trials)'))
yl = [0, max(h.Values)];
xl = [-1,1];
xlabel(sprintf('Tuning stability, \\itr\\it'))
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Counts'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
title(sprintf('Response-time and\n Positional tuning'), 'FontSize',6);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1, 0, 1],'Ytick',[0, 30000],'YtickLabel',[{'0', '30,000'}],'TickLength',[0.05,0], 'FontSize',6);
box off

axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4])
h=histogram([D.lickmap_regular_odd_vs_even_corr],10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% xlabel(sprintf('Stability across position and response time\n r (odd trials,even trials)'))
yl = [0, max(h.Values)];
xl = [-1,1];
xlabel(sprintf('Tuning stability, \\itr\\it'))
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Counts'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
title(sprintf('Positional tuning'), 'FontSize',6);
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1, 0, 1],'Ytick',[0, 25000],'YtickLabel',[{'0', '25,000'}],'TickLength',[0.05,0], 'FontSize',6);
box off

axes('position',[position_x4(3),position_y4(1), panel_width4, panel_height4])
h=histogram([D.information_per_spike_regular],[linspace(0,0.2,10),inf],'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
yl = [0, max(h.Values)];
xl = [0,0.22];
xlabel(sprintf('Spatial information \n(bits/spike)'));
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Counts'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
title(sprintf('Positional tuning'), 'FontSize',6);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0, 0.2],'Ytick',[0, 75000],'YtickLabel',[{'0', '75,000'}],'TickLength',[0.05,0], 'FontSize',6);
box off