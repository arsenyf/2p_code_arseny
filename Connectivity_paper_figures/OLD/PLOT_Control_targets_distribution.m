function PLOT_Control_targets_distribution ()

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Photostim\Connectivity\'];
filename = 'Control_targets_distribution';
DefaultFontSize =12;

figure
rel=STIMANAL.ControlTargetsIntermingled &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25'));
distance_to_closest_responsive_target=fetchn(STIMANAL.ControlTargetsIntermingled,'distance_to_closest_responsive_target');
histogram(distance_to_closest_responsive_target)
xlabel(sprintf('Distance of control target from \nphotostimulatable neural target'))
ylabel('Counts')
set(gca, 'FontSize', 10)

fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


rel2= (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25' & 'num_targets_controls>=25') & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );
D=fetch(rel2,'*')
mean([D.num_targets_neurons])
mean([D.num_targets_controls])

median([D.num_targets_neurons])
median([D.num_targets_controls])

rel_inf=STIM.ROIInfluence2  & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (IMG.PhotostimGroup & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1'));
% rel_inf=STIM.ROIInfluence2 ;% & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1');

rel_inf.count()

(IMG.ROI-IMG.ROIBad)& (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (IMG.PhotostimGroup & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1'))


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);
