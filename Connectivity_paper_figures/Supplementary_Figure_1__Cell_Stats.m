function Supplementary_Figure_1__Cell_Stats
close all;


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_Figure_1__Cell_Stats')];

rel_roi=PAPER.ROILICK2DInclusion;





%Graphics
%---------------------------------
fig=gcf;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
left_color=[0 0 0];
right_color=[0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

panel_width1=0.06;
panel_height1=0.06;
horizontal_dist1=0.12;
vertical_dist1=0.15;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.67;
position_y1(end+1)=position_y1(end)-vertical_dist1;





%% Temporal tuning similarity,\nacross positions
axes('position',[position_x1(1),position_y1(2), panel_width1, panel_height1])
hold on
psth_regular_odd_vs_even_corr = fetchn( LICK2D.ROILick2DPSTHStatsSpikes & rel_roi,'psth_regular_odd_vs_even_corr');
sigfnif_threshold=0.25;
[hhh3,edges]=histcounts([psth_regular_odd_vs_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nstability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.35, 'c', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);



axes('position',[position_x1(2),position_y1(2), panel_width1, panel_height1])
hold on
psth_position_concat_regular_odd_even_corr = fetchn( LICK2D.ROILick2DmapStatsSpikes3binsShort & rel_roi,'psth_position_concat_regular_odd_even_corr');
sigfnif_threshold=0.25;
[hhh3,edges]=histcounts([psth_position_concat_regular_odd_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location-temporal \ntuning stability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.35, 'd', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);




axes('position',[position_x1(3),position_y1(2), panel_width1, panel_height1])
hold on
lickmap_regular_odd_vs_even_corr = fetchn( LICK2D.ROILick2DmapStatsSpikes3binsShort & rel_roi,'lickmap_regular_odd_vs_even_corr');
sigfnif_threshold=0.25;
[hhh3,edges]=histcounts([lickmap_regular_odd_vs_even_corr],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=15;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4, [sprintf('Tuning corr.,') newline '{\it r} (odd,even)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location tuning\nstability'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.35, 'e', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);


axes('position',[position_x1(4),position_y1(2), panel_width1, panel_height1])
hold on
lickmap_fr_regular_modulation = fetchn( LICK2D.ROILick2DmapSpikes3binsModulation & rel_roi,'lickmap_fr_regular_modulation');
sigfnif_threshold=25;
[hhh3,edges]=histcounts([lickmap_fr_regular_modulation],linspace(0,100,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4, [sprintf('Tuning modulation') newline '(%)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Location tuning\nmodulation'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.35, 'f', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);




if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




