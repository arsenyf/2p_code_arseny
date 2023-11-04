%{
# Modulation 100*(max_fr-min_fr)/max_fr of positional 2D tuning of a neuron (firing-rate map averaged across the entire trial duration) with each pixel corresponding to neuronal response to a specific lick-port position in 2D
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins                                     : int   #
---
lickmap_fr_regular_modulation                      : double   # modulation of 2D tuning map averaged across trials with typical reward, modulation is 100*(max_fr-min_fr)/max_fr 
lickmap_fr_small_modulation=null                   : double   # modulation of 2D tuning map averaged across no rewarded trials
lickmap_fr_large_modulation=null                   : double   # modulation of 2D tuning map averaged across trials with large reward
lickmap_fr_first_modulation=null                   : double   # modulation of 2D tuning map averaged across first trial in block
lickmap_fr_begin_modulation=null                   : double   # modulation of 2D tuning map averaged across trials in the beginning of the block
lickmap_fr_mid_modulation=null                     : double   # modulation of 2D tuning map averaged across trials in the middle of the block
lickmap_fr_end_modulation=null                     : double   # modulation of 2D tuning map averaged across trials in the end of the block
%}


classdef ROILick2DmapSpikes3binsModulation < dj.Computed
    properties
% keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROISpikes & IMG.ROI & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
keySource = (EXP2.SessionEpoch*IMG.FOV) & LICK2D.ROILick2DmapSpikes3bins - IMG.Mesoscope;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
         
         rel = LICK2D.ROILick2DmapSpikes3bins & key; 
            
        key_ROI1=fetch(rel,'ORDER BY roi_number'); %2D map

        DATA=fetch(rel,'*','ORDER BY roi_number'); %2D map

        for i_roi=1:1:numel(key_ROI1)
            key_ROI1(i_roi).lickmap_fr_regular_modulation = fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_regular);
            key_ROI1(i_roi).lickmap_fr_small_modulation =   fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_small);
            key_ROI1(i_roi).lickmap_fr_large_modulation =   fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_large);
            key_ROI1(i_roi).lickmap_fr_first_modulation =   fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_first);
            key_ROI1(i_roi).lickmap_fr_begin_modulation =   fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_begin);
            key_ROI1(i_roi).lickmap_fr_mid_modulation =     fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_mid);
            key_ROI1(i_roi).lickmap_fr_end_modulation =     fn_compute_generic_2D_field_modulation (DATA(i_roi).lickmap_fr_end);
        end
        insert(self,key_ROI1)
    end
    end
end