function PLOTS_Cells2DTuning (key, dir_current_fig, flag_spikes, plot_one_in_x_cell , rel_rois)
close all;


% rel_rois=  IMG.ROIGood & (LICK2D.ROILick2DangleSpikes*LICK2D.ROILick2DPSTHStatsSpikes*LICK2D.ROILick2DmapSpikes  & key  & 'psth_regular_odd_vs_even_corr>0.5' & 'theta_tuning_odd_even_corr>0.5' & 'lickmap_regular_odd_vs_even_corr>0.5' & 'goodness_of_fit_vmises>0.5');
if flag_spikes==0 % if based on dff
    %     rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & (LICK2D.ROILick2DRewardStatsSpikes  & key    & 'reward_mean_pval_regular_small<=0.01 OR reward_mean_pval_regular_large<=0.01 ');
    %     rel_map_and_psth = LICK2D.ROILick2DmapSpikes *LICK2D.ROILick2DmapPSTHSpikes *LICK2D.ROILick2DmapStatsSpikes * LICK2D.ROILick2DPSTHSpikes  & rel_rois;
    %     rel_angle = LICK2D.ROILick2DangleSpikes  & rel_rois;
    %     rel_stats = LICK2D.ROILick2DPSTHStatsSpikes *LICK2D.ROILick2DSelectivityStatsSpikes  & rel_rois;
else  % if based on spikes
    %     rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & (LICK2D.ROILick2DRewardStatsSpikes & 'reward_mean_pval_regular_small<=0.05 OR reward_mean_pval_regular_large<=0.05 ' ) & (LICK2D.ROILick2DmapStatsSpikes & 'lickmap_regular_odd_vs_even_corr>=0.75' & 'percent_2d_map_coverage_small>=75' & 'number_of_response_trials>=500') & key;
    %     rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & (LICK2D.ROILick2DRewardStatsSpikes & 'reward_mean_pval_regular_small<=0.05 OR reward_mean_pval_regular_large<=0.05 ' ) & (LICK2D.ROILick2DmapStatsSpikes & 'percent_2d_map_coverage_small>=75' & 'number_of_response_trials>=500') & (LICK2D.ROILick2DContactenatedSpikes2 & 'psth_position_concat_regular_odd_even_corr>=0.25') & key;
    
    rel_map_and_psth = LICK2D.ROILick2DmapSpikes *LICK2D.ROILick2DmapPSTHSpikes*LICK2D.ROILick2DmapPSTHStabilitySpikes *LICK2D.ROILick2DmapStatsSpikes * LICK2D.ROILick2DPSTHSpikes  & rel_rois;
    rel_angle = LICK2D.ROILick2DangleSpikes3bins*LICK2D.ROILick2DangleStatsSpikes3bins  & rel_rois;
    rel_stats = LICK2D.ROILick2DPSTHStatsSpikes *LICK2D.ROILick2DmapStatsSpikes & rel_rois;
    rel_poisson = LICK2D.ROILick2DPSTHSpikesPoisson*LICK2D.ROILick2DPSTHStatsSpikesPoisson & rel_rois;
    rel_resampled_likepoisson = LICK2D.ROILick2DPSTHSpikesResampledlikePoisson*LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson & rel_rois;
    
end

session_date = fetch1(EXP2.Session & key,'session_date');
filename_prefix = [ 'anm' num2str(key.subject_id) '_s' num2str(key.session) '_' session_date];



roi_number=fetchn(rel_rois  & key,'roi_number','ORDER BY roi_number');
roi_uid=fetchn(rel_rois  & key,'roi_number_uid','ORDER BY roi_number');

if isempty(roi_number)
    return
end

psthmap_time =fetch1(rel_map_and_psth & key,'psthmap_time','LIMIT 1');
psth_time =fetch1(rel_map_and_psth & key,'psth_time','LIMIT 1');
psth_time_poisson =fetch1(rel_poisson & key,'psth_time_poisson','LIMIT 1');

number_of_bins =fetch1(rel_map_and_psth & key,'number_of_bins','LIMIT 1');
pos_x_bins_centers =fetch1(rel_map_and_psth  & key,'pos_x_bins_centers','LIMIT 1');


smooth_bin = 1;


horizontal_dist1=(1/(number_of_bins+2))*0.25;
vertical_dist1=(1/(number_of_bins+2))*0.25;
panel_width1=(1/(number_of_bins+6))*0.4;
panel_height1=(1/(number_of_bins+6))*0.35;
horizontal_distance2=0.23;
position_x1_grid(1)=0.07;
position_y1_grid(1)=0.15;
for i=1:1:number_of_bins-1
    position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist1;
    position_y1_grid(end+1)=position_y1_grid(end)+vertical_dist1;
end

position_x2_grid(1)=position_x1_grid(1)+horizontal_distance2;
position_y2_grid(1)=0.15;
for i=1:1:number_of_bins-1
    position_x2_grid(end+1)=position_x2_grid(end)+horizontal_dist1;
    position_y2_grid(end+1)=position_y2_grid(end)+vertical_dist1;
end

position_x3_grid(1)=position_x2_grid(1)+horizontal_distance2;
position_y3_grid(1)=0.15;
for i=1:1:number_of_bins-1
    position_x3_grid(end+1)=position_x3_grid(end)+horizontal_dist1;
    position_y3_grid(end+1)=position_y3_grid(end)+vertical_dist1;
end

position_x4_grid(1)=position_x3_grid(1)+horizontal_distance2;
position_y4_grid(1)=0.15;
for i=1:1:number_of_bins-1
    position_x4_grid(end+1)=position_x4_grid(end)+horizontal_dist1;
    position_y4_grid(end+1)=position_y4_grid(end)+vertical_dist1;
end


plots_order_mat_x=repmat([1:1:number_of_bins],number_of_bins,1);
plots_order_mat_y=repmat([1:1:number_of_bins]',1,number_of_bins);
horizontal_dist2=0.2;
vertical_dist2=0.2;
panel_width2=0.1;
panel_height2=0.1;
position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.70;
position_y2(end+1)=position_y2(end)-vertical_dist2*1.3;
position_y2(end+1)=position_y2(end)-vertical_dist2*0.6;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

panel_width3=0.15;
panel_height3=0.15;

%Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

% M.psth_stem=[fetchn(rel_map_and_psth,'psth_stem','ORDER BY roi_number')];
M.psth=[fetchn(rel_map_and_psth,'psth_regular','ORDER BY roi_number')];
M.psth_per_position_regular =[fetchn(rel_map_and_psth,'psth_per_position_regular','ORDER BY roi_number')];
M.psth_per_position_regular_stem =[fetchn(rel_map_and_psth,'psth_per_position_regular_stem','ORDER BY roi_number')];
M.psth_per_position_regular_odd=[fetchn(rel_map_and_psth,'psth_per_position_regular_odd','ORDER BY roi_number')];
M.psth_per_position_regular_even=[fetchn(rel_map_and_psth,'psth_per_position_regular_even','ORDER BY roi_number')];
M.psth_per_position_small =[fetchn(rel_map_and_psth,'psth_per_position_small','ORDER BY roi_number')];
M.psth_per_position_small_stem =[fetchn(rel_map_and_psth,'psth_per_position_small_stem','ORDER BY roi_number')];
M.psth_per_position_small_odd=[fetchn(rel_map_and_psth,'psth_per_position_small_odd','ORDER BY roi_number')];
M.psth_per_position_small_even=[fetchn(rel_map_and_psth,'psth_per_position_small_even','ORDER BY roi_number')];
M.psth_per_position_large =[fetchn(rel_map_and_psth,'psth_per_position_large','ORDER BY roi_number')];
M.psth_per_position_large_stem =[fetchn(rel_map_and_psth,'psth_per_position_large_stem','ORDER BY roi_number')];
M.psth_per_position_large_odd=[fetchn(rel_map_and_psth,'psth_per_position_large_odd','ORDER BY roi_number')];
M.psth_per_position_large_even=[fetchn(rel_map_and_psth,'psth_per_position_large_even','ORDER BY roi_number')];

M.lickmap_fr_regular=[fetchn(rel_map_and_psth,'lickmap_fr_regular','ORDER BY roi_number')];
M.lickmap_fr_regular_odd=[fetchn(rel_map_and_psth,'lickmap_fr_regular_odd','ORDER BY roi_number')];
M.lickmap_fr_regular_even=[fetchn(rel_map_and_psth,'lickmap_fr_regular_even','ORDER BY roi_number')];
M.lickmap_fr_small=[fetchn(rel_map_and_psth,'lickmap_fr_small','ORDER BY roi_number')];
M.lickmap_fr_large=[fetchn(rel_map_and_psth,'lickmap_fr_large','ORDER BY roi_number')];
M.lickmap_regular_odd_vs_even_corr=[fetchn(rel_map_and_psth,'lickmap_regular_odd_vs_even_corr','ORDER BY roi_number')];
M.information_per_spike_regular=fetchn(rel_map_and_psth,'information_per_spike_regular','ORDER BY roi_number');
M.information_per_spike_small=fetchn(rel_map_and_psth,'information_per_spike_small','ORDER BY roi_number');
M.information_per_spike_large=fetchn(rel_map_and_psth,'information_per_spike_large','ORDER BY roi_number');
M.psth_regular_odd_vs_even_corr=[fetchn(rel_stats,'psth_regular_odd_vs_even_corr','ORDER BY roi_number')];
M.psth_small_odd_vs_even_corr=[fetchn(rel_stats,'psth_small_odd_vs_even_corr','ORDER BY roi_number')];
M.psth_large_odd_vs_even_corr=[fetchn(rel_stats,'psth_large_odd_vs_even_corr','ORDER BY roi_number')];
M.psth_small_odd_vs_even_corr=[fetchn(rel_stats,'psth_small_odd_vs_even_corr','ORDER BY roi_number')];
M.psth_large_odd_vs_even_corr=[fetchn(rel_stats,'psth_large_odd_vs_even_corr','ORDER BY roi_number')];
M.field_size_regular=[fetchn(rel_map_and_psth,'field_size_regular','ORDER BY roi_number')];
M.field_size_small=[fetchn(rel_map_and_psth,'field_size_small','ORDER BY roi_number')];
M.field_size_large=[fetchn(rel_map_and_psth,'field_size_large','ORDER BY roi_number')];
M.field_size_without_baseline_regular=[fetchn(rel_map_and_psth,'field_size_without_baseline_regular','ORDER BY roi_number')];
M.field_size_without_baseline_small=[fetchn(rel_map_and_psth,'field_size_without_baseline_small','ORDER BY roi_number')];
M.field_size_without_baseline_large=[fetchn(rel_map_and_psth,'field_size_without_baseline_large','ORDER BY roi_number')];
M.centroid_without_baseline_regular=[fetchn(rel_map_and_psth,'centroid_without_baseline_regular','ORDER BY roi_number')];
M.centroid_without_baseline_small=[fetchn(rel_map_and_psth,'centroid_without_baseline_small','ORDER BY roi_number')];
M.centroid_without_baseline_large=[fetchn(rel_map_and_psth,'centroid_without_baseline_large','ORDER BY roi_number')];

% M.preferred_odd_even_corr=[fetchn(rel_stats,'psth_preferred_odd_even_corr','ORDER BY roi_number')];
% M.selectivity_odd_even_corr=[fetchn(rel_stats,'selectivity_odd_even_corr','ORDER BY roi_number')];
% M.psth_quadrants=[fetchn(rel_map_and_psth,'psth_quadrants','ORDER BY roi_number')];
% M.psth_quadrants_odd_even_corr=[fetchn(rel_map_and_psth,'psth_quadrants_odd_even_corr','ORDER BY roi_number')];

M.psth_regular=[fetchn(rel_map_and_psth,'psth_regular','ORDER BY roi_number')];
M.psth_regular_odd=[fetchn(rel_map_and_psth,'psth_regular_odd','ORDER BY roi_number')];
M.psth_regular_even=[fetchn(rel_map_and_psth,'psth_regular_even','ORDER BY roi_number')];
M.psth_regular_stem=[fetchn(rel_map_and_psth,'psth_regular_stem','ORDER BY roi_number')];

M.psth_small=[fetchn(rel_map_and_psth,'psth_small','ORDER BY roi_number')];
M.psth_small_odd=[fetchn(rel_map_and_psth,'psth_small_odd','ORDER BY roi_number')];
M.psth_small_even=[fetchn(rel_map_and_psth,'psth_small_even','ORDER BY roi_number')];
M.psth_small_stem=[fetchn(rel_map_and_psth,'psth_small_stem','ORDER BY roi_number')];

M.psth_large=[fetchn(rel_map_and_psth,'psth_large','ORDER BY roi_number')];
M.psth_large_odd=[fetchn(rel_map_and_psth,'psth_large_odd','ORDER BY roi_number')];
M.psth_large_even=[fetchn(rel_map_and_psth,'psth_large_even','ORDER BY roi_number')];
M.psth_large_stem=[fetchn(rel_map_and_psth,'psth_large_stem','ORDER BY roi_number')];

M.reward_mean_pval_regular_small=[fetchn(rel_stats,'reward_mean_pval_regular_small','ORDER BY roi_number')];
M.reward_mean_pval_regular_large=[fetchn(rel_stats,'reward_mean_pval_regular_large','ORDER BY roi_number')];
% M.reward_peak_pval_regular_small=[fetchn(rel_stats,'reward_peak_pval_regular_small','ORDER BY roi_number')];
% M.reward_peak_pval_regular_large=[fetchn(rel_stats,'reward_peak_pval_regular_large','ORDER BY roi_number')];
M.psth_position_concat_regular_odd_even_corr=[fetchn(rel_stats,'psth_position_concat_regular_odd_even_corr','ORDER BY roi_number')];
M.psth_position_concat_small_odd_even_corr=[fetchn(rel_stats,'psth_position_concat_small_odd_even_corr','ORDER BY roi_number')];
M.psth_position_concat_large_odd_even_corr=[fetchn(rel_stats,'psth_position_concat_large_odd_even_corr','ORDER BY roi_number')];

M = struct2table(M);

M_angle=fetch(rel_angle,'*','ORDER BY roi_number');

M_poisson.psth_regular=[fetchn(rel_poisson,'psth_regular_poisson','ORDER BY roi_number')];
M_poisson.psth_large=[fetchn(rel_poisson,'psth_large_poisson','ORDER BY roi_number')];
M_poisson.psth_small=[fetchn(rel_poisson,'psth_small_poisson','ORDER BY roi_number')];
M_poisson.psth_regular_stem=[fetchn(rel_poisson,'psth_regular_stem_poisson','ORDER BY roi_number')];
M_poisson.psth_large_stem=[fetchn(rel_poisson,'psth_large_stem_poisson','ORDER BY roi_number')];
M_poisson.psth_small_stem=[fetchn(rel_poisson,'psth_small_stem_poisson','ORDER BY roi_number')];
M_poisson.reward_mean_pval_regular_small=[fetchn(rel_poisson,'reward_mean_pval_regular_small_poisson','ORDER BY roi_number')];
M_poisson.reward_mean_pval_regular_large=[fetchn(rel_poisson,'reward_mean_pval_regular_large_poisson','ORDER BY roi_number')];
M_poisson = struct2table(M_poisson);

M_resampled_likepoisson.psth_regular=[fetchn(rel_resampled_likepoisson,'psth_regular','ORDER BY roi_number')];
M_resampled_likepoisson.psth_large=[fetchn(rel_resampled_likepoisson,'psth_large','ORDER BY roi_number')];
M_resampled_likepoisson.psth_small=[fetchn(rel_resampled_likepoisson,'psth_small','ORDER BY roi_number')];
M_resampled_likepoisson.psth_regular_stem=[fetchn(rel_resampled_likepoisson,'psth_regular_stem','ORDER BY roi_number')];
M_resampled_likepoisson.psth_large_stem=[fetchn(rel_resampled_likepoisson,'psth_large_stem','ORDER BY roi_number')];
M_resampled_likepoisson.psth_small_stem=[fetchn(rel_resampled_likepoisson,'psth_small_stem','ORDER BY roi_number')];
M_resampled_likepoisson.reward_mean_pval_regular_small=[fetchn(rel_resampled_likepoisson,'reward_mean_pval_regular_small','ORDER BY roi_number')];
M_resampled_likepoisson.reward_mean_pval_regular_large=[fetchn(rel_resampled_likepoisson,'reward_mean_pval_regular_large','ORDER BY roi_number')];
M_resampled_likepoisson = struct2table(M_resampled_likepoisson);



for i_roi=1:plot_one_in_x_cell:numel(roi_number)
    
    
    
    
    %% PSTH by Reward size, averaged across all positions
    %Real tuning
    axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
    hold on;
    plot_legend_flag=1;
    fn_plot_psth_by_reward_size (M,psth_time,i_roi, plot_legend_flag)
    title(sprintf('ROI %d \nROI unique=%d\n anm%d s%d\n%s\nStability PSTH regular %.2f\nStability PSTH small %.2f\nStability PSTH large %.2f \nReward Omission p = %.3f \nReward Increase p = %.3f\n\n',roi_number(i_roi),roi_uid(i_roi),key.subject_id,key.session, session_date, M.psth_regular_odd_vs_even_corr(i_roi),M.psth_small_odd_vs_even_corr(i_roi),M.psth_large_odd_vs_even_corr(i_roi), M.reward_mean_pval_regular_small(i_roi),M.reward_mean_pval_regular_large(i_roi)), 'FontSize',10);
    
    % POISSON simulated tuning
    axes('position',[position_x2(2)+0.1,position_y2(1), panel_width2, panel_height2])
    hold on;
    plot_legend_flag=0;
    fn_plot_psth_by_reward_size (M_poisson,psth_time_poisson,i_roi, plot_legend_flag)
    title(sprintf('Poisson \nReward Omission p = %.3f \nReward Increase p = %.3f\n\n', M_poisson.reward_mean_pval_regular_small(i_roi),M_poisson.reward_mean_pval_regular_large(i_roi)), 'FontSize',10);
    
    % Real tuning resampled in timebins like POISSON
    axes('position',[position_x2(3)+0.1,position_y2(1), panel_width2, panel_height2])
    hold on;
    plot_legend_flag=0;
    fn_plot_psth_by_reward_size (M_resampled_likepoisson,psth_time_poisson,i_roi, plot_legend_flag)
    title(sprintf('Real resampled like Poisson \nReward Omission p = %.3f \nReward Increase p = %.3f\n\n', M_resampled_likepoisson.reward_mean_pval_regular_small(i_roi),M_resampled_likepoisson.reward_mean_pval_regular_large(i_roi)), 'FontSize',10);
    
    
    
    
    %% Angular tuning
    axes('position',[position_x2(4)+0.1,position_y2(1), panel_width2, panel_height2])
    hold on;
    theta_bins_centers=M_angle(i_roi).theta_bins_centers;
    yyy=M_angle(i_roi).theta_tuning_regular;
    yyy_stem=M_angle(i_roi).theta_tuning_regular_stem;
    yyy_odd=M_angle(i_roi).theta_tuning_regular_odd;
    yyy_even=M_angle(i_roi).theta_tuning_regular_even;
    
    yyy_max = nanmax([yyy(:)+yyy_stem(:);yyy_odd(:);yyy_even(:)]);
    yyy=yyy./yyy_max;
    yyy_vnmises=(M_angle(i_roi).theta_tuning_regular_vmises)/yyy_max;
    yyy_stem = yyy_stem./yyy_max;
    plot(theta_bins_centers-44,yyy_vnmises,'-g','LineWidth',2);
    shadedErrorBar(theta_bins_centers,yyy, yyy_stem,'lineprops',{'-','Color',[ 1 0 1],'linewidth',1});
    plot(theta_bins_centers,M_angle(i_roi).theta_tuning_regular_odd/yyy_max,'-','Color',[0 0 0]);
    plot(theta_bins_centers,M_angle(i_roi).theta_tuning_regular_even/yyy_max,'-','Color',[0.5 0.5 0.5]);
    title(sprintf('Directional tuning \n RV = %.2f\n r = %.2f  r^2 fit VM = %.2f \n theta = %d VM = %d deg\n',M_angle(i_roi).rayleigh_length_regular, M_angle(i_roi).theta_tuning_odd_even_corr_regular, M_angle(i_roi).goodness_of_fit_vmises_regular,  floor(M_angle(i_roi).preferred_theta_regular), floor(M_angle(i_roi).preferred_theta_vmises_regular)), 'FontSize',10);
    xlim([-180,180])
    ylim([0, 1])
    xlabel('Direction ({\circ})', 'FontSize',10);
    ylabel('Spikes/s', 'FontSize',10);
    set(gca,'XTick',[-180,0,180],'Ytick',[0, 1], 'FontSize',10,'TickLength',[0.05,0]);
    
    
    
    
    xl = [floor(psthmap_time(1)) ceil(psthmap_time(end))];
    
    %% 1 PSTH per position, for regular reward
    psth_max_regular= cell2mat(reshape(M.psth_per_position_regular{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_regular_stem{i_roi},[number_of_bins^2,1]));
    try
        odd=cell2mat(reshape(M.psth_per_position_regular_odd{i_roi},[number_of_bins^2,1]));
        even=cell2mat(reshape(M.psth_per_position_regular_even{i_roi},[number_of_bins^2,1]));
        psth_max_all=max([psth_max_regular(:);odd(:);even(:)]);
    catch
        psth_max_all=max([psth_max_regular(:)]);
    end
    
    
    M.psth_per_position_regular{i_roi} = fn_map_2D_legalize_by_neighboring_psth(M.psth_per_position_regular{i_roi});
    
    for  i_l=1:1:number_of_bins^2
        axes('position',[position_x1_grid(plots_order_mat_x(i_l)), position_y1_grid(plots_order_mat_y(i_l)), panel_width1, panel_height1]);
        hold on;
        plot([0,0],[0,1],'-k','linewidth',0.25)
        temp_mean=M.psth_per_position_regular{i_roi}{i_l}./psth_max_all;
        temp_stem=M.psth_per_position_regular_stem{i_roi}{i_l}./psth_max_all;
        try
            plot(psthmap_time,M.psth_per_position_regular_odd{i_roi}{i_l}./psth_max_all,'-','Color',[0.4 0.4 0.4],'linewidth',1);
            plot(psthmap_time,M.psth_per_position_regular_even{i_roi}{i_l}./psth_max_all,'-','Color',[0.1 0.1 0.1],'linewidth',1);
        end
        shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[ 0 0 0.8],'linewidth',2});
        ylims=[0,1+eps];
        ylim(ylims);
        xlim(xl);
        if i_l ==1
            text(-2,-1,'Time to lick (s)','HorizontalAlignment','left', 'FontSize',10);
            text(-5,0,'Response (normalized)','HorizontalAlignment','left','Rotation',90, 'FontSize',10);
            set(gca,'XTick',[0,xl(2)],'Ytick',ylims, 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
        else
            set(gca,'XTick',[0,xl(2)],'XtickLabel',[],'Ytick',ylims,'YtickLabel',[], 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
            axis off
        end
    end
    
    %% 2 PSTH per position, for large reward
    M.psth_per_position_large{i_roi} = fn_map_2D_legalize_by_neighboring_psth(M.psth_per_position_large{i_roi});
    
    psth_max_large= cell2mat(reshape(M.psth_per_position_large{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_large_stem{i_roi},[number_of_bins^2,1]));
    try
        odd=cell2mat(reshape(M.psth_per_position_large_odd{i_roi},[number_of_bins^2,1]));
        even=cell2mat(reshape(M.psth_per_position_large_even{i_roi},[number_of_bins^2,1]));
        psth_max_all=max([psth_max_large(:);odd(:);even(:)]);
    catch
        psth_max_all=max([psth_max_large(:)]);
    end
    for  i_l=1:1:number_of_bins^2
        axes('position',[position_x2_grid(plots_order_mat_x(i_l)), position_y2_grid(plots_order_mat_y(i_l)), panel_width1, panel_height1]);
        hold on;
        plot([0,0],[0,1],'-k','linewidth',0.25)
        temp_mean=M.psth_per_position_large{i_roi}{i_l}./psth_max_all;
        temp_stem=M.psth_per_position_large_stem{i_roi}{i_l}./psth_max_all;
        try
            plot(psthmap_time,M.psth_per_position_large_odd{i_roi}{i_l}./psth_max_all,'-','Color',[0.4 0.4 0.4],'linewidth',1);
            plot(psthmap_time,M.psth_per_position_large_even{i_roi}{i_l}./psth_max_all,'-','Color',[0.1 0.1 0.1],'linewidth',1);
        end
        shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[ 1 0.5 0],'linewidth',2});
        ylims=[0,1+eps];
        ylim(ylims);
        xlim(xl);
        if i_l ==1
            %             text(-2,-1,'Time to lick (s)','HorizontalAlignment','left', 'FontSize',10);
            %             text(-5,0,'Response (normalized)','HorizontalAlignment','left','Rotation',90, 'FontSize',10);
            set(gca,'XTick',[0,xl(2)],'Ytick',ylims, 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
        else
            set(gca,'XTick',[0,xl(2)],'XtickLabel',[],'Ytick',ylims,'YtickLabel',[], 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
            axis off
        end
    end
    
    %% 3 PSTH per position, for small reward
    M.psth_per_position_small{i_roi} = fn_map_2D_legalize_by_neighboring_psth(M.psth_per_position_small{i_roi});
    
    psth_max_small= cell2mat(reshape(M.psth_per_position_small{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_small_stem{i_roi},[number_of_bins^2,1]));
    try
        odd=cell2mat(reshape(M.psth_per_position_small_odd{i_roi},[number_of_bins^2,1]));
        even=cell2mat(reshape(M.psth_per_position_small_even{i_roi},[number_of_bins^2,1]));
        psth_max_all=max([psth_max_small(:);odd(:);even(:)]);
    catch
        psth_max_all=max([psth_max_small(:)]);
    end
    for  i_l=1:1:number_of_bins^2
        axes('position',[position_x3_grid(plots_order_mat_x(i_l)), position_y3_grid(plots_order_mat_y(i_l)), panel_width1, panel_height1]);
        hold on;
        plot([0,0],[0,1],'-k','linewidth',0.25)
        temp_mean=M.psth_per_position_small{i_roi}{i_l}./psth_max_all;
        temp_stem=M.psth_per_position_small_stem{i_roi}{i_l}./psth_max_all;
        shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[0 0.7 0.2],'linewidth',2});
        try
            plot(psthmap_time,M.psth_per_position_small_odd{i_roi}{i_l}./psth_max_all,'-','Color',[0.4 0.4 0.4],'linewidth',1);
            plot(psthmap_time,M.psth_per_position_small_even{i_roi}{i_l}./psth_max_all,'-','Color',[0.1 0.1 0.1],'linewidth',1);
        end
        ylims=[0,1+eps];
        ylim(ylims);
        xlim(xl);
        if i_l ==1
            %             text(-2,-1,'Time to lick (s)','HorizontalAlignment','left', 'FontSize',10);
            %             text(-5,0,'Response (normalized)','HorizontalAlignment','left','Rotation',90, 'FontSize',10);
            set(gca,'XTick',[0,xl(2)],'Ytick',ylims, 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
        else
            set(gca,'XTick',[0,xl(2)],'XtickLabel',[],'Ytick',ylims,'YtickLabel',[], 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
            axis off
        end
    end
    
    
    %% 4 PSTH per position, for regular, small, and large reward
    psth_max_regular= cell2mat(reshape(M.psth_per_position_regular{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_regular_stem{i_roi},[number_of_bins^2,1]));
    psth_max_small= cell2mat(reshape(M.psth_per_position_small{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_small_stem{i_roi},[number_of_bins^2,1]));
    psth_max_large= cell2mat(reshape(M.psth_per_position_large{i_roi},[number_of_bins^2,1])) + cell2mat(reshape(M.psth_per_position_large_stem{i_roi},[number_of_bins^2,1]));
    psth_max_all=max([psth_max_regular(:);psth_max_small(:);psth_max_large(:)]);
    for  i_l=1:1:number_of_bins^2
        axes('position',[position_x4_grid(plots_order_mat_x(i_l)), position_y4_grid(plots_order_mat_y(i_l)), panel_width1, panel_height1]);
        hold on;
        plot([0,0],[0,1],'-k','linewidth',0.25)
        try
            temp_mean=M.psth_per_position_large{i_roi}{i_l}./psth_max_all;
            temp_stem=M.psth_per_position_large_stem{i_roi}{i_l}./psth_max_all;
            shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[ 1 0.5 0],'linewidth',1});
            
            temp_mean=M.psth_per_position_small{i_roi}{i_l}./psth_max_all;
            temp_stem=M.psth_per_position_small_stem{i_roi}{i_l}./psth_max_all;
            shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[0 0.7 0.2],'linewidth',1});
        end
        temp_mean=M.psth_per_position_regular{i_roi}{i_l}./psth_max_all;
        temp_stem=M.psth_per_position_regular_stem{i_roi}{i_l}./psth_max_all;
        shadedErrorBar(psthmap_time,temp_mean, temp_stem,'lineprops',{'-','Color',[ 0 0 0.8],'linewidth',1});
        
        ylims=[0,1+eps];
        ylim(ylims);
        xlim(xl);
        if i_l ==1
            text(-2,-1,'Time to lick (s)','HorizontalAlignment','left', 'FontSize',10);
            text(-5,0,'Response (normalized)','HorizontalAlignment','left','Rotation',90, 'FontSize',10);
            set(gca,'XTick',[0,xl(2)],'Ytick',ylims, 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
        else
            set(gca,'XTick',[0,xl(2)],'XtickLabel',[],'Ytick',ylims,'YtickLabel',[], 'FontSize',12,'TickLength',[0.1,0],'TickDir','out');
            axis off
        end
    end
    
    
    %% Maps regular reward
    axes('position',[position_x1_grid(1),position_y2(2), panel_width3, panel_height3])
    mmm=M.lickmap_fr_regular{i_roi};
    mmm=mmm./nanmax(mmm(:));
    imagescnan(mmm);
    %     imagescnan(pos_x_bins_centers, pos_x_bins_centers, mmm)
    max_map=max(mmm(:));
    hold on
    plot(M.centroid_without_baseline_regular{i_roi}(1),M.centroid_without_baseline_regular{i_roi}(2),'*');
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('Regular trials\n I = %.2f bits/spike  \nField size %.1f %%\nField size wob %.1f %%\nStability concat %.2f\n', M.information_per_spike_regular(i_roi),M.field_size_regular(i_roi),M.field_size_without_baseline_regular(i_roi),M.psth_position_concat_regular_odd_even_corr(i_roi)), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    colorbar
    %     xlabel(sprintf('Lickport X-pos \n(normalized)'), 'FontSize',10);
    %     ylabel(sprintf('Lickport  Z-pos '), 'FontSize',10);
    set(gca,'YDir','normal');
    set(gca, 'FontSize',10);
    axis off
    
    
    %% Maps reward increase
    axes('position',[position_x2_grid(2),position_y2(2), panel_width3, panel_height3])
    mmm=M.lickmap_fr_large{i_roi};
    mmm=mmm./nanmax(mmm(:));
    imagescnan(mmm);
    max_map=max(mmm(:));
    hold on
    plot(M.centroid_without_baseline_large{i_roi}(1),M.centroid_without_baseline_large{i_roi}(2),'*');
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('Reward increase\n I = %.2f bits/spike \nField size %.1f %%\nField size wob %.1f %%\nStability concat %.2f\n',M.information_per_spike_large(i_roi),M.field_size_large(i_roi),M.field_size_without_baseline_large(i_roi),M.psth_position_concat_large_odd_even_corr(i_roi)), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    colorbar
    %     xlabel(sprintf('Lickport X-pos \n(normalized)'), 'FontSize',10);
    %     ylabel(sprintf('Lickport  Z-pos '), 'FontSize',10);
    set(gca,'YDir','normal');
    set(gca, 'FontSize',10);
    axis off
    
    
    %% Maps reward omission
    axes('position',[position_x3_grid(3),position_y2(2), panel_width3, panel_height3])
    mmm=M.lickmap_fr_small{i_roi};
    mmm=mmm./nanmax(mmm(:));
    imagescnan(mmm);
    max_map=max(mmm(:));
    hold on
    plot(M.centroid_without_baseline_small{i_roi}(1),M.centroid_without_baseline_small{i_roi}(2),'*');
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('Reward omission\n I = %.2f bits/spike \nField size %.1f %%\nField size wob %.1f %%\nStability concat %.2f\n',M.information_per_spike_small(i_roi), M.field_size_small(i_roi),M.field_size_without_baseline_small(i_roi),M.psth_position_concat_small_odd_even_corr(i_roi)), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    colorbar
    %     xlabel(sprintf('Lickport X-pos \n(normalized)'), 'FontSize',10);
    %     ylabel(sprintf('Lickport  Z-pos '), 'FontSize',10);
    set(gca,'YDir','normal');
    set(gca, 'FontSize',10);
    axis off
    
    
    %% Map regular reward stability
    
    axes('position',[position_x1_grid(1),position_y2(3), panel_width3, panel_height3])
    mmm=M.lickmap_fr_regular_odd{i_roi};
    mmm=mmm./nanmax(mmm(:));
    imagescnan(mmm);
    max_map=max(mmm(:));
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('Stability r = %.2f \n Odd trials\n', M.lickmap_regular_odd_vs_even_corr(i_roi)), 'FontSize',10);
    axis xy
    axis equal;
    axis tight
    set(gca,'YDir','normal');
    colorbar
    axis off
    
    axes('position',[position_x1_grid(1)+0.1,position_y2(3), panel_width3, panel_height3])
    mmm=M.lickmap_fr_regular_even{i_roi};
    mmm=mmm./nanmax(mmm(:));
    imagescnan(mmm);
    max_map=max(mmm(:));
    caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
    colormap(parula)
    title(sprintf('\nEven trials\n'), 'FontSize',10);
    axis xy
    axis equal;
    axis tight;
    set(gca,'YDir','normal');
    colorbar
    axis off
    
    
    
    
    
    
    if isempty(dir(dir_current_fig))
        mkdir (dir_current_fig)
    end
    %
    filename=[filename_prefix 'roi_' num2str(roi_number(i_roi))];
    figure_name_out=[ dir_current_fig filename];
    eval(['print ', figure_name_out, ' -dtiff  -r200']);
    % eval(['print ', figure_name_out, ' -dpdf -r200']);
    
    
    clf
end

