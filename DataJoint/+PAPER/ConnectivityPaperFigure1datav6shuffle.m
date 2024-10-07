%{
# Analysis for Paper
-> LAB.Person
---
figure_data        : longblob      # data used for the figure
%}


classdef ConnectivityPaperFigure1datav6shuffle < dj.Computed
    properties
        keySource = LAB.Person & 'username="ars"';
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
            
            filename=[sprintf('Figure1v6')];
            
            
%             psth_regular_odd_vs_even_corr=0.25;
%             lickmap_regular_odd_vs_even_corr_threshold=0.25;
%             lickmap_fr_regular_modulation_threshold=25;
%             psth_regular_modulation_threshold=25;
            p_value_threshold = 0.05;
            %             information_per_spike_regular_threshold=0.1;
            rel_roi=PAPER.ROILICK2DInclusion;
%             rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('psth_regular_odd_vs_even_corr>=%.2f',psth_regular_odd_vs_even_corr)) ...
%                 & (LICK2D.ROILick2DPSTHSpikesModulation & sprintf('psth_regular_modulation>=%.2f',psth_regular_modulation_threshold));
%             
%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold)) ...
%                 & (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold));
            
%             rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHSpikesPvalue & sprintf('psth_regular_odd_vs_even_corr_pval<=%.2f',p_value_threshold) & ...
%                   sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold));
% 
%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_regular_odd_vs_even_corr_pval<=%.2f',p_value_threshold) & ...
%                   sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

        rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold));

        rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

%                              rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHSpikesPvalue & ...
%                   sprintf('psth_regular_odd_vs_even_corr_pval<=%.2f',p_value_threshold));
% 
%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_regular_odd_vs_even_corr_pval<=%.2f',p_value_threshold) & ...
%                   sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

              
%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_regular_odd_vs_even_corr_pval<=%.2f',p_value_threshold)); 

              
            % all
            rel_stats_all_1 = LICK2D.ROILick2DPSTHStatsSpikes*IMG.ROIID & rel_roi;
            rel_stats_all_2 = LICK2D.ROILick2DmapStatsSpikes3binsShort*IMG.ROIID & rel_roi;
            
            % temporal only
            rel_stats1= LICK2D.ROILick2DmapStatsSpikes3binsShort*IMG.ROIID & rel_roi &  rel_temporal_signif;
            % positional only
            rel_stats3= LICK2D.ROILick2DmapStatsSpikes3binsShort*IMG.ROIID & rel_roi & rel_positional_signif ;
            % temporal and positional
            rel_stats5= LICK2D.ROILick2DmapStatsSpikes3binsShort*IMG.ROIID & rel_roi &  rel_temporal_signif & rel_positional_signif;
            
            % temporal only, other stats
            rel_stats2= LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins*IMG.ROIID & rel_temporal_signif ;
            % positional only, other stats
            rel_stats22= LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins*IMG.ROIID & rel_positional_signif ;
            % temporal and positional only, other stats
            rel_stats222= LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins*IMG.ROIID & rel_positional_signif & rel_temporal_signif;
            % all, other stats
            rel_stats2222= LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins*IMG.ROIID & rel_roi ;
            rel_stats22222= LICK2D.ROILick2DmapSpikes3binsModulation*IMG.ROIID & rel_roi ;
            
            % positional only 4 bins
            rel_stats4_4bins= (LICK2D.ROILick2DmapStatsSpikeShort*IMG.ROIID & 'number_of_bins=4') & rel_positional_signif ;
            % temporal only PSTHs
            rel_psth_temporal = LICK2D.ROILick2DPSTHSpikesLongerInterval*IMG.ROIID & rel_temporal_signif ;
            
            rel_psth_temporal_and_positional = LICK2D.ROILick2DPSTHSpikesLongerInterval*IMG.ROIID & rel_temporal_signif & rel_positional_signif ;
            
            %% fetching stats and PSTH
            D_all.psth_regular_odd_vs_even_corr =fetchn(rel_stats_all_1, 'psth_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
            D_all.psth_position_concat_regular_odd_even_corr =fetchn(rel_stats_all_2, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
            D_all.lickmap_regular_odd_vs_even_corr =fetchn(rel_stats_all_2, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
            D_all.information_per_spike_regular =fetchn(rel_stats_all_2, 'information_per_spike_regular','ORDER BY roi_number_uid');
            D_all.psth_corr_across_position_regular =fetchn(rel_stats2222, 'psth_corr_across_position_regular','ORDER BY roi_number_uid');
            D_all.psth_corr_across_position_regular =fetchn(rel_stats22222, 'lickmap_fr_regular_modulation','ORDER BY roi_number_uid');
            
            D_tuned_temporal.lickmap_regular_odd_vs_even_corr=fetchn(rel_stats1, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
            D_tuned_temporal.information_per_spike_regular=fetchn(rel_stats1, 'information_per_spike_regular','ORDER BY roi_number_uid');
            D_tuned_temporal.psth_position_concat_regular_odd_even_corr=fetchn(rel_stats1, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
            D_tuned_temporal.psth_corr_across_position_regular=fetchn(rel_stats2, 'psth_corr_across_position_regular','ORDER BY roi_number_uid');
            
            D_tuned_positional.field_size_without_baseline_regular=fetchn(rel_stats3, 'field_size_without_baseline_regular','ORDER BY roi_number_uid');
            D_tuned_positional.information_per_spike_regular=fetchn(rel_stats3, 'information_per_spike_regular','ORDER BY roi_number_uid');
            D_tuned_positional.psth_position_concat_regular_odd_even_corr=fetchn(rel_stats3, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
            D_tuned_positional.psth_corr_across_position_regular=fetchn(rel_stats22, 'psth_corr_across_position_regular','ORDER BY roi_number_uid');
            
            D_tuned_temporal_and_positional.lickmap_regular_odd_vs_even_corr=fetchn(rel_stats5, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid');
            D_tuned_temporal_and_positional.information_per_spike_regular=fetchn(rel_stats5, 'information_per_spike_regular','ORDER BY roi_number_uid');
            D_tuned_temporal_and_positional.psth_position_concat_regular_odd_even_corr=fetchn(rel_stats5, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid');
            D_tuned_temporal_and_positional.psth_corr_across_position_regular=fetchn(rel_stats222, 'psth_corr_across_position_regular','ORDER BY roi_number_uid');
            
            
            D_tuned_positional_4bins.preferred_bin_regular=fetchn(rel_stats4_4bins & rel_positional_signif, 'preferred_bin_regular','ORDER BY roi_number_uid');
            D_tuned_positional_4bins.number_of_fields_without_baseline_regular=fetchn(LICK2D.ROILick2DmapUnimodalitySpikes*IMG.ROIID & 'number_of_bins=4' & 'threshold_for_peak=0.5' & rel_positional_signif , 'number_of_fields_without_baseline_regular','ORDER BY roi_number_uid');
            D_tuned_positional_4bins.field_size_without_baseline_regular=fetchn(rel_stats4_4bins & rel_positional_signif, 'field_size_without_baseline_regular','ORDER BY roi_number_uid');
            
            PSTH_all = cell2mat(fetchn(rel_psth_temporal,'psth_regular','ORDER BY roi_number_uid'));
            PSTH_all_temporal_and_positional = cell2mat(fetchn(rel_psth_temporal_and_positional,'psth_regular','ORDER BY roi_number_uid'));
            
            psth_time = fetch1(rel_psth_temporal,'psth_time','LIMIT 1');
            key.figure_data.D_all=D_all;
            key.figure_data.D_tuned_temporal=D_tuned_temporal;
            key.figure_data.D_tuned_positional=D_tuned_positional;
            key.figure_data.D_tuned_temporal_and_positional=D_tuned_temporal_and_positional;
            key.figure_data.D_tuned_positional_4bins=D_tuned_positional_4bins;
            key.figure_data.PSTH_all=PSTH_all;
            key.figure_data.PSTH_all_temporal_and_positional=PSTH_all_temporal_and_positional;
            
            key.figure_data.psth_time=psth_time;
            
            PAPER_graphics_definition_Figure1
            
            Figure_1_data_plot_script
            
            
            
            %             if isempty(dir(dir_current_fig))
            %                 mkdir (dir_current_fig)
            %             end
            %             %
            %             figure_name_out=[ dir_current_fig filename];
            %             eval(['print ', figure_name_out, ' -dpdf -r300']);
            %
            %
            
            insert(self, key);
            
        end
    end
    
end

