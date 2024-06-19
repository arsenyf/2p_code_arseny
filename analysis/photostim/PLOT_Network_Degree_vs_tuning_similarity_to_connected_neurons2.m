function PLOT_Network_Degree_vs_tuning_similarity_to_connected_neurons2()
% clf

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
filename = 'vs_tuning_similarity_to_connected_neurons_all_cells';
num_shuffles=100;
rel_include= (IMG.ROI- IMG.ROIBad) & STIM.ROIResponseDirectUnique;
k_degree.max_distance_lateral =100;
k_degree.session_epoch_number=2;
k_degree.num_svd_components_removed=0;
k_degree.p_val = 0.05;
k_neurons_or_control.neurons_or_control=1;

k_tuning_corr.session_epoch_number=2;
k_tuning_corr.excitatory_or_inhibitory_connection=2;
k_tuning_corr.tuning_modulation_threshold=0;
k_tuning_corr.tuning_odd_even_corr_threshold=-1;
k_tuning_corr.response_p_val=0.05;


k_corr_local.radius_size=100;
k_corr_local.session_epoch_type = 'spont_only'; % behav_only spont_only
k_corr_local.num_svd_components_removed=0;

k_corr_local_behav.radius_size=100;
k_corr_local_behav.session_epoch_type = 'behav_only'; 
k_corr_local_behav.num_svd_components_removed=0;

rel_session = EXP2.Session & (STIMANAL.OutDegree & IMG.Volumetric) & (EXP2.SessionEpoch& 'session_epoch_type="spont_only"')...
    & (STIMANAL.NeuronOrControl & 'neurons_or_control=1' & 'num_targets>=25')...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) ...
    & (LICK2D.ROILick2DmapStatsSpikes3binsShort);


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
left_color=[0 0 0];
right_color=[0 0 0];
set(gcf,'defaultAxesColorOrder',[left_color; right_color]);

DefaultFontSize=8;

horizontal_dist=0.25;
vertical_dist=0.22;

panel_width1=0.12;
panel_height1=0.12;

position_x1(1)=0.07;
position_x1(end+1)=position_x1(end)+horizontal_dist;
position_x1(end+1)=position_x1(end)+horizontal_dist;
position_x1(end+1)=position_x1(end)+horizontal_dist;

position_y1(1)=0.75;
position_y1(end+1)=position_y1(end)-vertical_dist;
position_y1(end+1)=position_y1(end)-vertical_dist;
position_y1(end+1)=position_y1(end)-vertical_dist;


sessions = fetch(rel_session);

DATA_DEGREE_ALL=[];
DATA_CORR_ALL=[];

DATA_SIGNAL_ALL1=[];


for i_s = 1:1:rel_session.count
    
    k_s = sessions(i_s);
    rel_signal1 = STIMANAL.Target2ConnectedCorrTuningMap & k_s & k_tuning_corr & rel_include  & (STIMANAL.NeuronOrControl & k_neurons_or_control);

    rel_degree = STIMANAL.OutDegree*STIM.ROIResponseDirectUnique	 & (STIMANAL.NeuronOrControl & k_neurons_or_control) & k_degree & k_s & rel_include & rel_signal1;
    DATA_DEGREE = struct2table(fetch(rel_degree, '*'));
    %    numel(unique(DATA_DEGREE.roi_number))
    
    key_epoch = fetch(EXP2.SessionEpoch & k_s & k_corr_local);
    rel_corr_local = POP.ROICorrLocalPhoto2  & k_s & k_corr_local & key_epoch & rel_include;
    
    if rel_corr_local.count==0
        continue
    end
    rel_corr_local =  rel_corr_local& key_epoch(1);
    
    DATA_SIGNAL1 = struct2table(fetch(rel_signal1, 'avg_tuning_correlation_with_targets', 'ORDER BY roi_number'));

    DATA_CORR = struct2table(fetch(rel_corr_local, '*'));

    
    idx=[];
    for i_r=1:1:size(DATA_DEGREE,1)
        idx(i_r) = find(DATA_CORR.roi_number == DATA_DEGREE.roi_number(i_r));
    end
    DATA_CORR_ALL =[DATA_CORR_ALL; DATA_CORR(idx,:)];
    
    
    
      idx=[];
    for i_r=1:1:size(DATA_DEGREE,1)
        idx(i_r) = find(DATA_SIGNAL1.roi_number == DATA_DEGREE.roi_number(i_r));
    end
    DATA_SIGNAL_ALL1 =[DATA_SIGNAL_ALL1; DATA_SIGNAL1(idx,:)];
    
    
    
    
    DATA_DEGREE_ALL =[DATA_DEGREE_ALL; DATA_DEGREE];
   %     DATA_SIGNAL_ALL5 =[DATA_SIGNAL_ALL5; DATA_SIGNAL5(idx,:)];

end

num_neurons_in_radius = DATA_CORR_ALL.num_neurons_in_radius_without_inner_ring;

signal1.avg_tuning_correlation_with_targets = DATA_SIGNAL_ALL1.avg_tuning_correlation_with_targets;


out_degree_excitatory = DATA_DEGREE_ALL.out_degree_excitatory;
out_degree_inhibitory= DATA_DEGREE_ALL.out_degree_inhibitory;


% Done to correct for uneven density of cells
relative_cell_density=num_neurons_in_radius/mean(num_neurons_in_radius);
out_degree_excitatory = out_degree_excitatory./relative_cell_density;
out_degree_inhibitory= out_degree_inhibitory./relative_cell_density;



number_of_bins=7;
%% Connectivity vs Positional tuning (modulation)
axes('position',[position_x1(1)+0.01, position_y1(1), panel_width1, panel_height1]);
hold on
% y=signal1.map_information ;
y=signal1.avg_tuning_correlation_with_targets;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
% hist_bins(end-2:end-1)=[];
hist_bins(end)=[];

[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Tuning correlation with \n effectively connected neurons,\n r'))
% ylabel(sprintf('Spatial Information \n(bits/spike)'))
title(sprintf('Location tuning\n'));
box off;
% xlim([0,70]);


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

