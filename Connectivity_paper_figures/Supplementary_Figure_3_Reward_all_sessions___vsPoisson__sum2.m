function Supplementary_Figure_3_Reward_all_sessions___vsPoisson__sum2
close all;

rel_roi = PAPER.ROILICK2DInclusion & (EXP2.Session & 'session>=0' ) - IMG.Mesoscope ;

rel_roi_large_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_large<=0.05');
rel_roi_small_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_small<=0.05');

rel_psth_large_signif = (LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson * LICK2D.ROILick2DPSTHStatsSpikesPoisson) &  rel_roi_large_signif ;
rel_psth_small_signif = (LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson * LICK2D.ROILick2DPSTHStatsSpikesPoisson) &  rel_roi_small_signif ; 

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Lick2D\population\reward_not_meso\'];

filename=['all_sessions_real_vs_poisson__sum'];


%Graphics
%---------------------------------
fig=gcf;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
left_color=[0 0 0];
right_color=[0 0 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);

horizontal_dist=0.25;
vertical_dist=0.35;

panel_width1=0.3;
panel_height1=0.3;
position_y1(1)=0.38;
position_x1(1)=0.07;
position_x1(end+1)=position_x1(end)+horizontal_dist*1.5;


panel_width2=0.09;
panel_height2=0.08;
horizontal_dist2=0.25;
vertical_dist2=0.25;

position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2*0.8;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_x3(1)=0.05;
position_x3(end+1)=position_x3(end)+horizontal_dist2;
position_x3(end+1)=position_x3(end)+horizontal_dist2;
position_x3(end+1)=position_x3(end)+horizontal_dist2;
position_x3(end+1)=position_x3(end)+horizontal_dist2;


position_y2(1)=0.8;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

position_y3(1)=0.2;
position_y3(end+1)=position_y3(end)-vertical_dist2;
position_y3(end+1)=position_y3(end)-vertical_dist2;
position_y3(end+1)=position_y3(end)-vertical_dist2;
%---------------------------------





subplot(2,2,1)
PSTH = fetch(rel_psth_large_signif,'*');
large = 100*(([PSTH.reward_mean_large]./[PSTH.reward_mean_regular])-1);
large_poisson = 100*(([PSTH.reward_mean_large_poisson]./[PSTH.reward_mean_regular_poisson])-1);
% large = ([PSTH.reward_mean_large]-[PSTH.reward_mean_regular])./([PSTH.reward_mean_large]+[PSTH.reward_mean_regular]);
% large_poisson = ([PSTH.reward_mean_large_poisson]-[PSTH.reward_mean_regular_poisson])./([PSTH.reward_mean_large_poisson]+[PSTH.reward_mean_regular_poisson]);
plot(large,large_poisson,'.','Color',[1 0.5 0])
hold on
plot([-100 100],[-100 100])
xlabel(sprintf('Data'))
ylabel(sprintf('Poisson model'))
title('Reward increase modulation');
axis equal
set(gca,'FontSize',12)
xlim([-100,500])
ylim([-100,100])


subplot(2,2,2)
PSTH = fetch(rel_psth_small_signif,'*');
% small = ([PSTH.reward_mean_small]-[PSTH.reward_mean_regular])./([PSTH.reward_mean_small]+[PSTH.reward_mean_regular]);
% small_poisson = ([PSTH.reward_mean_small_poisson]-[PSTH.reward_mean_regular_poisson])./([PSTH.reward_mean_small_poisson]+[PSTH.reward_mean_regular_poisson]);
small = 100*(([PSTH.reward_mean_small]./[PSTH.reward_mean_regular])-1);
small_poisson = 100*(([PSTH.reward_mean_small_poisson]./[PSTH.reward_mean_regular_poisson])-1);
plot(small,small_poisson,'.','Color',[0 0.5 0])
hold on
plot([-100 100],[-100 100])
xlabel(sprintf('Data'))
ylabel(sprintf('Poisson model'))
title('Reward Omission modulation');
axis equal
set(gca,'FontSize',12)
xlim([-100,500])
ylim([-100,100])

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




