%{
#
-> EXP2.SessionEpoch
-> IMG.ROI
---
p_val_lick_model1=null             : float   # p value of lick contribution to the model
p_val_lick_model2=null             : float   # p value of lick contribution to the model
p_val_llr_small=null               : float   # p value comparing GLM model 1 (time, lick) and GLM model 2 (time, lick, and reward), model compares regular with small reward
p_val_llr_large =null              : float   # p value comparing GLM model 1 (time, lick) and GLM model 2 (time, lick, and reward), model compares regular with large reward
reward_coeff_small=null            : float   # reward coefficiuents of GLM model 2 fort small reward
reward_coeff_large =null              : float   # reward coefficiuents of GLM model 2 for large reward

%}

classdef ROILick2DPSTHStatsSpikesGLM < dj.Computed
    properties(SetAccess=protected)
        master=LICK2D.ROILick2DPSTHSpikesGLM
    end
    methods(Access=protected)
function makeTuples(self, key)
            
            
        end
    end
end
    