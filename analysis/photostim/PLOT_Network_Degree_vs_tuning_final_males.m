function PLOT_Network_Degree_vs_tuning_final_males()
% clf

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\revision\males_females\'];
filename = 'network_degree_vs_tuning_shuffled_final_males';
num_shuffles=100;
rel_include= (IMG.ROI- IMG.ROIBad) & STIM.ROIResponseDirectUnique & (LAB.Subject & 'sex="M"');
k_degree.max_distance_lateral =100;
k_degree.session_epoch_number=2;
k_degree.num_svd_components_removed=0;
k_degree.p_val = 0.05;
k_neurons_or_control.neurons_or_control=1;

k_corr_local.radius_size=100;
k_corr_local.session_epoch_type = 'spont_only'; % behav_only spont_only
k_corr_local.num_svd_components_removed=0;

k_corr_local_behav.radius_size=100;
k_corr_local_behav.session_epoch_type = 'behav_only'; 
k_corr_local_behav.num_svd_components_removed=0;

rel_sex=LAB.Subject;
rel_sex = rel_sex.proj('sex', 'subject_id');

rel_session = EXP2.Session & (STIMANAL.OutDegree & IMG.Volumetric) & (EXP2.SessionEpoch& 'session_epoch_type="spont_only"')...
    & (STIMANAL.NeuronOrControl & 'neurons_or_control=1' & 'num_targets>=25')...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) ...
    & (LICK2D.ROILick2DmapStatsSpikes3binsShort) & (rel_sex & 'sex="M"');




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
DATA_SIGNAL_ALL2=[];
DATA_SIGNAL_ALL3=[];
DATA_SIGNAL_ALL4=[];

for i_s = 1:1:rel_session.count
    
    k_s = sessions(i_s);
    rel_degree = STIMANAL.OutDegree*STIM.ROIResponseDirectUnique	 & (STIMANAL.NeuronOrControl & k_neurons_or_control) & k_degree & k_s & rel_include;
    k_s;
    DATA_DEGREE = struct2table(fetch(rel_degree, '*'));
    %    numel(unique(DATA_DEGREE.roi_number))
    
    key_epoch = fetch(EXP2.SessionEpoch & k_s & k_corr_local);
    key_epoch_local_behav = fetch(EXP2.SessionEpoch & k_s & k_corr_local_behav);
    rel_signal1 = LICK2D.ROILick2DmapStatsSpikes3binsShort & k_s & key_epoch_local_behav & rel_include;
    rel_signal2 = LICK2D.ROILick2DPSTHStatsSpikes*LICK2D.ROILick2DPSTHSpikesModulation  & k_s & key_epoch_local_behav & rel_include;
    rel_signal3 = LICK2D.ROILick2DmapSpikes3binsModulation & k_s & key_epoch_local_behav & rel_include;
    rel_signal4 = IMG.ROIdeltaFStats  & k_s & key_epoch & rel_include;
%     rel_signal5 = STIM.ROIResponseDirectUnique & k_s & k_degree & rel_include;

    
    
    
    rel_corr_local = POP.ROICorrLocalPhoto2  & k_s & k_corr_local & key_epoch & rel_include;
    
    if rel_corr_local.count==0
        continue
    end
    rel_corr_local =  rel_corr_local& key_epoch(1);
    
    DATA_SIGNAL1 = struct2table(fetch(rel_signal1, 'information_per_spike_regular','lickmap_regular_odd_vs_even_corr','psth_position_concat_regular_odd_even_corr', 'ORDER BY roi_number'));
    DATA_SIGNAL2 = struct2table(fetch(rel_signal2, 'psth_regular_odd_vs_even_corr','psth_regular_modulation', 'reward_peak_regular', 'reward_peak_small','reward_peak_large', 'reward_mean_regular', 'reward_mean_small','reward_mean_large','reward_mean_pval_regular_large','reward_mean_pval_regular_small', 'ORDER BY roi_number'));
    DATA_SIGNAL3 = struct2table(fetch(rel_signal3, 'lickmap_fr_regular_modulation', 'ORDER BY roi_number'));
    DATA_SIGNAL4 = struct2table(fetch(rel_signal4, 'mean_dff'));
%     DATA_SIGNAL5 = struct2table(fetch(rel_signal5, 'response_mean'));

    DATA_CORR = struct2table(fetch(rel_corr_local, '*'));

    
    idx=[];
    for i_r=1:1:size(DATA_DEGREE,1)
        idx(i_r) = find(DATA_CORR.roi_number == DATA_DEGREE.roi_number(i_r));
    end
    DATA_CORR_ALL =[DATA_CORR_ALL; DATA_CORR(idx,:)];
    DATA_DEGREE_ALL =[DATA_DEGREE_ALL; DATA_DEGREE];
    
    DATA_SIGNAL_ALL1 =[DATA_SIGNAL_ALL1; DATA_SIGNAL1(idx,:)];
    DATA_SIGNAL_ALL2 =[DATA_SIGNAL_ALL2; DATA_SIGNAL2(idx,:)];
    DATA_SIGNAL_ALL3 =[DATA_SIGNAL_ALL3; DATA_SIGNAL3(idx,:)];
    DATA_SIGNAL_ALL4 =[DATA_SIGNAL_ALL4; DATA_SIGNAL4(idx,:)];
%     DATA_SIGNAL_ALL5 =[DATA_SIGNAL_ALL5; DATA_SIGNAL5(idx,:)];

end

num_neurons_in_radius = DATA_CORR_ALL.num_neurons_in_radius_without_inner_ring;
corr_local = DATA_CORR_ALL.corr_local_without_inner_ring;

signal1.map_information = DATA_SIGNAL_ALL1.information_per_spike_regular;
signal1.map_stability = DATA_SIGNAL_ALL1.lickmap_regular_odd_vs_even_corr;
signal1.psth_concat_stability = DATA_SIGNAL_ALL1.psth_position_concat_regular_odd_even_corr;

signal2.psth_stability = DATA_SIGNAL_ALL2.psth_regular_odd_vs_even_corr;
signal2.psth_modulation = DATA_SIGNAL_ALL2.psth_regular_modulation;

signal3.map_modulation = DATA_SIGNAL_ALL3.lickmap_fr_regular_modulation;


% reward_large = DATA_SIGNAL_ALL2.reward_peak_large; % the peak version looks better!
% reward_small = DATA_SIGNAL_ALL2.reward_peak_small;
% reward_regular = DATA_SIGNAL_ALL2.reward_peak_regular;
% 
idx_large = [DATA_SIGNAL_ALL2.reward_mean_pval_regular_large<=1]; % we take all
idx_small = [DATA_SIGNAL_ALL2.reward_mean_pval_regular_small<=1]; % we take all



reward_large = DATA_SIGNAL_ALL2.reward_mean_large; % the peak version looks better!
reward_small = DATA_SIGNAL_ALL2.reward_mean_small;
reward_regular = DATA_SIGNAL_ALL2.reward_mean_regular;
signal2.reward_increase = 100*((reward_large(idx_large)./reward_regular(idx_large))-1);
signal2.reward_omission = 100*((reward_small(idx_small)./reward_regular(idx_small))-1);

% signal3.rayleigh = DATA_SIGNAL_ALL3.rayleigh_length_regular;

signal4.mean_dff = DATA_SIGNAL_ALL4.mean_dff;

% signal5.response_mean = DATA_SIGNAL_ALL5.response_mean;



out_degree_excitatory = DATA_DEGREE_ALL.out_degree_excitatory;
out_degree_inhibitory= DATA_DEGREE_ALL.out_degree_inhibitory;

significant_connection_pairs=sum(out_degree_excitatory)

% Done to correct for uneven density of cells
relative_cell_density=num_neurons_in_radius/mean(num_neurons_in_radius);
out_degree_excitatory = out_degree_excitatory./relative_cell_density;
out_degree_inhibitory= out_degree_inhibitory./relative_cell_density;


% out_degree_excitatory = (out_degree_excitatory./num_neurons_in_radius)*mean(num_neurons_in_radius);
% out_degree_inhibitory= (out_degree_inhibitory./num_neurons_in_radius)*mean(num_neurons_in_radius);


number_of_bins=9;
number_of_bins2=9; 
%% Connectivity vs Positional tuning (modulation)
axes('position',[position_x1(1), position_y1(1), panel_width1, panel_height1]);
hold on
% y=signal1.map_information ;
y=signal3.map_modulation;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Location-tuning\n modulation (%%)'))
% ylabel(sprintf('Spatial Information \n(bits/spike)'))
title(sprintf('Location tuning\n'));
box off;
ylim([32,42]);

%% Connectivity vs Positional tuning (similarity)
axes('position',[position_x1(2), position_y1(1), panel_width1, panel_height1]);
hold on
y=signal1.map_stability ;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel([sprintf('Location-tuning, \nstability ') '\itr']);
title(sprintf('Location tuning\n'));
box off;


% %% Connectivity vs Directional tuning (Rayleigh)
% axes('position',[position_x1(1), position_y1(2), panel_width1, panel_height1]);
% hold on
% y=signal3.rayleigh;
% % excitatory
% k =out_degree_excitatory;
% hist_bins = linspace(0,ceil(max(k)),number_of_bins);
% hist_bins(end-2:end-1)=[];
% [hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
% shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0 0 1]})
% shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
% ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
% xlabel(sprintf('Number of causal connections,\n out-degree')) 
% ylabel(sprintf('Rayleigh vector length\n'));
% title(sprintf('Tuning to target direction\n'));
% box off;

%% Connectivity vs Temporal tuning (modulation)
axes('position',[position_x1(3), position_y1(1), panel_width1, panel_height1]);
hold on
y=signal2.psth_modulation ;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Tuning modulation, \itr');
title(sprintf('Tuning to response time \n'));box off;


%% Connectivity vs Temporal tuning (stability)
axes('position',[position_x1(4), position_y1(1), panel_width1, panel_height1]);
hold on
y=signal2.psth_stability ;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Tuning Similarity, \itr');
title(sprintf('Tuning to response time \n'));box off;


% %% Connectivity vs Temporal tuning tuning that is independent of direction: psth_position_concat_regularreward_odd_even_corr_binwise
% axes('position',[position_x1(4), position_y1(1), panel_width1, panel_height1]);
% hold on
% y=signal1.psth_concat_stability ;
% % excitatory
% k =out_degree_excitatory;
% hist_bins = linspace(0,ceil(max(k)),number_of_bins);
% hist_bins(end-2:end-1)=[];
% [hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
% shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
% shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
% ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
% xlabel(sprintf('Number of causal connections,\n out-degree')) 
% ylabel('Tuning Similarity, \itr');
% title(sprintf('Tuning to response time \nand target position'));box off;


%% Connectivity vs Reward tuning (large vs regular reward)
axes('position',[position_x1(1), position_y1(2), panel_width1, panel_height1]);
hold on
y=abs(signal2.reward_increase);
% excitatory
k =out_degree_excitatory(idx_large);
hist_bins = linspace(0,ceil(max(k)),number_of_bins2);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0.5 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Reward-increase \n modulation (%%)'))
title(sprintf('Reward-increase\n'));
box off;

%% Connectivity vs Reward tuning (small vs regular reward)
axes('position',[position_x1(2), position_y1(2), panel_width1, panel_height1]);
hold on
y=abs(signal2.reward_omission);
% excitatory
k =out_degree_excitatory(idx_small);
hist_bins = linspace(0,ceil(max(k)),number_of_bins2);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0 0.7 0.2]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Reward-omission \n modulation (%%)'))
title(sprintf('Reward-omission\n'));
box off;



%% Connectivity vs Reward tuning (reward omission and large reward combined)
axes('position',[position_x1(3), position_y1(2), panel_width1, panel_height1]);
hold on
% we average reward_increase and reward_omission of each neuron together
y=[mean([abs(signal2.reward_omission),abs(signal2.reward_increase)],2)];
% excitatory
k =[out_degree_excitatory(idx_small)];
hist_bins = linspace(0,ceil(max(k)),number_of_bins2);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Reward-outcome \n modulation (%%)'))
title(sprintf('Reward-outcome tuning\n'));
box off;
ylim([10,15]);

%% Local correlations
axes('position',[position_x1(1), position_y1(3), panel_width1, panel_height1]);
hold on
y=corr_local;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree'))
ylabel([sprintf('Local noise') newline '    {correlations, \it r}'])
title(sprintf('''Noise'' correlations with \nneighboring neurons\n'))
box off;
% ylim([0.025,0.15])
% set(gca, 'Ytick',[0.05, 0.1, 0.15])

%% Connectivity vs mean dF/F
axes('position',[position_x1(1), position_y1(4), panel_width1, panel_height1]);
hold on
y=signal4.mean_dff;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0 0 1]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
% ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
ylim([0,max(y_binned_mean+y_binned_stem)])

xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Mean DeltaF/F \n'))
title(sprintf('Flourescence \n'));
box off;

%% Connectivity vs Target response to direct photostimulation 
axes('position',[position_x1(4), position_y1(4), panel_width1, panel_height1]);
hold on
y=DATA_DEGREE_ALL.response_mean;
% excitatory
k =out_degree_excitatory;
hist_bins = linspace(0,ceil(max(k)),number_of_bins);
hist_bins(end-2:end-1)=[];
[hist_bins_centers, y_binned_mean,y_binned_stem, y_binned_shuffled_mean, y_binned_shuffled_stem] =fn_bin_and_shuffle (hist_bins, num_shuffles, k, y);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0 0 1]})
shadedErrorBar(hist_bins_centers,y_binned_shuffled_mean,y_binned_shuffled_stem,'lineprops',{'.-','Color',[0 0 0]})
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel(sprintf('Target response to direct \n photostimulation DeltaF/F \n'))
title(sprintf('Flourescence \n'));
box off;
ylim([0,2.5]);

%% Excitatory connections, versus Random Network
k=out_degree_excitatory;
hist_bins = linspace(0,max(k),10); %14
hist_bins_centers = hist_bins(1:end-1) + diff(hist_bins)/2;
hist_bins_centers=round(hist_bins_centers);

axes('position',[position_x1(2), position_y1(3), panel_width1, panel_height1]);
hold on
[k_prob]=histcounts(k,hist_bins);
k_prob=k_prob./length(k);
plot(hist_bins_centers,k_prob,'.-r')
% poisson
poisson_prob_at_bins = poisspdf(hist_bins_centers,mean(k));
continuous_bins=[0:1:max(hist_bins)];
poisson_prob_continuous = poisspdf(continuous_bins,mean(k));
poisson_prob_at_bins=[];
for i_b=2:1:numel(hist_bins)
    poisson_prob_at_bins(i_b)=sum(poisson_prob_continuous([ceil(hist_bins(i_b-1))+1:1: ceil(hist_bins(i_b))]));
end
poisson_prob = max( poisson_prob_at_bins)*(poisson_prob_continuous./max(poisson_prob_continuous));
plot(continuous_bins,poisson_prob,'-' ,'Color',[0.5 0.5 0.5])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Probability')
title('Excitatory connections', 'Color',[1 0 0]);
text(35,0.2,'Observed','Color',[1 0 0]);
text(25,0.5,sprintf('Random Network \n(Erdos-Renyi)'),'Color',[0.5 0.5 0.5]);

%log scale
axes('position',[position_x1(3), position_y1(3), panel_width1, panel_height1]);
loglog((hist_bins_centers),(k_prob),'.-r');
hold on
%poisson
loglog(continuous_bins,poisson_prob,'-','Color',[0.5 0.5 0.5]);
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Probability')
box off;
set(gca,'Xtick',[1,10,100], 'Ytick',[0.0001, 0.001, 0.01, 0.1, 1])
ylim([10^-4, 1]);
xlim([4 100]);



%% Inhibitory connections, versus Random Network
k=out_degree_inhibitory;
hist_bins = linspace(0,max(k),10); %14
hist_bins_centers = hist_bins(1:end-1) + diff(hist_bins)/2;
hist_bins_centers=round(hist_bins_centers);

axes('position',[position_x1(2), position_y1(4), panel_width1, panel_height1]);
hold on
[k_prob]=histcounts(k,hist_bins);
k_prob=k_prob./length(k);
plot(hist_bins_centers,k_prob,'.-b')
poisson_prob_at_bins = poisspdf(hist_bins_centers,mean(k));
continuous_bins=[0:1:max(hist_bins)];
poisson_prob_continuous = poisspdf(continuous_bins,mean(k));
poisson_prob_at_bins=[];
for i_b=2:1:numel(hist_bins)
    poisson_prob_at_bins(i_b)=sum(poisson_prob_continuous([ceil(hist_bins(i_b-1))+1:1: ceil(hist_bins(i_b))]));
end
poisson_prob = max( poisson_prob_at_bins)*(poisson_prob_continuous./max(poisson_prob_continuous));
plot(continuous_bins,poisson_prob,'-' ,'Color',[0.5 0.5 0.5])
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Probability')
title('Inhibitory connections','Color', [0 0 1]);
text(35,0.2,'Observed','Color',[0 0 1]);

%log scale
axes('position',[position_x1(3), position_y1(4), panel_width1, panel_height1]);
loglog((hist_bins_centers),(k_prob),'.-b');
hold on
%poisson
loglog(continuous_bins,poisson_prob,'-','Color',[0.5 0.5 0.5]);
xlabel(sprintf('Number of causal connections,\n out-degree')) 
ylabel('Probability')
k_prob(k_prob==0)=NaN;
% set(gca,'FontSize',12);
ylim([10^-3.2, 1]);
box off;
set(gca,'Xtick',[1,10,100], 'Ytick',[0.001, 0.01, 0.1, 1])
xlim([4 150]);

% set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
eval(['print ', figure_name_out, ' -dpdf -r200']);

