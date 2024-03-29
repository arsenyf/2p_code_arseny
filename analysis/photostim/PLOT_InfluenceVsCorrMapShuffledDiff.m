function PLOT_InfluenceVsCorrMapShuffledDiff()
% close all

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Photostim\Connectivity_vs_Tuning\'];
filename = 'connectivity_vs_tuning_by_map_stability';
title_string = 'Tuning to target position';

key.neurons_or_control=1;
key.response_p_val=1;
rel_data = STIMANAL.InfluenceVsCorrMap3*EXP2.SessionID  & 'num_pairs>=10' & 'num_targets>=50' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2')   ...;

rel_shuffled = STIMANAL.InfluenceVsCorrMapShuffled3*EXP2.SessionID & 'num_pairs>=10' & 'num_targets>=50' ...
    &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' & 'session_epoch_number=2')   ...;
  

num_svd_components_removed_vector_corr =[0]; % this is relevant if we remove  SVD  components of the ongoing dynamics from the connectivity response, to separate the evoked resposne from ongoing activity
% colormap=viridis(numel(num_svd_components_removed_vector_corr));
colormap=[1 0 0];


min_pairs_in_influence_bin=0;
min_pairs_in_corr_bin=0;


for i_c = 1:1:numel(num_svd_components_removed_vector_corr)
    key.num_svd_components_removed_corr=num_svd_components_removed_vector_corr(i_c);
    fn_plot_tuning_vs_connectivity(rel_data, rel_shuffled, key,title_string, colormap, i_c, min_pairs_in_influence_bin, min_pairs_in_corr_bin);
end


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);




