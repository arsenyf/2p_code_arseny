%% Plotting Stats
%--------------------------------

%% PSTH of all cells
ax5=axes('position',[position_x2(4),position_y22(1), panel_width3, panel_height3]);
PSTH_all = PSTH_all./max(PSTH_all,[],2);
[~,idx_max_time] = max(PSTH_all,[],2);
peaktime_psth=psth_time(idx_max_time)';

[~, idx_neurons_sorted] = sort(idx_max_time);
imagesc(psth_time,[],PSTH_all(idx_neurons_sorted,:))
colormap(ax5,inferno)
xl = [floor(psth_time(1)) ceil(psth_time(end))];
yl =[0 numel(idx_neurons_sorted)];
text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.5, sprintf('Time to 1st \ncontact-lick (s)'), 'FontSize',6,'HorizontalAlignment','Center');
text(-2.5,numel(idx_neurons_sorted),sprintf('Neurons'),'Rotation',90, 'FontSize',6);
set(gca,'XTick',[0,5],'Ytick',[],'TickLength',[0.05,0], 'FontSize',6);
% set(gca,'XTick',[0,xl(end)],'Ytick',[1, 100000],'YtickLabel',[{'1', '100,000'}],'TickLength',[0.05,0], 'FontSize',6);

%colorbar
ax8=axes('position',[position_x2(5),position_y22(1), panel_width3, panel_height3]);
colormap(ax8,inferno)
cb1 = colorbar();
axis off
set(cb1,'Ticks',[0, 1], 'FontSize',6);
text(5,0.5,sprintf('Activity (norm.)'),'Rotation',90, 'FontSize',6,'HorizontalAlignment','Center');
set(gca, 'FontSize',6);

%% Preferred time all PSTHs
axes('position',[position_x2(4),position_y22(1)+0.04, panel_width3, panel_height3*0.5])
% h=histogram(psth_time(idx_max_time),10,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
[hhh1,edges]=histcounts(peaktime_psth,linspace(-1,6,15));
hhh1=100*hhh1/sum(hhh1);
bar(edges(1:end-1),hhh1,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh1)];
yl(2)=20;
xl = [floor(psth_time(1)) ceil(psth_time(end))];
text(xl(1)-diff(xl)*0.3,yl(1)-diff(yl)*0.5,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl);
set(gca,'XTick',[],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off;
title(sprintf('Temporal tuning\n%d cells',numel(peaktime_psth)), 'FontSize',6);
text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.75, 'g', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

%% What percentage of temporally tuned neurons are positiionally tuned in -- binned according to preferred temporal bin
axes('position',[position_x4(2)+0.02,position_y4(2), panel_width4, panel_height4])
hold on
time_bin_size=0.5;
time_bins1 = floor(psth_time(1)):time_bin_size:ceil(psth_time(end));
time_bins=time_bins1(1):time_bin_size:time_bins1(end);
try
    idx_positional =[D_tuned_temporal.lickmap_regular_odd_vs_even_corr>=lickmap_regular_odd_vs_even_corr_threshold];
catch
    idx_positional =[D_tuned_temporal.information_per_spike_regular>=information_per_spike_regular_threshold];
end
tuned_in_time_bins=[];
for ib = 1:1:numel(time_bins)-1
    idx_time_bin = peaktime_psth>=time_bins(ib) & peaktime_psth<time_bins(ib+1);
    % percentage tuned in each time bin
    if (100*sum(idx_time_bin)/numel(idx_time_bin))>1 % if there are less than 1% of total cells in the bin we set it to NaN, to avoid spurious values
        tuned_in_time_bins(ib) =100*sum(idx_time_bin & idx_positional)/sum(idx_time_bin);
    else
        tuned_in_time_bins(ib)=NaN;
    end
end
% yyaxis right

time_bins=time_bins1(1):time_bin_size:time_bins1(end);
time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
% plot(time_bins_centers,tuned_in_time_bins,'.-','LineWidth',1,'MarkerSize',5,'Color',[0 0 0])
bar(time_bins_centers,tuned_in_time_bins,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
% xlabel(sprintf('Response time of neurons\n relative to first lickport contact (s)'));
xl=[time_bins(1),time_bins(end)];
xlim(xl);
% yl=[0 ceil(max(tuned_in_time_bins))];
yl=[0 70];

ylim(yl);
text(xl(1)-diff(xl)*0.4,yl(1)-diff(yl)*0.3, sprintf('Location neurons\n              (%%)'), 'FontSize',6,'HorizontalAlignment','left','Rotation',90);
text(xl(1)-diff(xl)*0.1,yl(1)+diff(yl)*1.3,sprintf('Peak \nresponse-time',numel(peaktime_psth)),'HorizontalAlignment','left', 'FontSize',6,'FontWeight','bold');
text(xl(1)+diff(xl)*0,yl(1)-diff(yl)*0.5,sprintf('Time to 1st \ncontact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
set(gca,'Xtick',[0,5],'TickLength',[0.05,0.05],'TickDir','out');
box off
set(gca,'XTick',[0,5],'Ytick',[yl(1), yl(2)],'TickLength',[0.05,0], 'FontSize',6);
text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.35, 'n', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
shuffle_value=100*sum(idx_positional)/numel(idx_positional);
plot([time_bins_centers(1),time_bins_centers(end)],[shuffle_value shuffle_value],'-','LineWidth',1,'MarkerSize',5,'Color',[0.5 0.5 0.5])
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*0.85,sprintf('Expected'),'HorizontalAlignment','left', 'FontSize',6,'Color',[0.5 0.5 0.5]);

%% Number of fields
axes('position',[position_x4(1),position_y4(1), panel_width4, panel_height4])
[hhh2,edges]=histcounts([D_tuned_positional_4bins.number_of_fields_without_baseline_regular],[1,2,3,4,5]);
hhh2=100*hhh2/sum(hhh2);
bar(edges(1:end-1),hhh2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh2)];
yl(2)=60;
xl = [0.5,4.5];
text(xl(1)+diff(xl)*0.25,yl(1)-diff(yl)*0.4,sprintf('Number of peaks'), 'FontSize',6,'HorizontalAlignment','center');
text(xl(1)+diff(xl)*0.75,yl(1)+diff(yl)*1.4,sprintf('Location tuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[1,2,3,4],'Ytick',[0, yl(2)],'TickLength',[0.01,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.8, yl(1)+diff(yl)*1.5, 'j', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Field size
axes('position',[position_x4(2),position_y4(1), panel_width4, panel_height4])
[hhh2,edges]=histcounts([D_tuned_positional_4bins.field_size_without_baseline_regular],linspace(0,100,10));
% [hhh2,edges]=histcounts([D_tuned_positional.field_size_without_baseline_regular],linspace(0,100,10));
hhh2=100*hhh2/sum(hhh2);
bar(edges(1:end-1),hhh2,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh2)];
yl(2)=30;
xl = [0,100];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.4,sprintf('Peak width (%%)'), 'FontSize',6,'HorizontalAlignment','center');
%             text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Positional \ntuning'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[0,100],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
%             text(xl(1)-diff(xl)*0.5, yl(1)+diff(yl)*1.5, 'j', ...
%                 'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');



%% Preferred positions
ax10=axes('position',[position_x4(3)-0.06,position_y4(1), panel_width4*0.8, panel_height4*0.8]);
bin_mat_coordinate_hor= repmat([1:1:4],4,1);
bin_mat_coordinate_ver= repmat([1:1:4]',1,4);
[preferred_bin_mat] = histcounts2(bin_mat_coordinate_ver([D_tuned_positional_4bins.preferred_bin_regular]),bin_mat_coordinate_hor([D_tuned_positional_4bins.preferred_bin_regular]),[1:1:4+1],[1:1:4+1]);
preferred_bin_mat=100*preferred_bin_mat./sum(preferred_bin_mat(:));
mmm=imagesc([-1,0,1],[-1,0,1],preferred_bin_mat);
yl=[0, max(20,ceil(nanmax(preferred_bin_mat(:))))];
caxis(yl)
colormap(ax10,jet2);
text(0.5,3.2,sprintf('Peak\nlocations'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
axis equal
axis tight
set(gca,'YDir','normal', 'FontSize',6);
axis off
text(-2.5, 4.5, 'k', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
%colorbar
ax11=axes('position',[position_x4(3)+0.055-0.09,position_y4(1), panel_width4*0.8, panel_height4*0.8]);
caxis(yl)
colormap(ax11,jet2)
cb2 = colorbar;
axis off
set(cb2,'Ticks',[yl],'TickLabels',[yl], 'FontSize',6);
text(0.5,-0.2,sprintf('Location neurons (%%)'), 'FontSize',6,'HorizontalAlignment','center');
set(gca, 'FontSize',6);


%% Temporal tuning similarity,\nacross positions
axes('position',[position_x4(1),position_y4(2), panel_width4, panel_height4])
[hhh3,edges]=histcounts([D_tuned_temporal_and_positional.psth_corr_across_position_regular],linspace(-1,1,15));
hhh3=100*hhh3/sum(hhh3);
bar(edges(1:end-1),hhh3,'FaceColor',[0 0 0],'EdgeColor',[0 0 0])
yl = [0, max(hhh3)];
yl(2)=25;
xl = [-1,1];
text(xl(1)+diff(xl)*0.5,yl(1)-diff(yl)*0.5, [sprintf('Tuning corr.,') '{\it r}'  newline 'across locations'], 'FontSize',6,'HorizontalAlignment','center')
text(xl(1)+diff(xl)*0.5,yl(1)+diff(yl)*1.3,sprintf('Temporal tuning\nsimilarity'), 'FontSize',6,'HorizontalAlignment','center', 'fontweight', 'bold');
text(xl(1)-diff(xl)*0.25,yl(1)+diff(yl)*0,sprintf('Percentage'),'Rotation',90, 'FontSize',6,'VerticalAlignment','bottom');
xlim(xl);
ylim(yl)
set(gca,'XTick',[-1,0,1],'Ytick',[0, yl(2)],'TickLength',[0.05,0], 'FontSize',6);
box off
text(xl(1)-diff(xl)*0.9, yl(1)+diff(yl)*1.35, 'm', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


%% Venn diagram
axes('position',[position_x4(3)+0.03,position_y4(1)-0.013, panel_width4*1.5, panel_height4*1.25])
count_total=numel([D_all.psth_corr_across_position_regular]);

A1=numel([D_tuned_temporal.psth_corr_across_position_regular]);
A2=numel([D_tuned_positional.psth_corr_across_position_regular]);
I1=numel([D_tuned_temporal_and_positional.lickmap_regular_odd_vs_even_corr]);

A = [A1 A2]; I = I1;
[h,v]=venn(A,I,'FaceColor',{[0 0 1],[1 0 0]});

%by itself plots circles with total areas A, and intersection area(s) I. 
% A is a three element vector [c1 c2 c3], and I is a four element vector [i12 i13 i23 i123], specifiying the two-circle intersection areas i12, i13, i23, and the three-circle intersection i123.
% for i_v=1:1:3%numel(v.ZonePop)
% text(v.ZoneCentroid(i_v,1)-v.ZoneCentroid(i_v,1)*0.0,v.ZoneCentroid(i_v,2),sprintf('%.1f%%',(100*v.ZonePop(i_v)/count_total)),'Color',[1 1 1],'FontSize',6,'HorizontalAlignment','left');
% % text(v.ZoneCentroid(i_v,1)-v.ZoneCentroid(i_v,1)*0.0,v.ZoneCentroid(i_v,2),sprintf('%.1f%%',(100*v.CirclePop(i_v)/count_total)),'Color',[1 1 1],'FontSize',6,'HorizontalAlignment','left');
% end
text(v.ZoneCentroid(1,1)*2.7,v.ZoneCentroid(1,2),sprintf('%.1f\n  %%',(100*v.ZonePop(1)/count_total)),'Color',[0 0 0],'FontSize',6,'HorizontalAlignment','left');
text(v.ZoneCentroid(2,1)*1.3,v.ZoneCentroid(1,2),sprintf('%.1f\n  %%',(100*v.ZonePop(2)/count_total)),'Color',[0 0 0],'FontSize',6,'HorizontalAlignment','left');
text(v.ZoneCentroid(3,1)*0.5,v.ZoneCentroid(1,2),sprintf('%.1f\n  %%',(100*v.ZonePop(3)/count_total)),'Color',[0 0 0],'FontSize',6,'HorizontalAlignment','left');

axis off
box off
ff=gca;
xl=ff.XLim;
yl=ff.YLim;
text(v.Position(1,1)-v.Radius(1)*0.2,v.Position(1,2)+v.Radius(1)*1.3,sprintf('Temporal tuning'),'Color',[0 0 1],'FontSize',6,'HorizontalAlignment','Center');
text(v.Position(2,1)-v.Radius(1)*0.2,v.Position(2,2)-v.Radius(2)*1.65,sprintf('Location tuning'),'Color',[1 0 0],'FontSize',6,'HorizontalAlignment','Center');

text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.3, sprintf('%d cells',count_total), 'fontsize', 6, 'fontname', 'helvetica', 'fontweight', 'bold','HorizontalAlignment','Center');

text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.4, 'l', ...
    'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

