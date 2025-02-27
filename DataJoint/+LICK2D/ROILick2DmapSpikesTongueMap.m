%{
# Positional 2D tuning of a neuron (firing-rate map averaged across the entire trial duration) with each pixel corresponding to neuronal response to a specific lick-port position in 2D
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins                          : int   #
---
lickmap_fr_regular                      : blob   # 2D tuning map averaged across trials with typical reward
lickmap_fr_small=null                   : blob   # 2D tuning map averaged across no rewarded trials
lickmap_fr_large=null                   : blob   # 2D tuning map averaged across trials with large reward
lickmap_fr_first=null                   : blob   # 2D tuning map averaged across first trial in block
lickmap_fr_begin=null                   : blob   # 2D tuning map averaged across trials in the beginning of the block
lickmap_fr_mid=null                     : blob   # 2D tuning map averaged across trials in the middle of the block
lickmap_fr_end=null                     : blob   # 2D tuning map averaged across trials in the end of the block
lickmap_fr_regular_odd                  : blob   # 2D tuning map averaged across trials with typical reward  -- only odd trials
lickmap_fr_regular_even                 : blob   # 2D tuning map averaged across trials with typical reward  -- only even trials
pos_x_bins_centers                      : blob   # binning used for the 2D tuning maps
pos_z_bins_centers                      : blob   # binning used for the 2D tuning maps
%}


classdef ROILick2DmapSpikesTongueMap < dj.Computed
    properties
% keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & TRACKING.VideoTongueTrial - IMG.Mesoscope;
        keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & TRACKING.VideoTongueTrial & IMG.Mesoscope;

    end
    methods(Access=protected)
        function makeTuples(self, key)
           flag_electric_video = 1; %detect licks with electric contact or video (if available) 1 - electric, 2 - video
            rel_data = IMG.ROISpikes;
            rel_temp = IMG.Mesoscope & key;
            if rel_temp.count>0 % if its mesoscope data
                fr_interval = [-2, 5]; % used it for the mesoscope
                fr_interval_limit= [-2, 5]; % for comparing firing rates between conditions and computing firing-rate maps
            else  % if its not mesoscope data
                fr_interval = [-1, 4]; 
                fr_interval_limit= [0, 3]; % for comparing firing rates between conditions and computing firing-rate maps
            end
            fn_compute_Lick2D_map_based_on_tongue_position (key,self, rel_data, fr_interval, fr_interval_limit, flag_electric_video);
            
            % % also populates
            self2=LICK2D.ROILick2DmapPSTHSpikesTongueMap;
            self3=LICK2D.ROILick2DmapPSTHStabilitySpikesTongueMap;
            self4=LICK2D.ROILick2DmapStatsSpikesTongueMap;
            self5=LICK2D.ROILick2DSelectivitySpikesTongueMap;
            self6=LICK2D.ROILick2DSelectivityStatsSpikesTongueMap;

        end
    end
end