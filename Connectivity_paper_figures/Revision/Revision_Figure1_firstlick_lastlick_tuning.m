function Revision_Figure1_firstlicl_lastlick_tuning
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
dir_embeded_graphics=dir_current_fig;

filename=[sprintf('FigureRevision1_v1')];

% PAPER_graphics_definition_Figure1
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
% key=IMG.ROI & (LICK2D.ROILick2DPSTHStatsSpikesLastLick & 'psth_regular_odd_vs_even_corr>0.25') & (LICK2D.ROILick2DPSTHSpikesModulationLastLick & 'psth_regular_modulation>25');

%% Inclusion  by tuning aligned for 1st tongue contact
%----------------------------------------------------
key=PAPER.ROILICK2DInclusion & (LICK2D.ROILick2DPSTHStatsSpikes & 'psth_regular_odd_vs_even_corr>0.25') & (LICK2D.ROILick2DPSTHSpikesModulation & 'psth_regular_modulation>25') ;

% PSTH aligned to lick port presentation
PSTH_all = cell2mat(fetchn(LICK2D.ROILick2DPSTHSpikesLickport & key,'psth_regular'));
psth_time = fetch1(LICK2D.ROILick2DPSTHSpikesLickport & key,'psth_time', 'LIMIT 1');
flag_plot_colorbar=0;
title_name='target presentation';
flag_legend=1;
fn_plot_PSTH_aligned_to_different_times_Revision (1,1, PSTH_all, psth_time, flag_plot_colorbar, title_name, flag_legend)

% PSTH aligned to first contact lick
PSTH_all = cell2mat(fetchn(LICK2D.ROILick2DPSTHSpikesLongerInterval & key,'psth_regular'));
psth_time = fetch1(LICK2D.ROILick2DPSTHSpikesLongerInterval & key,'psth_time', 'LIMIT 1');
flag_plot_colorbar=0;
title_name='first contact-lick';
flag_legend=0;
fn_plot_PSTH_aligned_to_different_times_Revision (2,1, PSTH_all, psth_time, flag_plot_colorbar, title_name, flag_legend)


% PSTH aligned to last contact lick
PSTH_all = cell2mat(fetchn(LICK2D.ROILick2DPSTHSpikesLastLick & key,'psth_regular'));
psth_time = fetch1(LICK2D.ROILick2DPSTHSpikesLastLick & key,'psth_time', 'LIMIT 1');
flag_plot_colorbar=1;
title_name='last contact-lick';
flag_legend=0;
fn_plot_PSTH_aligned_to_different_times_Revision (3,1, PSTH_all, psth_time, flag_plot_colorbar, title_name, flag_legend)


% % PSTH of all cells
% ax5=axes('position',[position_x2(1),position_y22(1), panel_width3, panel_height3]);
% PSTH_all = PSTH_all./max(PSTH_all,[],2);
% [~,idx_max_time] = max(PSTH_all,[],2);
% peaktime_psth=psth_time(idx_max_time)';
% 
% [~, idx_neurons_sorted] = sort(idx_max_time);
% imagesc(psth_time,[],PSTH_all(idx_neurons_sorted,:))
% colormap(ax5,inferno)
% xl = [floor(psth_time(1)) ceil(psth_time(end))];
% yl =[0 numel(idx_neurons_sorted)];
% text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.5, sprintf('Time to last \ncontact-lick (s)'), 'FontSize',6,'HorizontalAlignment','Center');
% text(-2.5,numel(idx_neurons_sorted),sprintf('Neurons'),'Rotation',90, 'FontSize',6);
% set(gca,'XTick',[0,5],'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
% % set(gca,'XTick',[0,xl(end)],'Ytick',[1, 100000],'YtickLabel',[{'1', '100,000'}],'TickLength',[0.05,0], 'FontSize',6);
% 
% %colorbar
% ax8=axes('position',[position_x2(1),position_y22(1), panel_width3, panel_height3]);
% colormap(ax8,inferno)
% cb1 = colorbar();
% axis off
% set(cb1,'Ticks',[0, 1], 'FontSize',6);
% text(5,0.5,sprintf('Activity (norm.)'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','Center');
% set(gca, 'FontSize',6);
% 
% % Preferred time all PSTHs
% axes('position',[position_x2(1),position_y22(1)+0.04, panel_width3, panel_height3*0.5])
% % h=histogram(psth_time(idx_max_time),10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
% [hhh1,edges]=histcounts(peaktime_psth,linspace(-1,6,15));
% hhh1=100*hhh1/sum(hhh1);
% bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
% yl = [0, max(hhh1)];
% yl(2)=20;
% xl = [floor(psth_time(1)) ceil(psth_time(end))];
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.25,sprintf('Neurons \n  (%%)'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
% xlim(xl);
% ylim(yl);
% set(gca,'XTick',[],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
% box off;
% % title(sprintf('Temporal tuning\n%d cells',numel(peaktime_psth)), 'FontSize',6);
% title(sprintf('Temporal tuning\n'), 'FontSize',6);
% text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.75, 'g', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




key=(LICK2D.ROILick2DPSTHStatsSpikes & 'peaktime_psth_regular>0.5') & (EXP2.TrialLickBlock & 'num_licks_for_reward=2');

first_lick_modulation = fetchn((LICK2D.ROILick2DPSTHSpikesModulation-IMG.Mesoscope) & key,'psth_regular_modulation','zORDER BY roi_number');
last_lick_modulation = fetchn(LICK2D.ROILick2DPSTHSpikesModulationLastLick & key,'psth_regular_modulation','ORDER BY roi_number');
lickport_presentation_modulation = fetchn(LICK2D.ROILick2DPSTHSpikesModulationLickport & key,'psth_regular_modulation','ORDER BY roi_number');
% 
% first_lick_stability = fetchn((LICK2D.ROILick2DPSTHStatsSpikes-IMG.Mesoscope)& key,'psth_regular_odd_vs_even_corr','ORDER BY roi_number');
% last_lick_stability = fetchn(LICK2D.ROILick2DPSTHStatsSpikesLastLick& key,'psth_regular_odd_vs_even_corr','ORDER BY roi_number');
% lickport_presentation_stability = fetchn(LICK2D.ROILick2DPSTHStatsSpikesLickport& key,'psth_regular_odd_vs_even_corr','ORDER BY roi_number');



subplot(3,3,1)
hold on
dscatter(first_lick_modulation,last_lick_modulation)
plot([0,100],[0,100]);
xlim([0,100]);
ylim([0,100]);
xlabel('Aligned: First Lick')
ylabel('Aligned: Last Lick')
[h,p]=ttest(first_lick_modulation,last_lick_modulation);
title(sprintf('Modulation Depth p =<%.20f',p))

% subplot(3,3,3)
CI=(first_lick_modulation-last_lick_modulation)./(first_lick_modulation+last_lick_modulation);
% histogram(CI)
mean(CI)

subplot(3,3,2)
hold on
dscatter(first_lick_modulation,lickport_presentation_modulation)
plot([0,100],[0,100]);
xlim([0,100]);
ylim([0,100]);
xlabel('Aligned: First Lick')
ylabel('Aligned: Lickport presentation')
[h,p]=ttest(first_lick_modulation,lickport_presentation_modulation);
title(sprintf('Modulation Depth p =<%.20f',p))
% 
% subplot(3,3,4)
% hold on
% dscatter(first_lick_stability,last_lick_stability)
% plot([-1,1],[-1,1]);
% xlim([-1,1]);
% ylim([-1,1]);
% xlabel('Aligned: First Lick')
% ylabel('Aligned: Last Lick')
% title('Stability (odd/even corr)')
% 
% 
% subplot(3,3,5)
% hold on
% dscatter(first_lick_stability,lickport_presentation_stability)
% plot([-1,1],[-1,1]);
% xlim([0,1]);
% ylim([0,1]);
% xlabel('Aligned: First Lick')
% ylabel('Aligned: Lickport presentation')
% title('Stability (odd/even corr)')
% 
