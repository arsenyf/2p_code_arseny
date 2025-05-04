%{
# Checking if the control sites are intermingled with direcly stimulated responding neurons

-> EXP2.SessionEpoch
---
distance_between_targets                     : longblob  #minimal distances in microns between closest directly stimulated neurons that show responses
targets_density_percentage                   : longblob  #number of directly stimulated neurons that show responses out of all neurons in this plane
opsin_expressing_neurons_density_percentage  : longblob  #inference of percentage of neurons expressing the opsing based on directly stimulated responsive and non-responsive neurons
%}


classdef TargetsDensity < dj.Imported
    properties
        keySource = EXP2.SessionEpoch & 'flag_photostim_epoch =1' & IMG.ROI & STIM.ROIResponseDirectUnique	 & (STIMANAL.SessionEpochsIncludedFinal & 'flag_include=1') & (STIMANAL.NeuronOrControl & 'neurons_or_control=0') & (STIMANAL.NeuronOrControl & 'neurons_or_control=1');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            rel_target_neuron = STIM.ROIResponseDirectUnique*IMG.ROI	& key & (STIMANAL.NeuronOrControl & 'neurons_or_control=1');
            rel_target_control = STIM.ROIResponseDirectUnique*IMG.ROI	& key & (STIMANAL.NeuronOrControl & 'neurons_or_control=0');
            rel_all_neurons = (IMG.ROI -IMG.ROIBad)	& key & 'plane_num=1'; % the photostim plane
            
            N=fetch(rel_target_neuron,'*', 'ORDER BY roi_number');
            C=fetch(rel_target_control,'*',  'ORDER BY roi_number');
            ALL=fetch(rel_all_neurons,'*', 'ORDER BY roi_number');
            
            zoom =fetch1(IMG.FOVEpoch & key,'zoom');
            k.scanimage_zoom = zoom;
            pix2dist=  fetch1(IMG.Zoom2Microns & k,'fov_microns_size_x') / fetch1(IMG.FOV & key, 'fov_x_size');
            
            x_all = [N.roi_centroid_x];
            y_all =  [N.roi_centroid_y];
            if size(N,1)<2
                return
            end
            for i_n = 1:1:numel(N)
                x = N(i_n).roi_centroid_x;
                y =  N(i_n).roi_centroid_y;
                dx=x_all-x;
                dy=y_all-y;
                distance2D = sqrt(dx.^2 + dy.^2)*pix2dist; %
                distance2D (i_n) = []; % excluding self
                distance_between_targets (i_n)=min(distance2D);
            end
            
            key.distance_between_targets = unique(distance_between_targets); % counting each pair
            key.targets_density_percentage = 100*numel(N)/numel(ALL);
            key.opsin_expressing_neurons_density_percentage = 100*numel(N)/(numel(N) + numel(C));
            
            insert(self,key);
        end
    end
end