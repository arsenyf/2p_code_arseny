%{
# Out degree of directly stimulated neurons, i.e. number of neurons indirectly influenced by the photostimulation

-> IMG.PhotostimGroup
-> IMG.ROI
max_distance_lateral                 : float              # maximum lateral distance (um) to compute pairs within this distance form target neuron
p_val                                : double              # p-value of the response in influenced cells
---
out_degree_all                      : int                # number of neurons influenced (excited and inhibited) by this neuron, significance based on t-test
out_degree_excitatory               : int                # number of neurons influenced (excited) by this neuron, significance based on t-test
out_degree_inhibitory               : int                # number of neurons influenced (inhibited) by this neuron, significance based on t-test
%}


classdef OutDegree2 < dj.Imported
    properties
        keySource = EXP2.SessionEpoch & STIM.ROIResponseDirect2 &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            minimal_lateral_distance=25; %  in microns, max distance to direct neuron
            max_distance_lateral_vec = [1000];
            p_val=[0.05];
            
            
            rel_group = IMG.PhotostimGroup &   STIM.ROIResponseDirect2 & key;
            photostim_group = fetch(rel_group,'ORDER BY photostim_group_num');
            
            key_ROI=fetch(STIM.ROIResponseDirect2 & key,'ORDER BY photostim_group_num');
            
            for i_d = 1:1:numel(max_distance_lateral_vec)
                for i_p = 1:1:numel(p_val)
                    current_p_val = p_val(i_p);
                    key_ROI_current = key_ROI;
                    parfor i_g = 1:1: rel_group.count
                        rel_group_current = photostim_group(i_g);
                        
                        % using t-test p-value as criteria
                        rel = (STIM.ROIInfluence2 & rel_group_current) & sprintf('response_p_value1<=%.4f',current_p_val) & sprintf('response_distance_lateral_um>%d',minimal_lateral_distance)  & sprintf('response_distance_lateral_um<=%d',(max_distance_lateral_vec(i_d)));
                        rel_current = rel ;
                        key_ROI_current(i_g).out_degree_all = rel_current.count;
                        
                        rel_current = rel  & 'response_mean>0';
                        key_ROI_current(i_g).out_degree_excitatory= rel_current.count;
                        
                        rel_current = rel  & 'response_mean<0';
                        key_ROI_current(i_g).out_degree_inhibitory= rel_current.count;
                        
                        
                        %                             % using Ranksum test p_value as criteria
                        %                             rel = (STIM.ROIInfluence & rel_group_current) & sprintf('num_svd_components_removed=%d',num_svd) & sprintf('response_p_value2<=%.4f',current_p_val)  & sprintf('response_distance_lateral_um>%d',minimal_lateral_distance)  & sprintf('response_distance_lateral_um<=%d',(max_distance_lateral_vec(i_d)));
                        %                             rel_current = rel ;
                        %                             key_ROI_current(i_g).out_degree_all2 = rel_current.count;
                        %
                        %                             rel_current = rel  & 'response_mean>0';
                        %                             key_ROI_current(i_g).out_degree_excitatory2= rel_current.count;
                        %
                        %                             rel_current = rel  & 'response_mean<0';
                        %                             key_ROI_current(i_g).out_degree_inhibitory2= rel_current.count;
                        
                        
                        key_ROI_current(i_g).max_distance_lateral = max_distance_lateral_vec(i_d);
                        %                             key_ROI_current(i_g).num_svd_components_removed = num_svd;
                        key_ROI_current(i_g).p_val = current_p_val;
                        
                    end
                    insert(self,key_ROI_current)
                end
            end
        end
    end
end



