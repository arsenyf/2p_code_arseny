function Revision_Connectivity_of_Hubs_etc ()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename = 'Revision_Connectivity_of_Hubs_etc';
figure

PLOT_Network_Degree_vs_tuning_similarity_to_connected_neurons()
PLOT_Network_Degree_vs_tuning_similarity_to_connected_neurons2()
populate(LICK2D.Target2ConnectedCorrTuningMap);
populate(LICK2D.DistanceTuningColumnsMapsSpikes);

Analysis_of_connection_stability_over_time


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
eval(['print ', figure_name_out, ' -dpdf -r200']);
