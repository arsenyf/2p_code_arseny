%{
# P-value of stability and modulation depth of Positional 2D tuning of a neuron (firing-rate map averaged across the entire trial duration) with each pixel corresponding to neuronal response to a specific lick-port position in 2D
# Shuffling is done by mixing trial identiy, not shifting spikes
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins                          : int   #
---
lickmap_regular_odd_vs_even_corr_pval               : double   # p_value stability of 2D map based on shuffled distribution
psth_position_concat_regular_odd_even_corr_pval     : double   # p_value stability of the PSTH concatenated across all positions
lickmap_fr_regular_modulation_pval                  : double   # p_value modulation of 2D map based on shuffled distribution

%}


classdef ROILick2DmapSpikes3binsPvalue2 < dj.Computed
    properties
% keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROISpikes & IMG.ROI & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock - IMG.Mesoscope;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
           flag_electric_video = 1; %detect licks with electric contact or video (if available) 1 - electric, 2 - video
            rel_data = IMG.ROISpikes;
            
            rel_meso = IMG.Mesoscope & key;
            if rel_meso.count>0 % if its mesoscope data
                fr_interval = [-2, 5]; % used it for the mesoscope
                fr_interval_limit= [-2, 5]; % for comparing firing rates between conditions and computing firing-rate maps
            else  % if its not mesoscope data
                fr_interval = [-1, 4]; 
                fr_interval_limit= [0, 3]; % for comparing firing rates between conditions and computing firing-rate maps
            end
            
            %Also populates: 
            self2=LICK2D.ROILick2DmapSpikesShuffledDistribution2;
            fn_compute_Lick2D_map_and_selectivity2_3bins_shuffle2 (key,self, rel_data, fr_interval, fr_interval_limit, flag_electric_video, self2);
            

        end
    end
end