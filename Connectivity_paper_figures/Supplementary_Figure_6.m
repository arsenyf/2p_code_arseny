function Supplementary_Figure_6()
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
filename = 'Supplementary_Figure_6';

clf;
PAPER_graphics_definition_Figure3


DefaultFontSize =6;
% % figure
% set(gcf,'DefaultAxesFontName','helvetica');
% set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
% set(gcf,'PaperOrientation','portrait');
% set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
% set(gcf,'color',[1 1 1]);

% set(gcf,'DefaultAxesFontSize',6);


%% fov
panel_width1_fov=0.1;
panel_height1_fov=0.1;
position_x1_fov(1)=0.1;
position_y1_fov(1)=0.7;


horizontal_dist=0.25;
vertical_dist=0.06;

panel_width1=0.2;
panel_height1=0.035;
panel_width2=0.2;
panel_height2=0.1;
position_x1=[];
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist;

position_y1=[];
position_y1(1)=0.73;
position_y1(end+1)=position_y1(end)-0.07;
position_y1(end+1)=position_y1(end)-vertical_dist;
position_y1(end+1)=position_y1(end)-vertical_dist*1.1;


 %% FOV
% key_fov.subject_id = 463192;
% key_fov.session=1;
key_fov.subject_id = 496916;
key_fov.session=3;
epoch_list = fetchn(EXP2.SessionEpoch & 'session_epoch_type="spont_photo"' & key_fov, 'session_epoch_number','ORDER BY session_epoch_number');
key_fov.session_epoch_number = epoch_list(end); % to take the photostim groups from
key_fov.plane_num=1;


ax1=axes('position',[position_x1_fov(1),position_y1_fov(1), panel_width1_fov, panel_height1_fov]);
hold on
plane1=fetch1(IMG.Plane & key_fov ,'mean_img');
imagesc((plane1));
xl=[0,size(plane1,1)];
yl=[0,size(plane1,2)];
caxis([0 max(plane1(:))*0.4])
axis off;
axis tight;
axis equal;
colormap(ax1,gray)
text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.1, 'a', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.05,yl(1)+diff(yl)*1.1,sprintf('Photostimulation targets'),'FontSize',6, 'fontweight', 'bold')
text(xl(1)+diff(xl)*0.05,yl(1)-diff(yl)*0.05,sprintf('Target neurons'), 'FontSize',6,'HorizontalAlignment','left','Color',[1 0 1]);
text(xl(1)+diff(xl)*0.05,yl(1)-diff(yl)*0.15,sprintf('Control targets'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0.75 0.75]);

% G=fetch(IMG.PhotostimGroupROI & key  & 'flag_neuron_or_control=1' & 'distance_to_closest_neuron<15','*');
rel_neurons=IMG.PhotostimGroupROI & key_fov & ( STIMANAL.NeuronOrControl & 'neurons_or_control=1');
G_neurons=fetch(rel_neurons,'*');

rel_controls=IMG.PhotostimGroupROI & key_fov & ( STIMANAL.NeuronOrControlLessStrict & 'neurons_or_control=0');
G_controls=fetch(rel_controls,'*');

% R=fetch((IMG.ROI) & key_fov & IMG.ROIGood,'*');
% for i_f=1:1:numel(R)
%     x=R(i_f).roi_centroid_x;
%     y=R(i_f).roi_centroid_y;
% %     plot(x,y,'ok','MarkerSize',1)
% end
for i_f=1:1:numel(G_neurons)
    x=G_neurons(i_f).photostim_center_x;
    y=G_neurons(i_f).photostim_center_y;
    plot(x,y,'.','MarkerSize',3,'Color',[1 0 1])
end
for i_f=1:1:numel(G_controls)
    x=G_controls(i_f).photostim_center_x;
    y=G_controls(i_f).photostim_center_y;
    plot(x,y,'.','MarkerSize',3,'Color',[0 0.75 0.75])
end

axis off;
axis tight;
axis equal;

%scale bar
try
    zoom =fetch1(IMG.FOVEpoch & key_fov,'zoom');
    kkk.scanimage_zoom = zoom;
    pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_y') / fetch1(IMG.FOV & key_fov, 'fov_x_size');
catch
    pix2dist= fetch1(IMG.Parameters & 'parameter_name="fov_size_microns_z1.1"', 'parameter_value')/fetch1(IMG.FOV & key_fov, 'fov_x_size');
end
scalebar=100/pix2dist; %100 microns
plot([250,250+scalebar],[50,50],'-w','LineWidth',2)
text((200+scalebar)*1.25,50,['100 \mum'],'FontSize',6, 'fontweight', 'bold','Color',[1 1 1])

%% Control target distribution
axes('position',[position_x1(1)+0.02, position_y1(2)-0.1, panel_width2/2, panel_height2]);
hold on
rel=STIMANAL.ControlTargetsIntermingled &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25'));
distance_to_closest_responsive_target=fetchn(STIMANAL.ControlTargetsIntermingled,'distance_to_closest_responsive_target');
h=histogram(distance_to_closest_responsive_target);
set(h,'FaceColor',[0 0.75 0.75])
xlabel([sprintf('Lateral distance of control target from \n nearest neural target '), '(\mum)'])
ylabel('Counts')
set(gca, 'FontSize', 10)
xlim([0,400])


%% Connectivity

rel_data = (STIMANAL.InfluenceDistance & 'flag_divide_by_std=0' & 'flag_withold_trials=1' & 'flag_normalize_by_total=1') ...
    &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25'));


rel_data_control_intermingled = (STIMANAL.InfluenceDistanceIngermingledControl & 'flag_divide_by_std=0' & 'flag_withold_trials=1' & 'flag_normalize_by_total=1') ...
    &  (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25'));


key.num_svd_components_removed=0;
key.is_volumetric =1; % 1 volumetric, 1 single plane
distance_axial_bins=[0,60,90,120];
distance_axial_bins_plot=[0,30,60,90,120];
% key.session_epoch_number=2;
flag_response= 1; %0 all, 1 excitation, 2 inhibition, 3 absolute
response_p_val=0.05;


key.neurons_or_control =1; % 1 neurons, 0 control sites
rel_neurons = rel_data & key & sprintf('response_p_val=%.3f',response_p_val);

rel_all = rel_data & key & sprintf('response_p_val=1');

rel_sessions_neurons= EXP2.SessionEpoch & rel_neurons; % only includes sessions with responsive neurons



%% 2D plots - Neurons
ax1=axes('position',[position_x1(2), position_y1(2), panel_width1, panel_height1]);
D1=fetch(rel_neurons,'*');  % response p-value for inclusion. 1 means we take all pairs
D1_all=fetch(rel_all,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT1=fn_PLOT_ConnectionProbabilityDistance_averaging(D1,D1_all,distance_axial_bins,flag_response);

xl=[OUT1.distance_lateral_bins_centers(1),OUT1.distance_lateral_bins_centers(end)];
xl=[0,200];
imagesc(OUT1.distance_lateral_bins_centers(1:end), distance_axial_bins_plot,  OUT1.map(:,1:end))
axis tight
% axis equal
cmp = bluewhitered(2048); %
colormap(ax1, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
caxis([0 1]);
% set(gca,'XTick',OUT1.distance_lateral_bins_centers)
% xlabel([sprintf('Lateral Distance ') '(\mum)']);
% ylabel([sprintf('Axial Distance ') '(\mum)']);
% colorbar
% set(gca,'YTick',[],'XTick',[20,100:100:500]);
set(gca,'YTick',[0 60 120],'XTick',[25,100:100:500]);
ylabel([sprintf('Axial      \nDistance ') '(\mum)        ']);
xlim(xl)
title('Target neurons','Color',[1 0 1])

ax2=axes('position',[position_x1(2)+0.2, position_y1(2), panel_width2/5, panel_height2/4]);
cmp = bluewhitered(512); %
colormap(ax2, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
caxis([0 1]);

colorbar
axis off
text(5, +0.2, sprintf('\n\nConnection \n Probability'),'Rotation',90);



%% 2D plots - Control sites  -- all distances
key_control.distance_to_closest_responsive_target =5000; %relevant for control sites only
rel_control_intermingled = rel_data_control_intermingled & rel_sessions_neurons & key & sprintf('response_p_val=%.3f',response_p_val) & key_control;
rel_control_all_intermingled = rel_data_control_intermingled & rel_sessions_neurons & key & sprintf('response_p_val=1')  & key_control;

D2=fetch(rel_control_intermingled,'*');  % response p-value for inclusion. 1 means we take all pairs
D2_all=fetch(rel_control_all_intermingled,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT2=fn_PLOT_ConnectionProbabilityDistance_averaging(D2,D2_all,distance_axial_bins,flag_response);

ax3=axes('position',[position_x1(2), position_y1(3), panel_width1, panel_height1]);
imagesc(OUT2.distance_lateral_bins_centers,  distance_axial_bins_plot, OUT2.map)
xl=[0,200];
axis tight
% axis equal
cmp = bluewhitered(2048); %
colormap(ax3, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
caxis([0 1]);
% set(gca,'XTick',OUT1.distance_lateral_bins_centers)
% xlabel([sprintf('Lateral Distance ') '(\mum)']);
% ylabel([sprintf('Axial Distance ') '(\mum)']);
% colorbar
% set(gca,'YTick',[],'XTick',[20,100:100:500]);
set(gca,'YTick',[0 60 120],'XTick',[25,100:100:500]);
ylabel([sprintf('Axial      \nDistance ') '(\mum)        ']);
xlim(xl)
title('Control targets, all','Color',[0 0.75 0.75])
% 
% ax4=axes('position',[position_x1(1)+0.2, position_y1(2)+0.09, panel_width1/5, panel_height1/4]);
% cmp = bluewhitered(512); %
% colormap(ax4, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
% colorbar
% axis off
% text(8, 0.1, sprintf('\n\nConnection \n Probability'),'Rotation',90);



%% 2D plots - Control sites  -- at short distances
key_control.distance_to_closest_responsive_target =25; %relevant for control sites only
rel_control_intermingled = rel_data_control_intermingled & rel_sessions_neurons & key & sprintf('response_p_val=%.3f',response_p_val) & key_control;
rel_control_all_intermingled = rel_data_control_intermingled & rel_sessions_neurons & key & sprintf('response_p_val=1')  & key_control;

D3=fetch(rel_control_intermingled,'*');  % response p-value for inclusion. 1 means we take all pairs
D3_all=fetch(rel_control_all_intermingled,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT3=fn_PLOT_ConnectionProbabilityDistance_averaging(D3,D3_all,distance_axial_bins,flag_response);

ax3=axes('position',[position_x1(2), position_y1(4), panel_width1, panel_height1]);
imagesc(OUT3.distance_lateral_bins_centers,  distance_axial_bins_plot, OUT3.map)
xl=[0,200];
axis tight
% axis equal
cmp = bluewhitered(2048); %
colormap(ax3, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
caxis([0 1]);
% set(gca,'XTick',OUT1.distance_lateral_bins_centers)
xlabel([sprintf('Lateral Distance ') '(\mum)']);
% ylabel([sprintf('Axial Distance ') '(\mum)']);
% colorbar
% set(gca,'YTick',[],'XTick',[20,100:100:500]);
set(gca,'YTick',[0 60 120],'XTick',[25,100:100:500]);
ylabel([sprintf('Axial      \nDistance ') '(\mum)        ']);
xlim(xl)

title([sprintf('Control targets, within <25 ') '\mum' newline 'from target neurons'],'Color',[0 0 0.75])

% ax4=axes('position',[position_x1(1)+0.2, position_y1(3)+0.09, panel_width1/5, panel_height1/4]);
% cmp = bluewhitered(512); %
% colormap(ax4, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
% colorbar
% axis off
% text(8, 0.1, sprintf('\n\nConnection \n Probability'),'Rotation',90);


%% Marginal distribution - lateral
axes('position',[position_x1(2), position_y1(1), panel_width2, panel_height2*0.7]);
hold on
% plot(xl, [0 0],'-k')
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT1.marginal_lateral_mean(1:end),OUT1.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[1 0 1]})
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT2.marginal_lateral_mean(1:end),OUT2.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[0 0.75 0.75]})
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT3.marginal_lateral_mean(1:end),OUT3.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[0 0 0.75]})

% yl(1)=-2*abs(min([OUT1.marginal_lateral_mean,OUT2.marginal_lateral_mean]));
% yl(2)=abs(max([OUT1.marginal_lateral_mean,OUT2.marginal_lateral_mean]));
yl(1)=0;
yl(2)=0.6;
ylim(yl)
set(gca,'XTick',[],'XLim',xl);
set(gca,'XTick',[25,100:100:400],'XLim',xl);
xlabel([sprintf('Lateral Distance ') '(\mum)']);
box off
% ylabel([sprintf('         Response\n') '        (z-score)']);
ylabel(sprintf('Connection \nProbability '));
set(gca,'YTick',[0,0.1,0.5]);

text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.8,sprintf('Target neurons'),'FontSize',6,'HorizontalAlignment','left','Color',[1 0 1])
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.6,sprintf('Control targets, all'), 'FontSize',6,'HorizontalAlignment','left','Color',[0 0.75 0.75]);
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.3,[sprintf('Control targets, within <25 ') '\mum' newline 'from target neurons'], 'FontSize',6,'HorizontalAlignment','left','Color',[0 0 0.75]);
xlim([0,200])


fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r300']);
eval(['print ', figure_name_out, ' -dpdf -r300']);

