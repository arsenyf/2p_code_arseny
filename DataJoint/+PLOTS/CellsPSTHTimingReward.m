%{
# 
-> EXP2.Session
%}


classdef CellsPSTHTimingReward < dj.Computed
    properties
        
      keySource = (EXP2.Session  & LICK2D.ROILick2DPSTHSpikesLongerInterval) -  IMG.Mesoscope ;
%       keySource = (EXP2.Session   &  LICK2D.ROILick2DPSTHSpikes) &  IMG.Mesoscope;

    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\Cells\PSTHTiming_reward\not_mesoscope\'];
            
            flag_spikes = 1; % 1 spikes, 0 dff
            
            if flag_spikes==1
                rel_rois=  (IMG.ROI& IMG.ROIGood - IMG.ROIBad) & key ;
            end
            
            plot_one_in_x_cell=1; % e.g. plots one in 20 signficant cell
            
            dir_current_fig = [dir_base  '\Lick2D\Cells\PSTHTiming_reward\not_mesoscope\large\'];
            rel_rois_large = rel_rois & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'reward_mean_pval_regular_large<0.01') ;
            PLOTS_CellsPSTHTimingReward (key, dir_current_fig,flag_spikes, plot_one_in_x_cell, rel_rois_large);
            
             dir_current_fig = [dir_base  '\Lick2D\Cells\PSTHTiming_reward\not_mesoscope\small\'];
             rel_rois_small = rel_rois & (LICK2D.ROILick2DPSTHStatsSpikesLongerInterval & 'reward_mean_pval_regular_small<0.01') ;
             PLOTS_CellsPSTHTimingReward (key, dir_current_fig,flag_spikes, plot_one_in_x_cell, rel_rois_small);
            
            insert(self,key);
            
        end
    end
end