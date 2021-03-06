function PLOT_Network_Degree_vs_tuning_new()
clf

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Photostim\Connectivity\'];
filename = 'network_degree_vs_tuning_new';

k_degree.max_distance_lateral =150;
k_degree.session_epoch_number=2;
k_degree.num_svd_components_removed=0;
k_degree.p_val = 0.05;
k_neurons_or_control.neurons_or_control=1;

k_corr_local.radius_size=100;
k_corr_local.session_epoch_type = 'behav_only'; % behav_only spont_only
k_corr_local.num_svd_components_removed=0;
rel_session = EXP2.Session & (STIMANAL.OutDegree & IMG.Volumetric) & (EXP2.SessionEpoch& 'session_epoch_type="spont_only"') ...
       &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower=100' & 'flag_include=1')  ...
     & (STIMANAL.NeuronOrControlNumber2 & 'num_targets_neurons>=25') ;
 
%Graphics
%---------------------------------

set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
left_color=[0 0 0];
right_color=[0 0 0];
set(gcf,'defaultAxesColorOrder',[left_color; right_color]);


horizontal_dist=0.25;
vertical_dist=0.2;

panel_width1=0.15;
panel_height1=0.15;

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

for i_s = 1:1:rel_session.count
    
    k_s = sessions(i_s);
    rel_degree = STIMANAL.OutDegree*STIM.ROIResponseDirect2  & (STIMANAL.NeuronOrControl2 & k_neurons_or_control) & k_degree & k_s;
    k_s;
    DATA_DEGREE = struct2table(fetch(rel_degree, '*'));
    %    numel(unique(DATA_DEGREE.roi_number))
    
    key_epoch = fetch(EXP2.SessionEpoch & k_s & k_corr_local);
    rel_signal1 = LICK2D.ROILick2DangleSpikes  & k_s & key_epoch;
%     rel_signal2 = LICK2D.ROILick2DRewardStatsSpikes  & k_s & key_epoch;
    rel_signal3 = LICK2D.ROILick2DPSTHStatsSpikes & k_s & key_epoch;
%     rel_signal3 = LICK2D.ROILick2DQuadrantsSpikes & k_s & key_epoch;
    rel_corr_local = POP.ROICorrLocalPhoto2  & k_s & k_corr_local & key_epoch;
    
    max_degree_session_excit(i_s)=max([DATA_DEGREE.out_degree_excitatory]);
    mean_degree_session_excit(i_s)=mean([DATA_DEGREE.out_degree_excitatory]);
    
    max_degree_session_inhibit(i_s)=max([DATA_DEGREE.out_degree_inhibitory]);
    mean_degree_session_inhibit(i_s)=mean([DATA_DEGREE.out_degree_inhibitory]);
    
    
%         if max_degree_session_excit(i_s)<30
%             continue
%         end
    
    if rel_corr_local.count==0
        continue
    end
    rel_corr_local =  rel_corr_local& key_epoch(1);
    
    
    DATA_SIGNAL1 = struct2table(fetch(rel_signal1, 'goodness_of_fit_vmises'));
%     DATA_SIGNAL2 = struct2table(fetch(rel_signal2, 'reward_mean_pval_regular_large'));
    DATA_SIGNAL3 = struct2table(fetch(rel_signal3, '*'));


    DATA_CORR = struct2table(fetch(rel_corr_local, '*'));
    
    
    idx=[];
    for i_r=1:1:size(DATA_DEGREE,1)
        idx(i_r) = find(DATA_CORR.roi_number == DATA_DEGREE.roi_number(i_r));
    end
    DATA_CORR_ALL =[DATA_CORR_ALL; DATA_CORR(idx,:)];
    DATA_DEGREE_ALL =[DATA_DEGREE_ALL; DATA_DEGREE];
    
    DATA_SIGNAL_ALL1 =[DATA_SIGNAL_ALL1; DATA_SIGNAL1(idx,:)];
%     DATA_SIGNAL_ALL2 =[DATA_SIGNAL_ALL2; DATA_SIGNAL2(idx,:)];
    DATA_SIGNAL_ALL3 =[DATA_SIGNAL_ALL3; DATA_SIGNAL3(idx,:)];

end

num_neurons_in_radius = DATA_CORR_ALL.num_neurons_in_radius_without_inner_ring;

% if flag_response==0
%     out_degree = DATA_DEGREE_ALL.out_degree_all1;
% elseif flag_response==1
%     out_degree = DATA_DEGREE_ALL.out_degree_excitatory;
% elseif flag_response==2
%     out_degree = DATA_DEGREE_ALL.out_degree_inhibitory;
% end

% out_degree=(out_degree./num_neurons_in_radius)*mean(num_neurons_in_radius);

signal1 = DATA_SIGNAL_ALL1.goodness_of_fit_vmises;
% signal2 = DATA_SIGNAL_ALL2.reward_mean_pval_regular_large;
% signal3 = DATA_SIGNAL_ALL3.psth_quadrants_odd_even_corr;
signal3 = DATA_SIGNAL_ALL3.psth_odd_even_corr;

out_degree_excitatory = DATA_DEGREE_ALL.out_degree_excitatory;
out_degree_inhibitory= DATA_DEGREE_ALL.out_degree_inhibitory;

out_degree_excitatory = (out_degree_excitatory./num_neurons_in_radius)*mean(num_neurons_in_radius);
out_degree_inhibitory= (out_degree_inhibitory./num_neurons_in_radius)*mean(num_neurons_in_radius);




%% Connectivity vs Directional tuning
ax1=axes('position',[position_x1(1), position_y1(1), panel_width1, panel_height1]);
hold on
% excitatory
k =out_degree_excitatory;
hist_bins = prctile(k,linspace(0,100,8));
hist_bins_centers = hist_bins(1:end-1) + diff(hist_bins)/2;
x=k;
y=signal1;
[y_binned_mean, y_binned_stem]= fn_bin_data(x,y,hist_bins);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0 0 1]})
xlabel('Effective Connections')
ylabel(sprintf('Tuning to target direction\n'));
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
box off;
% text(15,0.01,'Inhibitory','Color',[0 0 1]);
% text(15,0.03,'Excitatory','Color',[1 0 0]);



%% Connectivity vs Temporal tuning
ax1=axes('position',[position_x1(2), position_y1(1), panel_width1, panel_height1]);
hold on
% excitatory
k =out_degree_excitatory;
hist_bins = prctile(k,linspace(0,100,7));
hist_bins_centers = hist_bins(1:end-1) + diff(hist_bins)/2;
x=k;
y=signal3;
[y_binned_mean, y_binned_stem]= fn_bin_data(x,y,hist_bins);
shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[0.25 0.75 0.25]})
xlabel('Effective Connections')
ylabel(sprintf('Tuning to response time \nand target direction\n'));
ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
box off;
% text(15,0.01,'Inhibitory','Color',[0 0 1]);
% text(15,0.03,'Excitatory','Color',[1 0 0]);

% %% Local correlations
% ax1=axes('position',[position_x1(1), position_y1(2), panel_width1, panel_height1]);
% hold on
% % excitatory
% k =out_degree_excitatory;
% hist_bins = prctile(k,linspace(0,100,12));
% hist_bins_centers = hist_bins(1:end-1) + diff(hist_bins)/2;
% x=k;
% y=-log10(signal2);
% [y_binned_mean, y_binned_stem]= fn_bin_data(x,y,hist_bins);
% shadedErrorBar(hist_bins_centers,y_binned_mean,y_binned_stem,'lineprops',{'.-','Color',[1 0 0]})
% xlabel('Effective Connections')
% ylabel('Reward tuning')
% ylim([min(y_binned_mean-y_binned_stem),max(y_binned_mean+y_binned_stem)])
% box off;
% % text(15,0.01,'Inhibitory','Color',[0 0 1]);
% % text(15,0.03,'Excitatory','Color',[1 0 0]);

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);

