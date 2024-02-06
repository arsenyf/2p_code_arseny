function connectivity_for_Ran()

dir_save = 'C:\Users\scanimage\Google Drive\WORK\Shared_files\for_Ran\connectivity\';
filename_base = ['connectivity.mat'];


% frame_rate=5.2
%  frame_window_long=[56,110]/2;
% time=(-frame_window_long(1):1:frame_window_long(2)-1)/frame_rate;
%
rel =IMG.PhotostimGroupROI & (STIM.ROIResponseDirectUnique & (STIMANAL.NeuronOrControl & 'neurons_or_control=1'));







% DATA.ResponseConnected=fetch(STIM.ROIInfluenceTraceLong & rel,'*');
% DATA.ResponseDirect=fetch(STIMANAL.ROIResponseDirectVariability & rel,'*');
% DATA.sessions = fetch(EXP2.SessionID  & rel_connections);



sessions = fetch(EXP2.SessionID  & STIM.ROIInfluenceTraceLong & rel);
for i_s = 1:1:numel(sessions)
    key=sessions(i_s);
    
    rel_connections = STIM.ROIInfluenceTraceLong & rel  & key;
    rel_direct = STIMANAL.ROIResponseDirectVariability & rel & key;
    
    DATA=[];
    filename=['anm' sprintf('%d',key.subject_id) '_s' sprintf('%d',key.session) filename_base];
    DATA.ResponseConnected=fetch(rel_connections,'*');
    DATA.ResponseDirect=fetch(rel_direct  ,'*');
    save([dir_save filename],'DATA')
    
end




% sessions = fetch(EXP2.SessionID  & rel_connections);
% PP=[];
% for i_s = 1:1:numel(sessions)
%     key=sessions(i_s);
%     C=fetch(STIM.ROIInfluenceTraceLong & rel & key,'*');
%     M={C.all_neurons_response_trace_matrix}';
%     SIGNIF=[C.all_neurons_response_significance]';
%     DISTANCE=[C.all_neurons_distance_3d]';
%     IDX_SIGNIF=SIGNIF<0.01;
%     IDX_DISTANCE = DISTANCE>=25 & DISTANCE<100;
% %     IDX_select=IDX_SIGNIF & IDX_DISTANCE;
%         IDX_select=IDX_DISTANCE;
%
% time_vector = C(1).time_vector;
%     P=cell2mat(M);
%     P=P(IDX_select,:);
%     PP=[PP;P];
% end
%     plot(time_vector,mean(P,1))
