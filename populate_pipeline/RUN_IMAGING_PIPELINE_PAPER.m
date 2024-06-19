function RUN_IMAGING_PIPELINE_PAPER()

% % % EXAMPLE how to delete directly from SQL:
% % %conn = dj.conn;
% % %conn.query('DROP TABLE `arseny_analysis_pop`.`__r_o_i_s_v_d`')'

% DJconnect;
rig='imaging1';
user_name ='ars';

dir_base_behavior ='G:\Arseny\2p\BPOD_behavior\';

% dir_behavioral_data = [dir_base_behavior 'anm447991_AF13\'];
% dir_behavioral_data = [dir_base_behavior 'anm445873_ST68\]'
% dir_behavioral_data = [dir_base_behavior 'anm445980_ST66\'];
% dir_behavioral_data = [dir_base_behavior 'anm447990_AF14\'];
% dir_behavioral_data = [dir_base_behavior 'anm462458_AF17\'];
% dir_behavioral_data = [dir_base_behavior 'anm462455_AF23\'];
% dir_behavioral_data = [dir_base_behavior 'anm463190_AF26\'];
% dir_behavioral_data = [dir_base_behavior 'anm463189_AF27\'];
% dir_behavioral_data = [dir_base_behavior 'anm464724_AF28\'];
% dir_behavioral_data = [dir_base_behavior 'anm464725_AF29\'];
% dir_behavioral_data = [dir_base_behavior 'anm463192_AF25\'];
% dir_behavioral_data = [dir_base_behavior 'anm464728_AF32\'];
% dir_behavioral_data = [dir_base_behavior 'anm481102_AF33\'];
% dir_behavioral_data = [dir_base_behavior 'anm486673_AF34\'];
% dir_behavioral_data = [dir_base_behavior 'anm486668_AF35\'];
% dir_behavioral_data = [dir_base_behavior 'anm481101_AF36\'];
% dir_behavioral_data = [dir_base_behavior 'anm490663_AF37\'];
% dir_behavioral_data = [dir_base_behavior 'anm492791_AF38\'];
% dir_behavioral_data = [dir_base_behavior 'anm480483_AF41\'];
% dir_behavioral_data = [dir_base_behavior 'anm496552_AF42\'];
% dir_behavioral_data = [dir_base_behavior 'anm496912_AF43\'];
dir_behavioral_data = [dir_base_behavior 'anm491362_AF44\'];
% dir_behavioral_data = [dir_base_behavior 'anm496916_AF45\'];



% populate_somatotopy; %populate EXP2.SessionEpochSomatotopy, in case somatopic mapping was done

behavioral_protocol_name='af_2D';
% behavioral_protocol_name='waterCue';

IMG.Parameters; %configure the path to your data folder here



%% STEP 0 - populate LAB (for each new person/rig/animal)
% populate_LAB_new_Rig_Person_Animal() % 

% Definition tables - make sure they are not empty by running them
% EXP2.ActionEventType;
% EXP2.TrialEventType;
% EXP2.TrainingType;
% EXP2.Task;
% EXP2.TrialNameType;
% EXP2.EarlyLick;
% EXP2.Outcome;
% EXP2.TrialInstruction;
% EXP2.TaskProtocol;
% EXP2.EpochName;
% EXP2.EpochName2;
% EXP2.SessionEpochType
% IMG.Zoom2Microns

%% STEP 1 - could be run independelty of suite2p
populate_Session_without_behavior (user_name, rig); % populate session without behavior
% populate_behavior_WaterCue (dir_behavioral_data, behavioral_protocol_name);
populate_behavior_Lick2D(dir_behavioral_data, behavioral_protocol_name); %also EXP2.SessionTrial

% populate_Session_and_behavior (dir_behavioral_data, user_name, rig); % populate session with behavior

populate(EXP2.SessionBehavioral) %it just tells if this is session is the first, sencond etc among behavioral sessions

% should run after populate_behavior_Lick2D
populate(EXP2.SessionEpoch); % reads info about FOV and trial duration from SI files. Also populates EXP2.SessionEpochDirectory, IMG.SessionEpochFrame, IMG.FrameTime, IMG.FrameStartFile

% flag_do_registration=1;
% flag_find_bad_frames_only=0;
% ReplaceAndRegisterFrames(flag_do_registration, flag_find_bad_frames_only);
% 

%% STEP 2 - run suite2p (outside this script)
% IMG.Bregma
populate(IMG.FOV); % also populates IMG.Plane, IMG.PlaneCoordinates, IMG.PlaneDirectory, IMG.PlaneSuite2p
populate(IMG.FOVEpoch); 
populate(IMG.SessionEpochFramePlane); %deals with missing frames at the end of the session epoch in some planes, due to volumetric imaging

populate(IMG.Volumetric);

populate(IMG.ROI); %also populates IMG.ROIdepth
populate(IMG.ROIBrainArea); % requires IMG.Bregma  Assigns brain area in Allen Brain Atlas reference frames
populate(IMG.ROIGood); 
populate(IMG.ROITrace); 
populate(IMG.ROISpikes);
populate(IMG.ROITraceNeuropil); 

populate(IMG.ROIdeltaF); % IMG.ROIdeltaFMean IMG.ROIFMean
populate(IMG.ROIdeltaFPeak); 
populate(IMG.ROIdeltaFStats);
populate(IMG.ROIBadSessionEpoch);
populate(IMG.ROIBad); 
populate(IMG.ROIID);

populate(IMG.ROIInclude);

% We use this:
populate(IMG.ETLTransform);  % XYZ coordinate transform (same transform across all sessions) for correction of ETL abberations based on ETL callibration. Populated from external script.
populate(IMG.ROIPositionETL);  % XYZ coordinate correction of ETL abberations based on ETL callibration

% NOT USED
populate(IMG.PlaneETLTransform); % XYZ coordinate transform (unique transform for each session) for correction of ETL abberations based on anatomical fiducial (NOT USED).
populate(IMG.ETLTransform2);   % XYZ coordinate transform (same transform across  all sessions) for correction of ETL abberations based on anatomical fiducial (NOT USED). Populated from external script 
populate(IMG.ROIPositionETL2); % XYZ coordinate correction of ETL abberations based on anatomical fiducial (NOT USED)




populate(IMG.ROIdeltaFNeuropil); % IMG.ROIdeltaFMeanNeuropil
populate(IMG.ROIdeltaFNeuropilSubtr);
populate(IMG.ROIdeltaFStatsNeuropil);
 
% populate(IMG.ROIBadNeuropil); 

%% PHOTOSTIM
% ANALYSIS_PHOTOSTIM_PAPER; % this script summarizes all the scripts below:
STIMANAL.SessionEpochsIncluded;  %% manually update session info here


populate(IMG.PhotostimGroup); % also IMG.PhotostimProtocol
populate(IMG.PhotostimGroupROI); % also populates IMG.PhotostimDATfile;

populate(STIM.ROIInfluence5); % also populates STIM.ROIInfluenceTrace 
populate(STIM.ROIInfluence5ETL); % DEBUG => add option to populate STIM.ROIInfluenceTrace 

populate(STIM.ROIResponseDirect);  
%%%% STIMANAL.NeuronOrControl5 requires STIM.ROIResponseDirect5  ==> debug
populate(STIM.ROIResponseDirect5);  
populate(STIM.ROIResponseDirect5ETL);  
populate(STIM.ROIResponseDirect5ETL2);  


populate(STIMANAL.NeuronOrControl5);
populate(STIMANAL.NeuronOrControl5ETL);
populate(STIMANAL.NeuronOrControl5ETL2);

populate(STIMANAL.InfluenceDistance55);
populate(STIMANAL.InfluenceDistance55ETL);

populate(STIMANAL.ControlTargetsIntermingled);
populate(STIMANAL.InfluenceDistanceIngermingledControl);


populate(STIMANAL.OutDegree);
populate(STIMANAL.OutDegreeETL);

populate(POP.ROICorrLocalPhoto)
populate(POP.ROICorrLocalPhoto2)

populate(STIMANAL.ROIGraphAllETL);


populate(STIM.ROIResponseDirectUnique);
populate(STIMANAL.ConnectivityBetweenDirectlyStimulatedOnly);



%% 
 populate(POP.DistancePairwiseLateral); %also populates POP.DistancePairwise3D

%% Lick 2D
% ANALYSIS_LICK2D; % this script summarizes all the scripts below:


%based on spikes
%--------------------------------
%debug:  exludes all older sessions that do not have EXP2.TrialLickBlock.Debug to include them

populate(LICK2D.ROILick2DangleSpikes3bins); %also populates LICK2D.ROILick2DangleBlockSpikes3bins LICK2D.ROILick2DangleStatsSpikes3bins LICK2D.ROILick2DangleBlockStatsSpikes3bins
populate(LICK2D.ROILick2DPSTHSpikes); % also populates LICK2D.ROILick2DPSTHStatsSpikes LICK2D.ROILick2DPSTHBlockSpikes LICK2D.ROILick2DPSTHBlockStatsSpikes
populate(LICK2D.ROILick2DPSTHSpikesModulation); % modulation depth of the 1D tuning (PSTH)
populate(LICK2D.ROILick2DPSTHSpikesPvalue); % p_value of stability and modulation depth of the 1D tuning (PSTH); also populates LICK2D.ROILick2DPSTHSpikesShuffledDistribution

% PSTH aligned to the last contact lick
populate(LICK2D.ROILick2DPSTHSpikesLastLick); % also populates LICK2D.ROILick2DPSTHStatsSpikesLastLick
populate(LICK2D.ROILick2DPSTHSpikesModulationLastLick) % modulation depth of the 1D tuning (PSTH)

% PSTH aligned to lick port presentation
populate(LICK2D.ROILick2DPSTHSpikesLickport); % also populates LICK2D.ROILick2DPSTHStatsSpikesLickport
populate(LICK2D.ROILick2DPSTHSpikesModulationLickport) % modulation depth of the 1D tuning (PSTH)



populate(LICK2D.ROILick2DmapSpikes); %also populates LICK2D.ROILick2DmapPSTHSpikes LICK2D.ROILick2DmapPSTHStabilitySpikes LICK2D.ROILick2DmapStatsSpikes LICK2D.ROILick2DSelectivitySpikes LICK2D.ROILick2DSelectivityStatsSpikes
populate(LICK2D.ROILick2DmapStatsSpikeShort);
populate(LICK2D.ROILick2DmapUnimodalitySpikes);
populate(LICK2D.ROILick2DPSTHSpikesPvalue); % p_value of stability and modulation depth of the 1D tuning (PSTH); also populates LICK2D.ROILick2DPSTHSpikesShuffledDistribution

populate(LICK2D.ROILick2DmapSpikes3bins); %also populates LICK2D.ROILick2DmapPSTHSpikes3bins LICK2D.ROILick2DmapPSTHStabilitySpikes3bins LICK2D.ROILick2DmapStatsSpikes3bins LICK2D.ROILick2DSelectivitySpikes3bins LICK2D.ROILick2DSelectivityStatsSpikes3bins
populate(LICK2D.ROILick2DmapStatsSpikes3binsShort);
populate(LICK2D.ROILick2DmapSpikes3binsModulation) % modulation depth of the 2D tuning (map)
populate(LICK2D.ROILick2DmapSpikes3binsPvalue); %also populates LICK2D.ROILick2DmapSpikesShuffledDistribution


populate(LICK2D.ROILick2DPSTHSpikesPoisson); % also populates LICK2D.ROILick2DPSTHStatsSpikesPoisson LICK2D.ROILick2DPSTHBlockSpikesPoisson LICK2D.ROILick2DPSTHBlockStatsSpikesPoisson
populate(LICK2D.ROILick2DPSTHSpikesResampledlikePoisson); % also populates LICK2D.ROILick2DPSTHStatsSpikesResampledlikePoisson LICK2D.ROILick2DPSTHBlockSpikesResampledlikePoisson LICK2D.ROILick2DPSTHBlockStatsSpikesResampledlikePoisson

populate(IMG.ROIExample);
populate(LICK2D.ROILick2DPSTHSpikesExample); 
populate(LICK2D.ROILick2DmapSpikesExample);  %also populates LICK2D.ROILick2DmapPSTHSpikesExample LICK2D.ROILick2DmapPSTHStabilitySpikesExample LICK2D.ROILick2DmapStatsSpikesExample


% del(IMG.ROIExample)
% del(LICK2D.ROILick2DPSTHSpikesExample)
% del(LICK2D.ROILick2DmapSpikesExample)
% del(LICK2D.ROILick2DmapPSTHSpikesExample)
% del(LICK2D.ROILick2DmapPSTHStabilitySpikesExample)
% del(LICK2D.ROILick2DmapStatsSpikesExample)

LICK2D.ROILick2DmapStatsSpikes

populate(PLOTS.Cells2DTuningSpikes);
populate(PLOTS.Cells2DTuningSpikesRewardSignif);

populate(PLOTS.Cells2DTuningSpikesPhotostimulated);
populate(PLOTS.Cells2DTuningSpikesPhotostimulated2);

populate(PLOTS.Cells2DTuningSpikesFirstBehavioralSession);


populate(PLOTS.MultipleCells2DTuningSpikes); %Multiple 2D tunings map on cells

populate(LICK2D.ROILick2DmapRewardSpikes); %populating also LICK2D.ROILick2DmapRewardStatsSpikes
populate(LICK2D.ROILick2DmapRewardSpikes3bins); %populating also LICK2D.ROILick2DmapRewardStatsSpikes3bins

populate(LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes);
populate(LICK2D.ROILick2DPSTHSimilarityAcrossPositionsSpikes3bins);
LICK2D.ROILick2DPSTHSpikesLongerInterval

populate(PLOTS.Maps2DthetaSpikes);
% populate(PLOTS.Maps2DPSTHSpikes);

% populate(ANLI.ROILick2DangleShuffle);
% populate(ANLI.ROILick2DmapShuffle);

populate(PLOTS.Maps2Dtheta);



%based on dff
%--------------------------------
populate(LICK2D.ROILick2DangleNeuropil);
populate(LICK2D.ROILick2DPSTH); %LICK2D.ROILick2DPSTHStats LICK2D.ROILick2DRewardStats LICK2D.ROILick2DBlockStats
populate(LICK2D.ROILick2Dmap); %also populates LICK2D.ROILick2DSelectivity LICK2D.ROILick2DSelectivityStats



populate(LICK2D.ROILick2DLickRate);
populate(LICK2D.ROILick2DangleEvents);
% populate(LICK2D.ROIRidge);
populate(LICK2D.ROIBodypartCorr);

% populate(PLOTS.Cells2DTuning);
populate(PLOTS.Maps2DPSTH);
populate(PLOTS.Maps2DReward);
populate(PLOTS.Maps2DBlock);

populate(PLOTS.Maps2DLickRate);
populate(PLOTS.MapsBodypartCorr);

% populate(PLOTS.Maps2DPSTHpreferred);



% Based on Spikes
%--------------------------------
populate(PLOTS.Population2DReward);
populate(PLOTS.CellsPSTHTiming);
populate(PLOTS.CellsPSTHTimingReward);
populate(PLOTS.Cells2DTuningSpikesTop100);



%% SVD
% STIMANAL.MiceIncluded

populate(POP.ROISVD); %also populates POP.SVDTemporalComponents POP.SVDSingularValues

populate(POP.ROISVDPython); %also populates POP.SVDTemporalComponentsPython POP.SVDSingularValuesPython


populate(POP.ROISVDSpikes); %also populates POP.SVDTemporalComponentsSpikes POP.SVDSingularValuesSpikes
populate(POP.ROISVDNeuropil); %also populates POP.SVDTemporalComponentsNeuropil POP.SVDSingularValuesNeuropil
populate(POP.ROISVDNeuropilSubtr); %also populates POP.SVDTemporalComponentsNeuropilSubtract POP.SVDSingularValuesNeuropilSubtract

populate(POP.ROISVDDistanceScale);
populate(POP.ROISVDDistanceScaleSpikes);
populate(POP.ROISVDDistanceScaleNeuropil);


populate(PLOTS.Dimensionality);
populate(PLOTS.DimensionalityNeuropil);

populate(PLOTS.MapsSVD);
populate(PLOTS.MapsClusterCorrSVD);





%% video tracking
populate(TRACKING.TrackingTrial);
populate(TRACKING.TrackingTrialBad);
populate(TRACKING.VideoFiducialsTrial);
populate(TRACKING.VideoFiducialsSessionAvg);
populate(TRACKING.VideoTongueTrial); %also populates TRACKING.VideoLickportTrial TRACKING.VideoGroomingTrial TRACKING.VideoBodypartTrajectTrial TRACKING.VideoLickportPositionTrial
populate(TRACKING.VideoNthLickTrial);
populate(LICK2D.PLOTCameras);
populate(LICK2D.PLOTCameras);

populate(PLOTS.MapsBodypartCorr);

%% Ridge regression behavior
populate(RIDGE.Predictors); %RIDGE.PredictorType RIDGE.PredictorTypeUse

populate(RIDGE.ROIRidge); %also populates RIDGE.ROIRidgeVarExplained;    Required to run first: POP.ROISVD which also populates the required POP.SVDSingularValues,  POP.SVDTemporalComponents
populate(RIDGE.ROIRidgeNeuropil); %also populates RIDGE.ROIRidgeVarExplainedNeuropil
populate(PLOTS.MapsRidge);
populate(PLOTS.MapsRidgeNeuropil);
populate(PLOTS.MapsRidgeVarianceExplained)
populate(PLOTS.MapsRidgeVarianceExplainedNeuropil)


