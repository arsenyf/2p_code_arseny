%{
# Checking if the control sites are intermingled with direcly stimulated responding neurons

-> EXP2.SessionEpoch
photostim_group_num   : int #
---
-> IMG.ROI
distance_to_closest_responsive_target    : double  #distance in microns to the closest directly stimulated neurons that show responses
%}


classdef ControlTargetsIntermingled < dj.Imported
    properties
        keySource = EXP2.SessionEpoch & 'flag_photostim_epoch =1' & IMG.ROI & STIM.ROIResponseDirectUnique	 & (STIMANAL.SessionEpochsIncludedFinal & 'flag_include=1') & (STIMANAL.NeuronOrControl & 'neurons_or_control=0') & (STIMANAL.NeuronOrControl & 'neurons_or_control=1');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            rel_control = STIM.ROIResponseDirectUnique*IMG.ROI	& key & (STIMANAL.NeuronOrControl & 'neurons_or_control=0');
            rel_neuron = STIM.ROIResponseDirectUnique*IMG.ROI	& key & (STIMANAL.NeuronOrControl & 'neurons_or_control=1');
            
            C=fetch(rel_control,'*',  'ORDER BY roi_number');
            kkk=fetch(rel_control,'ORDER BY roi_number');
            N=fetch(rel_neuron,'*', 'ORDER BY roi_number');
            
             zoom =fetch1(IMG.FOVEpoch & key,'zoom');
            k.scanimage_zoom = zoom;
            pix2dist=  fetch1(IMG.Zoom2Microns & k,'fov_microns_size_x') / fetch1(IMG.FOV & key, 'fov_x_size');
            
            x_all = [N.roi_centroid_x];
            y_all =  [N.roi_centroid_y];
            
            for i_n = 1:1:numel(C)
                x = C(i_n).roi_centroid_x;
                y =  C(i_n).roi_centroid_y;
                dx=x_all-x;
                dy=y_all-y;
                distance2D = sqrt(dx.^2 + dy.^2)*pix2dist; %
                
                kkk(i_n).distance_to_closest_responsive_target=min(distance2D);
            end
            insert(self,kkk);
        end
    end
end