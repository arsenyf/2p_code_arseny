%{
# include good ROI that were considered cell by suite2p
-> IMG.ROI
---
roi_number_uid                  : int           # roi uid (unique across sessions). Same roi registered across sessions would have the same uid. It wasn't unique until 2020.01.13
%}


classdef ROIID < dj.Imported
    properties
        keySource = IMG.Plane;
    end
    methods(Access=protected)
        function makeTuples(self, key)
           
            R=fetch(IMG.ROI & key,'roi_number_uid','ORDER BY roi_number');
            insert(self, R);
        end
    end
end