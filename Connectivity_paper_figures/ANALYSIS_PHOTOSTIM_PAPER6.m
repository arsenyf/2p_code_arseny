function ANALYSIS_PHOTOSTIM_PAPER6()

STIMANAL.SessionEpochsIncludedFinal %% manually update session info here

% photostim_direct_new()
% distance_dependence_new()


% XYZ coordinate correction of ETL abberations based on ETL callibration
populate(STIM.ROIInfluence2)
populate(STIM.ROIInfluenceNoZscore);
populate(STIM.ROIResponseDirect2);
populate(STIM.ROIResponseDirectUnique);
populate(STIMANAL.NeuronOrControl);
populate(STIMANAL.NeuronOrControlNumber);
populate(STIMANAL.ConnectivityBetweenDirectlyStimulatedOnly);
populate(STIMANAL.ControlTargetsIntermingled);
populate(STIMANAL.InfluenceDistanceIngermingledControl);

populate(STIMANAL.InfluenceDistance);
populate(STIMANAL.InfluenceDistanceNoZscore);
populate(STIMANAL.ROIGraphAll) % ETL corrected
populate(STIMANAL.OutDegree)
populate(POP.ROICorrLocalPhoto2); %spikes
populate(POP.ROICorrLocalPhoto); %delta F




PLOT_ConnectionProbabilityDistance()
PLOT_ConnectionProbabilityDistance_short_distance_included
PLOT_ConnectionProbabilityDistance_control_intermingled
PLOT_Control_targets_distribution

PLOT_InfluenceDistance()
PLOT_InfluenceDistanceShort_Distance_Included()

STIMANAL.InfluenceDistanceIngermingledControl

% PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle() %directional, temporal, and reward tuning -- this is what I show in presentations
PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle2() %directional, temporal, and reward tuning -- this is what I show in presentations

PLOT_Network_Degree_vs_tuning_ETL__final_with_shuffle2_temp() %directional, temporal, and reward tuning -- this is what I show in presentations

PLOT_Network_Degree_InOutCorr

fn_analysis_connectivity_versus_outdegree

%% Influence versus noise correlations 
populate(STIMANAL.Target2AllCorrTraceSpont);%based on spikes
populate(STIMANAL.InfluenceVsCorrTraceSpont);
populate(STIMANAL.InfluenceVsCorrTraceSpontShuffled); 

populate(STIMANAL.InfluenceVsCorrTraceSpontResidual); 

PLOT_InfluenceVsCorrTraceSpontResidual()


populate(STIMANAL.Target2AllCorrTraceBehav);%based on spikes
populate(STIMANAL.InfluenceVsCorrTraceBehav);
populate(STIMANAL.InfluenceVsCorrTraceBehavShuffled); 

populate(STIMANAL.InfluenceVsCorrTraceBehavResidual); 

PLOT_InfluenceVsCorrTraceBehavResidual()


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
% 
% populate(STIMANAL.InfluenceVsCorrAngle);  
% populate(STIMANAL.InfluenceVsCorrAngleShuffled); 
% 
% PLOT_InfluenceVsCorrAngleShuffledDiff();
% 
% %% Influence versus signal correlations (based on Angular tuning)
% populate(STIMANAL.Target2AllCorrAngleTuning);
% 
% populate(STIMANAL.InfluenceVsCorrAngleTuning);
% populate(STIMANAL.InfluenceVsCorrAngleTuningShuffled); 
% 
% PLOT_InfluenceVsCorrAngularTuningShuffledDiff(); 


%% Influence versus signal correlations (based on 2D map concatenated)
populate(STIMANAL.Target2AllCorrMap); 

populate(STIMANAL.InfluenceVsCorrMap); 
populate(STIMANAL.InfluenceVsCorrMapShuffled); 

PLOT_InfluenceVsCorrMapShuffledDiff(); 

%% Correlations 
PLOT_CorrPairwiseDistanceVoxels()

PLOT_CorrPairwiseDistanceSpikes_MesoSinglePlane()
PLOT_CorrPairwiseDistanceSpikes_MesoVolumetric()
PLOT_CorrPairwiseDistanceSpikes_PhotoRigVolumetric()
