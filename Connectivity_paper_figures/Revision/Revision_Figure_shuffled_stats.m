function Revision_Figure_shuffled_stats ()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename = 'Revision_Shuffled_stats';
figure

PAPER_graphics_definition_Sup_Figure2


rel_roi=PAPER.ROILICK2DInclusion;

rel_signif = LICK2D.ROILick2DPSTHSpikesPvalue & 'psth_regular_modulation_pval<=0.05' & rel_roi;

rel_signif2 = LICK2D.ROILick2DPSTHSpikesModulation & 'psth_regular_modulation>=25' & rel_roi;


% Temporal modulation
axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
hold on
lickmap_fr_regular_modulation = fetchn( LICK2D.ROILick2DPSTHSpikesModulation & rel_roi & rel_signif,'psth_regular_modulation');
sigfnif_threshold=25;
[hhh3,edges]=histcounts([lickmap_fr_regular_modulation],linspace(0,100,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning modulation') newline '(%)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nmodulation'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);

% Temporal modulation
axes('position',[position_x1(2),position_y1(1), panel_width1, panel_height1])
hold on
lickmap_fr_regular_modulation = fetchn( LICK2D.ROILick2DPSTHSpikesModulation & rel_roi & rel_signif2,'psth_regular_modulation');
sigfnif_threshold=25;
[hhh3,edges]=histcounts([lickmap_fr_regular_modulation],linspace(0,100,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning modulation') newline '(%)'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nmodulation'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.5,yl(1)+diff(yl)*0.05, sprintf('All neurons\n      (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.75, yl(1)+diff(yl)*1.5, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
plot([sigfnif_threshold,sigfnif_threshold],yl,'Color',[1 0 0],'LineWidth',2);

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
eval(['print ', figure_name_out, ' -dpdf -r200']);
