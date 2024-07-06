function  mesoscope_fetch_spikes ()

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_students_data_shared\mesoscope_data_spikes\';
key.subject_id = 464725;
key.session = 2;
% key.subject_id = 464725;
% key.session = 2;
% key.subject_id = 464725;
% key.session = 5;
% key.subject_id = 464725;
% key.session = 8;

% key.subject_id = 464724;
% key.session = 2;
% key.subject_id = 464724;
% key.session = 5;
key.subject_id = 464724;
key.session = 7;

filename = ['data_dff_subject' num2str(key.subject_id) '_session_' num2str(key.session) '.mat'];

imaging_frame_rate = fetch1(IMG.FOVEpoch & key,'imaging_frame_rate','LIMIT 1');

rel= IMG.ROI*IMG.ROIBrainArea*IMG.PlaneCoordinates & (EXP2.SessionEpoch & IMG.Mesoscope & key) & (IMG.ROIGood-IMG.ROIBad) ;

session_date = fetchn(EXP2.Session  & key,'session_date');
behavioral_session_number = fetchn(EXP2.SessionBehavioral  & key,'behavioral_session_number');

%% Spontaneous dff
rel_trace =IMG.ROISpikes & rel & 'session_epoch_type="spont_only"' & 'session_epoch_number=1';
spikes_spont=cell2mat(fetchn(rel_trace, 'spikes_trace','ORDER BY roi_number'));

%% Behavioral dff
rel_trace =IMG.ROISpikes & rel & 'session_epoch_type="behav_only"';
spikes_behav=cell2mat(fetchn(rel_trace, 'spikes_trace','ORDER BY roi_number'));


%% Anatomical Coordinates in microns
R=fetch(rel,'roi_centroid_x_um_relative2bregma','roi_centroid_y_um_relative2bregma','roi_centroid_z_um', 'brain_area','ORDER BY roi_number');


brain_area_legend=fetch(LAB.BrainArea & IMG.ROIBrainArea,'*');


Data.subject_id=key.subject_id;
Data.session = key.session;
Data.behavioral_session_number = behavioral_session_number;
Data.session_date = session_date;
Data.spikes_spont=spikes_spont;
Data.spikes_behav=spikes_behav;
Data.imaging_frame_rate = imaging_frame_rate;
Data.cell_pos_x=[R.roi_centroid_x_um_relative2bregma];
Data.cell_pos_y=[R.roi_centroid_y_um_relative2bregma];
Data.cell_pos_z = [R.roi_centroid_z_um];
Data.brain_area={R.brain_area}';
Data.brain_area_legend=brain_area_legend;
Data.Comment = 'spikes_spont & spikes_behav are NeuronsXFrames matrix of neural activity (deconvoled and neuropil subtracted deltaF/F, calcium imaging) of the same cells imaged during spontaneous and behavioral session; imaging_frame_rate in Hz; cell_pos_x & cell_pos_y cell_pos_z represent antatomical coordinates of each neuron  in microns relative to bregam and the top imaged planne';


save([dir_save filename],'Data')

