function ANALYSIS_PHOTOSTIM_PAPER6()

Summary_statistics ()

STIMANAL.SessionEpochsIncludedFinal %% manually update session info here
STIMANAL.SessionEpochsIncludedFinalUniqueEpochs
% photostim_direct_new()
% distance_dependence_new()


% XYZ coordinate correction of ETL abberations based on ETL callibration
populate(STIM.ROIInfluence2)
populate(STIM.ROIInfluenceNoZscore);
populate(STIM.ROIInfluence); %should be the  same as STIM.ROIInfluence2 but also saves the response trace into STIM.ROIInfluenceTraceLong  
populate(STIM.ROIInfluenceDFF); %based on DFF (except for target neuron selection that is based on spikes)
populate(STIM.ROIInfluence3);  %similar to STIM.ROIInfluence2 but with larger window for determining peak response



populate(STIM.ROIResponseDirect2);
populate(STIM.ROIResponseDirectUnique);
populate(STIMANAL.NeuronOrControl);
populate(STIMANAL.NeuronOrControlNumber);
populate(STIMANAL.ConnectivityBetweenDirectlyStimulatedOnly);
populate(ConnectivityBetweenDirectlyStimulatedOnlyOverconnected);
populate(STIMANAL.ControlTargetsIntermingled);
populate(STIMANAL.InfluenceDistanceIngermingledControl);

populate(STIMANAL.ROIResponseDirectVariability)
populate(STIMANAL.ROIInfluenceVariability) % follows the signficance definition criteria in the paper
populate(STIMANAL.ROIInfluenceVariability2) % also plots the response, for more significant neurons
populate(STIMANAL.ROIInfluenceVariability3) 

populate(STIMANAL.ROIResponseDirectVariabilitySpikes)
populate(STIMANAL.ROIInfluenceVariabilitySpikes)

populate(STIMANAL.InfluenceDistance);
populate(STIMANAL.InfluenceDistanceNoZscore);
populate(STIMANAL.ROIGraphAll) % ETL corrected
populate(STIMANAL.OutDegree)
populate(POP.ROICorrLocalPhoto2); %spikes
% populate(POP.ROICorrLocalPhoto); %delta F

populate(STIMANAL.ROIResponseDirectVariability);
populate(STIMANAL.ROIInfluenceVariability);
populate(STIMANAL.ConnectivityBetweenDirectlyStimulatedOnlyOverconnected);

PLOT_ConnectionProbabilityDistance()
PLOT_ConnectionProbabilityDistance_short_distance_included
PLOT_ConnectionProbabilityDistance_control_intermingled
PLOT_ConnectionProbabilityDistance_Eucledian()
PLOT_Control_targets_distribution

PLOT_InfluenceDistance()
PLOT_InfluenceDistanceShort_Distance_Included()


% PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle() %directional, temporal, and reward tuning -- this is what I show in presentations
% PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle2() %directional, temporal, and reward tuning -- this is what I show in presentations
% PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle2_temp() %directional, temporal, and reward tuning -- this is what I show in presentations
PLOT_Network_Degree_vs_tuning_final()

% PLOT_Network_Degree_InOutCorr

fn_analysis_connectivity_versus_outdegree

Plot_in_out_degree_and_bidirectional_connectivity



%% Influence versus noise correlations 
populate(STIMANAL.Target2AllCorrTraceSpont);%based on spikes
populate(STIMANAL.InfluenceVsCorrTraceSpont2);
populate(STIMANAL.InfluenceVsCorrTraceSpontShuffled2); 
% populate(STIMANAL.InfluenceVsCorrTraceSpontResidual); 
% PLOT_InfluenceVsCorrTraceSpontResidual();
PLOT_InfluenceVsCorrTraceSpontShuffledDiff();

populate(STIMANAL.Target2AllCorrTraceBehav);%based on spikes
populate(STIMANAL.InfluenceVsCorrTraceBehav2);
populate(STIMANAL.InfluenceVsCorrTraceBehavShuffled2); 
% populate(STIMANAL.InfluenceVsCorrTraceBehavResidual); 
% PLOT_InfluenceVsCorrTraceBehavResidual();
PLOT_InfluenceVsCorrTraceBehavShuffledDiff(); 


%% Influence versus signal correlations (based on 2D map)
populate(STIMANAL.Target2AllCorrMap); 
populate(STIMANAL.InfluenceVsCorrMap); %lickmap_regular_odd_vs_even_corr>0
populate(STIMANAL.InfluenceVsCorrMapShuffled);  %lickmap_regular_odd_vs_even_corr>0
% populate(STIMANAL.InfluenceVsCorrMap2);  %lickmap_regular_odd_vs_even_corr>0.25
% populate(STIMANAL.InfluenceVsCorrMapShuffled2);  %lickmap_regular_odd_vs_even_corr>0.25
% PLOT_InfluenceVsCorrMapShuffledDiff2(); 

populate(STIMANAL.InfluenceVsCorrMap3); %lickmap_regular_odd_vs_even_corr>0 & lickmap_fr_regular_modulation>=25
populate(STIMANAL.InfluenceVsCorrMapShuffled3);  %lickmap_regular_odd_vs_even_corr>0 & lickmap_fr_regular_modulation>=25
PLOT_InfluenceVsCorrMapShuffledDiff(); 

%Revision -- using shuffling on location tuning for inclusion
populate(STIMANAL.InfluenceVsCorrMap4); %lickmap_regular_odd_vs_even_corr>0 & lickmap_fr_regular_modulation>=25
populate(STIMANAL.InfluenceVsCorrMapShuffled4);  %lickmap_regular_odd_vs_even_corr>0 & lickmap_fr_regular_modulation>=25



%% Influence versus signal correlations (based on PSTH)
populate(STIMANAL.Target2AllCorrPSTH); 
populate(STIMANAL.InfluenceVsCorrPSTH);  
populate(STIMANAL.InfluenceVsCorrPSTHShuffled);  
PLOT_InfluenceVsCorrPSTHShuffledDiff(); 


%% Influence versus signal correlations (based on PSTH concatenated)
populate(STIMANAL.Target2AllCorrConcat); 
populate(STIMANAL.InfluenceVsCorrConcat); 
populate(STIMANAL.InfluenceVsCorrConcatShuffled); 
PLOT_InfluenceVsCorrConcatShuffledDiff(); 


% %% Influence versus signal correlations (based on Angular preferred direction)
% populate(STIMANAL.Target2AllCorrAngle);
% populate(STIMANAL.InfluenceVsCorrAngle);  
% populate(STIMANAL.InfluenceVsCorrAngleShuffled); 
% PLOT_InfluenceVsCorrAngleShuffledDiff();
% 
% %% Influence versus signal correlations (based on Angular tuning)
% populate(STIMANAL.Target2AllCorrAngleTuning);
% populate(STIMANAL.InfluenceVsCorrAngleTuning);
% populate(STIMANAL.InfluenceVsCorrAngleTuningShuffled); 
% PLOT_InfluenceVsCorrAngularTuningShuffledDiff(); 




%% Correlations 
PLOT_CorrPairwiseDistanceVoxels()

PLOT_CorrPairwiseDistanceSpikes_MesoSinglePlane()
PLOT_CorrPairwiseDistanceSpikes_MesoVolumetric()
PLOT_CorrPairwiseDistanceSpikes_PhotoRigVolumetric()



%% Revision
% Modulation of neihborhood
populate(LICK2D.DistanceTuningColumnsMapsSpikes)
%Similarity of tuning between target and connected cells as a function o target out-degree
populate(STIMANAL.Target2ConnectedCorrTuningMap)
populate(STIMANAL.Target2ConnectedCorrTuningMap2)
PLOT_Network_Degree_vs_tuning_similarity_to_connected_neurons()

Revision_Figure1_firstlick_lastlick_tuning
Revision_Figure2_Tuning_across_sessions_and_block_pvalue_signif()
Supplementary_Figure_XXX__TongueMap_vsTargetMap()
Supplementary_Figure1_number_of_success_trials_across_sessions


% GLM for licks
populate(LICK2D.ROILick2DPSTHSpikesGLM) % also populates LICK2D.ROILick2DPSTHStatsSpikesGLM
populate(LICK2D.ROILick2DPSTHSpikesGLM2) % also populates LICK2D.ROILick2DPSTHStatsSpikesGLM2 -- different binning, time and spline definition. Not used eventually.

% Opsing density
populate(STIMANAL.TargetsDensity)

% Inhibitory interactions
populate(STIMANAL.InfluenceVsCorrMap3Inhibitory)
populate(STIMANAL.InfluenceVsCorrMapShuffled3Inhibitory)


populate(STIMANAL.InfluenceVsCorrMap3Inhibitory2)
populate(STIMANAL.InfluenceVsCorrMapShuffled3Inhibitory2)

populate(STIMANAL.InfluenceVsCorrMap3Inhibitory3)
populate(STIMANAL.InfluenceVsCorrMapShuffled3Inhibitory3)

populate(STIMANAL.InfluenceVsCorrMap3Inhibitory4)
populate(STIMANAL.InfluenceVsCorrMapShuffled3Inhibitory4)
