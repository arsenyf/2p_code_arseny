%{
# Shuffled distributions of stability and modulation depth of PSTHs
-> EXP2.SessionEpoch
-> IMG.ROI
---
psth_regular_odd_vs_even_corr_shuffled       : longblob   # shuffle distribution of stability values
psth_regular_modulation_shuffled             : longblob   # shuffle distribution of modulation depth value
%}


classdef ROILick2DPSTHSpikesShuffledDistribution < dj.Computed
    properties(SetAccess=protected)
        master=LICK2D.ROILick2DPSTHSpikesPvalue
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
        end
    end
end