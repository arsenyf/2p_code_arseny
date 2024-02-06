%{
# ROI (Region of interest - e.g. cells), parcellation according to Allen Brain atlas
-> IMG.ROI
-> LAB.BrainArea
---
roi_centroid_x_um_relative2bregma : double        # ROI centroid  x, microns, relative to bregma
roi_centroid_y_um_relative2bregma : double        # ROI centroid  y, microns, relative to bregma
roi_centroid_z_um : double                        # ROI centroid  z, microns, relative to top plane

%}

classdef ROIBrainArea < dj.Imported
    properties
        keySource = EXP2.Session & IMG.Bregma & IMG.Mesoscope;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            %             clf
            close all
            figure
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\brain_maps\brain_alignment\'];
            
            R=fetch (IMG.ROI & key, 'roi_centroid_x','roi_centroid_y', 'ORDER BY roi_number');
            x_all= [R.roi_centroid_x]';
            y_all= [R.roi_centroid_y]';
            key_ROI= rmfield(R,'roi_centroid_x');
            key_ROI= rmfield(key_ROI,'roi_centroid_y');
            
            
            x_pos_relative=fetchn(IMG.ROI*IMG.PlaneCoordinates& key ,'x_pos_relative','ORDER BY roi_number');
            y_pos_relative=fetchn(IMG.ROI*IMG.PlaneCoordinates& key,'y_pos_relative','ORDER BY roi_number');
            z_pos_relative=fetchn(IMG.ROI*IMG.PlaneCoordinates& key,'z_pos_relative','ORDER BY roi_number');
            
            x_all = x_all + x_pos_relative;
            y_all = y_all + y_pos_relative;
            x_all = x_all/0.75;
            y_all = y_all/0.5;
            
            
            % aligning relative to bregma
            bregma_x_um=1000*fetchn(IMG.Bregma & key,'bregma_x_mm');
            bregma_y_um=1000*fetchn(IMG.Bregma & key,'bregma_y_mm');
            x_all_max= max(x_all);
            y_all_min= min(y_all);
            
            x_all=x_all-[x_all_max - bregma_x_um]; % anterior posterior
            y_all=y_all-y_all_min+bregma_y_um; % medial lateral
            
            
            dXY=zeros(numel(x_all),numel(x_all));
            parfor iROI=1:1:numel(x_all)
                x=x_all(iROI);
                y=y_all(iROI);
                dXY(iROI,:)= sqrt((x_all-x).^2 + (y_all-y).^2); % in um
            end
            
            
            %% PLOT ALLEN MAP
            allen2mm=1000*3.2/160;
            allenDorsalMapSM_Musalletal2019 = load('allenDorsalMapSM_Musalletal2019.mat');
            edgeOutline = allenDorsalMapSM_Musalletal2019.dorsalMaps.edgeOutline;
            labels = allenDorsalMapSM_Musalletal2019.dorsalMaps.labels;
            
            relevant_brain_area = fetchn(LAB.BrainArea,'brain_area');
            idx_relevant_areas=(ismember(labels,relevant_brain_area));
            edgeOutline=edgeOutline(idx_relevant_areas);
            labels=labels(idx_relevant_areas);
            
            bregma_x_allen = allenDorsalMapSM_Musalletal2019.dorsalMaps.bregmaScaled(2);
            bregma_y_allen = allenDorsalMapSM_Musalletal2019.dorsalMaps.bregmaScaled(1);
            
            
            numberROI = size(R,1);
            
            subplot(2,2,1)
           hold on
            roi_brain_area=cell(numberROI,1);
            for i_a = 1:1:numel(edgeOutline)
                xxx_area_edges = -1*([edgeOutline{i_a}(:,1)]-bregma_x_allen);
                yyy_area_edges= [edgeOutline{i_a}(:,2)]-bregma_y_allen;
                xxx_area_edges=xxx_area_edges*allen2mm;
                yyy_area_edges=yyy_area_edges*allen2mm;
                
                in = inpolygon( x_all , y_all , xxx_area_edges , yyy_area_edges ) ;
                roi_brain_area(in)=labels(i_a);
                plot(xxx_area_edges, yyy_area_edges,'.','Color', [0 0 0], 'MarkerSize', 5)
                
            end
            
            area_colormap=jet(numel(labels));
            for i_a=1:1:numel(labels)
                idx_brain_area=strcmp(labels{i_a},roi_brain_area);
                plot(x_all(idx_brain_area),y_all(idx_brain_area),'.','Color',area_colormap(i_a,:));
            end
          
            title(sprintf('anm %d session %d', key.subject_id, key.session));

            
                        subplot(2,2,2)
                        hold on
        for i_a=1:1:numel(labels)
                idx_brain_area=strcmp(labels{i_a},roi_brain_area);
                plot(x_all(idx_brain_area),y_all(idx_brain_area),'.','Color',area_colormap(i_a,:));
            end
            
            for i_r = 1:1:numberROI
                % if the cell is in between brain-regions polygons, we find the closest neihbor out of the assigned cells
                if isempty(roi_brain_area{i_r})
                    temp = dXY(i_r,:);
                    temp(i_r)=NaN; % we ignore self
                    idx_empty=find(cellfun(@isempty,roi_brain_area));
                    temp(idx_empty)=NaN; % we ignore all other cells that are not asigned.
                    [~,idx_closest_cell]=min(temp); % we find the closest neihbor out of the assigned cells
                    roi_brain_area(i_r)=roi_brain_area(idx_closest_cell);
                end
                
                key_ROI(i_r).brain_area=roi_brain_area{i_r};
                key_ROI(i_r).roi_centroid_x_um_relative2bregma=x_all(i_r);
                key_ROI(i_r).roi_centroid_y_um_relative2bregma=y_all(i_r);
                key_ROI(i_r).roi_centroid_z_um=z_pos_relative(i_r);
                
            end
            
            insert(self,key_ROI);
            
            filename = ['anm' num2str(key.subject_id) '_s' num2str(key.session) '.tiff'];
            
            if isempty(dir(dir_current_fig))
                mkdir (dir_current_fig)
            end
            %
            figure_name_out=[ dir_current_fig filename];
            eval(['print ', figure_name_out, ' -dtiff  -r200']);
            
        end
        
    end
end
