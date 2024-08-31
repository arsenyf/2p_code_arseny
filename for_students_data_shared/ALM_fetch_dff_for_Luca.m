function  ALM_fetch_dff_for_Luca ()

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_Luca\';

key.subject_id=462455;
key.session=2

filename = ['data_dff_subject' num2str(key.subject_id) '_session_' num2str(key.session) '.mat'];

imaging_frame_rate = fetch1(IMG.FOVEpoch & key,'imaging_frame_rate','LIMIT 1');

rel= IMG.ROI*IMG.ROIPosition & (EXP2.SessionEpoch  & key) & (IMG.ROIGood-IMG.ROIBad) ;

session_date = fetchn(EXP2.Session  & key,'session_date');
behavioral_session_number = fetchn(EXP2.SessionBehavioral  & key,'behavioral_session_number');

%% Spontaneous dff
rel_trace =IMG.ROIdeltaF & rel & 'session_epoch_type="spont_only"' & 'session_epoch_number=1';
dff_spont=cell2mat(fetchn(rel_trace, 'dff_trace','ORDER BY roi_number'));

% %% Behavioral dff
% rel_trace =IMG.ROIdeltaF & rel & 'session_epoch_type="behav_only"';
% dff_behav=cell2mat(fetchn(rel_trace, 'dff_trace','ORDER BY roi_number'));


%% Anatomical Coordinates in microns
R=fetch(rel,'roi_centroid_x_um','roi_centroid_y_um','roi_centroid_z_um','ORDER BY roi_number');



Data.subject_id=key.subject_id;
Data.session = key.session;
Data.behavioral_session_number = behavioral_session_number;
Data.session_date = session_date;
Data.dff_spont=dff_spont;
% Data.dff_behav=dff_behav;
Data.imaging_frame_rate = imaging_frame_rate;
Data.cell_pos_x=[R.roi_centroid_x_um];
Data.cell_pos_y=[R.roi_centroid_y_um];
Data.cell_pos_z = [R.roi_centroid_z_um];
Data.Comment = 'dff_spont & dff_behav are NeuronsXFrames matrix of neural activity (deltaF/F, calcium imaging) of the same cells imaged during spontaneous and other sessions; imaging_frame_rate in Hz; cell_pos_x cell_pos_y cell_pos_z represent antatomical coordinates of each neuron  in microns relative to the imaging plane, for z -- relative to  top  plane';


save([dir_save filename],'Data')

