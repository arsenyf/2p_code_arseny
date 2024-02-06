%{
# Response traces of all neurons to target neuron photostimulation, regardless of connection significance
-> IMG.PhotostimGroup
num_svd_components_removed                            : int         # how many of the first svd components were removed
---
all_neurons_response_trace_matrix                     : longblob   #  matrix of trial-averaged responses of all other neurons to photostimulation of this target neuron, every row is a neuron, all neurons are included regardless of connection significance
all_neurons_response_trace_matrix_without_baseline    : longblob   # matrix of trial-averaged responses of all other neurons to photostimulation of this target neuron, every row is a neuron, all neurons are included regardless of connection significance, after subtracting the baseline
all_neurons_roi_numbers                               : blob        #  all other neurons, roi numbers of 
all_neurons_connection_strength                       : blob        #   all other neurons, connection strength
all_neurons_response_significance                     : blob        #  all other neurons, response signficance 
all_neurons_distance_lateral                          : blob        #  all other neurons, lateral distance um
all_neurons_distance_axial                            : blob        #  all other neurons, axial distance um
all_neurons_distance_3d                               : blob        #  all other neurons, distance eucledian in 3d um
time_vector                                           : blob        #  time vector relative to photostimulation time for the response trace

%} 

classdef ROIInfluenceTraceLong < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end
