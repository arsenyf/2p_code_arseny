%{
# Pairwise correlation as a function of distance
-> EXP2.SessionEpoch
p_value_threshold               : double   #
---
distance_corr_2d                     :blob      # mat of average pairwise pearson coeff of cells, binned according lateral X axial distance
distance_corr_lateral                :blob      # binned according lateral  distance
distance_corr_eucledian              :blob      # binned according to eucledian 3d distance
distance_corr_axial_columns          :blob      # correlation binned according to axial distance, for cells  within columns of different size defined by inner and and outer radius, which is the lateral distance of cells included within a column
column_inner_radius                  :blob      # inner radius of a column, microns. cells at lateral distance smaller than this radius are not included
column_outer_radius                  :blob      # outer radius of a column, microns. cells at lateral distance larger than this radius are not included
axial_distance_bins                  :blob      # axial bins, microns
lateral_distance_bins                :blob      # laterian bins, microns
eucledian_distance_bins              :blob    # eucledian bins, microns
num_cells_included                   :int       #
%}


classdef DistanceCorrMapSpikesShuffled3 < dj.Computed
    properties
                keySource = (EXP2.SessionEpoch  & IMG.ROI & LICK2D.ROILick2DmapStatsSpikes3bins - IMG.Mesoscope) &IMG.Volumetric ;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            close all;
            %Graphics
            %---------------------------------
            figure('visible','off')
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
            set(gcf,'color',[1 1 1]);
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            
            p_value_threshold = [0.1, 0.05, 0.01];
            
            mesoscope_flag=count(IMG.Mesoscope & key);
           if mesoscope_flag==1
                dir_save_fig = [dir_base  '\Lick2D\population\TUNING_vs_DISTANCE\single_sessions\tuning_by_map_fr\'];
            else
                dir_save_fig = [dir_base  '\Lick2D\population\TUNING_vs_DISTANCE\single_sessions_mesoscope\tuning_by_map_fr\'];
            end
            
            for i_c = 1:1:numel(p_value_threshold)
                rel_roi = IMG.ROI & (IMG.ROIGood-IMG.ROIBad) & key & (LICK2D.ROILick2DmapSpikes3binsPvalue2 & sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold(i_c)));
                rel_roi_xy = IMG.ROIPositionETL & rel_roi;
                rel_data = LICK2D.ROILick2DmapSpikes3bins & rel_roi & key;
                key.p_value_threshold = p_value_threshold(i_c);
                fn_compute_distance_psth_correlation_shuffled(rel_roi, rel_data, key,self, dir_save_fig, rel_roi_xy, mesoscope_flag);
            end
            
        end
    end
%     
end

