%{
# Counts the number of licks per trial
-> EXP2.BehaviorTrial
---
licks_aiming_horizontal_before_lickport_entrance            : double                 # correlation between target position and lick direction, average across all licks in this category
licks_aiming_horizontal_after_lickport_entrance             : double                 # 
licks_aiming_horizontal_at_1st_contact                      : double                 # 
licks_aiming_horizontal_before_1st_contact                  : double                 # 
licks_aiming_horizontal_after_1st_contact                   : double                 # 
%}


classdef VideoLickCountTrial < dj.Computed
    properties
        keySource = (EXP2.Session  & TRACKING.VideoNthLickTrial) ;
        
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            key_insert = fetch(TRACKING.VideoTongueTrial & key);
            
            rel_licks_video_all = (TRACKING.VideoNthLickTrial& key);
            rel_licks_video_after_1st_contact = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_firsttouch>=0') ;
            rel_licks_electric_contacts_only = (TRACKING.VideoNthLickTrial& key & 'lick_touch_number>=0');
            rel_licks_video_before_lickport_entrance = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_lickport_entrance<0');
            rel_licks_video_after_lickport_entrance = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_lickport_entrance>=0');
            
            
            L_video_all_licks = fetch( rel_licks_video_all,'trial','ORDER BY trial');
            L_video_after_1st_contact = fetch( rel_licks_video_after_1st_contact,'trial','ORDER BY trial');
            L_video_before_likcport_entrance = fetch( rel_licks_video_before_lickport_entrance,'trial','ORDER BY trial');
            L_video_after_likcport_entrance = fetch( rel_licks_video_after_lickport_entrance,'trial','ORDER BY trial');
            
            L_electric_contacts = fetch( rel_licks_electric_contacts_only,'trial','ORDER BY trial');
            
            for i_tr=1:1:numel(key_insert)
                curr_trial = key_insert(i_tr).trial;
                key_insert(i_tr).licks_byvideo_in_trial =  sum([L_video_all_licks.trial]==curr_trial);
                key_insert(i_tr).licks_byvideo_after_1st_contact_including =  sum([L_video_after_1st_contact.trial]==curr_trial);
                key_insert(i_tr).licks_byvideo_before_lickport_entrance =  sum([L_video_before_likcport_entrance.trial]==curr_trial);
                key_insert(i_tr).licks_byvideo_after_lickport_entrance =  sum([L_video_after_likcport_entrance.trial]==curr_trial);
                key_insert(i_tr).licks_byelectric_contact =  sum([L_electric_contacts.trial]==curr_trial);
                
            end
            insert(self,key_insert);
        end
    end
end

