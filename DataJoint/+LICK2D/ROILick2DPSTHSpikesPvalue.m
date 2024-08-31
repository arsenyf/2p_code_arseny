%{
# P-value of stability and modulation depth of PSTHs based on shuffled distributions
# Shuffling is done by shifting spikes, without shuffling trial identity

-> EXP2.SessionEpoch
-> IMG.ROI
---
psth_regular_odd_vs_even_corr_pval  : float   # p_value stability based on shuffled distribution
psth_small_odd_vs_even_corr_pval    =null            : float   # p_value stability based on shuffled distribution
psth_large_odd_vs_even_corr_pval    =null            : float   # p_value stability based on shuffled distribution
    
psth_first_odd_vs_even_corr_pval    =null            : float   # p_value stability based on shuffled distribution
psth_begin_odd_vs_even_corr_pval    =null            : float   # p_value stability based on shuffled distribution
psth_mid_odd_vs_even_corr_pval      =null            : float   # p_value stability based on shuffled distribution
psth_end_odd_vs_even_corr_pval      =null            : float   # p_value stability based on shuffled distribution
    
psth_regular_modulation_pval        : float   # p_value modulation based on shuffled distribution
psth_small_modulation_pval          =null            : float   # p_value modulation based on shuffled distribution
psth_large_modulation_pval          =null            : float   # p_value modulation based on shuffled distribution
    
psth_first_modulation_pval          =null            : float   # p_value modulation based on shuffled distribution
psth_begin_modulation_pval          =null            : float   # p_value modulation based on shuffled distribution
psth_mid_modulation_pval            =null            : float   # p_value modulation based on shuffled distribution
psth_end_modulation_pval            =null            : float   # p_value modulation based on shuffled distribution

%}


classdef ROILick2DPSTHSpikesPvalue < dj.Imported
    properties
        keySource = ((EXP2.SessionEpoch*IMG.FOV) & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock) - IMG.Mesoscope;
%                 keySource = (EXP2.SessionEpoch*IMG.FOV)  & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
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
            time_resample_bin=[];
            
            %Also populates: 
            self2=LICK2D.ROILick2DPSTHSpikesShuffledDistribution;
           fn_computer_Lick2DPSTH_shuffle(key,self, rel_data,fr_interval, fr_interval_limit, flag_electric_video, time_resample_bin, self2);

        end
    end
end
