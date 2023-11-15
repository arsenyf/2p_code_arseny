function Sup_Fig_2_distance_dependence
close all;

PAPER_graphics_definition_Figure1

%% Tuning versus anatomical dtstance
key_distance.odd_even_corr_threshold=0.25;
rel_data_distance= (LICK2D.DistanceCorrPSTHSpikes *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
rel_data_shuffled_distance= (LICK2D.DistanceCorrPSTHSpikesShuffled *EXP2.SessionID & 'num_cells_included>=0') - IMG.Mesoscope;
D=fetch(rel_data_distance	 & key_distance,'*');
D_shuffled=fetch(rel_data_shuffled_distance	 & key_distance,'*');
bins_lateral_distance=D(1).lateral_distance_bins;
bins_lateral_center = bins_lateral_distance(1:end-1) + mean(diff(bins_lateral_distance))/2;
bins_axial_distance=D(1).axial_distance_bins;
bins_eucledian_distance=D(1).lateral_distance_bins;
bins_eucledian_center = bins_eucledian_distance(1:end-1) + mean(diff(bins_eucledian_distance))/2;

%lateral
distance_lateral_all = cell2mat({D.distance_corr_lateral}');
d_lateral_mean =  nanmean(distance_lateral_all,1);
d_lateral_stem =  nanstd(distance_lateral_all,1)/sqrt(size(D,1));
distance_lateral_all_shuffled = cell2mat({D_shuffled.distance_corr_lateral}');
d_lateral_mean_shuffled =  nanmean(distance_lateral_all_shuffled,1);
d_lateral_stem_shuffled =  nanstd(distance_lateral_all_shuffled,1)/sqrt(size(D_shuffled,1));

%axial
idx_column_radius=2; %10 to 30 microns
distance_axial_all=[];
distance_axial_all_shuffled=[];
for i_s=1:1:size(D,1)
    distance_axial_all(i_s,:) = D(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
    distance_axial_all_shuffled(i_s,:) = D_shuffled(i_s).distance_corr_axial_columns(:,idx_column_radius); %index 1 refers to the radius of the axial column we take
end
d_axial_mean1 =  nanmean(distance_axial_all,1);
d_axial_stem1 =  nanstd(distance_axial_all,1)/sqrt(size(D,1));
d_axial_mean1_shuffled =  nanmean(distance_axial_all_shuffled,1);
d_axial_stem_shuffled1 =  nanstd(distance_axial_all_shuffled,1)/sqrt(size(D_shuffled,1));

%eucledian
distance_eucledian_all = cell2mat({D.distance_corr_eucledian}');
d_eucledian_mean =  nanmean(distance_eucledian_all,1);
d_eucledian_stem =  nanstd(distance_eucledian_all,1)/sqrt(size(D,1));

distance_eucledian_all_shuffled = cell2mat({D_shuffled.distance_corr_eucledian}');
d_eucledian_mean_shuffled =  nanmean(distance_eucledian_all_shuffled,1);
d_eucledian_stem_shuffled =  nanstd(distance_eucledian_all_shuffled,1)/sqrt(size(D_shuffled,1));

%% Eucledian
axes('position',[position_x5(2)+0.0075-0.06,position_y5(2), panel_width5, panel_height5])
% all sessions

% shadedErrorBar(bins_lateral_center,d_lateral_mean_shuffled,d_lateral_stem_shuffled,'lineprops',{'.-','Color',[0 0 0]})
lineProps.col={[0.5 0.5  0.5 ]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean_shuffled,5)',smooth(d_eucledian_stem_shuffled,5)',lineProps);

lineProps.col={[1 0 1]};
lineProps.LineStyle{1}='-';
lineProps.width=0.25;
mseb(bins_eucledian_center,smooth(d_eucledian_mean,5)',smooth(d_eucledian_stem,5)',lineProps);
% yl = [0, 0.15];
yl = [0, 0.25];

xl = [0,500];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Eucledian' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '           {\it r}'], 'FontSize',6,'VerticalAlignment','middle','Rotation',90);
text(xl(1)+diff(xl)*0.0,yl(1)+diff(yl)*1.3,sprintf('Tuning similarity vs.\n anatomical distance'), 'FontSize',6,'HorizontalAlignment','left', 'fontweight', 'bold');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,250,500],'XTickLabel',[0,250, 500],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*1.35, 'o', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.15, 'Shuffled', 'fontsize', 6, 'fontname', 'helvetica','Color',[0.5 0.5 0.5]);
%  text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.75, 'Eucledian',  'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);

%  
%% Axial vs Lateral

axes('position',[position_x5(3)+0.0075-0.06,position_y5(2), panel_width5, panel_height5])
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_lateral_center,d_lateral_mean,d_lateral_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
mseb(bins_axial_distance,d_axial_mean1,d_axial_stem1,lineProps);
yl = [0.1, 0.25];
xl = [0,120];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5,['Axial/Lateral' newline 'Distance (\mum)'], 'FontSize',6,'HorizontalAlignment','center');
% text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.2,['Tuning corr.,' newline '      {\it r}'], 'FontSize',6,'VerticalAlignment','middle', 'fontweight', 'bold','Rotation',90);
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,60,120],'XTickLabel',[0,60, 120],'Ytick',[yl],'TickLength',[0.05,0], 'FontSize',6);
box off;
text(xl(1)+diff(xl)*0.05, yl(1)+diff(yl)*0.15, 'Lateral', 'fontsize', 6, 'fontname', 'helvetica','Color',[1 .25 .25]);
 text(xl(1)+diff(xl)*0.25, yl(1)+diff(yl)*0.95, 'Axial',  'fontsize', 6, 'fontname', 'helvetica','Color',[0.25 0.25 1]);
 
if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dpdf -r300']);
eval(['print ', figure_name_out, ' -dtiff  -r300']);
