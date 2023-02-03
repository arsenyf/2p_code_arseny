function PLOTS_CellsPSTHTimingReward (key, dir_current_fig, flag_spikes, plot_one_in_x_cell , rel_rois)
close all;


% rel_rois=  IMG.ROIGood & (LICK2D.ROILick2DangleSpikes*LICK2D.ROILick2DPSTHStatsSpikes*LICK2D.ROILick2DmapSpikes  & key  & 'psth_regular_odd_vs_even_corr>0.5' & 'theta_tuning_odd_even_corr>0.5' & 'lickmap_regular_odd_vs_even_corr>0.5' & 'goodness_of_fit_vmises>0.5');
if flag_spikes==0 % if based on dff
else  % if based on spikes
    rel = (LICK2D.ROILick2DPSTHSpikesLongerInterval * LICK2D.ROILick2DPSTHStatsSpikesLongerInterval) & rel_rois;
end

session_date = fetch1(EXP2.Session & key,'session_date');
filename_prefix = [ 'anm' num2str(key.subject_id) '_s' num2str(key.session) '_' session_date];



roi_number=fetchn(rel_rois  & key,'roi_number','ORDER BY roi_number');
roi_uid=fetchn(rel_rois  & key,'roi_number_uid','ORDER BY roi_number');

if isempty(roi_number)
    return
end

psth_time =fetch1(rel & key,'psth_time','LIMIT 1');


smooth_bin = 1;



horizontal_dist2=0.4;
vertical_dist2=0.2;
panel_width2=0.2;
panel_height2=0.2;
position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.50;
position_y2(end+1)=position_y2(end)-vertical_dist2*1.3;
position_y2(end+1)=position_y2(end)-vertical_dist2*0.6;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

panel_width3=0.15;
panel_height3=0.15;

%Graphics
%---------------------------------
% figure;
figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

% M.psth_stem=[fetchn(rel_map_and_psth,'psth_stem','ORDER BY roi_number')];
M.psth_regular=[fetchn(rel,'psth_regular','ORDER BY roi_number')];
M.psth_regular_stem=[fetchn(rel,'psth_regular_stem','ORDER BY roi_number')];
M.psth_small=[fetchn(rel,'psth_small','ORDER BY roi_number')];
M.psth_small_stem=[fetchn(rel,'psth_small_stem','ORDER BY roi_number')];
M.psth_large=[fetchn(rel,'psth_large','ORDER BY roi_number')];
M.psth_large_stem=[fetchn(rel,'psth_large_stem','ORDER BY roi_number')];
M.peaktime_psth_regular=[fetchn(rel,'peaktime_psth_regular','ORDER BY roi_number')];
M.reward_mean_pval_regular_small=[fetchn(rel,'reward_mean_pval_regular_small','ORDER BY roi_number')];
M.reward_mean_pval_regular_large=[fetchn(rel,'reward_mean_pval_regular_large','ORDER BY roi_number')];
M = struct2table(M);



for i_roi=1:plot_one_in_x_cell:numel(roi_number)
    
    
    
    
    %% PSTH
    axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
    hold on;
    plot_legend_flag=1;
    peaktime_psth = M.peaktime_psth_regular(i_roi);
    psth_reward_max = max(M.psth_regular{i_roi});
    psth_regular= M.psth_regular{i_roi}/psth_reward_max;
    psth_regular_stem= M.psth_regular_stem{i_roi}/psth_reward_max;
    shadedErrorBar(psth_time,psth_regular, psth_regular_stem,'lineprops',{'-','Color',[ 0 0 0.8],'linewidth',1});
    xl = [floor(psth_time(1)) ceil(psth_time(end))];
    xlim(xl);
    ylim([0, 1]);
    xlabel('Time to lick (s)', 'FontSize',10);
    ylabel('Response (normalized)', 'FontSize',10);
    set(gca,'XTick',[xl(1),0, 4, xl(end)],'Ytick',[0, 1],'TickLength',[0.05,0], 'FontSize',10);
    plot([0 0], [0 1], '-k')
    
    title(sprintf('ROI %d \nROI unique=%d\n anm%d s%d\n%s \nPeaktime %.2f (s)\n',roi_number(i_roi),roi_uid(i_roi),key.subject_id,key.session, session_date, peaktime_psth), 'FontSize',10);
    
    
    %% PSTH
    axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
    hold on;
    plot_legend_flag=1;
    psth_reward_max = max([M.psth_regular{i_roi},M.psth_large{i_roi},M.psth_small{i_roi} ]);
    psth_regular= M.psth_regular{i_roi}/psth_reward_max;
    psth_regular_stem= M.psth_regular_stem{i_roi}/psth_reward_max;
    psth_small= M.psth_small{i_roi}/psth_reward_max;
    psth_small_stem= M.psth_small_stem{i_roi}/psth_reward_max;
    psth_large= M.psth_large{i_roi}/psth_reward_max;
    psth_large_stem= M.psth_large_stem{i_roi}/psth_reward_max;
    
    try
        shadedErrorBar(psth_time,psth_large, psth_large_stem,'lineprops',{'-','Color',[ 1 0.5 0],'linewidth',1});
        shadedErrorBar(psth_time,psth_small, psth_small_stem,'lineprops',{'-','Color',[0 0.7 0.2],'linewidth',1});
        shadedErrorBar(psth_time,psth_regular, psth_regular_stem,'lineprops',{'-','Color',[ 0 0 0.8],'linewidth',1});
        
        xl = [floor(psth_time(1)) ceil(psth_time(end))];
        xlim(xl);
        ylim([0, 1]);
        xlabel('Time to lick (s)', 'FontSize',10);
        ylabel('Response (normalized)', 'FontSize',10);
        set(gca,'XTick',[xl(1),0, 4, xl(end)],'Ytick',[0, 1],'TickLength',[0.05,0], 'FontSize',10);
        plot([0 0], [0 1], '-k')
        if plot_legend_flag==1
            text(5, 0.7,  sprintf('Regular trials\n'),'Color',[0 0 1]);
            text(5, 0.5, sprintf('Reward increase\n'),'Color',[ 1 0.5 0]);
            text(5, 0.3, sprintf('Reward omission\n'),'Color',[0 0.7 0.2]);
        end
        title(sprintf('Reward Omission p = %.3f \nReward Increase p = %.3f\n\n', M.reward_mean_pval_regular_small(i_roi),M.reward_mean_pval_regular_large(i_roi)), 'FontSize',10);
    catch
        
    end
    
    if peaktime_psth<0
        peaktime_dir='t-1';
    elseif peaktime_psth>0 && peaktime_psth<1
        peaktime_dir='t0';
    elseif peaktime_psth>1 && peaktime_psth<2
        peaktime_dir='t1';
    elseif peaktime_psth>2 && peaktime_psth<3
        peaktime_dir='t2';
    elseif peaktime_psth>3 && peaktime_psth<4
        peaktime_dir='t3';
    elseif peaktime_psth>4  && peaktime_psth<5
        peaktime_dir='t4';
    elseif peaktime_psth>5
        peaktime_dir='t5';
    else
        return
    end
    
    
    if isempty(dir([dir_current_fig peaktime_dir]))
        mkdir ([dir_current_fig peaktime_dir])
    end
    %
    filename=[filename_prefix 'roi_' num2str(roi_number(i_roi))];
    figure_name_out=[ dir_current_fig peaktime_dir '\' filename];
    eval(['print ', figure_name_out, ' -dtiff  -r50']);
    % eval(['print ', figure_name_out, ' -dpdf -r200']);
    
    
    clf
end

