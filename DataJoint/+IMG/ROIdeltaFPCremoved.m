%{
# Flourescent trace
-> EXP2.SessionEpoch
-> IMG.ROI
num_svd_components_removed      : int     # how many of the first svd components were removed
---
dff_trace      : longblob   # dff trace for each frame, after projecting out n first SVD components
%}


classdef ROIdeltaFPCremoved < dj.Imported
    properties
        keySource = (EXP2.SessionEpoch & 'session_epoch_type="spont_only"' & IMG.ROI) - IMG.Mesoscope;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key_ROI=fetch(IMG.ROI&key,'ORDER BY roi_number');
            num_svd_components_removed_vector=[1,3];
            
            Fall=cell2mat(fetchn(IMG.ROIdeltaF &key,'dff_trace','ORDER BY roi_number'));
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
                    dFF=F(iROI,:);
                    k2=key_ROI(iROI);
                    k2.num_svd_components_removed=num_svd_components_removed_vector(i_c);
                    k2.dff_trace = dFF;
                    k2.session_epoch_type = key.session_epoch_type;
                    k2.session_epoch_number = key.session_epoch_number;
                    insert(self,k2);
                end
            end
        end
    end
end
