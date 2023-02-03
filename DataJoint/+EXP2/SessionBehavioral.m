%{
# Saves the sessions with behavior. It is helpful in case session number does not correspond to behavioral day in case there was no behavior on some sessions
-> EXP2.Session
behavioral_session_number         : smallint   # behavioral session number. The first behavioral session is 1
%}


classdef SessionBehavioral < dj.Computed
    properties
        keySource = (EXP2.Session & EXP2.BehaviorTrial)
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key_subject_id.subject_id=key.subject_id;
            behavioral_session_number=max(fetchn(EXP2.SessionBehavioral & key_subject_id,'behavioral_session_number'));
            if isempty(behavioral_session_number)
                behavioral_session_number=0;
            end
            key.behavioral_session_number=behavioral_session_number+1;
            self.insert(key)
        end
    end
end