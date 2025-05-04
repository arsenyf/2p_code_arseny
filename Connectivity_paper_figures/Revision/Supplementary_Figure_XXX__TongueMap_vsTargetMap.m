function Supplementary_Figure_XXX__TongueMap_vsTargetMap
close all;


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];

filename=[sprintf('Revision_Supplementary_Figure_XXX__TongueMap_vsTargetMap')];


rel_roi_initial=PAPER.ROILICK2DInclusion;
p_value_threshold=0.05;

% just the cells
rel_positional_signif = rel_roi_initial  ...
    &  (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

rel_roi=rel_positional_signif;

% rel_roi=PAPER.ROILICK2DInclusionWithMesoscope;
rel_tuning2target_stability = LICK2D.ROILick2DmapStatsSpikes & (rel_roi & LICK2D.ROILick2DmapStatsSpikesTongueMap);
rel_tuning2tongue_stability = LICK2D.ROILick2DmapStatsSpikesTongueMap & (rel_roi & LICK2D.ROILick2DmapStatsSpikes);

tuning2target_stability_all = fetchn(rel_tuning2target_stability, 'lickmap_regular_odd_vs_even_corr');
tuning2tongue_stability_all= fetchn(rel_tuning2tongue_stability, 'lickmap_regular_odd_vs_even_corr');

subplot(3,2,1)
hold on;
scatter(tuning2target_stability_all,tuning2tongue_stability_all,5, 'filled','MarkerFaceAlpha',0.05);
plot([-1,1],[-1,1],'-k')
xlabel(sprintf('Tuning stability \nbased on target position'))
ylabel(sprintf('Tuning stability \nbased on tongue position'))
title(sprintf('Mean r = %.2f target,\n Mean r = %.2f tongue',mean(tuning2target_stability_all),mean(tuning2tongue_stability_all)))
mean(tuning2target_stability_all)
mean(tuning2tongue_stability_all)
[h,p]=ttest2(tuning2target_stability_all,tuning2tongue_stability_all);





rel_tuning2target_modulation = LICK2D.ROILick2DmapSpikesModulation & (rel_roi & LICK2D.ROILick2DmapSpikesModulationTongue);
rel_tuning2tongue_modulation= LICK2D.ROILick2DmapSpikesModulationTongue & (rel_roi & LICK2D.ROILick2DmapSpikesModulation);
tuning2target_modulation_all = fetchn(rel_tuning2target_modulation, 'lickmap_fr_regular_modulation');
tuning2tongue_modulation_all= fetchn(rel_tuning2tongue_modulation, 'lickmap_fr_regular_modulation');


subplot(3,2,2)
plot(tuning2target_modulation_all,tuning2tongue_modulation_all,'.k')
xlabel('Tuning modulation based on target position')
ylabel('Tuning modulation based on tongue position')
title(sprintf('Mean modulation = %.1f target,\n Mean modulation = %.2f tongue',mean(tuning2target_modulation_all),mean(tuning2tongue_modulation_all)))
mean(tuning2target_modulation_all)
mean(tuning2tongue_modulation_all)










%% Now same but per day

max_number_days=7;
for i_d=1:1:max_number_days
    key.behavioral_session_number=i_d;
    rel_current_behavioral_day = EXP2.SessionBehavioral*EXP2.SessionID & rel_roi & key & LICK2D.ROILick2DmapSpikesModulationTongue;
    keys=fetch(rel_current_behavioral_day);
    tuning2target_stability_day=[];
    tuning2tongue_stability_day=[];
    tuning2target_modulation_day=[];
    tuning2tongue_modulation_day=[];
    % looping across sessions in this day
    for i_k=1:1:numel(keys)
        
        % stability of significant cells by day
        
        tuning2target_stability_day(i_k)=nanmean(fetchn(rel_tuning2target_stability & rel_current_behavioral_day & keys(i_k), 'lickmap_regular_odd_vs_even_corr'));
        tuning2tongue_stability_day(i_k)=nanmean(fetchn(rel_tuning2tongue_stability & rel_current_behavioral_day & keys(i_k), 'lickmap_regular_odd_vs_even_corr'));
        
        
        % modulation of significant cells by day
        tuning2target_modulation_day(i_k)=nanmean(fetchn(rel_tuning2target_modulation & rel_current_behavioral_day & keys(i_k), 'lickmap_fr_regular_modulation'));
        tuning2tongue_modulation_day(i_k)=nanmean(fetchn(rel_tuning2tongue_modulation & rel_current_behavioral_day & keys(i_k), 'lickmap_fr_regular_modulation'));
        
        
    end
    
    % mean and stem across sessions on this day (sessions correspond to different animals recorded on this day)
    tuning2target_stability_day_mean(i_d)=nanmean(tuning2target_stability_day);
    tuning2target_stability_day_stem(i_d)=std(tuning2target_stability_day)/sqrt(numel(i_k));
    
    tuning2tongue_stability_day_mean(i_d)=nanmean(tuning2tongue_stability_day);
    tuning2tongue_stability_day_stem(i_d)=std(tuning2tongue_stability_day)/sqrt(numel(i_k));
    
    tuning2target_modulation_day_mean(i_d)=nanmean(tuning2target_modulation_day);
    tuning2target_modulation_day_stem(i_d)=std(tuning2target_modulation_day)/sqrt(numel(i_k));
    
    tuning2tongue_modulation_day_mean(i_d)=nanmean(tuning2tongue_modulation_day);
    tuning2tongue_modulation_day_stem(i_d)=std(tuning2tongue_modulation_day)/sqrt(numel(i_k));
end



% Modulation of signficant cells
subplot(3,2,3)
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%target red
mseb(1:max_number_days,tuning2target_stability_day_mean,tuning2target_stability_day_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%tongue blue
mseb(1:max_number_days,tuning2tongue_stability_day_mean,tuning2tongue_stability_day_stem,lineProps);
xlabel('Sessions');
ylabel('Tuning stability, r');
legend({'Target tuning', 'Tongue tuning'},'Location', 'SouthWest')
ylim([0,1])

subplot(3,2,4)
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%target red
mseb(1:max_number_days,tuning2target_modulation_day_mean,tuning2target_modulation_day_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%tongue blue
mseb(1:max_number_days,tuning2tongue_modulation_day_mean,tuning2tongue_modulation_day_stem,lineProps);
xlabel('Sessions');
ylabel('Tuning modulation (%)');
legend({'Target tuning', 'Tongue tuning'},'Location', 'SouthWest')
ylim([0,100])


if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf -r200']);




