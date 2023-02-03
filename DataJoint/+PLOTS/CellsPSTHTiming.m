%{
# 
-> EXP2.Session
%}


classdef CellsPSTHTiming < dj.Computed
    properties
        
      keySource = (EXP2.Session  & LICK2D.ROILick2DPSTHSpikesLongerInterval) -  IMG.Mesoscope ;
%       keySource = (EXP2.Session   &  LICK2D.ROILick2DPSTHSpikes) &  IMG.Mesoscope;

    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\Cells\PSTHTiming\not_mesoscope\'];
            
            flag_spikes = 1; % 1 spikes, 0 dff
            
            if flag_spikes==1
                rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & ...
                    (LICK2D.ROILick2DPSTHSpikes)  & key;
            end
            
            plot_one_in_x_cell=5; % e.g. plots one in 20 signficant cell
            
            PLOTS_CellsPSTHTiming (key, dir_current_fig,flag_spikes, plot_one_in_x_cell, rel_rois);
            
            insert(self,key);
            
        end
    end
end