%{
# Taking only directly stimulated neurons to get a complete connectivity profile
-> EXP2.SessionEpoch
p_val_threshold                     : double          # p_val threshold for connectiong significance
---
mat_response_mean                   : longblob                #
mat_distance                        : longblob                # (pixels)
mat_response_pval                   : longblob                #
roi_num_list                        : blob                    #
photostim_group_num_list            : blob                    #
in_degree_list                      : blob                    #
out_degree_list                     : blob                    #
in_out_degree_corr=null             : double       #
unidirectional_connect_number       : int          # total number of pairs with unidirectional connections
bidirectional_connect_number        : int          # total number of pairs with bidirectional  connections
unidirectional_proportion=null      : double          # out of total signficant unidirectional or bidirectonal connections
%}


classdef ConnectivityBetweenDirectlyStimulatedOnly < dj.Imported
    properties
        %         keySource = IMG.PhotostimGroup;
        keySource = EXP2.SessionEpoch & 'flag_photostim_epoch =1' & IMG.FOV & STIMANAL.NeuronOrControl;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            dir_base =fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            
            p_val_threshold = [0.05, 0.1, 0.2];
            minimal_distance = 25; %in microns
            
            for i_p =1:1:numel(p_val_threshold)
                close;
                dir_save_figure = [dir_base '\photostim\Graph_analysis\Connectivity_Between_Direct_only\pval_' num2str(i_p) '\'];

                fn_compute_graph_and_connectivity_stats(key, p_val_threshold(i_p), minimal_distance, dir_save_figure, self)
            end
            
        end
    end
end