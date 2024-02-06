%{
# 
-> EXP2.Session
%}


classdef Cells2DTuningSpikesFirstBehavioralSession < dj.Computed
    properties
        
      keySource = (EXP2.Session   &  LICK2D.ROILick2DmapSpikes) -  IMG.Mesoscope  & (EXP2.SessionBehavioral & 'behavioral_session_number=1') & (LICK2D.ROILick2DmapStatsSpikes & 'number_of_bins=4');
      
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\Cells\2DTuning_First_Behavioral_Session\not_mesoscope\'];
            
            flag_spikes = 1; % 1 spikes, 0 dff
            
            if flag_spikes==1
                rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & ...
                    (LICK2D.ROILick2DmapStatsSpikes & 'lickmap_regular_odd_vs_even_corr>=0.5')  & ...
                    (LICK2D.ROILick2DmapSpikes3binsModulation & 'lickmap_fr_regular_modulation>=50') & key;
            end
            
            plot_one_in_x_cell=1; % e.g. plots one in 20 signficant cell
            
            PLOTS_Cells2DTuning(key, dir_current_fig,flag_spikes, plot_one_in_x_cell, rel_rois);
            
            insert(self,key);
            
        end
    end
end