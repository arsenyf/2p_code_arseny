function Supplementary_Figure_3_de_Poission
close all;

rel_roi = PAPER.ROILICK2DInclusion & (EXP2.Session & 'session>=0' ) - IMG.Mesoscope ;

rel_roi_large_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_large<=0.05');
rel_roi_small_signif = rel_roi  & (LICK2D.ROILick2DPSTHStatsSpikes & 'reward_mean_pval_regular_small<=0.05');

rel_psth_large_signif = (LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson * LICK2D.ROILick2DPSTHStatsSpikesPoisson) &  rel_roi_large_signif ;
rel_psth_small_signif = (LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson * LICK2D.ROILick2DPSTHStatsSpikesPoisson) &  rel_roi_small_signif ; 

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];

filename=[sprintf('Supplementary_Figure_3_de_poisson')];

rel_example_psth = IMG.ROIID* LICK2D.ROILick2DPSTHSpikesResampledlikePoisson;
rel_example_psth_poisson = IMG.ROIID* LICK2D.ROILick2DPSTHSpikesPoisson ;

PAPER_graphics_definition_SupFig3

% 
% %% Behavior cartoon
% axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
% xl = [0 2680];
% yl = [0 1500];
% fig1_a = imread([dir_embeded_graphics 'Figure1_behavior_cartoon.tif']);
% % fig1_a=flipdim(fig1_a,1);
% imagesc(fig1_a);
% set(gca,'Xlim',xl,'Ylim',yl);
% text(xl(1)+diff(xl)*0.1, yl(1)+diff(yl)*0.1, 'a', ...
%     'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');
% % text(xl(1)+diff(xl)*0.5, yl(1)+diff(yl)*1.1,'vS1','FontSize',8,'FontWeight','bold','Color',[0 1 0],'HorizontalAlignment','center');
% axis off;
% axis tight;
% axis equal;


%% Lick-rates across reward conditions


axes('position',[position_x1(1),position_y1(1), panel_width1, panel_height1])
rel_behavior_trial = (EXP2.BehaviorTrialEvent*EXP2.SessionTrial  & 'trial_event_type="go"' & EXP2.TrialRewardSize) - TRACKING.TrackingTrialBad - IMG.Mesoscope;

list_sessions = fetch(EXP2.Session*EXP2.SessionID & rel_behavior_trial);

y_regular=[];
y_large=[];
y_small=[];

for i_s = 1:1:numel(list_sessions)
    k_session=list_sessions(i_s);
    % rel_behavior_trial = (EXP2.BehaviorTrialEvent*EXP2.SessionTrial  & 'trial_event_type="go"' & EXP2.TrialRewardSize) - TRACKING.TrackingTrialBad & IMG.Mesoscope;
    
    time_go = fetchn(rel_behavior_trial & k_session,'trial_event_time','ORDER BY trial'); %relative to trial start
    
    L_regular=[fetch(EXP2.ActionEvent*rel_behavior_trial & (EXP2.TrialRewardSize & 'reward_size_type="regular"') & k_session,'*')];
    L_large=[fetch(EXP2.ActionEvent*rel_behavior_trial & (EXP2.TrialRewardSize & 'reward_size_type="large"') & k_session,'*')];
    L_omission=[fetch(EXP2.ActionEvent*rel_behavior_trial & (EXP2.TrialRewardSize & 'reward_size_type="omission"') & k_session,'*')];
    
    T_regular=numel(unique([L_regular.trial_uid]));
    T_large=numel(unique([L_large.trial_uid]));
    T_omission=numel(unique([L_omission.trial_uid]));
    
    
    ValveTime_regular = mean(fetchn(EXP2.TrialRewardSize & 'reward_size_type="regular"' & rel_behavior_trial & k_session,'reward_size_valve_time'));
    ValveTime_large = mean(fetchn(EXP2.TrialRewardSize & 'reward_size_type="large"' & rel_behavior_trial & k_session,'reward_size_valve_time'));
    ValveTime_omission = mean(fetchn(EXP2.TrialRewardSize & 'reward_size_type="omission"' & rel_behavior_trial & k_session,'reward_size_valve_time'));
    
    ValveTime_large/ValveTime_regular;
    %
    % unique([L_regular.trial_uid])
    % for
    
    
    
    licks_time_electric_regular =[L_regular.action_event_time]  - [L_regular.trial_event_time];
    licks_time_electric_large =[L_large.action_event_time]  - [L_large.trial_event_time];
    licks_time_electric_omission =[L_omission.action_event_time]  - [L_omission.trial_event_time];
    
    time_bin_size=0.5;
    time_bins=-1:time_bin_size:4;
        time_bins_centers=time_bins(1:end-1)+mean(diff(time_bins))/2;
    [counts, edges]=histcounts(licks_time_electric_regular,time_bins);
    y_regular(i_s,:) =(counts/T_regular)/time_bin_size; % we divide the count of licktimes for all trials by the number of trials and time bin
    [counts, edges]=histcounts(licks_time_electric_large,time_bins);
    y_large(i_s,:) =(counts/T_large)/time_bin_size;
    [counts, edges]=histcounts(licks_time_electric_omission,time_bins);
    y_small(i_s,:) =(counts/T_omission)/time_bin_size;
    
end

hold on;
lineProps.style='-';
lineProps.width=0.1;

%large
temp_mean=nanmean(y_large,1);
temp_stem=nanstd(y_large,[],1)/sqrt(numel(list_sessions));
lineProps.col={[ 1 0.3 0]};
mseb(time_bins_centers,temp_mean, temp_stem,lineProps);

%small
temp_mean=nanmean(y_small,1);
temp_stem=nanstd(y_small,[],1)/sqrt(numel(list_sessions));lineProps.col={[0 0.7 0.2]};
mseb(time_bins_centers,temp_mean, temp_stem,lineProps);

%regular
temp_mean=nanmean(y_regular,1);
temp_stem=nanstd(y_regular,[],1)/sqrt(numel(list_sessions));lineProps.col={[ 0 0 0.8]};
mseb(time_bins_centers,temp_mean, temp_stem,lineProps);

% title(sprintf('Response time of tuned neurons'));
xl=[time_bins(1),time_bins(end)];
yl=[0 4];
xlim(xl);
ylim(yl);
ylabel(sprintf('Lick rate (licks/s)'));
xlabel('Time to 1st contact-lick (s)');
% title(sprintf('Reward-increase trials\n %.1f licks/trial vs. %.1f on regular trials',sum(y2)*time_bin_size,sum(y1)*time_bin_size),'Color',[1 0.5 0]);
set(gca,'FontSize',6)
 text(xl(1)-diff(xl)*0.7, yl(1)+diff(yl)*1.25, 'a', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');

%% Single cell PSTH example
% Example Cell 1 PSTH
axes('position',[position_x2(1),position_y2(1), panel_width2, panel_height2])
roi_number_uid = 77559;
cell_number=1;
panel_legend='b';
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
title(sprintf('Real \ntuning\n\n'));
panel_legend='c';
axes('position',[position_x2(2),position_y2(1), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);
title(sprintf('Simulated \ntuning\n\n'));

panel_legend=[];
% Example Cell 2 PSTH
axes('position',[position_x2(1),position_y2(2), panel_width2, panel_height2])
roi_number_uid = 77887; %1264855
cell_number=2;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(2), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);


% Example Cell 3 PSTH
axes('position',[position_x2(1),position_y2(3), panel_width2, panel_height2])
roi_number_uid = 1278002;% 1350575;
cell_number=3;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(3), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);


% Example Cell 4 PSTH
axes('position',[position_x2(1),position_y2(4), panel_width2, panel_height2])
roi_number_uid = 1304816;
cell_number=4;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(4), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);

panel_legend=[];
% Example Cell 5 PSTH
axes('position',[position_x2(1),position_y2(5), panel_width2, panel_height2])
roi_number_uid = 1251809;
cell_number=5;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 0, 0,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(5), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);

panel_legend=[];
% Example Cell 6 PSTH
axes('position',[position_x2(1),position_y2(6), panel_width2, panel_height2])
roi_number_uid = 66091;
cell_number=6;
[~, psth_max]=fn_plot_single_cell_psth_example_reward_real(rel_example_psth,roi_number_uid , 1, 1,panel_legend, cell_number);
axes('position',[position_x2(2),position_y2(6), panel_width2, panel_height2])
fn_plot_single_cell_psth_example_reward_poisson(rel_example_psth_poisson,roi_number_uid , 0, 0,panel_legend, [], psth_max);


%% Population analysis -- reward modulation -- real versus Poisson


axes('position',[position_x3(1),position_y3(1), panel_width3, panel_height3])
PSTH = fetch(rel_psth_large_signif,'*');
large = 100*(([PSTH.reward_mean_large]./[PSTH.reward_mean_regular])-1);
large_poisson = 100*(([PSTH.reward_mean_large_poisson]./[PSTH.reward_mean_regular_poisson])-1);
% large = ([PSTH.reward_mean_large]-[PSTH.reward_mean_regular])./([PSTH.reward_mean_large]+[PSTH.reward_mean_regular]);
% large_poisson = ([PSTH.reward_mean_large_poisson]-[PSTH.reward_mean_regular_poisson])./([PSTH.reward_mean_large_poisson]+[PSTH.reward_mean_regular_poisson]);
plot(large,large_poisson,'.','Color',[1 0.3 0])
hold on
plot([-100 100],[-100 100])
xlabel(sprintf('Real Tuning, reward modulation (%%)'))
ylabel(sprintf('Simulated tuning, \n reward modulation (%%)'))
title('Reward-increase modulation');
axis equal
set(gca,'FontSize',6)
xl=[-100,500];
yl=[-100,100];
xlim(xl)
ylim(yl)
 text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.1, 'd', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');


axes('position',[position_x3(1),position_y3(2), panel_width3, panel_height3])
PSTH = fetch(rel_psth_small_signif,'*');
% small = ([PSTH.reward_mean_small]-[PSTH.reward_mean_regular])./([PSTH.reward_mean_small]+[PSTH.reward_mean_regular]);
% small_poisson = ([PSTH.reward_mean_small_poisson]-[PSTH.reward_mean_regular_poisson])./([PSTH.reward_mean_small_poisson]+[PSTH.reward_mean_regular_poisson]);
small = 100*(([PSTH.reward_mean_small]./[PSTH.reward_mean_regular])-1);
small_poisson = 100*(([PSTH.reward_mean_small_poisson]./[PSTH.reward_mean_regular_poisson])-1);
plot(small,small_poisson,'.','Color',[0 0.5 0])
hold on
plot([-100 100],[-100 100])
xlabel(sprintf('Real Tuning, reward modulation (%%)'))
ylabel(sprintf('Simulated tuning, \n reward modulation (%%)'))
title('Reward-omission modulation');
axis equal
set(gca,'FontSize',6)
xl=[-100,500];
yl=[-100,100];
xlim(xl)
ylim(yl)
 text(xl(1)-diff(xl)*0.2, yl(1)+diff(yl)*1.1, 'e', ...
        'fontsize', 12, 'fontname', 'helvetica', 'fontweight', 'bold');








if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




