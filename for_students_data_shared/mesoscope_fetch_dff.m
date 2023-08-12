function  mesoscope_fetch_dff ()

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_students_data_shared\mesoscope_data_dff\';
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
rel_trace =IMG.ROIdeltaF & rel & 'session_epoch_type="spont_only"' & 'session_epoch_number=1';
dff_spont=cell2mat(fetchn(rel_trace, 'dff_trace','ORDER BY roi_number'));

%% Behavioral dff
rel_trace =IMG.ROIdeltaF & rel & 'session_epoch_type="behav_only"';
dff_behav=cell2mat(fetchn(rel_trace, 'dff_trace','ORDER BY roi_number'));


%% Anatomical Coordinates in microns
R=fetch(rel,'roi_centroid_x','roi_centroid_y','x_pos_relative','y_pos_relative','brain_area','ORDER BY roi_number');
x = [R.roi_centroid_x] + [R.x_pos_relative];
y = [R.roi_centroid_y] + [R.y_pos_relative];
x=x/0.75;
y=y/0.5;

brain_area_legend=fetch(LAB.BrainArea & IMG.ROIBrainArea,'*');


Data.subject_id=key.subject_id;
Data.session = key.session;
Data.behavioral_session_number = behavioral_session_number;
Data.session_date = session_date;
Data.dff_spont=dff_spont;
Data.dff_behav=dff_behav;
Data.imaging_frame_rate = imaging_frame_rate;
Data.cell_pos_x=x';
Data.cell_pos_y=y';
Data.brain_area={R.brain_area}';
Data.brain_area_legend=brain_area_legend;
Data.Comment = 'dff_spont & dff_behav are NeuronsXFrames matrix of neural activity (deltaF/F, calcium imaging) of the same cells imaged during spontaneous and behavioral session; imaging_frame_rate in Hz; cell_x & cell_y represent antatomical coordinates of each neuron  in microns';


save([dir_save filename],'Data')

