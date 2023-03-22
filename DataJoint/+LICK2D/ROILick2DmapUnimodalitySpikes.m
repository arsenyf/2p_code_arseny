%{
# Positional 2D tuning of a neuron (firing-rate map averaged across the entire trial duration) with each pixel corresponding to neuronal response to a specific lick-port position in 2D
-> EXP2.SessionEpoch
-> IMG.ROI
number_of_bins                              : int      #
threshold_for_peak                          : double   #
---
number_of_fields_regular                    : int      # number of fields, different feilds have to be separated by bins with activity below threshold_for_peak
number_of_fields_without_baseline_regular   : int      # number of fields after baseline subtraction, different feilds have to be separated by bins with activity below threshold_for_peak
fields_size_regular                         : blob      # number of fields, different feilds have to be separated by bins with activity below threshold_for_peak
fields_size_without_baseline_regular        : blob      # number of fields after baseline subtraction, different feilds have to be separated by bins with activity below threshold_for_peak
%}


classdef ROILick2DmapUnimodalitySpikes < dj.Computed
    properties
        %                         keySource = (EXP2.SessionEpoch*IMG.FOV) & IMG.ROISpikes & IMG.ROI & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
        keySource = EXP2.SessionEpoch & LICK2D.ROILick2DmapSpikes - IMG.Mesoscope;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            threshold_for_peak=[0.25, 0.5];
            
            rel_data =LICK2D.ROILick2DmapSpikes & key;
            [lickmap_fr_regular]=fetchn(rel_data, 'lickmap_fr_regular','ORDER BY roi_number');
            
            for i_t = 1:1:numel(threshold_for_peak)
                key_roi=fetch(rel_data,'ORDER BY roi_number');
                for i_r=1:1:numel(key_roi)
                    key_roi(i_r).threshold_for_peak = threshold_for_peak(i_t);
                    number_of_bins = key_roi(1).number_of_bins;
                    [number_of_fields,fields_size, number_of_fields_baseline_substracted, fields_size_baseline_substracted] = fn_compute_map_number_fields_and_field_size (lickmap_fr_regular{i_r},threshold_for_peak(i_t));
                    key_roi(i_r).number_of_fields_regular = number_of_fields;
                    key_roi(i_r).fields_size_regular = (100.*fields_size)/(number_of_bins^2);
                    key_roi(i_r).number_of_fields_without_baseline_regular = number_of_fields_baseline_substracted;
                    key_roi(i_r).fields_size_without_baseline_regular = (100.*fields_size_baseline_substracted)/(number_of_bins^2);
                end
                insert(self,key_roi);
            end
        end
    end
end