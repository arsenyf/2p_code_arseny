function Supplementary_Figure_3_GLM
close all;

rel_roi = PAPER.ROILICK2DInclusion & (EXP2.Session & 'session>=0' ) - IMG.Mesoscope ;


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\Revision\'];

filename=[sprintf('Supplementary_Figure_GLM2')];
% PAPER_graphics_definition_SupFig3
%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

%% behavior cartoon
% panel_width1=0.12;
% panel_height1=0.12;
% horizontal_dist1=0.1;
% vertical_dist1=0.1;
% position_x1(1)=0.06;
% position_y1(1)=0.78;


panel_width1=0.08;
panel_height1=0.06;
horizontal_dist1=0.1;
vertical_dist1=0.13;
position_x1(1)=0.12;
position_y1(1)=0.77;



% PSTH - position averaged
panel_width2=0.05;
panel_height2=0.03;
horizontal_dist2=0.09;
vertical_dist2=0.045;
position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;


position_y2(1)=0.65;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;


% Scatters
panel_width3=0.1;
panel_height3=0.07;
horizontal_dist3=0.4;
vertical_dist3=0.15;
position_x3(1)=0.4;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;

position_y3(1)=0.7;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;

%for plotting tuning curves
rel_example_psth = IMG.ROIID* LICK2D.ROILick2DPSTHSpikesResampledlikePoisson;
rel_example_psth_poisson = IMG.ROIID* LICK2D.ROILick2DPSTHSpikesGLM;


%% Summary Statistics
rel_roi_small_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_small<=0.05');
rel_roi_large_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_large<=0.05');

%cells signficant by reward regardless of GLM
GLM_small_signif = fetch(LICK2D.ROILick2DPSTHStatsSpikesGLM &  rel_roi_small_signif,'*') ;
GLM_large_signif = fetch(LICK2D.ROILick2DPSTHStatsSpikesGLM &  rel_roi_large_signif,'*') ;

%all cells
GLM_all = fetch(LICK2D.ROILick2DPSTHStatsSpikesGLM &  rel_roi,'*') ;






%% GLM Summary Stats
sigThreshold = 0.01;
nTotal = size(GLM_all, 1);
nSmall = size(GLM_small_signif, 1);
nLarge = size(GLM_large_signif, 1);



%% === GLM stats for all neurons ===
lickResponsive_all = sum([GLM_all.p_val_lick_model2] < sigThreshold);
rewardResponsive_small_all = sum([GLM_all.p_val_llr_small] < sigThreshold);
rewardResponsive_large_all = sum([GLM_all.p_val_llr_large] < sigThreshold);

% Percentages out of all neurons
perc_lick_all = 100 * lickResponsive_all / nTotal
perc_reward_small_all = 100 * rewardResponsive_small_all / nTotal
perc_reward_large_all = 100 * rewardResponsive_large_all / nTotal




%% === GLM stats for all sigfnicant neurons (significance unrelated to GLM) ===


% Small reward stats, out of cells signficant by reward regardless of GLM
lickResponsive_small_signif = sum([GLM_small_signif.p_val_lick_model2] < sigThreshold);
rewardResponsive_small_signif = sum([GLM_small_signif.p_val_llr_small] < sigThreshold);

% Large reward stats, out of cells signficant by reward regardless of GLM
lickResponsive_large_signif = sum([GLM_large_signif.p_val_lick_model2] < sigThreshold);
rewardResponsive_large_signif = sum([GLM_large_signif.p_val_llr_large] < sigThreshold);

% Percentages out of significant cells
perc_lick_small_signif  = 100 * lickResponsive_small_signif  / nSmall
perc_lick_large_signif  = 100 * lickResponsive_large_signif  / nLarge
perc_reward_small_signif = 100 * rewardResponsive_small_signif / nSmall
perc_reward_large_signif = 100 * rewardResponsive_large_signif / nLarge




%% PLOT SETTINGS
minP = 1e-10;
maxP = 1;
nBins = 10;

colors = {[0 0.6 0],[1 0.5 0]};
jitter_frac = 1;


%% Lick p-values Panel (Histogram + Scatter)
pvals_all = max([GLM_all.p_val_lick_model2], minP);
pvals_sig_large = max([GLM_large_signif.p_val_lick_model2], minP);
pvals_sig_small = max([GLM_small_signif.p_val_lick_model2], minP);

counts_all = histcounts(pvals_all, logspace(log10(minP), log10(maxP), nBins+1));
counts_sig_large = histcounts(pvals_sig_large, logspace(log10(minP), log10(maxP), nBins+1));
counts_sig_small = histcounts(pvals_sig_small, logspace(log10(minP), log10(maxP), nBins+1));

axes('position',[position_x3(1),position_y3(1), panel_width3, panel_height3])

hold on;
log_hist_plot(counts_all, counts_sig_small, minP, maxP, nBins, colors{1});
log_hist_plot(0,counts_sig_large, minP, maxP, nBins, colors{2});
xline(sigThreshold, 'r--');
title(sprintf('Licking predictor:\ncoefficient significance'));
xlabel('p-value (GLM coefficient)')
text(0.0000001,0.75, sprintf('p < %.3g', sigThreshold),'Color',[1 0 0]);

%% LLR Large Panel (Histogram + Scatter)
pvals_all = max([GLM_all.p_val_llr_large], minP);
pvals_sig_large = max([GLM_large_signif.p_val_llr_large], minP);
counts_all = histcounts(pvals_all, logspace(log10(minP), log10(maxP), nBins+1));
counts_sig = histcounts(pvals_sig_large, logspace(log10(minP), log10(maxP), nBins+1));

axes('position',[position_x3(1),position_y3(2), panel_width3, panel_height3])
hold on;
log_hist_plot(0, counts_sig, minP, maxP, nBins, colors{2});
title(sprintf('Reward-increase predictor:\n model improvement test'));

set(gca, 'XScale', 'log');
xline(sigThreshold, 'r--');
xlim([minP, maxP]);
xlabel('p-value (likelihood ratio test)')
% subplot(2,4,5); hold on;
% log_scatter_plot(pvals_all, pvals_sig, [GLM_all.reward_coeff_large], [GLM_large_signif.reward_coeff_large], jitter_frac, minP, maxP);
% ylabel('Reward Coeff'); xlabel('p-value');
% title('Reward Coeff (large)');

%% LLR Small Panel (Histogram + Scatter)
pvals_all = max([GLM_all.p_val_llr_small], minP);
pvals_sig_small = max([GLM_small_signif.p_val_llr_small], minP);
counts_all = histcounts(pvals_all, logspace(log10(minP), log10(maxP), nBins+1));
counts_sig = histcounts(pvals_sig_small, logspace(log10(minP), log10(maxP), nBins+1));

axes('position',[position_x3(1),position_y3(3), panel_width3, panel_height3])

hold on;
log_hist_plot(0, counts_sig, minP, maxP, nBins, colors{1});
title(sprintf('Reward-omission predictor:\n model improvement test'));
set(gca, 'XScale', 'log');
xline(sigThreshold, 'r--');
xlim([minP, maxP]);
xlabel('p-value (likelihood ratio test)')



% axes('position', [position_x3(1), position_y3(4), panel_width3, panel_height3]);
% hold on;
% 
% % Extract coefficients
% coeff_small = [GLM_all.reward_coeff_small];
% coeff_large = [GLM_all.reward_coeff_large];
% 
% % Plot histograms
% edges = linspace(-1.5, 1.5, 30);
% histogram(coeff_small, edges, 'FaceColor', colors{1}, 'EdgeAlpha', 0.4, 'DisplayStyle', 'bar', 'Normalization', 'probability');
% histogram(coeff_large, edges, 'FaceColor', colors{2}, 'EdgeAlpha', 0.4, 'DisplayStyle', 'bar', 'Normalization', 'probability');
% 
% xline(0, 'k--');
% xlabel('Reward coefficient');
% ylabel('Fraction');
% legend({'Omission', 'Increase'}, 'Location', 'northeast');
% title('Reward coefficient distribution');
% % Compute t-test across reward coefficients
% [~, p_ttest, ~, stats] = ttest([GLM_all.reward_coeff_large]);
% t_stat = stats.tstat;
% df_stat = stats.df;



%% Helper function: Histogram log-scale
    function log_hist_plot(counts_all, counts_sig, minP, maxP, nBins, colors)
        binEdges = logspace(log10(minP), log10(maxP), nBins+1);
        binWidths = diff(binEdges);
        for i = 1:nBins
            if sum(counts_all)>0
                
                rectangle('Position', [binEdges(i), 0, binWidths(i), counts_all(i)/sum(counts_all)], 'FaceColor', [0 0 0], 'EdgeColor', 'none');
            end
            rectangle('Position', [binEdges(i), 0, binWidths(i), counts_sig(i)/sum(counts_sig)], 'EdgeColor', colors, 'LineWidth',1.5);
        end
        set(gca, 'XScale', 'log');
        xlim([minP, maxP]);
        ylim([0, 1]);
        %     xticks(logspace(log10(minP), 0, 10));
        %         xticks('');
        %     xtickformat('%.0e');
        ylabel('Fraction');
        %     grid on;
    end

%% Helper function: Scatter with log jitter
    function log_scatter_plot(pvals_all, pvals_sig, coeff_all, coeff_sig, jitter_frac, minP, maxP)
        jitter_all = pvals_all .* 10.^(jitter_frac * (rand(size(pvals_all)) - 0.5));
        jitter_sig = pvals_sig .* 10.^(jitter_frac * (rand(size(pvals_sig)) - 0.5));
        scatter(jitter_all, coeff_all, 12, 'k', '.');
        scatter(jitter_sig, coeff_sig, 12, 'r', '.');
        set(gca, 'XScale', 'log');
        xline(0.01, 'r--');
        xlim([minP, maxP]);
        ylim([-1, 1]);
        grid on;
    end


% === Panel 1: Normalized histogram + scatter on log-x ===

% %%
%
% % === Panel 1: Normalized histogram + scatter on log-x ===
%
% % --- Setup ---
% % Setup
% minP = 1e-8;
% maxP = 1;
% nBins = 10;
%
% pvals_all = max([GLM_all.p_val_llr_large], minP);
% pvals_sig = max([GLM_large_signif.p_val_llr_large], minP);
%
% % Bin edges (log-spaced) and geometric bin centers
% binEdges = logspace(log10(minP), log10(maxP), nBins+1);
% binCenters = sqrt(binEdges(1:end-1) .* binEdges(2:end));  % geometric mean
% binWidths = diff(binEdges);
%
% % Histogram counts
% counts_all = histcounts(pvals_all, binEdges);
% counts_sig = histcounts(pvals_sig, binEdges);
%
% % Normalize to total number of neurons
% norm_all = counts_all / numel(pvals_all);
% norm_sig = counts_sig / numel(pvals_sig);  % not numel(pvals_sig)
%
% % Plot using log-scale-aware bar widths
% subplot(4,2,1); cla; hold on;
%
% for i = 1:length(binCenters)
%     % Yellow bar (all)
%     rectangle('Position', [binEdges(i), 0, binWidths(i), norm_all(i)], ...
%               'FaceColor', [0 0 0], 'EdgeColor', 'none');
%     % Purple bar (significant)
%     rectangle('Position', [binEdges(i), 0, binWidths(i), norm_sig(i)], ...
%               'FaceColor','none', 'EdgeColor',  [1 0 0]);
% end
%
% set(gca, 'XScale', 'log');
% xlim([minP, maxP]);
% ylim([0, max([norm_all, norm_sig]) * 1.1]);
% xticks(logspace(log10(minP), 0, 9));
% xtickformat('%.0e');
% ylabel('Fraction of total neurons');
% title('LLR p-values (raw, log scale)');
% legend({'All', 'Significant'}, 'Location', 'northeast');
% grid on;
% set(gca, 'XTickLabel', []);  % optional
%
%
% % --- Bottom scatter subplot with larger jitter ---
% subplot(4,2,3); hold on;
%
% % Apply larger log-space jitter: ±0.5 log10 units (? 10× spread range)
% jitter_frac = 1;
% pvals_all_jitter = pvals_all .* 10.^(jitter_frac * (rand(size(pvals_all)) - 0.5));
% pvals_sig_jitter = pvals_sig .* 10.^(jitter_frac * (rand(size(pvals_sig)) - 0.5));
%
% scatter(pvals_all_jitter, [GLM_all.reward_coeff_large], '.k');
% scatter(pvals_sig_jitter, [GLM_large_signif.reward_coeff_large], '.r');
% xline(0.01, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
%
% set(gca, 'XScale', 'log');
% xlim([minP, maxP]);
% ylim([-2.5, 2.5]);
% xlabel('LLR p-value (raw)');
% ylabel('Reward coefficient');
% grid on;



%%

% % Panel 1 with normalized marginal histogram
% subplot(4,2,1);  % top row, column 1 (marginal)
% hold on
% [counts1, edges] = histcounts(-log10([GLM_all.p_val_llr_large]),[0:0.5:7.5]);
% bar(edges(1:end-1),counts1./sum(counts1))
% [counts2, edges] = histcounts(-log10([GLM_large_signif.p_val_llr_large]),[0:0.5:7.5]);
% bar(edges(1:end-1),counts2./sum(counts2))
%
%
%
%
% subplot(4,2,3);  % second row, column 1 (scatter)
% hold on
% scatter(-log10([GLM_all.p_val_llr_large]), [GLM_all.reward_coeff_large], '.k');
% scatter(-log10([GLM_large_signif.p_val_llr_large]), [GLM_large_signif.reward_coeff_large], '.r');
% xline(2, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
% ylim([-1,1]);
% xlim([0,6]);
% xlabel('-log_{10}(p_{LLR, large})');
% ylabel('Reward coeff');

% subplot(2,2,1)
% hold on
% scatter(-log10([GLM_all.p_val_llr_large]),[GLM_all.reward_coeff_large],'.k');
% scatter(-log10([GLM_large_signif.p_val_llr_large]),[GLM_large_signif.reward_coeff_large],'.r');
% sum(-log10([GLM_large_signif.p_val_llr_large])<2)
% xline(2, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
% ylim([-1,1]);
% xlim([0,6]);
%
% subplot(2,2,2)
% hold on
% scatter(-log10([GLM_all.p_val_llr_small]),[GLM_all.reward_coeff_small],'.k');
% scatter(-log10([GLM_small_signif.p_val_llr_small]),[GLM_small_signif.reward_coeff_small],'.g');
%
% xline(2, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
% ylim([-1,1]);
% xlim([0,6]);
%
% subplot(2,2,3)
% hold on
% scatter(-log10([GLM_all.p_val_lick_model2]),[GLM_all.reward_coeff_large],'.k');
% xline(2, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
% ylim([-1,1]);
%
% subplot(2,2,4)
% hold on
% scatter(-log10([GLM_all.p_val_lick_model2]),[GLM_all.reward_coeff_small],'.k');
% xline(2, 'r--', 'p = 0.01', 'LabelOrientation', 'horizontal');
% ylim([-1,1]);
%

















%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 77559;
cell_number=1;
panel_legend='b';
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
title(sprintf('Real \ntuning\n\n'));
panel_legend='c';
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
title(sprintf('GLM model 1\ntime + licks\n\n'));
panel_legend='d';
axes('position',[position_x2(3),position_y2(1), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
title(sprintf('GLM model 2\ntime + licks + reward\n\n'));

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 72820; %1264855  % previously was 77887
cell_number=2;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
axes('position',[position_x2(3),position_y2(2), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);


% Example Cell 3 PSTH
axes('position',[position_x2(1),position_y2(3), panel_width2, panel_height2])
roi_number_uid = 1278002;% 1350575;
cell_number=3;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(3), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
axes('position',[position_x2(3),position_y2(3), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);


% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(4), panel_width2, panel_height2])
roi_number_uid = 1304816;
cell_number=4;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(4), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
axes('position',[position_x2(3),position_y2(4), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);

panel_legend=[];
% Example Cell 5 PSTH
axes('position',[position_x2(1),position_y2(5), panel_width2, panel_height2])
roi_number_uid = 1251809;
cell_number=5;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(5), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
axes('position',[position_x2(3),position_y2(5), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);

panel_legend=[];
% Example Cell 6 PSTH
axes('position',[position_x2(1),position_y2(6), panel_width2, panel_height2])
roi_number_uid = 66091;
cell_number=6;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 1, 1,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(6), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
axes('position',[position_x2(3),position_y2(6), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_GLM2(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);








if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);



end
