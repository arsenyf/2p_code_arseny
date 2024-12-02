%{
# Correlation in tuning between the target and connected neurons, averaged across all connected neurons to that target
-> IMG.PhotostimGroup
-> IMG.ROI
response_p_val         : double      # response p-value of influence cell pairs for inclusion. 1 means we take all pairs
---
avg_tuning_correlation_with_targets=null     :double    # Influence versus Correlation.
%}


classdef Target2ConnectedCorrTuningMap2 < dj.Computed
    properties
        keySource = EXP2.SessionEpoch & (STIM.ROIResponseDirect2 & STIMANAL.SessionEpochsIncludedFinalUniqueEpochs) & STIMANAL.Target2AllCorrMap;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            close all;
            figure("Visible",false);
            p_val_list=[0.01, 0.05, 0.1, 1]; % for influence significance %making it for more significant values requires debugging of the shuffling method
            minimal_distance=25; %um, lateral;  exlude all cells within minimal distance from target
            maximal_distance=100; %um lateral;  exlude all cells further than maximal distance from target
            
            rel_include = IMG.ROI-IMG.ROIBad;
            rel_target = IMG.PhotostimGroup & (STIM.ROIResponseDirectUnique & key & rel_include);
            
            key_ROIs = fetch(STIM.ROIResponseDirectUnique & rel_target,'ORDER BY photostim_group_num');
            
            rel_data_corr =STIMANAL.Target2AllCorrMap & rel_include & rel_target ;
            rel_data_influence=STIM.ROIInfluence2 & rel_include & rel_target & 'num_svd_components_removed=0';
            
            
            DataCorr_original = cell2mat(fetchn(rel_data_corr,'rois_corr','ORDER BY photostim_group_num'));
            
            
            group_list = fetchn(rel_target,'photostim_group_num','ORDER BY photostim_group_num');
            if numel(group_list)<1
                return
            end
            
            DataStim_response=cell(numel(group_list),1);
            DataStim_pval=cell(numel(group_list),1);
            
            parfor i_g = 1:1:numel(group_list)
                rel_data_influence_current = [rel_data_influence & ['photostim_group_num=' num2str(group_list(i_g))]];
                DataStim_response{i_g} = fetchn(rel_data_influence_current,'response_mean', 'ORDER BY roi_number')';
                DataStim_pval{i_g} = fetchn(rel_data_influence_current,'response_p_value1', 'ORDER BY roi_number')';
                %                     DataStim_num_of_baseline_trials_used{i_g} = fetchn(rel_data_influence_current,'num_of_baseline_trials_used', 'ORDER BY roi_number')';
                DataStim_num_of_target_trials_used{i_g} = fetchn(rel_data_influence_current,'num_of_target_trials_used', 'ORDER BY roi_number');
                DataStim_distance_lateral{i_g}=fetchn(rel_data_influence_current,'response_distance_lateral_um', 'ORDER BY roi_number');
            end
            DataStim_response = cell2mat(DataStim_response);
            DataStim_distance_lateral = cell2mat(DataStim_distance_lateral)';
            DataStim_pval = cell2mat(DataStim_pval);
            DataStim_num_of_target_trials_used = cell2mat(DataStim_num_of_target_trials_used)';
            
            
            for i_p = 1:1:numel(p_val_list)
                
                idx_include = true(size(DataStim_distance_lateral));
                idx_include(DataStim_distance_lateral<=minimal_distance  )=false; %exlude all cells within minimal distance from target
                idx_include(DataStim_distance_lateral>maximal_distance  )=false; %exlude all cells further than maximal distance from target
                idx_include(DataStim_pval>p_val_list(i_p))=false;
                idx_include(DataStim_response<0)=false; %we take only excitatory responses
                idx_include(DataStim_num_of_target_trials_used==0  )=false;
                
                DataStim_idx = zeros(size(DataStim_response));
                DataStim_idx(~idx_include)=NaN;
                
                avg_tuning_correlation_with_targets = nanmean(DataCorr_original + DataStim_idx,2);
                
                
                key_insert = key_ROIs;
                for i_g=1:1:numel(group_list)
                    key_insert(i_g).response_p_val =p_val_list(i_p);
                    key_insert(i_g).avg_tuning_correlation_with_targets=avg_tuning_correlation_with_targets(i_g);
                end
                insert(self, key_insert);
                
                
            end
        end
    end
end

