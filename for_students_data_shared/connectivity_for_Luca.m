function connectivity_for_Luca ()


% key.subject_id=462458;
% key.session=6
key.subject_id=462455;
key.session=2
session_date = fetch1(EXP2.Session & key,'session_date');

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_Luca\';

filename_base = ['connectivity.mat'];


dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value'); 
dir_current_fig = [dir_base  '\Photostim\photostim_traces\coupled_for_Luca_Mazzucato\'];

dir_current_fig = [dir_current_fig '\anm' num2str(key.subject_id) '\session_' num2str(key.session) '_' session_date  '\'];

% rel_data = STIMANAL.TargetAndConnectedResponseTraceDFF;
rel_data = STIMANAL.TargetAndConnectedResponseTraceDFF2LucaMazucatto	;


DATA=fetch(rel_data & 'target_response_p_value1<0.0001' & 'connected_response_peak_mean>0.2' & 'connected_response_p_value1<0.001','*');
DATA=rmfield(DATA,'session_epoch_number')
DATA=rmfield(DATA,'plane_num')
DATA=rmfield(DATA,'channel_num')
DATA=rmfield(DATA,'fov_num')

save([dir_save filename_base],'DATA')



time_vector=fetch1(rel_data & key,'time_vector','LIMIT 1');
time_vector_idx = time_vector<10;
RESPONSE = fetch(rel_data & key & 'target_response_p_value1<0.0001' & 'connected_response_peak_mean>0.2' & 'connected_response_p_value1<0.001','target_response_trace_mean','connected_response_trace_mean','connected_response_p_value1','target_response_p_value1','connected_distance_lateral_um');


target_response=cell2mat({RESPONSE.target_response_trace_mean}');
connected_response=cell2mat({RESPONSE.connected_response_trace_mean}');
connected_response_p_value1=cell2mat({RESPONSE.connected_response_p_value1}');
target_response_p_value1=cell2mat({RESPONSE.target_response_p_value1}');
connected_distance_lateral_um=cell2mat({RESPONSE.connected_distance_lateral_um}');

plot(time_vector(time_vector_idx),mean(target_response(:,time_vector_idx),1))


figure
for i=1:1:size(target_response,1)
    plot(time_vector(time_vector_idx),target_response(i,time_vector_idx))
    
end





figure

    if isempty(dir(dir_current_fig))
        mkdir (dir_current_fig)
    end
    
for i=1:1:size(connected_response,1)
    plot(time_vector(time_vector_idx),connected_response(i,time_vector_idx))
    title(sprintf('target pval = %.4f  connection  pval = %.4f', target_response_p_value1(i), connected_response_p_value1(i)));
   
    

    %
        filename=['photostim_group_' num2str(RESPONSE(i).photostim_group_num) '_roi_' num2str(RESPONSE(i).roi_number)];
    figure_name_out=[ dir_current_fig filename];
    eval(['print ', figure_name_out, ' -dtiff  -r100']);
    % eval(['print ', figure_name_out, ' -dpdf -r200']);
    
    clf;
end
plot(time_vector(time_vector_idx),mean(connected_response(:,time_vector_idx),1))