%{
#
-> EXP2.SessionEpoch
-> IMG.ROI
-> RIDGE.PredictorType
time_shift                        : int             #     in units of 2p-imaging frames
threshold_for_event        : double        # threshold in zscore, after binning. 0 means we don't threshold. 1 means we take only positive events exceeding 1 std, 2 means 2 std etc.
time_bin                   : double        # time window used for binning the data. 
---
predictor_beta          : double   # beta coefficient of the ridge regression 
%} 


classdef ROIRidge < dj.Imported
    properties
        keySource = (EXP2.SessionEpoch)  & IMG.ROI & 'session_epoch_type="behav_only"' & RIDGE.Predictors - IMG.Mesoscope;
    end
    methods(Access=protected)
        function makeTuples(self, key)



            kk.threshold_for_event =0;
            key.time_bin = 1;
            
%             time_shift_vec=[-2:1:7]; % for 0.5s bins
            time_shift_vec=[-3:key.time_bin:5]; % for 0.2s bins
            time_shift_vec=round(time_shift_vec/key.time_bin);
            rel_data1 = (POP.ROISVD & key)& kk;
            rel_data2 = (POP.SVDSingularValues & key) & kk;
            rel_data3 = (POP.SVDTemporalComponents & key) & kk;
%             rel_data1 = (POP.ROISVDSpikes & key)& kk;
%             rel_data2 = (POP.SVDSingularValuesSpikes & key) & kk;
%             rel_data3 = (POP.SVDTemporalComponentsSpikes & key) & kk;

            self2 = RIDGE.ROIRidgeVarExplained;
            fn_compute_Ridge_svd(key,self,self2, rel_data1,rel_data2,rel_data3, time_shift_vec, key.time_bin);
            
        end
    end
end
