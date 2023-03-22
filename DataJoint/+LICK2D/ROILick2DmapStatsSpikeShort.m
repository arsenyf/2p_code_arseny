%{
# Stats on 2D tuning maps
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins            : int   #
---
lickmap_regular_odd_vs_even_corr          : double   # 2D map correlation across odd vs even regular trials
psth_position_concat_regular_odd_even_corr    : double   # correlation of the PSTH concatenated across all positions, across trials with typical reward
information_per_spike_regular=null          : double   # Spatial Information per spike (Skaags et al 1996) for 2D map computed across trials with typical reward
preferred_bin_regular=null                  : double   #
field_size_regular=null                     : double   # 2D Field size at half max, expressed as percentage
field_size_without_baseline_regular=null    : double   # 2D Field size at half max, expressed as percentage, computed after removing the baseline firing rate

%}


classdef ROILick2DmapStatsSpikeShort < dj.Computed
     properties
        keySource = EXP2.SessionEpoch & LICK2D.ROILick2DmapStatsSpikes;
    end
    methods(Access=protected)
        function makeTuples(self, key)
        key_roi= fetch(LICK2D.ROILick2DmapStatsSpikes & key, 'lickmap_regular_odd_vs_even_corr','psth_position_concat_regular_odd_even_corr','information_per_spike_regular','preferred_bin_regular','field_size_regular','field_size_without_baseline_regular');
        insert(self,key_roi)
        end
    end
end