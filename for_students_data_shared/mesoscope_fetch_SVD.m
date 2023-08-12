function  mesoscope_fetch_SVD ()

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_students_data_shared\mesoscope_data_svd\';
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

filename = ['data_svd_subject' num2str(key.subject_id) '_session_' num2str(key.session) '.mat'];


rel= IMG.ROI*IMG.ROIBrainArea*IMG.PlaneCoordinates & (EXP2.SessionEpoch & IMG.Mesoscope & key) & (IMG.ROIGood-IMG.ROIBad) ;

session_date = fetchn(EXP2.Session  & key,'session_date');
behavioral_session_number = fetchn(EXP2.SessionBehavioral  & key,'behavioral_session_number');

%% Spontaneous ROISVD
rel_trace =POP.ROISVD & rel & 'session_epoch_type="spont_only"' & 'session_epoch_number=1'  & 'threshold_for_event = 0'  & 'time_bin=1.5';
roi_components_spont=cell2mat(fetchn(rel_trace, 'roi_components','ORDER BY roi_number'));

%% Behavioral ROISVD
rel_trace =POP.ROISVD  & rel & 'session_epoch_type="behav_only"' & 'threshold_for_event = 0' & 'time_bin=1.5';
roi_components_behav=cell2mat(fetchn(rel_trace, 'roi_components','ORDER BY roi_number'));

time_bin = fetch1(rel_trace & key,'time_bin','LIMIT 1');
threshold_for_event = fetch1(rel_trace& key,'threshold_for_event','LIMIT 1');

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
Data.roi_components_spont=roi_components_spont;
Data.roi_components_behav=roi_components_behav;
Data.cell_pos_x=x';
Data.cell_pos_y=y';
Data.brain_area={R.brain_area}';
Data.brain_area_legend=brain_area_legend;
Data.time_bin = time_bin;
Data.threshold_for_event = threshold_for_event;
Data.Comment = 'contribution of the temporal components to the activity of each neuron; fetching this table for all neurons should give U in SVD of size (neurons x components) for the top num_comp components; same cells are imaged during spontaneous and behavioral session;  cell_x & cell_y represent antatomical coordinates of each neuron  in microns; time_bin and threshold_for_event define how the data was pre processed before computing the principle components using SVD';


save([dir_save filename],'Data')

