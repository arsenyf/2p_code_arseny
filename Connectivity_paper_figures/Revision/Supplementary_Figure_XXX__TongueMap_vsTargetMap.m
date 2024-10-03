function Supplementary_Figure_XXX__TongueMap_vsTargetMap
close all;


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];

filename=[sprintf('Revision_Supplementary_Figure_XXX__TongueMap_vsTargetMap')];

rel_roi=PAPER.ROILICK2DInclusion;

r_target = fetchn(LICK2D.ROILick2DmapStatsSpikes & (rel_roi & LICK2D.ROILick2DmapStatsSpikesTongueMap), 'lickmap_regular_odd_vs_even_corr');
r_tongue= fetchn(LICK2D.ROILick2DmapStatsSpikesTongueMap & rel_roi, 'lickmap_regular_odd_vs_even_corr');

subplot(2,2,1)
plot(r_target,r_tongue,'.k')
xlabel('Stability based on target position')
ylabel('Stability based on tongue position')
title(sprintf('Mean r %.2f target,\n mean r %.2f tongue',mean(r_target),mean(r_tongue)))
mean(r_target)
mean(r_tongue)

% subplot(2,2,2)
% p_value_threshold=0.05;
% rel_signif=LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold)
% r_target = fetchn(LICK2D.ROILick2DmapStatsSpikes & (rel_signif & LICK2D.ROILick2DmapStatsSpikesTongueMap), 'lickmap_regular_odd_vs_even_corr');
% r_tongue= fetchn(LICK2D.ROILick2DmapStatsSpikesTongueMap & rel_signif, 'lickmap_regular_odd_vs_even_corr');
% 
% 
% plot(r_target,r_tongue,'.k')
% xlabel('Stability based on target position')
% xlabel('Stability based on tongue position')
% title(sprintf('Mean r %.2f target,\n mean r %.2f tongue',mean(r_target),mean(r_tongue)))
% mean(r_target)
% mean(r_tongue)
% 

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




