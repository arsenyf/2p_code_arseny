function Figure3_v1_males
close all;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\revision\males_females\'];
dir_embeded_graphics=dir_current_fig;

DefaultFontSize =6;

% key_fov.subject_id = 463192;
% key_fov.session=1;
key_fov.subject_id = 496916;
key_fov.session=3;
epoch_list = fetchn(EXP2.SessionEpoch & 'session_epoch_type="spont_photo"' & key_fov, 'session_epoch_number','ORDER BY session_epoch_number');
key_fov.session_epoch_number = epoch_list(end); % to take the photostim groups from
key_fov.plane_num=1;

filename=[sprintf('Figure3_v1_males')];

PAPER_graphics_definition_Figure3






 %% FOV
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
text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.1, 'e', ...
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
    pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_x') / fetch1(IMG.FOV & key_fov, 'fov_x_size');
    %     pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_y') / fetch1(IMG.FOV & key_fov, 'fov_x_size');
catch
    pix2dist= fetch1(IMG.Parameters & 'parameter_name="fov_size_microns_z1.1"', 'parameter_value')/fetch1(IMG.FOV & key_fov, 'fov_x_size');
end
scalebar=100/pix2dist; %100 microns
plot([250,250+scalebar],[50,50],'-w','LineWidth',2)
text((200+scalebar)*1.25,50,['100 \mum'],'FontSize',6, 'fontweight', 'bold','Color',[1 1 1])


%% Connection probabily Eucledian


rel_data = (STIMANAL.InfluenceDistanceEucledian & 'flag_divide_by_std=0' & 'flag_withold_trials=1' & 'flag_normalize_by_total=1') ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs& IMG.Volumetric & 'stimpower>=150' & 'flag_include=1'  ...
     & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25')) & (LAB.Subject & 'sex="M"');

key.num_svd_components_removed=0;
key.is_volumetric =1; % 1 volumetric, 1 single plane
% key.session_epoch_number=2;
flag_response= 1; %0 all, 1 excitation, 2 inhibition, 3 absolute
response_p_val=0.05;


key.neurons_or_control =1; % 1 neurons, 0 control sites
rel_neurons = rel_data & key & sprintf('response_p_val=%.3f',response_p_val);

rel_all = rel_data & key & sprintf('response_p_val=1');

rel_sessions_neurons= EXP2.SessionEpoch & rel_neurons; % only includes sessions with responsive neurons

%  Neurons
D1=fetch(rel_neurons,'*');  % response p-value for inclusion. 1 means we take all pairs
D1_all=fetch(rel_all,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT1=fn_PLOT_ConnectionProbabilityDistance_averaging_Eucledian(D1,D1_all,flag_response);

% Control sites
key.neurons_or_control =0; % 1 neurons, 0 control sites
rel_control = rel_data & rel_sessions_neurons & key & sprintf('response_p_val=%.3f',response_p_val);
rel_control_all = rel_data & rel_sessions_neurons & key & sprintf('response_p_val=1');

D2=fetch(rel_control,'*');  % response p-value for inclusion. 1 means we take all pairs
D2_all=fetch(rel_control_all,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT2=fn_PLOT_ConnectionProbabilityDistance_averaging_Eucledian(D2,D2_all,flag_response);

%% Marginal distribution - Eucledian
axes('position',[position_x1(1), position_y1(1), panel_width1, panel_height1]);
xl=[25,250];
hold on
% plot(xl, [0 0],'-k')
shadedErrorBar(OUT1.distance_eucledian_bins_centers(1:end),smooth(OUT1.marginal_eucledian_mean(1:end),7),smooth(OUT1.marginal_eucledian_stem(1:end),7),'lineprops',{'-','Color',[1 0 1]})
shadedErrorBar(OUT1.distance_eucledian_bins_centers(1:end),smooth(OUT2.marginal_eucledian_mean(1:end),7),smooth(OUT2.marginal_eucledian_stem(1:end),7),'lineprops',{'-','Color',[0 0.75 0.75]})
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
% set(gca,'XTick',[25,100:100:500],'XLim',xl);
set(gca,'XTick',[25,100:100:500],'XLim',xl);
xlabel([sprintf('Eucledian Distance ') '(\mum)']);





%% Influence distance
rel_data = (STIMANAL.InfluenceDistance & 'flag_divide_by_std=0' & 'flag_withold_trials=0' & 'flag_normalize_by_total=1') ...
    &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower=150' & 'flag_include=1' )  ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25') ...
    & (STIMANAL.NeuronOrControlNumber & 'num_targets_controls>=25') & (LAB.Subject & 'sex="M"');;

key.num_svd_components_removed=0;
key.is_volumetric =1; % 1 volumetric, 1 single plane
distance_axial_bins=[0,60,90,120];
distance_axial_bins_plot=[0,30,60,90,120];
% key.session_epoch_number=2;
flag_response= 0 %0 all, 1 excitation, 2 inhibition, 3 absolute
response_p_val=1;


key.neurons_or_control =1; % 1 neurons, 0 control sites
rel_neurons = rel_data & key & sprintf('response_p_val=%.3f',response_p_val);
rel_sessions_neurons= EXP2.SessionEpoch & rel_neurons; % only includes sessions with responsive neurons



%% 2D plots - Neurons
ax1=axes('position',[position_x2(1), position_y2(2), panel_width2, panel_height2]);
D1=fetch(rel_neurons,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT1=fn_PLOT_CoupledResponseDistance_averaging(D1,distance_axial_bins,flag_response);

xl=[OUT1.distance_lateral_bins_centers(1),OUT1.distance_lateral_bins_centers(end)];
xl=[0,500];
yl=[0 120]
imagesc(OUT1.distance_lateral_bins_centers(1:end), distance_axial_bins_plot,  OUT1.map(:,1:end))
axis tight
axis equal
cmp = bluewhitered(512); %
colormap(ax1, cmp)
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
caxis([-0.01 max(max(OUT1.map(:,1:end)))]);
% set(gca,'XTick',OUT1.distance_lateral_bins_centers)
xlabel([sprintf('Lateral Distance ') '(\mum)']);
% ylabel([sprintf('Axial Distance ') '(\mum)']);
% colorbar
% set(gca,'YTick',[],'XTick',[20,100:100:500]);
set(gca,'YTick',[0 60 120],'XTick',[25,100:100:500]);
ylabel([sprintf('Axial      \nDistance ') '(\mum)        ']);
xlim(xl)
% title('Target neurons','Color',[1 0 1]);
text(xl(1)+diff(xl)*0.5,yl(2)+diff(yl)*1.5,sprintf('Target neurons'),'FontSize',6, 'fontweight', 'bold','Color',[1 0 1],'HorizontalAlignment','center')

%% 2D plots - Control Targets
key.neurons_or_control =0; % 1 neurons, 0 control sites
rel_control = rel_data & rel_sessions_neurons & key & sprintf('response_p_val=%.3f',response_p_val);
D2=fetch(rel_control ,'*');  % response p-value for inclusion. 1 means we take all pairs
OUT2=fn_PLOT_CoupledResponseDistance_averaging(D2,distance_axial_bins,flag_response);

ax10=axes('position',[position_x2(2)-0.07, position_y2(2), panel_width2, panel_height2]);
imagesc(OUT2.distance_lateral_bins_centers(1:end),  distance_axial_bins_plot, OUT2.map(:,1:end))
axis tight
axis equal
% cmp = bluewhitered(512); %
colormap(ax10, cmp)
caxis([-0.01 max(max(OUT1.map(:,1:end)))]);
% caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
xlabel([sprintf('Lateral Distance ') '(\mum)']);
% ylabel([sprintf('Axial Distance ') '(\mum)']);
set(gca,'YTick',[0 60 120],'YTickLabel',[],'XTick',[25,100:100:500]);
% ylabel([sprintf('Axial \nDistance\n ') '(\mum)']);
text(xl(1)+diff(xl)*0.5,yl(2)+diff(yl)*1.5,sprintf('Control targets'),'FontSize',6, 'fontweight', 'bold','Color',[0 0.75 0.75],'HorizontalAlignment','center')


%colorbar positive values
ax2=axes('position',[position_x2(2)+0.03, position_y2(2)+0.04, panel_width2*0.2, panel_height2*0.15]);
% imagesc(OUT1.distance_lateral_bins_centers, distance_axial_bins_plot,  OUT1.map)
cmp = bluewhitered(512); %
colormap(ax2, cmp)
caxis([OUT1.minv max(max(OUT1.map(:,1:end)))]);
ccc=colorbar;
set(ccc,'YTick',[0,1], 'YTickLabel',[0,1]);
% ccc.Location='SouthOutside';
text(6, -0.6, ['Connection' newline 'strength'],'Rotation',90);

% text(7, -3, ['Connection strength' newline '(\Delta z-score activity)'],'Rotation',90);
axis off

%colorbar negative values
ax3=axes('position',[position_x2(2)+0.03,10, panel_width2*0.2, panel_height2*0.35]);
OUT1.map(OUT1.map>=0)=0;
imagesc(OUT1.distance_lateral_bins_centers, distance_axial_bins_plot,  OUT1.map)
cmp = bluewhitered(512); %
%colorbar negative values
ax4=axes('position',[position_x2(2)+0.03, position_y2(2)+0.025, panel_width2*0.2, panel_height2*0.15]);
colormap(ax4, cmp)
% caxis([OUT1.minv 0]);
caxis([-0.01 0]);

ccc=colorbar;
set(ccc,'YTick',[-0.01,0], 'YTickLabel',[-0.01,0]);
% ccc.Location='SouthOutside';
% text(6, 0.1, ['Connection strength' newline '(\Delta z-score activity)'],'Rotation',0);
axis off




%% Marginal distribution - lateral
axes('position',[position_x2(1), position_y2(1), panel_width2, panel_height2*0.75]);
hold on
plot(xl, [0 0],'-k')
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT2.marginal_lateral_mean(1:end),OUT2.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[0 0.75 0.75]})
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT1.marginal_lateral_mean(1:end),OUT1.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[1 0 1]})
yl(1)=-0.05;
yl(2)=1.2;
ylim(yl)
% set(gca,'XTick',[25,100:100:500],'XLim',xl);
set(gca,'XTick',[25,100:100:500],'XTickLabel',[],'XLim',xl);

box off
% ylabel([sprintf('         Response\n') '        (z-score)']);
ylabel (['Connection strength' newline '(\Delta z-score activity)']);
set(gca,'YTick',[0,0.5,1]);
% xlabel([sprintf('Lateral Distance ') '(\mum)']);

%% Marginal distribution - lateral (zoom)
axes('position',[position_x2(1)+0.03, position_y2(1)+0.02, panel_width2*0.75, panel_height2*0.5]);
hold on
plot(xl, [0 0],'-k')
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT2.marginal_lateral_mean(1:end),OUT2.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[0 0.75 0.75]})
shadedErrorBar(OUT1.distance_lateral_bins_centers(1:end),OUT1.marginal_lateral_mean(1:end),OUT1.marginal_lateral_stem(1:end),'lineprops',{'-','Color',[1 0 1]})
yl=[-0.008 0.002];
ylim(yl)
set(gca,'XLim',xl);
box off
set(gca,'YTick',[-0.005  0 yl(2)],'XTick',[100 250 500],'XTickLabel',{'100' '     250' '500'},'TickLength',[0.05 0.05]);
text(200,0.005,'Target neurons','Color',[1 0 1]);
text(200,0.003,sprintf('Control targets'),'Color',[0 0.75 0.75]);




%% Marginal distribution - axial NEAR
axm=axes('position',[position_x2(2), position_y2(1)+0.03, panel_width2*0.4, panel_height2*0.4]);
hold on
plot([distance_axial_bins(1),distance_axial_bins(end)],[0 0],'-k')
shadedErrorBar(distance_axial_bins,OUT1.marginal_axial_in_column_mean,OUT1.marginal_axial_in_column_stem,'lineprops',{'.-','Color',[1 0 1]})
shadedErrorBar(distance_axial_bins,OUT2.marginal_axial_in_column_mean,OUT2.marginal_axial_in_column_stem,'lineprops',{'.-','Color',[0 0.75 0.75]})
axm.View = [90 90]
xlabel([sprintf('Axial \nDistance ') '(\mum)']);
ylabel (['          Connection strength '  '(\Delta z-score activity)']);
set(gca,'XTick',[0 60 120]);
title([sprintf('25< Lateral <=100            \n') '(\mum)'],'FontSize',6)

%% Marginal distribution - axial FAR
axm=axes('position',[position_x2(2)+0.07, position_y2(1)+0.03, panel_width2*0.4, panel_height2*0.4]);
hold on
% plot([distance_axial_bins(1),distance_axial_bins(end)],[0 0],'-k')
shadedErrorBar(distance_axial_bins,OUT1.marginal_axial_out_column_mean,OUT1.marginal_axial_out_column_stem,'lineprops',{'.-','Color',[1 0 1]})
shadedErrorBar(distance_axial_bins,OUT2.marginal_axial_out_column_mean,OUT2.marginal_axial_out_column_stem,'lineprops',{'.-','Color',[0 0.75 0.75]})
axm.View = [90 90]
% xlabel([sprintf('Axial Distance ') '(\mum)']);
set(gca,'XTick',[0 60 120],'XTickLabel',[],'YTickLabel',[-0.005,0]);
title([sprintf('            100< Lateral <=250\n ') '(\mum)'],'FontSize',6)

fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)


%% The following calculates the average number of neuron targets and control targets, over sessions:
% rel2= (STIMANAL.NeuronOrControlNumber & 'num_targets_neurons>=25' & 'num_targets_controls>=25') & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );
% D=fetch(rel2,'*')
% mean([D.num_targets_neurons])
% mean([D.num_targets_controls])
% 
% median([D.num_targets_neurons])
% median([D.num_targets_controls])
% 
% rel_inf=STIM.ROIInfluence2  & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (IMG.PhotostimGroup & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1'));
% % rel_inf=STIM.ROIInfluence2 ;% & (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1');
% 
% rel_inf.count()

% (IMG.ROI-IMG.ROIBad)& (STIMANAL.SessionEpochsIncludedFinal& IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' ) & (IMG.PhotostimGroup & (STIMANAL.NeuronOrControl  & 'neurons_or_control=1'))




if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);




