%{
# Modulation depth is  100*(max_fr-min_fr)/max_fr of the PSTH
-> EXP2.SessionEpoch
-> IMG.ROI
---
psth_regular_modulation                      : double   # modulation depth of psth averaged across  trials with typical reward, modulation is 100*(max_fr-min_fr)/max_fr
psth_small_modulation=null                   : double   # modulation depth of psth averaged across  rewarded trials
psth_large_modulation=null                   : double   # modulation depth of psth averaged across  trials with large reward
psth_first_modulation=null                   : double   # modulation depth of psth averaged across  first trial in block
%}


classdef ROILick2DPSTHSpikesModulationLastLick < dj.Computed
    properties
        % keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROISpikes & IMG.ROI & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
        keySource = (EXP2.SessionEpoch*IMG.FOV) & LICK2D.ROILick2DPSTHSpikesLastLick  - IMG.Mesoscope;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            rel1 = LICK2D.ROILick2DPSTHSpikesLastLick & key;
            key_ROI1=fetch(rel1,'ORDER BY roi_number'); %PSTH
            DATA1=fetch(rel1,'*','ORDER BY roi_number'); %PSTH
            
                  
            for i_roi=1:1:numel(key_ROI1)
                key_ROI1(i_roi).psth_regular_modulation = fn_compute_generic_1D_or_2D_tuning_modulation_depth (DATA1(i_roi).psth_regular);
                key_ROI1(i_roi).psth_small_modulation =   fn_compute_generic_1D_or_2D_tuning_modulation_depth (DATA1(i_roi).psth_small);
                key_ROI1(i_roi).psth_large_modulation =   fn_compute_generic_1D_or_2D_tuning_modulation_depth (DATA1(i_roi).psth_large);
            end
            insert(self,key_ROI1)
        end
    end
end