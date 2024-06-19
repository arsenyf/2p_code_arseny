%{
# Local tuning modulation within a neighborhood of a certain latera distance radius
-> EXP2.SessionEpoch
odd_even_corr_threshold               : double   #
modulation_threshold                  : double   #

---
neighborhood_modulation_lateral           : blob      # tuning of a neighborhood at certain lateral radius
neighborhood_modulation_lateral_shuffle   : blob      # tuning of a neighborhood at certain lateral radius shuffled
lateral_distance_bins                                    : blob      #lateral distance biined for comuting the neighborhood
neighborhood_modulation_eucledian           : blob      # tuning of a neighborhood at certain lateral radius
neighborhood_modulation_eucledian_shuffle   : blob      # tuning of a neighborhood at certain lateral radius shuffled
eucledian_distance_bins                                    : blob      #lateral distance biined for comuting the neighborhood
num_cells_included                                       :int       #
%}


classdef DistanceTuningColumnsMapsSpikes < dj.Computed
    properties
        keySource = (EXP2.SessionEpoch  & IMG.ROI & LICK2D.ROILick2DmapStatsSpikes3bins - IMG.Mesoscope) &IMG.Volumetric ;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            close all;
            %Graphics
            %---------------------------------
            figure
            %             figure('visible','off')
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
            set(gcf,'color',[1 1 1]);
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            
            odd_even_corr_threshold=[-1, 0, 0.25, 0.5];
            %             odd_even_corr_threshold=-1;
            lickmap_fr_regular_modulation_threshold=[0,25,50,75];
            
            mesoscope_flag=count(IMG.Mesoscope & key);
            if mesoscope_flag==1
                dir_save_fig = [dir_base  '\Lick2D\population\TUNING_vs_DISTANCE_Columns\single_sessions\tuning_by_map_fr\'];
            else
                dir_save_fig = [dir_base  '\Lick2D\population\TUNING_vs_DISTANCE_Columns\single_sessions_mesoscope\tuning_by_map_fr\'];
            end
            
            for i_c = 1:1:numel(odd_even_corr_threshold)
                for i_m = 1:1:numel(lickmap_fr_regular_modulation_threshold)
                    
                    rel_roi = (IMG.ROI - IMG.ROIBad) & key & (LICK2D.ROILick2DmapStatsSpikes3bins & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',odd_even_corr_threshold(i_c)))...
                        & (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold(i_m)));
                    rel_roi_xy = IMG.ROIPositionETL & rel_roi;
                    rel_data = LICK2D.ROILick2DmapSpikes3bins & rel_roi & key;
                    key.odd_even_corr_threshold = odd_even_corr_threshold(i_c);
                    key.modulation_threshold = lickmap_fr_regular_modulation_threshold(i_m);
                    fn_compute_distance_tuning_columns(rel_roi, rel_data, key,self, dir_save_fig, rel_roi_xy, mesoscope_flag);
                end
            end
        end
    end
    %
end

