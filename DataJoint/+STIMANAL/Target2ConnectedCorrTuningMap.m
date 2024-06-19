%{
# Correlation versus influence, and Influence versus Correlation. Binned
-> IMG.PhotostimGroup
-> IMG.ROI
response_p_val                              : double      # response p-value of influence cell pairs for inclusion. 1 means we take all pairs
excitatory_or_inhibitory_connection         : int      # 1 excitatory, 2 inhibitory
tuning_modulation_threshold                 : double   # for both target neurons and connected neurons
tuning_odd_even_corr_threshold              : double   # for both target neurons and connected neurons
---
avg_tuning_correlation_with_targets=null     :double   # Influence versus Correlation.
%}


classdef Target2ConnectedCorrTuningMap < dj.Computed
    properties
        keySource = EXP2.SessionEpoch & (STIM.ROIResponseDirect2 & STIMANAL.SessionEpochsIncludedFinalUniqueEpochs) & STIMANAL.Target2AllCorrMap;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            close all;
            figure("Visible",false);
            p_val_list=[0.01, 0.05, 0.1, 1]; % for influence significance %making it for more significant values requires debugging of the shuffling method
            odd_even_corr_threshold=[-1, 0, 0.25, 0.5];
            lickmap_fr_regular_modulation_threshold=[0,25,50,75];

            minimal_distance=25; %um, lateral;  exlude all cells within minimal distance from target
            maximal_distance=100; %um lateral;  exlude all cells further than maximal distance from target
            
            rel_include = IMG.ROI-IMG.ROIBad;
            rel_target = IMG.PhotostimGroup & (STIM.ROIResponseDirectUnique & key & rel_include);
            
            key_ROIs = fetch(STIM.ROIResponseDirectUnique & rel_target,'ORDER BY photostim_group_num');
            
            rel_data_corr =STIMANAL.Target2AllCorrMap & rel_include & rel_target ;
            rel_data_influence=STIM.ROIInfluence2 & rel_include & rel_target & 'num_svd_components_removed=0';
            
            DataCorr_original = cell2mat(fetchn(rel_data_corr,'rois_corr','ORDER BY photostim_group_num'));
            
            % for selecting tuned cells
            rel_data_signal = LICK2D.ROILick2DmapSpikes3binsModulation*LICK2D.ROILick2DmapStatsSpikes3binsShort & rel_include;
            k_psth =key;
            k_psth=rmfield(k_psth,'session_epoch_type');
            k_psth=rmfield(k_psth,'session_epoch_number');
            
            
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
            
            for i_excit_inhib =1:1:2 % 1 excitatory 2 inhibitory
                for i_mod = 1:1:numel(lickmap_fr_regular_modulation_threshold)
                    for i_odd_even = 1:1:numel(odd_even_corr_threshold)
                        
                        rel_target_signif_by_psth = (STIM.ROIResponseDirectUnique &  rel_target) &    (IMG.ROI &  (rel_data_signal & k_psth & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold(i_mod)) & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',odd_even_corr_threshold(i_odd_even))));
                        group_list_signif = fetchn(rel_target_signif_by_psth,'photostim_group_num','ORDER BY photostim_group_num');
                        idx_group_list_signif = ismember(group_list,group_list_signif);
                        
                        roi_psth_signif = fetchn(rel_data_signal & k_psth & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold(i_mod)) & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',odd_even_corr_threshold(i_odd_even)), 'roi_number', 'ORDER BY roi_number');
                        roi_psth_all = fetchn(rel_data_signal & k_psth , 'roi_number', 'ORDER BY roi_number');
                        idx_psth_signif=ismember(roi_psth_all,roi_psth_signif);
                        
                        
                        for i_p = 1:1:numel(p_val_list)
                            idx_include = true(size(DataStim_distance_lateral));
                            idx_include(DataStim_distance_lateral<=minimal_distance  )=false; %exclude all cells within minimal distance from target
                            idx_include(DataStim_distance_lateral>maximal_distance  )=false; %exclude all cells further than maximal distance from target
                            idx_include(DataStim_pval>p_val_list(i_p))=false;
                            if i_excit_inhib==1
                                idx_include(DataStim_response<0)=false; %we take only excitatory responses
                            elseif i_excit_inhib==2
                                idx_include(DataStim_response>0)=false; %we take only inhibitory responses
                            end
                            idx_include(DataStim_num_of_target_trials_used==0  )=false;
                            
                            idx_include(:,~idx_psth_signif')=false;
                            
                            DataStim_idx = zeros(size(DataStim_response));
                            DataStim_idx(~idx_include)=NaN;
                            
                            avg_tuning_correlation_with_targets = nanmean(DataCorr_original + DataStim_idx,2);
                            signif_avg_tuning_correlation_with_targets = avg_tuning_correlation_with_targets(idx_group_list_signif);
                            key_insert = key_ROIs(idx_group_list_signif);
                            for i_g=1:1:numel(group_list(idx_group_list_signif))
                                key_insert(i_g).response_p_val = p_val_list(i_p);
                                key_insert(i_g).excitatory_or_inhibitory_connection = i_excit_inhib;
                                key_insert(i_g).tuning_modulation_threshold = lickmap_fr_regular_modulation_threshold(i_mod);
                                key_insert(i_g).tuning_odd_even_corr_threshold =  odd_even_corr_threshold(i_odd_even);
                                key_insert(i_g).avg_tuning_correlation_with_targets = signif_avg_tuning_correlation_with_targets(i_g);
                            end
                            insert(self, key_insert);
                        end % loop over p-values
                    end % loop over odd_even tuning threshold
                end     % loop over tuning modulation threshold
            end         % excitatory inhibitory
        end
    end
end
