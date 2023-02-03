function RUN_IMAGING_PIPELINE()

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

flag_multi_session_registration = 0;


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
populate_behavior_Lick2D(dir_behavioral_data, behavioral_protocol_name);

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
populate(IMG.ROIGood); 
populate(IMG.ROITrace); 
populate(IMG.ROISpikes);

populate(IMG.ROIPositionETL); 


populate(IMG.ROIdeltaF); % IMG.ROIdeltaFMean IMG.ROIFMean
% populate(ANLI.IncludeROI4);
populate(IMG.ROIdeltaFPeak); 
populate(IMG.ROIdeltaFStats);
populate(IMG.ROIBadSessionEpoch);
populate(IMG.ROIBad); 


populate(IMG.ROITraceNeuropil); 
populate(IMG.ROIdeltaFNeuropil); % IMG.ROIdeltaFMeanNeuropil
populate(IMG.ROIdeltaFNeuropilSubtr);
populate(IMG.ROIdeltaFStatsNeuropil);
 
% populate(IMG.ROIBadNeuropil); 

%% PHOTOSTIM
% ANALYSIS_PHOTOSTIM; % this script summarizes all the scripts below:
STIMANAL.SessionEpochsIncluded;  %% manually update session info here


populate(IMG.PhotostimGroup); % also IMG.PhotostimProtocol
populate(IMG.PhotostimGroupROI); % also populates IMG.PhotostimDATfile;

populate(STIM.ROIInfluence5); % also populates STIM.ROIInfluenceTrace 
populate(STIM.ROIInfluence5ETL);

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

populate(STIMANAL.OutDegree);
populate(STIMANAL.OutDegreeETL);

populate(POP.ROICorrLocalPhoto)

populate(STIMANAL.ROIGraphAllETL);


%%% old
% % % populate(STIM.ROIResponse); % also populates STIM.ROIResponseVector
% % % populate(STIM.ROIResponse2); % control with the stim window (for detection) is shifted forward
% % 
% % % populate(STIM.ROIResponseDirect);
% % % 
% % % populate(STIM.ROIResponseMost);
% % 
% % % populate(STIM.ROIGraph2);
% % % populate(STIM.ROIGraphAll);
% % % populate(ANLI.ROICorr1);
% % % populate(ANLI.ROICorr3);
% % % populate(ANLI.ROICorr5);
% % % populate(ANLI.ROICorr10);


%% 
 populate(POP.DistancePairwiseLateral); %also populates POP.DistancePairwise3D

%% Lick 2D
% ANALYSIS_LICK2D; % this script summarizes all the scripts below:


%based on spikes
%--------------------------------
%debug:  exludes all older sessions that do not have EXP2.TrialLickBlock.Debug to include them

populate(LICK2D.ROILick2DangleSpikes);
populate(LICK2D.ROILick2DQuadrantsSpikes);
%debug: not all LICK2D.ROILick2DPSTHSpikes have LICK2D.ROILick2DRewardStatsSpikes
populate(LICK2D.ROILick2DPSTHSpikes); %LICK2D.ROILick2DPSTHStatsSpikes LICK2D.ROILick2DRewardStatsSpikes LICK2D.ROILick2DBlockStatsSpikes
populate(LICK2D.ROILick2DmapSpikes); %also populates LICK2D.ROILick2DSelectivitySpikes LICK2D.ROILick2DSelectivityStatsSpikes

populate(PLOTS.Cells2DTuningSpikes);

populate(PLOTS.CellsRewardTuningSpikes);


populate(LICK2D.ROILick2DPSTHSpikesPoisson);

populate(PLOTS.CellsRewardTuningSpikesPoisson);


populate(PLOTS.Maps2DthetaSpikes);
% populate(PLOTS.Maps2DPSTHSpikes);

% populate(ANLI.ROILick2DangleShuffle);
% populate(ANLI.ROILick2DmapShuffle);




%based on dff
%--------------------------------
populate(LICK2D.ROILick2Dangle);
populate(LICK2D.ROILick2DangleNeuropil);
populate(LICK2D.ROILick2DPSTH); %LICK2D.ROILick2DPSTHStats LICK2D.ROILick2DRewardStats LICK2D.ROILick2DBlockStats
populate(LICK2D.ROILick2Dmap); %also populates LICK2D.ROILick2DSelectivity LICK2D.ROILick2DSelectivityStats
populate(LICK2D.ROILick2DQuadrants);


populate(LICK2D.ROILick2DLickRate);
populate(LICK2D.ROILick2DangleEvents);
% populate(LICK2D.ROIRidge);
populate(LICK2D.ROIBodypartCorr);

% populate(PLOTS.Cells2DTuning);
populate(PLOTS.Maps2Dtheta);
populate(PLOTS.Maps2DPSTH);
populate(PLOTS.Maps2DReward);
populate(PLOTS.Maps2DBlock);

populate(PLOTS.Maps2DLickRate);
populate(PLOTS.MapsBodypartCorr);

% populate(PLOTS.Maps2DPSTHpreferred);



% Based on Spikes
%--------------------------------
populate(PLOTS.Population2DReward);



%% All 3 Not used (probably could be removed):
% % populate(ANLI.ROILick2DmapReward);
% populate(ANLI.ROILick2DPSTHReward);
% populate(ANLI.ROILick2DPSTHBlock);


%% MAPS Sponts vs Behavior
% populate(PLOTS.MapsSpontVsBeharDeltaMeanDFF);

% populate(PLOTS.MapsSpontVsBeharDeltaMeanDFF);


%% SOMATOSENSORY MAPS
populate(PLOTS.SomatotopyDeltaFiringRate);
populate(PLOTS.SomatotopyDeltaMean);
populate(PLOTS.SomatotopyDeltaMeanNeuropil);
% populate(PLOTS.SomatotopyDeltaMeanFlourescence);


%% SVD
% STIMANAL.MiceIncluded

populate(POP.ROISVD); %also populates POP.SVDTemporalComponents POP.SVDSingularValues
populate(POP.ROISVDSpikes); %also populates POP.SVDTemporalComponentsSpikes POP.SVDSingularValuesSpikes
populate(POP.ROISVDNeuropil); %also populates POP.SVDTemporalComponentsNeuropil POP.SVDSingularValuesNeuropil
populate(POP.ROISVDNeuropilSubtr); %also populates POP.SVDTemporalComponentsNeuropilSubtract POP.SVDSingularValuesNeuropilSubtract

populate(POP.ROISVDDistanceScale);
populate(POP.ROISVDDistanceScaleSpikes);
populate(POP.ROISVDDistanceScaleNeuropil);


populate(PLOTS.Dimensionality);
populate(PLOTS.DimensionalityNeuropil);

populate(PLOTS.MapsSVD);


%% Clustering and Correlatios
% populate(ANLI.ROIHierarCluster);
% populate(ANLI.ROIHierarClusterSelectivity);
% populate(ANLI.ROIHierarClusterShapeAndSelectivity);


% populate(POP.ROIClusterCorr2); %smoothed
% populate(POP.ROISubClusterCorr);
% populate(POP.ROICorrLocal);

populate(POP.ROIClusterCorr);
populate(POP.ROIClusterCorrNeuropil);
populate(POP.ROIClusterCorrThresholded);
% populate(POP.ROIClusterCorrNeuropilSubtr)

populate(POP.ROIClusterCorrSVD);

populate(PLOTS.MapsClusterCorr);
populate(PLOTS.MapsClusterCorrNeuropil);
populate(PLOTS.MapsClusterCorrThresholded);
populate(PLOTS.MapsClusterCorrSVD);



%% Activity movies
populate(PLOTS.MoviesActivity);
populate(PLOTS.MoviesSVD);


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


%% Water cue task
% populate(WC.FPSTHaverage);


