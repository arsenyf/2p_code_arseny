%{
# Shuffled distributions of stability and modulation depth of Positional 2D tuning
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins                          : int   #
---
lickmap_regular_odd_vs_even_corr_shuffled                   : longblob   # shuffle distribution of 2D map stabilty depth value
psth_position_concat_regular_odd_even_corr_shuffled         : longblob   # shuffle distribution of PSTH per position stabilty depth value
lickmap_fr_regular_modulation_shuffled                      : longblob   # shuffle distribution of 2D map modulation depth value

%}

classdef ROILick2DmapSpikesShuffledDistribution < dj.Computed
    properties(SetAccess=protected)
        master=LICK2D.ROILick2DPSTHSpikesPvalue
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
        end
    end
end