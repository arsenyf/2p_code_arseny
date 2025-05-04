%{
# GLM model 1 (time, lick) and GLM model 2 (time, lick, and reward)
# In addition, the models computed separately for  regular vs. large trials, and regular vs. small trials

-> EXP2.SessionEpoch
-> IMG.ROI
---
psth_regular_glm1              : blob   # mean; model that has only temporal splines and lick rate as predictors
psth_small__glm1=null          : blob   #
psth_large__glm1=null          : blob   #

psth_regular_stem__glm1        : blob   # standard error of the mean
psth_small_stem__glm1=null     : blob   #
psth_large_stem__glm1=null     : blob   #

psth_regular_glm2              : blob   # mean; model that has  temporal splines,  lick rate as predictors, and trial types (regular, small, large)
psth_small__glm2=null          : blob   #
psth_large__glm2=null          : blob   #

psth_regular_stem__glm2        : blob   # standard error of the mean
psth_small_stem__glm2=null     : blob   #
psth_large_stem__glm2=null     : blob   #

psth_time_glm              : blob   # time vector
%}

% p_val_lick_model1(i_roi), p_val_lick_model2(i_roi), ~, ~, p_val_LLR_small(i_roi), p_val_LLR_large(i_roi)


classdef ROILick2DPSTHSpikesGLM < dj.Imported
    properties
        keySource = ((EXP2.SessionEpoch*IMG.FOV) & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock) - IMG.Mesoscope;
        %                 keySource = (EXP2.SessionEpoch*IMG.FOV)  & IMG.ROI & IMG.ROISpikes & EXP2.TrialLickPort & 'session_epoch_type="behav_only"' & EXP2.TrialLickBlock & IMG.Mesoscope;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            close all;
            
            %Graphics
            %---------------------------------
            % figure;
            figure("Visible",false);
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
            set(gcf,'color',[1 1 1]);
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_current_fig = [dir_base  '\Lick2D\Cells\PSTHGLM\'];

            flag_electric_video = 1; %detect licks with electric contact or video (if available) 1 - electric, 2 - video
            rel_data = IMG.ROISpikes;
            
            rel_temp = IMG.Mesoscope & key;
            if rel_temp.count>0 % if its mesoscope data
                fr_interval= [-2, 5]; % for comparing firing rates between conditions and computing firing-rate maps
            else  % if its not mesoscope data
                fr_interval = [-1, 4];
            end
            time_resample_bin=0.5;
            flag_plot_cells =1; %1 yes, 0 no
            % Spline basis
            SPLINE_PARAM.order = 4; %4
            SPLINE_PARAM.nInternalKnots = 3; %5
            
            self2=LICK2D.ROILick2DPSTHStatsSpikesGLM;
            fn_computer_Lick2DPSTH_GLM2(key,self, rel_data,fr_interval, flag_electric_video, time_resample_bin, flag_plot_cells, self2, SPLINE_PARAM, dir_current_fig);
            
            %Also populates:
            %self2=LICK2D.ROILick2DPSTHStatsSpikesGLM;
            
            
        end
    end
end
