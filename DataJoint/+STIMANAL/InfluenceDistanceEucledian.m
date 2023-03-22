%{
# Responses of couple neurons to photostimulation, as a function of distance
# XYZ coordinate correction of ETL abberations based on ETL callibration

-> EXP2.SessionEpoch
neurons_or_control                          : boolean             # 1 - neurons, 0 control
flag_withold_trials                         : boolean             # 1 define influence significance and sign based on odd trials, but compute the actual response based on even trials, 0 use all trials
flag_divide_by_std                          : boolean             # 1 normalize the response by its std, 0 don't normalize
flag_normalize_by_total                     : boolean             # 1 normalize by total number of pairs (e.g. includin non significant), 0 don't normalize
response_p_val                              : double              # response p-value for inclusion. 1 means we take all pairs
num_svd_components_removed                  : int     # how many of the first svd components were removed
---
is_volumetric                               : boolean             # 1 volumetric, 0 single plane
num_targets                                 : int                 # number of directly stimulated neurons (with significant response) or number of control targets (with non-significant responses)
num_pairs                                   : int                 # total number of cell-pairs included
distance_eucledian_bins                     : blob                # eucledian bins (um), edges

response_eucledian                            : longblob                # sum of response for all cell-pairs in each (eucledian) bin, divided by the total number of all pairs (positive and negative) in that bin
response_eucledian_excitation                 : longblob                # sum of response for all cell-pairs with positive response in each bin, divided by the total number of all pairs (positive and negative) in that bin
response_eucledian_inhibition                 : longblob                # sum of response for all cell-pairs with negative response in each bin, divided by the total number of all pairs (positive and negative) in that bin
response_eucledian_absolute                   : longblob                # sum of absolute value of tre response for all cell-pairs in each bin, divided by the total number of all pairs (positive and negative) in that bin

counts_eucledian=null                         : longblob                # counts of cell-pairs, in each bin
counts_eucledian_excitation=null              : longblob                # counts of cell-pairs with positive response, in each bin
counts_eucledian_inhibition=null              : longblob                # counts of cell-pairs with negative response, in each bin
%}


classdef InfluenceDistanceEucledian < dj.Computed
    properties
        keySource = (EXP2.SessionEpoch & 'flag_photostim_epoch =1') & STIM.ROIResponseDirectUnique & (STIMANAL.SessionEpochsIncludedFinal & 'flag_include=1');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            rel=STIM.ROIInfluence2;
            distance_eucledian_bins = [0:10:500]; % microns
            
            num_svd_components_removed_vector = [0];
            pval=[0.01, 0.05, 1];
            neurons_or_control_flag = [1,0];
            flag_withold_trials = [0,1];
            flag_normalize_by_total = [1];
            flag_divide_by_std = [0]; % 1 divide the response by std. 0 don't divide
               
            
            for i_n = 1:1:numel(neurons_or_control_flag)
                kkk=key;
                kkk.neurons_or_control = neurons_or_control_flag(i_n);
                rel_direct= STIMANAL.NeuronOrControl & kkk;
                rel_group_targets =  IMG.PhotostimGroup & rel_direct; % we do it to get rid of the roi column
                DATA_all=fetch((rel & key & rel_group_targets)& 'num_svd_components_removed=0' & 'num_of_target_trials_used>=20','*');
                
                if isempty(DATA_all)
                   return; 
                end

                parfor i_p = 1:1:numel(pval) %parfor

                    for i_c = 1:1:numel(num_svd_components_removed_vector)
                        kk=key;
                        kk.num_svd_components_removed=num_svd_components_removed_vector(i_c);
                        
                        for i_total = 1:1:numel(flag_normalize_by_total)
                            for i_w = 1:1:numel(flag_withold_trials)
                                for i_std = 1:1:numel(flag_divide_by_std)
                                    rel_current = rel & kk;
                                    k =STIMANAL_fn_distance_binning_coupled_response_eucledian(rel_current, key,DATA_all,rel_group_targets, pval(i_p), distance_eucledian_bins, flag_withold_trials(i_w),flag_normalize_by_total(i_total),flag_divide_by_std(i_std));
                                    k.flag_withold_trials = flag_withold_trials(i_w);
                                    k.flag_normalize_by_total = flag_normalize_by_total(i_total);
                                    k.flag_divide_by_std = flag_divide_by_std(i_std);
                                    k.neurons_or_control = neurons_or_control_flag(i_n);
                                    k.num_svd_components_removed = num_svd_components_removed_vector(i_c);
                                    insert(self,k);
                                end
                            end
                        end
                        
                    end
                end
            end
        end
    end
end