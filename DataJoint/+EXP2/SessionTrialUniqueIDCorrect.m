%{
# trial_uid in EXP2.SessionTrial was supposed to be unique but Arseny found that it is not. This table is a correction to it -- here all the trials have unique ID
-> EXP2.SessionTrial
---
trial_uid_correct                   : int                           # unique across sessions/animals; we should use this one because the original trial_uid turned out to be non unique
%}


classdef SessionTrialUniqueIDCorrect < dj.Computed
    properties(SetAccess=protected)
        keySource = (EXP2.Session & EXP2.SessionTrial) ;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            
            key_insert=fetch(EXP2.SessionTrial & key); %we are going to replace trial_uid with trial_uid_correct
            
            all_uids=fetchn(EXP2.SessionTrialUniqueIDCorrect,'trial_uid_correct'); % all existing uid in all sessions
            
            
            % to ensure uniqueness we always increment relative to existing  trials
            if isempty(all_uids)
                counter =0;
            else
                counter = max(all_uids);
            end
            
            for i=1:1:numel(key_insert)
                counter = counter +1;
                key_insert(i).trial_uid_correct = counter;
            end
            insert(self,key_insert);
        end
    end
end
