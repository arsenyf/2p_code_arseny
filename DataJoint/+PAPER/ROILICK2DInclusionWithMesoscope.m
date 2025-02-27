%{
# include ROI that had all the behavior experiments
-> IMG.ROI
%}


classdef ROILICK2DInclusionWithMesoscope < dj.Computed
    properties
        keySource = (EXP2.Session & IMG.ROISpikes  & EXP2.TrialLickPort & EXP2.TrialLickBlock);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            rel_roi=(IMG.ROIGood-IMG.ROIBad) & EXP2.TrialLickPort & EXP2.TrialLickBlock & key;
            key_roi=fetch(rel_roi);
            insert(self,key_roi);
        end
    end
end

