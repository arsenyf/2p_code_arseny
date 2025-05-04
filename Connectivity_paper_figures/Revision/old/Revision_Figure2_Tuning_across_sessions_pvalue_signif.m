function Revision_Figure2_Tuning_across_sessions_pvalue_signif ()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename = 'Revision_TuningStatistics_across_sessions_pvalue_signif';
figure



rel_roi=PAPER.ROILICK2DInclusion & (LAB.Subject & (EXP2.SessionBehavioral & 'behavioral_session_number>=5'));

% significance based on modulation p-value
%---------------------------------------------
p_value_threshold=0.05;

rel_temporal_signif = rel_roi  ...
  &   (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold));

rel_positional_signif = rel_roi  ...
    &  (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold));

rel_modulation_temporal_signif = (LICK2D.ROILick2DPSTHSpikesModulation) ...
    & (LICK2D.ROILick2DPSTHSpikesPvalue &  sprintf('psth_regular_modulation_pval<=%.2f',p_value_threshold))  ...
    & rel_roi;

rel_modulation_positional_signif = (LICK2D.ROILick2DmapSpikes3binsModulation)  ...
   & (LICK2D.ROILick2DmapSpikes3binsPvalue2 &  sprintf('lickmap_fr_regular_modulation_pval<=%.2f',p_value_threshold)) ...
    & rel_roi;

% significance based on modulation and stability thresholds
%---------------------------------------------
% psth_regular_odd_vs_even_corr=0.25;
% lickmap_regular_odd_vs_even_corr_threshold=0.25;
% lickmap_fr_regular_modulation_threshold=25;
% psth_regular_modulation_threshold=25;
% rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('psth_regular_odd_vs_even_corr>=%.2f',psth_regular_odd_vs_even_corr)) ...
%     & (LICK2D.ROILick2DPSTHSpikesModulation & sprintf('psth_regular_modulation>=%.2f',psth_regular_modulation_threshold));
% 
% rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold)) ...
%     & (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold));
% 
% rel_modulation_temporal_signif = (LICK2D.ROILick2DPSTHSpikesModulation & sprintf('psth_regular_modulation>=%.2f',psth_regular_modulation_threshold)) & ...
%     (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('psth_regular_odd_vs_even_corr>=%.2f',psth_regular_odd_vs_even_corr))  ...
%     & rel_roi;
% 
% rel_modulation_positional_signif = (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold)) & ...
%     (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold)) ...
%     & rel_roi;


percent_signif_days_temporal_mean=[];
percent_signif_days_temporal_stem=[];

percent_signif_days_positional_mean=[];
percent_signif_days_positional_stem=[];

modulation_signif_days_temporal_mean=[];
modulation_signif_days_temporal_stem=[];

modulation_signif_days_positional_mean=[];
modulation_signif_days_positional_stem=[];


max_number_days=5;
for i_d=1:1:max_number_days
    key.behavioral_session_number=i_d;
    rel_current_behavioral_day = EXP2.SessionBehavioral*EXP2.SessionID & rel_roi & key;
    keys=fetch(rel_current_behavioral_day);
    total_count=[];
    temporal_count=[];
    positional_count=[];
    temporal_modulation=[];
    positional_modulation=[];
    % looping across sessions in this day
    for i_k=1:1:numel(keys)
        % percentages of significant cells by day
        temp_rel=rel_roi & rel_current_behavioral_day & keys(i_k);
        total_count(i_k)=temp_rel.count;
        
        temp_rel_temporal=rel_temporal_signif & rel_current_behavioral_day & keys(i_k);
        temporal_count(i_k)=temp_rel_temporal.count;
        
        temp_rel_pos=rel_positional_signif & rel_current_behavioral_day & keys(i_k);
        positional_count(i_k)=temp_rel_pos.count;
        
        % modulation of significant cells by day
        temporal_modulation(i_k)=nanmean(fetchn(rel_modulation_temporal_signif & temp_rel_temporal,'psth_regular_modulation'));
        positional_modulation(i_k)=nanmean(fetchn(rel_modulation_positional_signif & temp_rel_pos,'lickmap_fr_regular_modulation'));
        
        
    end
    
    % mean and stem across sessions on this day (sessions correspond to different animals recorded on this day) 
    percent_signif_days_temporal_mean(i_d)=mean(100*temporal_count./total_count);
    percent_signif_days_temporal_stem(i_d)=std(100*temporal_count./total_count)/sqrt(numel(total_count));
    
    percent_signif_days_positional_mean(i_d)=mean(100*positional_count./total_count);
    percent_signif_days_positional_stem(i_d)=std(100*positional_count./total_count)/sqrt(numel(total_count));

    
    
    modulation_signif_days_temporal_mean(i_d)=mean(temporal_modulation);
    modulation_signif_days_temporal_stem(i_d)=std(temporal_modulation)/sqrt(numel(temporal_modulation));
    
    modulation_signif_days_positional_mean(i_d)=mean(mean(positional_modulation));
    modulation_signif_days_positional_stem(i_d)=std(positional_modulation)/sqrt(numel(positional_modulation));

end

% Percentage of signifcant cells
subplot(2,2,1)
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb(1:max_number_days,percent_signif_days_temporal_mean,percent_signif_days_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb(1:max_number_days,percent_signif_days_positional_mean,percent_signif_days_positional_stem,lineProps);
xlabel('Sessions');
ylabel('Tuned cells (%)');
legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])

% Modulation of signficant cells
subplot(2,2,2)
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb(1:max_number_days,modulation_signif_days_temporal_mean,modulation_signif_days_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb(1:max_number_days,modulation_signif_days_positional_mean,modulation_signif_days_positional_stem,lineProps);
xlabel('Sessions');
ylabel('Tuning modulation (%)');
legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])



if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
eval(['print ', figure_name_out, ' -dpdf -r200']);
