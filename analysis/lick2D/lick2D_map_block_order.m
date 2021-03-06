function lick2D_map_block_order()
close all;
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value'); 

flag_all_or_signif=1;  % 1 all cells, 2 signif cells in 2D lick maps, 3 signf cells in PSTH motor responses

key.subject_id = 463195;
key.session =3;


% key.subject_id = 445873;
% key.session =5;

% key.subject_id = 447990;
% key.session =8;

% key.session_epoch_number = 1;
key.number_of_bins=4;
% key.fr_interval_start=-1000;
% key.fr_interval_end=0;
key.fr_interval_start=0;
key.fr_interval_end=2000;
session_date = fetch1(EXP2.Session & key,'session_date');

if flag_all_or_signif ==1
    dir_current_fig = [dir_base  '\Lick2D\anm' num2str(key.subject_id) '\' session_date '\cells_all\' ];
    rel= ANLI.ROILick2DmapBlock * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTHBlock & IMG.ROIGood & key;
elseif flag_all_or_signif ==2
    dir_current_fig = [dir_base  '\Lick2D\anm' num2str(key.subject_id) '\' session_date '\cells_signif_2Dlick\'];
    rel= (ANLI.ROILick2DmapBlock * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTHBlock) & IMG.ROIGood & key  & 'pval_information_per_spike<=0.001';
elseif flag_all_or_signif ==3
    dir_current_fig = [dir_base  '\Lick2D\anm' num2str(key.subject_id) '\' session_date '\cells_signif_motor\' ];
    rel= (ANLI.ROILick2DmapBlock * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTHBlock) & IMG.ROIGood & key  & 'pval_psth<=0.05';
    %     rel= ANLI.ROILick2Dmap * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTH & IMG.ROIGood & key  & 'pval_information_per_spike<=0.01';
    % rel= ANLI.ROILick2Dmap * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTH & IMG.ROIGood & key  & 'pval_information_per_spike<=0.05' & 'pval_lickmap_odd_even_corr<=0.05' ;
    % rel= ANLI.ROILick2Dmap * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTH & IMG.ROIGood & key  & 'pval_rayleigh_length<=0.05';
    % rel= ANLI.ROILick2Dmap * ANLI.ROILick2Dangle * ANLI.ROILick2DangleShuffle * ANLI.ROILick2DmapShuffle * ANLI.ROILick2DPSTH & IMG.ROIGood & key  & 'rayleigh_length>=1';
end


% rel= rel & 'information_per_spike>0.05';
rel= rel & 'information_per_spike>0.1';

dir_current_fig = [dir_current_fig 'supersignif\' 'time' num2str(key.fr_interval_start) '-' num2str(key.fr_interval_end) '\' 'bins' num2str(key.number_of_bins) '\' 'block_order\'];

M=fetch(rel ,'*');
roi_number=[M.roi_number];

time=M.psth_time;
time_bin=[-2,3]; %2 sec

number_of_bins = M.number_of_bins;


horizontal_dist1=(1/(number_of_bins+2))*0.7;
vertical_dist1=(1/(number_of_bins+2))*0.6;
panel_width1=(1/(number_of_bins+6))*0.8;
panel_height1=(1/(number_of_bins+6))*0.7;
position_x1(1)=0.1;
position_y1(1)=0.2;
for i=1:1:number_of_bins-1
    position_x1(end+1)=position_x1(end)+horizontal_dist1;
    position_y1(end+1)=position_y1(end)+vertical_dist1;
end

plots_order_mat_x=repmat([1:1:number_of_bins],number_of_bins,1);
plots_order_mat_y=repmat([1:1:number_of_bins]',1,number_of_bins);

horizontal_dist2=(1/(number_of_bins+2))*1.2;
vertical_dist2=(1/(number_of_bins+2));
panel_width2=(1/(number_of_bins+5));
panel_height2=(1/(number_of_bins+5));
position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.73;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);



for i_roi=1:1:size(M,1)
    
    psth_max= cell2mat(reshape(M(i_roi).psth_per_position,[number_of_bins^2,1]));
    psth_max= psth_max(:,time>0 & time<=2);
    psth_max=max(psth_max(:));
    for  i_l=1:1:number_of_bins^2
        
        
        axes('position',[position_x1(plots_order_mat_x(i_l)), position_y1(plots_order_mat_y(i_l)), panel_width1, panel_height1]);
        hold on;
        
        plot(time,M(i_roi).psth_per_position{i_l},'-r','LineWidth',1);
        try
            plot(time,M(i_roi).psth_per_position_odd{i_l},'-','Color',[0 0 1],'LineWidth',1);
            plot(time,M(i_roi).psth_per_position_even{i_l},'-','Color',[0 1 0],'LineWidth',1);
        end
        ylims=[0,ceil(psth_max)+eps];
        ylim(ylims);
        xlim(time_bin);
        if i_l ==1
            xlabel('Time to lick (s)', 'FontSize',14);
            ylabel('Spikes/s', 'FontSize',14);
            set(gca,'XTick',[-2,0,2],'Ytick',ylims, 'FontSize',10,'TickLength',[0.05,0]);
        else
            set(gca,'XTick',[-2,0,2],'Ytick',ylims,'YtickLabel',[], 'FontSize',10,'TickLength',[0.05,0]);
        end
        %         title(num2str(plots_order(i_l)))
    end
    
    axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
    hold on;
    psth_m_begin= M(i_roi).psth_averaged_over_all_positions_begin;
    psth_m_mid= M(i_roi).psth_averaged_over_all_positions_mid;
    psth_m_end= M(i_roi).psth_averaged_over_all_positions_end;

plot(time,psth_m_begin,'-r');
plot(time,psth_m_mid,'-g');
plot(time,psth_m_end,'-b');

%     psth_stem = M(i_roi).psth_stem_over_all_positions;
%     shadedErrorBar(time,psth_m, psth_stem,'lineprops',{'-','Color','r','markeredgecolor','r','markerfacecolor','r','linewidth',1});
    xlim(time_bin);
    ylim([0, ceil(nanmax([psth_m_begin,psth_m_end,psth_m_mid]))]);
    title(sprintf('All positions \n p-val = %.4f ', M(i_roi).pval_psth), 'FontSize',10);
    xlabel('Time to lick (s)', 'FontSize',10);
    ylabel('Spikes/s', 'FontSize',10);
    set(gca,'XTick',[-2,0,2],'Ytick',[0, ceil(nanmax([psth_m_begin,psth_m_end,psth_m_mid]))],'TickLength',[0.05,0], 'FontSize',10);
    
    
    
    axes('position',[position_x2(2),position_y2(1)-0.03, panel_width2*1.5, panel_height2*1.5])
    imagescnan(M(i_roi).pos_x_bins_centers, M(i_roi).pos_x_bins_centers, M(i_roi).lickmap_fr)
    max_map=max(M(i_roi).lickmap_fr(:));
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('ROI %d anm%d %s\n \n Positional (2D) tuning  \n I = %.2f bits/spike  \n  p-val = %.4f  ',roi_number(i_roi),key.subject_id, session_date, M(i_roi).information_per_spike, M(i_roi).pval_information_per_spike ), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    colorbar
    xlabel(sprintf('Lickport X-pos \n(normalized)'), 'FontSize',10);
    ylabel(sprintf('Lickport  Z-pos '), 'FontSize',10);
set(gca,'YDir','normal');
    set(gca, 'FontSize',10);
    
    axes('position',[position_x2(4),position_y2(3), panel_width2*1.5, panel_height2*1.5])
    imagescnan(M(i_roi).pos_x_bins_centers, M(i_roi).pos_x_bins_centers, M(i_roi).lickmap_fr_odd)
    max_map=max(M(i_roi).lickmap_fr_odd(:));
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('Stability r <odd,even> = %.2f \n p-val = %.4f  \n \n Odd trials', M(i_roi).lickmap_odd_even_corr, M(i_roi).pval_lickmap_odd_even_corr ), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    axis tight
set(gca,'YDir','normal');
    colorbar
    
    axes('position',[position_x2(4),position_y2(4), panel_width2*1.5, panel_height2*1.5])
    imagescnan(M(i_roi).pos_x_bins_centers, M(i_roi).pos_x_bins_centers, M(i_roi).lickmap_fr_even)
    max_map=max(M(i_roi).lickmap_fr_even(:));
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('\n  \n Even trials '), 'FontSize',10);
    axis xy
    axis equal;
    axis tight;
set(gca,'YDir','normal');
    colorbar
    
    
    axes('position',[position_x2(3)+0.02,position_y2(1), panel_width2, panel_height2])
    hold on;
    xxx=M(i_roi).theta_bins_centers;
    yyy=M(i_roi).theta_tuning_curve;
    plot(xxx,yyy,'-b','LineWidth',2);
    plot(xxx,M(i_roi).theta_tuning_curve_odd,'-','Color',[0 0 0]);
    plot(xxx,M(i_roi).theta_tuning_curve_even,'-','Color',[0.5 0.5 0.5]);
    title(sprintf('Directional tuning \n RV = %.2f p-val = %.2f \n r = %.2f  p-val = %.4f',M(i_roi).rayleigh_length,M(i_roi).pval_rayleigh_length, M(i_roi).theta_tuning_odd_even_corr,  M(i_roi).pval_theta_tuning_odd_even_corr ), 'FontSize',10);
    xlim([-180,180])
    ylim([0, ceil(nanmax(yyy))])
    xlabel('Direction ({\circ})', 'FontSize',10);
    ylabel('Spikes/s', 'FontSize',10);
    set(gca,'XTick',[-180,0,180],'Ytick',[0, ceil(nanmax(yyy))-eps], 'FontSize',10,'TickLength',[0.05,0]);
    
    
    
    
    if isempty(dir(dir_current_fig))
        mkdir (dir_current_fig)
    end
    %
    filename=['roi_' num2str(roi_number(i_roi))];
    figure_name_out=[ dir_current_fig filename];
    eval(['print ', figure_name_out, ' -dtiff  -r200']);
    % eval(['print ', figure_name_out, ' -dpdf -r200']);
    
    
    clf
end

