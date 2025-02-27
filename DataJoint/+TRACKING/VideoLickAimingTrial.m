%{
# Measurements for the entire session: calculates standard deviation of the tongue position and bins it according to licport position in x,z
-> EXP2.Session
---
number_of_bins                                    : int
aiming_2d_before_1st_contact                      : blob                 #  licks before 1st contact with the target
aiming_2d_at_1st_contact                          : blob                 #  licks at 1st contact with the target
aiming_2d_after_1st_contact_including             : blob                 #  licks after 1st contact with the target, including that 1st contact
aiming_2d_before_lickport_entrance                : blob                 #  licks before lickport entrance
aiming_2d_after_lickport_entrance                 : blob                 #  licks after lickport entrance
%}


classdef VideoLickAimingTrial < dj.Computed
    properties
        keySource = (EXP2.Session  & TRACKING.VideoNthLickTrial) ;
        
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            key_insert = fetch(EXP2.Session & key);
            rel = TRACKING.VideoNthLickTrial*EXP2.SessionTrial*TRACKING.VideoLickportPositionTrial*EXP2.TrialLickPortPositionRescale*EXP2.SessionTrialUniqueIDCorrect & key;
            %             rel_licks_video_after_1st_contact = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_firsttouch>=0') ;
            %             rel_licks_electric_contacts_only = (TRACKING.VideoNthLickTrial& key & 'lick_touch_number>=0');
            %             rel_licks_video_before_lickport_entrance = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_lickport_entrance<0');
            %             rel_licks_video_after_lickport_entrance = (TRACKING.VideoNthLickTrial& key & 'lick_number_relative_to_lickport_entrance>=0');
            %
            
            
            %z- motor
            % zaber_to_mm_z_motor = 1/1000; %1,000 in zaber motor units == 1 mm
            zaber_to_mm_z_motor = 1/10000; %1,000 in zaber motor units == 1 mm
            
            %x- motor, and y-motor
            zaber_to_mm_x_motor = 1.25/50000; %50,000 in zaber motor units ==1.25 mm
            
            [Xpix2mm, Zpix2mm]  =  fn_video_pixels_to_mm (key, zaber_to_mm_z_motor, zaber_to_mm_x_motor);

            
            
            T = fetch(rel & 'lick_number_relative_to_firsttouch<0','lickport_pos_x','lickport_pos_z', 'lick_peak_x','lickport_x','number_of_bins', 'ORDER BY trial_uid_correct');
            aiming_2d_before_1st_contact = fn_tongue_variability(T, Xpix2mm, Zpix2mm);
            number_of_bins = T(1).number_of_bins;
            
            T = fetch(rel & 'lick_number_relative_to_firsttouch=0','lickport_pos_x','lickport_pos_z', 'lick_peak_x','lickport_x','number_of_bins', 'ORDER BY trial_uid_correct');
            aiming_2d_at_1st_contact = fn_tongue_variability(T, Xpix2mm, Zpix2mm);
            
            T = fetch(rel & 'lick_number_relative_to_firsttouch>=0','lickport_pos_x','lickport_pos_z', 'lick_peak_x','lickport_x','number_of_bins', 'ORDER BY trial_uid_correct');
            aiming_2d_after_1st_contact_including = fn_tongue_variability(T, Xpix2mm, Zpix2mm);
            
            T = fetch(rel & 'lick_number_relative_to_lickport_entrance<0','lickport_pos_x','lickport_pos_z', 'lick_peak_x','lickport_x','number_of_bins', 'ORDER BY trial_uid_correct');
            aiming_2d_before_lickport_entrance = fn_tongue_variability(T, Xpix2mm, Zpix2mm);
            
            T = fetch(rel & 'lick_number_relative_to_lickport_entrance>=0','lickport_pos_x','lickport_pos_z', 'lick_peak_x','lickport_x','number_of_bins', 'ORDER BY trial_uid_correct');
            aiming_2d_after_lickport_entrance = fn_tongue_variability(T, Xpix2mm, Zpix2mm);
            
            subplot(3,3,1)
            imagesc(aiming_2d_before_1st_contact)
            title('aiming before 1st contact')
            colormap(jet)
            colorbar
            %caxis([-0.3,0.6])
                                    caxis([0,20])

            subplot(3,3,2)
            imagesc(aiming_2d_at_1st_contact)
            colorbar
            title('aiming at 1st contact')
                        %caxis([-0.2,0.6])
                        caxis([0,20])

            subplot(3,3,3)
            imagesc(aiming_2d_after_1st_contact_including)
            colorbar
            title('aiming after 1st contact including')
                        %caxis([-0.2,0.6])
                        caxis([0,20])

            subplot(3,3,4)
            imagesc(aiming_2d_before_lickport_entrance)
            colorbar
            title('aiming before lickport entrance')
                        %caxis([-0.3,0.6])
                        caxis([0,20])

            subplot(3,3,5)
            imagesc(aiming_2d_after_lickport_entrance)
            colorbar
            title('aiming after lickport entrance')
                        %caxis([-0.3,0.6])
                        caxis([0,20])

            key_insert.number_of_bins = number_of_bins;
            key_insert.aiming_2d_before_1st_contact =  aiming_2d_before_1st_contact;
            key_insert.aiming_2d_at_1st_contact =  aiming_2d_at_1st_contact;
            key_insert.aiming_2d_after_1st_contact_including =  aiming_2d_after_1st_contact_including;
            key_insert.aiming_2d_before_lickport_entrance =  aiming_2d_before_lickport_entrance;
            key_insert.aiming_2d_after_lickport_entrance =  aiming_2d_after_lickport_entrance;
            insert(self,key_insert);
            
            
            
            function aiming_2d = fn_tongue_variability(T, Xpix2mm, Zpix2mm)
                number_of_bins = T(1).number_of_bins;
                x_bins = linspace(-1, 1,number_of_bins+1);
                x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;
                z_bins = linspace(-1,1,number_of_bins+1);
                z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;
                x_bins(1)= -inf;
                x_bins(end)= inf;
                z_bins(1)= -inf;
                z_bins(end)= inf;
                
                pos_x = [T.lickport_pos_x];
                pos_z = [T.lickport_pos_z];
                [~, ~, ~, x_idx, z_idx] = histcounts2(pos_x,pos_z,x_bins,z_bins);
%                 lickport_physical_position_x = [T.lickport_x]';
                lick_peak_x = [T.lick_peak_x]'.*Xpix2mm.slope + Xpix2mm.intercept;
                aiming_2d=[];
                for i_x=1:1:numel(x_bins_centers)
                    for i_z=1:1:numel(z_bins_centers)
                        idx = find((x_idx==i_x)  &  (z_idx==i_z));
                    aiming_2d(i_z,i_x)=nanstd(lick_peak_x(idx));

%                     aiming_2d(i_z,i_x)=nanstd(lick_peak_x(idx));
%                         aiming_2d(i_z,i_x)=corr(lickport_physical_position_x(idx),lick_peak_x(idx),'Rows','pairwise');
%                     aiming_2d(i_z,i_x)=nanmean(abs(lickport_physical_position_x(idx)-lick_peak_x(idx)));

                    end
                end
            end
            
            
            function aiming_2d = fn_tongue_target_correlation(T)
                number_of_bins = T(1).number_of_bins;
                x_bins = linspace(-1, 1,number_of_bins+1);
                x_bins_centers=x_bins(1:end-1)+mean(diff(x_bins))/2;
                z_bins = linspace(-1,1,number_of_bins+1);
                z_bins_centers=z_bins(1:end-1)+mean(diff(z_bins))/2;
                x_bins(1)= -inf;
                x_bins(end)= inf;
                z_bins(1)= -inf;
                z_bins(end)= inf;
                
                pos_x = [T.lickport_pos_x];
                pos_z = [T.lickport_pos_z];
                [~, ~, ~, x_idx, z_idx] = histcounts2(pos_x,pos_z,x_bins,z_bins);
                lickport_physical_position_x = [T.lickport_x]';
                lick_peak_x = [T.lick_peak_x]';
                aiming_2d=[];
                for i_x=1:1:numel(x_bins_centers)
                    for i_z=1:1:numel(z_bins_centers)
                        idx = find((x_idx==i_x)  &  (z_idx==i_z));
%                         aiming_2d(i_z,i_x)=corr(lickport_physical_position_x(idx),lick_peak_x(idx),'Rows','pairwise');
                    aiming_2d(i_z,i_x)=nanmean(abs(lickport_physical_position_x(idx)-lick_peak_x(idx)));

                    end
                end
            end
            
        end
        
        
    end
end

