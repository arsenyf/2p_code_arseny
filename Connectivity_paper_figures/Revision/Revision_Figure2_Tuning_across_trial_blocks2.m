function Revision_Figure2_Tuning_across_trial_blocks2 ()
close all
dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\Connectivity_paper_figures\plots\Revision\'];
filename = 'Revision_TuningStatistics_across_blocks';
figure


psth_regular_odd_vs_even_corr=0.25;
lickmap_regular_odd_vs_even_corr_threshold=0.25;
lickmap_fr_regular_modulation_threshold=25;
psth_regular_modulation_threshold=25;


rel_roi=PAPER.ROILICK2DInclusion & (LAB.Subject & (EXP2.SessionBehavioral & 'behavioral_session_number>=5'));

rel_signif_temporal = (LICK2D.ROILick2DPSTHStatsSpikes & sprintf('psth_regular_odd_vs_even_corr>=%.2f',psth_regular_odd_vs_even_corr)) & (LICK2D.ROILick2DPSTHSpikesModulation & sprintf('psth_regular_modulation>=%.2f',psth_regular_modulation_threshold)) & rel_roi;
rel_signif_positional = (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold)) & (LICK2D.ROILick2DmapSpikes3binsModulation & sprintf('lickmap_fr_regular_modulation>=%.2f',lickmap_fr_regular_modulation_threshold))  & rel_roi;


 


percent_signif_blocks_temporal_mean=[];
percent_signif_blocks_temporal_stem=[];

percent_signif_blocks_positional_mean=[];
percent_signif_blocks_positional_stem=[];

modulation_signif_blocks_temporal_mean=[];
modulation_signif_blocks_temporal_stem=[];

modulation_signif_blocks_positional_mean=[];
modulation_signif_blocks_positional_stem=[];


keys=   fetch(EXP2.SessionEpoch & rel_roi & 'session_epoch_number=3' & 'session_epoch_type="behav_only"');

number_blocks=4;
for i_b=1:1:number_blocks
   
  
    
    total_count=[];
    temporal_count=[];
    positional_count=[];
    temporal_modulation=[];
    positional_modulation=[];
    
   
    % looping across sessions 
    for i_k=1:1:numel(keys)
        % percentages of significant cells by block
        temp_rel=rel_roi  & keys(i_k);
        total_count(i_k)=temp_rel.count;
        
        temp_rel_temporal= rel_signif_temporal  & keys(i_k);
        temporal_count(i_k)=temp_rel_temporal.count;
        
        temp_rel_pos=rel_signif_positional & keys(i_k);
        positional_count(i_k)=temp_rel_pos.count;
        
        % modulation of significant cells by block
        if i_b==1
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_first_modulation'));
            positional_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_first_modulation'));
        elseif i_b==2
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_begin_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_begin_modulation'));
        elseif i_b==3
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_mid_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_mid_modulation'));
        elseif i_b==4
            temporal_modulation(i_k)=nanmean(fetchn(LICK2D.ROILick2DPSTHSpikesModulation &  temp_rel_temporal,'psth_end_modulation'));
            positional_modulation(i_k) = nanmean(fetchn(LICK2D.ROILick2DmapSpikes3binsModulation & temp_rel_pos,'lickmap_fr_end_modulation'));
        end
        
        
    end
    
    percent_signif_blocks_temporal_mean(i_b)=mean(100*temporal_count./total_count);
    percent_signif_blocks_temporal_stem(i_b)=std(100*temporal_count./total_count)/sqrt(numel(total_count));
    
    percent_signif_blocks_positional_mean(i_b)=mean(100*positional_count./total_count);
    percent_signif_blocks_positional_stem(i_b)=std(100*positional_count./total_count)/sqrt(numel(total_count));

    
    modulation_signif_blocks_temporal_mean(i_b)=mean(temporal_modulation);
    modulation_signif_blocks_temporal_stem(i_b)=std(temporal_modulation)/sqrt(numel(temporal_modulation));
    
    modulation_signif_blocks_positional_mean(i_b)=mean(nanmean(positional_modulation));
    modulation_signif_blocks_positional_stem(i_b)=nanstd(positional_modulation)/sqrt(numel(positional_modulation));

end

% Percentage of signifcant cells
subplot(2,2,1)
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb([1,3,4,7],percent_signif_blocks_temporal_mean,percent_signif_blocks_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb([1,3,4,7],percent_signif_blocks_positional_mean,percent_signif_blocks_positional_stem,lineProps);
xlabel('Trial in Block');
ylabel('Tuned cells (%)');
legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])
xlim([1,7]);

% Modulation of signficant cells
subplot(2,2,2)
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='-';
lineProps.width=0.25;
%temporal red
mseb([1,3,4,7],modulation_signif_blocks_temporal_mean,modulation_signif_blocks_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='-';
lineProps.width=0.25;
%positional blue
mseb([1,3,4,7],modulation_signif_blocks_positional_mean,modulation_signif_blocks_positional_stem,lineProps);
xlabel('Trial in Block');
ylabel('Tuning modulation (%)');
legend({'Temporal tuning', 'Location tuning'},'Location', 'SouthWest')
ylim([0,100])
xlim([1,7]);

if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
eval(['print ', figure_name_out, ' -dpdf -r200']);
