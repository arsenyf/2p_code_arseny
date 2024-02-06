%{
# Taking only directly stimulated neurons to get a complete connectivity profile
-> EXP2.SessionEpoch
p_val_threshold                     : double          # p_val threshold for connectiong significance
min_outdegree                       : int             #  
---
mat_response_mean                   : longblob        #
mat_distance                        : longblob        # (pixels)
mat_response_pval                   : longblob        #
roi_num_list                        : blob            #
photostim_group_num_list            : blob            #
in_degree_list                      : blob            #
out_degree_list                     : blob            #
in_out_degree_corr=null             : double          #
unidirectional_connect_number       : int             # total number of pairs with unidirectional connections
bidirectional_connect_number        : int             # total number of pairs with bidirectional  connections
unidirectional_proportion=null      : double          # out of total signficant unidirectional or bidirectonal connections
number_of_neurons_in_subnetwork     : int             # number of neurons in the subnetwork with some min_outdegree
%}


classdef ConnectivityBetweenDirectlyStimulatedOnlyOverconnected < dj.Imported
    properties
        %         keySource = IMG.PhotostimGroup;
        keySource = EXP2.SessionEpoch & 'flag_photostim_epoch =1' & IMG.FOV & STIMANAL.NeuronOrControl;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            dir_base =fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            
            p_val_threshold = 0.05;
            minimal_distance = 25; %in microns
            maximal_distance =1000; %in microns
            min_outdegree = [0,1,2,3,4,5,6,7,8,9,10,15,20];

            for i_o =1:1:numel(min_outdegree)
                close;
                dir_save_figure = [dir_base 'photostim\Graph_analysis\Connectivity_Between_Direct_only\min_outdegree\outdegree_' num2str(i_o) '\'];
                fn_compute_graph_and_connectivity_stats_min_out_degree (key, p_val_threshold,min_outdegree(i_o), minimal_distance, maximal_distance, dir_save_figure, self)
            end
            
        end
    end
end