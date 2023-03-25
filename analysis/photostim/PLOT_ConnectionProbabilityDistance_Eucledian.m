function PLOT_ConnectionProbabilityDistance_Eucledian()
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Photostim\Connectivity\'];
filename = 'Distance_Connection_probability_Eucledian';

clf;


DefaultFontSize =12;
% figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

% set(gcf,'DefaultAxesFontSize',6);



horizontal_dist=0.35;
vertical_dist=0.2;

panel_width1=0.2;
panel_height1=0.25;
position_x1(1)=0.2;
position_x1(end+1)=position_x1(end)+horizontal_dist;

position_y1(1)=0.5;
position_y1(end+1)=position_y1(end)-vertical_dist;

rel_data = (STIMANAL.InfluenceDistanceEucledian & 'flag_divide_by_std=0' & 'flag_withold_trials=1' & 'flag_normalize_by_total=1') ...
    &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=150' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25'));

key.num_svd_components_removed=0;
key.is_volumetric =1; % 1 volumetric, 1 single plane
% key.session_epoch_number=2;
flag_response= 1; %0 all, 1 excitation, 2 inhibition, 3 absolute
response_p_val=0.05;


key.neurons_or_control =1; % 1 neurons, 0 control sites
rel_neurons = rel_data & key & sprintf('response_p_val=%.3f',response_p_val);

rel_all = rel_data & key & sprintf('response_p_val=1');

rel_sessions_neurons= EXP2.SessionEpoch & rel_neurons; % only includes sessions with responsive neurons



%%  Neurons
D1=fetch(rel_neurons,'*');  % response p-value for inclusion. 1 means we take all pairs
D1_all=fetch(rel_all,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT1=fn_PLOT_ConnectionProbabilityDistance_averaging_Eucledian(D1,D1_all,flag_response);

%%  Control sites
key.neurons_or_control =0; % 1 neurons, 0 control sites
rel_control = rel_data & rel_sessions_neurons & key & sprintf('response_p_val=%.3f',response_p_val);
rel_control_all = rel_data & rel_sessions_neurons & key & sprintf('response_p_val=1');

D2=fetch(rel_control,'*');  % response p-value for inclusion. 1 means we take all pairs
D2_all=fetch(rel_control_all,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT2=fn_PLOT_ConnectionProbabilityDistance_averaging_Eucledian(D2,D2_all,flag_response);

%% Marginal distribution - lateral
axes('position',[position_x1(1), position_y1(1)+0.175, panel_width1, panel_height1*0.5]);
xl=[25,250];
hold on
% plot(xl, [0 0],'-k')
shadedErrorBar(OUT1.distance_eucledian_bins_centers(1:end),smooth(OUT1.marginal_eucledian_mean(1:end),7),smooth(OUT1.marginal_eucledian_stem(1:end),7),'lineprops',{'-','Color',[1 0 1]})
shadedErrorBar(OUT1.distance_eucledian_bins_centers(1:end),smooth(OUT2.marginal_eucledian_mean(1:end),7),smooth(OUT2.marginal_eucledian_stem(1:end),7),'lineprops',{'-','Color',[0.5 0.5 0.5]})
% yl(1)=-2*abs(min([OUT1.marginal_eucledian_mean,OUT2.marginal_eucledian_mean]));
% yl(2)=abs(max([OUT1.marginal_eucledian_mean,OUT2.marginal_eucledian_mean]));
yl(1)=0;
yl(2)=0.4;
ylim(yl)
set(gca,'XTick',[],'XLim',xl);
box off
% ylabel([sprintf('         Response\n') '        (z-score)']);
ylabel(sprintf('Connection \nProbability '));
set(gca,'YTick',[0,yl(2)],'XTick',[xl(1),100,xl(2)])


fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);
