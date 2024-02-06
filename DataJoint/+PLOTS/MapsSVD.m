%{
#
-> EXP2.SessionEpoch
%}


classdef MapsSVD < dj.Computed
    properties
        keySource = EXP2.SessionEpoch & POP.ROISVD  & IMG.Mesoscope & POP.ROISVDDistanceScale;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\brain_maps\SVD\dff\'];
            
            rel_roi = (IMG.ROI - IMG.ROIBad) & key;
            rel_data = (POP.ROISVD & 'threshold_for_event=0' & 'time_bin=1.5') & rel_roi & key;
            rel_data_spatial_scale = POP.ROISVDDistanceScale  & key;

            x_all=fetchn(rel_roi,'roi_centroid_x','ORDER BY roi_number');
            y_all=fetchn(rel_roi,'roi_centroid_y','ORDER BY roi_number');
            
            x_pos_relative=fetchn(rel_roi*IMG.PlaneCoordinates ,'x_pos_relative','ORDER BY roi_number');
            y_pos_relative=fetchn(rel_roi*IMG.PlaneCoordinates,'y_pos_relative','ORDER BY roi_number');
            
            x_all = x_all + x_pos_relative;
            y_all = y_all + y_pos_relative;
            x_all = x_all/0.75;
            y_all = y_all/0.5;
            
            
            % aligning relative to bregma
            bregma_x_um=1000*fetchn(IMG.Bregma & key,'bregma_x_mm');
            if ~isempty(bregma_x_um)
                bregma_y_um=1000*fetchn(IMG.Bregma & key,'bregma_y_mm');
                x_all_max= max(x_all);
                y_all_min= min(y_all);
                
                x_all=x_all-[x_all_max - bregma_x_um]; % anterior posterior
                y_all=y_all-y_all_min+bregma_y_um; % medial lateral
            end
            
            
            DATA=fetch(rel_data,'*');
            ROI_WEIGHTS = cell2mat({DATA.roi_components}');
            
            DATA_SPATIAL_SCALE=fetch(rel_data_spatial_scale,'*');
            distance_bins_centers =DATA_SPATIAL_SCALE.distance_bins_centers;
            rd_distance_components =DATA_SPATIAL_SCALE.rd_distance_components;
            distance_tau  =DATA_SPATIAL_SCALE.distance_tau;
            max_components = min(size(ROI_WEIGHTS,2),500);
            
            
            components_2plot = [1:10,50, 100, max_components];
            for i_c = 1:1:numel(components_2plot)
                W = ROI_WEIGHTS(:, components_2plot(i_c));
                rd_distance = rd_distance_components(components_2plot(i_c),:);
                PLOTS_MapsSVD(key, dir_current_fig, W, x_all, y_all, components_2plot(i_c), rd_distance, distance_bins_centers, distance_tau(components_2plot(i_c)));
            end
            insert(self,key);
            
        end
    end
end