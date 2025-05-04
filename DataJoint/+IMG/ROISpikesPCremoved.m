%{
# Flourescent trace
-> EXP2.SessionEpoch
-> IMG.ROI
num_svd_components_removed      : int     # how many of the first svd components were removed
---
spikes_trace      : longblob   # (s) deconvolved trace for each frame
%}


classdef ROISpikesPCremoved < dj.Imported
    properties
        keySource =(EXP2.SessionEpoch & IMG.ROIdeltaF ) &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key_ROI=fetch(IMG.ROI&key,'ORDER BY roi_number');
            num_svd_components_removed_vector=[1,3];
            
            Fall=cell2mat(fetchn((IMG.ROISpikes &key) - IMG.ROIBad,'spikes_trace','ORDER BY roi_number'));
            %             Fall = gpuArray(Fall);
           [U,S,V]=svd(Fall); % S time X neurons; % U time X time;  V neurons x neurons

%             try
%                 [U,S,V]=svd(Fall); % S time X neurons; % U time X time;  V neurons x neurons
%             catch
%                 return;
%             end
            
            for i_c = 1:1:numel(num_svd_components_removed_vector)
                if num_svd_components_removed_vector(i_c)>0
                    num_comp = num_svd_components_removed_vector(i_c);
                    F = U(:,(1+num_comp):end)*S((1+num_comp):end, (1+num_comp):end)*V(:,(1+num_comp):end)';
                end
                %                 F=gather(F);
                for iROI=1:1:size(Fall,1)
                    spikes_trace=F(iROI,:);
                    k2=key_ROI(iROI);
                    k2.num_svd_components_removed=num_svd_components_removed_vector(i_c);
                    k2.spikes_trace = spikes_trace;
                    k2.session_epoch_type = key.session_epoch_type;
                    k2.session_epoch_number = key.session_epoch_number;
                    insert(self,k2);
                end
            end
        end
    end
end
