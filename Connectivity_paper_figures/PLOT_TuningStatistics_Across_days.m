function PLOT_TuningStatistics_Across_days ()

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  'Connectivity_paper_figures\plots\'];
filename = 'TuningStatistics_across_days';


psth_regular_odd_vs_even_corr=0.25;
lickmap_regular_odd_vs_even_corr_threshold=0.25;
%             information_per_spike_regular_threshold=0.1;
% rel_roi=IMG.ROI & IMG.Mesoscope;
rel_roi=PAPER.ROILICK2DInclusion;
rel_temporal_signif = rel_roi & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & sprintf('psth_regular_odd_vs_even_corr>=%.2f',psth_regular_odd_vs_even_corr));
rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('lickmap_regular_odd_vs_even_corr>=%.2f',lickmap_regular_odd_vs_even_corr_threshold));
%             rel_positional_signif = rel_roi & (LICK2D.ROILick2DmapStatsSpikes3binsShort & sprintf('information_per_spike_regular>=%.2f',information_per_spike_regular_threshold));


figure
roi_days_total_mean=[];
roi_days_total_stem=[];

roi_days_temporal_mean=[];
roi_days_temporal_stem=[];

roi_days_positional_mean=[];
roi_days_positional_stem=[];

max_number_days=5;
for i_d=1:1:max_number_days
    key.behavioral_session_number=i_d;
    rel_current_behavioral_day = EXP2.SessionBehavioral*EXP2.SessionID & rel_roi & key;
    keys=fetch(rel_current_behavioral_day);
    total=[];
    temporal=[];
    positional=[];
    for i_k=1:1:numel(keys)
        temp=rel_roi & rel_current_behavioral_day & keys(i_k);
        total(i_k)=temp.count;
        temp=rel_temporal_signif & rel_current_behavioral_day & keys(i_k);
        temporal(i_k)=temp.count;
        temp=rel_positional_signif & rel_current_behavioral_day & keys(i_k);
        positional(i_k)=temp.count;
    end
    roi_days_total_mean(i_d)=mean(total);
    roi_days_total_stem(i_d)=std(total)/sqrt(numel(total));
    
    roi_days_temporal_mean(i_d)=mean(temporal./total);
    roi_days_temporal_stem(i_d)=std(temporal./total)/sqrt(numel(total));
    
    roi_days_positional_mean(i_d)=mean(positional./total);
    roi_days_positional_stem(i_d)=std(positional./total)/sqrt(numel(total));
    
end

subplot(2,2,1)
hold on
hold on
lineProps.col={[1 0 0]};
lineProps.style='.-';
lineProps.width=0.25;
mseb(1:max_number_days,roi_days_temporal_mean,roi_days_temporal_stem,lineProps);
lineProps.col={[0 0 1]};
lineProps.style='.-';
lineProps.width=0.25;
mseb(1:max_number_days,roi_days_positional_mean,roi_days_positional_stem,lineProps);

ylim([0,1])
if isempty(dir(dir_current_fig))
    mkdir (dir_current_fig)
end
%
figure_name_out=[ dir_current_fig filename];
eval(['print ', figure_name_out, ' -dtiff  -r200']);
% eval(['print ', figure_name_out, ' -dpdf -r200']);
