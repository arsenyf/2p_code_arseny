%{
# Analysis for Paper
-> LAB.Person
---
figure_data        : longblob      # data used for the figure
%}


classdef ConnectivityPaperFigure2datav2shuffle < dj.Computed
    properties
        keySource = LAB.Person & 'username="ars"';
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
            
            filename=[sprintf('Figure2v4')];
            
            lickmap_regular_odd_vs_even_corr_threshold=0.25;
            reward_p_value_threshold = 0.05;
            lickmap_fr_regular_modulation_threshold=25;
            p_value_threshold = 0.05;

            rel_roi=PAPER.ROILICK2DInclusion;
            
            
            rel_reward_large_signif = rel_roi & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('reward_mean_pval_regular_large<=%.2f',reward_p_value_threshold));
            rel_reward_small_signif = rel_roi & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('reward_mean_pval_regular_small<=%.2f',reward_p_value_threshold));
            rel_allreward_signif = rel_roi &  (rel_reward_large_signif | rel_reward_small_signif);


        rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold));
%             rel_positional_and_allreward_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold)) ...
%                 & (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold)) ...& (rel_reward_large_signif | rel_reward_small_signif);
            
            rel_positional_and_allreward_signif = rel_roi & (LICK2D.ROILick2DmapSpikes3binsPvalue & sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold))...
               & (rel_reward_large_signif | rel_reward_small_signif);
      
            % positional and reward
            rel_stats1= LICK2D.ROILick2DmapStatsSpikes3bins*IMG.ROIID & rel_roi & rel_positional_and_allreward_signif ;
            rel_stats11= LICK2D.ROILick2DPSTHStatsSpikes*IMG.ROIID & rel_roi & rel_positional_and_allreward_signif ;

            %  reward (regardless of positional tuning)
            rel_stats2= LICK2D.ROILick2DmapStatsSpikes3bins*IMG.ROIID & rel_roi & rel_allreward_signif ;
            rel_stats22= LICK2D.ROILick2DPSTHStatsSpikes*IMG.ROIID & rel_roi & rel_allreward_signif ;


            %% D_positional_and_reward
            D_positional_and_reward.lickmap_regular_odd_vs_even_corr =fetchn(rel_stats1, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid'); 
            
            D_positional_and_reward.percent_2d_map_coverage_regular =fetchn(rel_stats1, 'percent_2d_map_coverage_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.percent_2d_map_coverage_small =fetchn(rel_stats1, 'percent_2d_map_coverage_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.percent_2d_map_coverage_large =fetchn(rel_stats1, 'percent_2d_map_coverage_large','ORDER BY roi_number_uid'); 

            D_positional_and_reward.lickmap_regular_vs_small_corr =fetchn(rel_stats1, 'lickmap_regular_vs_small_corr','ORDER BY roi_number_uid'); 
            D_positional_and_reward.lickmap_regular_vs_large_corr =fetchn(rel_stats1, 'lickmap_regular_vs_large_corr','ORDER BY roi_number_uid'); 
            
            D_positional_and_reward.field_size_without_baseline_regular =fetchn(rel_stats1, 'field_size_without_baseline_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.field_size_without_baseline_small =fetchn(rel_stats1, 'field_size_without_baseline_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.field_size_without_baseline_large =fetchn(rel_stats1, 'field_size_without_baseline_large','ORDER BY roi_number_uid'); 
            
            D_positional_and_reward.field_size_regular =fetchn(rel_stats1, 'field_size_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.field_size_small =fetchn(rel_stats1, 'field_size_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.field_size_large =fetchn(rel_stats1, 'field_size_large','ORDER BY roi_number_uid'); 

            D_positional_and_reward.information_per_spike_regular =fetchn(rel_stats1, 'information_per_spike_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.information_per_spike_small =fetchn(rel_stats1, 'information_per_spike_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.information_per_spike_large =fetchn(rel_stats1, 'information_per_spike_large','ORDER BY roi_number_uid'); 
            
            D_positional_and_reward.psth_position_concat_regular_odd_even_corr =fetchn(rel_stats1, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid'); 
            D_positional_and_reward.psth_position_concat_small_odd_even_corr =fetchn(rel_stats1, 'psth_position_concat_small_odd_even_corr','ORDER BY roi_number_uid'); 
            D_positional_and_reward.psth_position_concat_large_odd_even_corr =fetchn(rel_stats1, 'psth_position_concat_large_odd_even_corr','ORDER BY roi_number_uid'); 

            D_positional_and_reward.reward_mean_small =fetchn(rel_stats11, 'reward_mean_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_mean_regular =fetchn(rel_stats11, 'reward_mean_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_mean_large =fetchn(rel_stats11, 'reward_mean_large','ORDER BY roi_number_uid'); 

            D_positional_and_reward.reward_mean_pval_regular_small =fetchn(rel_stats11, 'reward_mean_pval_regular_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_mean_pval_regular_large =fetchn(rel_stats11, 'reward_mean_pval_regular_large','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_mean_pval_small_large =fetchn(rel_stats11, 'reward_mean_pval_small_large','ORDER BY roi_number_uid'); 

            D_positional_and_reward.reward_peak_small =fetchn(rel_stats11, 'reward_peak_small','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_peak_regular =fetchn(rel_stats11, 'reward_peak_regular','ORDER BY roi_number_uid'); 
            D_positional_and_reward.reward_peak_large =fetchn(rel_stats11, 'reward_peak_large','ORDER BY roi_number_uid'); 

            D_positional_and_reward.reward_peak_pval_regular_small =fetchn(rel_stats11, 'reward_peak_pval_regular_small','ORDER BY roi_number_uid');
            D_positional_and_reward.reward_peak_pval_regular_large =fetchn(rel_stats11, 'reward_peak_pval_regular_large','ORDER BY roi_number_uid');
            D_positional_and_reward.reward_peak_pval_small_large =fetchn(rel_stats11, 'reward_peak_pval_small_large','ORDER BY roi_number_uid');

            
            %% D_reward
            D_reward.lickmap_regular_odd_vs_even_corr =fetchn(rel_stats2, 'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number_uid'); 
            
            D_reward.percent_2d_map_coverage_regular =fetchn(rel_stats2, 'percent_2d_map_coverage_regular','ORDER BY roi_number_uid'); 
            D_reward.percent_2d_map_coverage_small =fetchn(rel_stats2, 'percent_2d_map_coverage_small','ORDER BY roi_number_uid'); 
            D_reward.percent_2d_map_coverage_large =fetchn(rel_stats2, 'percent_2d_map_coverage_large','ORDER BY roi_number_uid'); 

            
            D_reward.lickmap_regular_vs_small_corr =fetchn(rel_stats2, 'lickmap_regular_vs_small_corr','ORDER BY roi_number_uid'); 
            D_reward.lickmap_regular_vs_large_corr =fetchn(rel_stats2, 'lickmap_regular_vs_large_corr','ORDER BY roi_number_uid'); 
            
            D_reward.field_size_without_baseline_regular =fetchn(rel_stats2, 'field_size_without_baseline_regular','ORDER BY roi_number_uid'); 
            D_reward.field_size_without_baseline_small =fetchn(rel_stats2, 'field_size_without_baseline_small','ORDER BY roi_number_uid'); 
            D_reward.field_size_without_baseline_large =fetchn(rel_stats2, 'field_size_without_baseline_large','ORDER BY roi_number_uid'); 
            
            D_reward.field_size_regular =fetchn(rel_stats2, 'field_size_regular','ORDER BY roi_number_uid'); 
            D_reward.field_size_small =fetchn(rel_stats2, 'field_size_small','ORDER BY roi_number_uid'); 
            D_reward.field_size_large =fetchn(rel_stats2, 'field_size_large','ORDER BY roi_number_uid'); 

            D_reward.information_per_spike_regular =fetchn(rel_stats2, 'information_per_spike_regular','ORDER BY roi_number_uid'); 
            D_reward.information_per_spike_small =fetchn(rel_stats2, 'information_per_spike_small','ORDER BY roi_number_uid'); 
            D_reward.information_per_spike_large =fetchn(rel_stats2, 'information_per_spike_large','ORDER BY roi_number_uid'); 
            
            D_reward.psth_position_concat_regular_odd_even_corr =fetchn(rel_stats2, 'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number_uid'); 
            D_reward.psth_position_concat_small_odd_even_corr =fetchn(rel_stats2, 'psth_position_concat_small_odd_even_corr','ORDER BY roi_number_uid'); 
            D_reward.psth_position_concat_large_odd_even_corr =fetchn(rel_stats2, 'psth_position_concat_large_odd_even_corr','ORDER BY roi_number_uid'); 

            D_reward.reward_mean_small =fetchn(rel_stats22, 'reward_mean_small','ORDER BY roi_number_uid'); 
            D_reward.reward_mean_regular =fetchn(rel_stats22, 'reward_mean_regular','ORDER BY roi_number_uid'); 
            D_reward.reward_mean_large =fetchn(rel_stats22, 'reward_mean_large','ORDER BY roi_number_uid'); 

            D_reward.reward_mean_pval_regular_small =fetchn(rel_stats22, 'reward_mean_pval_regular_small','ORDER BY roi_number_uid'); 
            D_reward.reward_mean_pval_regular_large =fetchn(rel_stats22, 'reward_mean_pval_regular_large','ORDER BY roi_number_uid'); 
            D_reward.reward_mean_pval_small_large =fetchn(rel_stats22, 'reward_mean_pval_small_large','ORDER BY roi_number_uid'); 

            D_reward.reward_peak_small =fetchn(rel_stats22, 'reward_peak_small','ORDER BY roi_number_uid'); 
            D_reward.reward_peak_regular =fetchn(rel_stats22, 'reward_peak_regular','ORDER BY roi_number_uid'); 
            D_reward.reward_peak_large =fetchn(rel_stats22, 'reward_peak_large','ORDER BY roi_number_uid'); 

            D_reward.reward_peak_pval_regular_small =fetchn(rel_stats22, 'reward_peak_pval_regular_small','ORDER BY roi_number_uid');
            D_reward.reward_peak_pval_regular_large =fetchn(rel_stats22, 'reward_peak_pval_regular_large','ORDER BY roi_number_uid');
            D_reward.reward_peak_pval_small_large =fetchn(rel_stats22, 'reward_peak_pval_small_large','ORDER BY roi_number_uid');

           
            
            
            D_venn_reward_positional.count_total=count(rel_roi);
            D_venn_reward_positional.A_count_largereward=count(rel_reward_large_signif);
            D_venn_reward_positional.B_count_smallreward=count(rel_reward_small_signif);
            D_venn_reward_positional.C_count_positional=count(rel_positional_signif);
            D_venn_reward_positional.AB= count(rel_reward_large_signif & rel_reward_small_signif);
            D_venn_reward_positional.AC= count(rel_reward_large_signif & rel_positional_signif);
            D_venn_reward_positional.BC= count(rel_reward_small_signif & rel_positional_signif);
            D_venn_reward_positional.ABC= count(rel_reward_large_signif & rel_reward_small_signif & rel_positional_signif);
            D_venn_reward_positional.venn_labels={'A_count_largereward', 'B_count_smallreward', 'C_count_positional'};

            
            
            key.figure_data.D_venn_reward_positional=D_venn_reward_positional;
            key.figure_data.D_reward=D_reward;
            key.figure_data.D_positional_and_reward = D_positional_and_reward;
            
        
            
            if isempty(dir(dir_current_fig))
                mkdir (dir_current_fig)
            end
            %
            figure_name_out=[ dir_current_fig filename];
            eval(['print ', figure_name_out, ' -dpdf -r300']);
            
            
            
            insert(self, key);
            
        end
    end
    
end

