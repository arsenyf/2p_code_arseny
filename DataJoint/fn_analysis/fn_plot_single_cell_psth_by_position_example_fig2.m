function [psth_time] = fn_plot_single_cell_psth_by_position_example_fig2 (rel_example, roi_number_uid, xlabel_flag, ylabel_flag, position_x1_grid, position_y1_grid, cell_number2d, psth_max_all2)
key_roi.roi_number_uid =roi_number_uid;
P =fetch(rel_example & key_roi,'*');
try
psth_time = P.psth_time;
catch
    psth_time = P.psthmap_time;
end
number_of_bins =P.number_of_bins;
pos_x_bins_centers =P.pos_x_bins_centers;
pos_z_bins_centers =P.pos_z_bins_centers';

% we do it for display purpose only only for those experiment for which there was no data in one of  the positions due to technical reasons
P.psth_per_position_regular = fn_map_2D_legalize_by_neighboring_psth(P.psth_per_position_regular);
P.psth_per_position_regular_stem = fn_map_2D_legalize_by_neighboring_psth(P.psth_per_position_regular_stem);



horizontal_dist1=(1/(number_of_bins+2))*0.1*1.25;
vertical_dist1=(1/(number_of_bins+2))*0.08*1.5;
panel_width1=(1/(number_of_bins+6))*0.15*1.25;
panel_height1=(1/(number_of_bins+6))*0.09*1.5;
for i=1:1:number_of_bins-1
    position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist1;
    position_y1_grid(end+1)=position_y1_grid(end)+vertical_dist1;
end


xl = [floor(psth_time(1)) ceil(psth_time(end))];

%% 1 PSTH per position, for regular reward
psth_max_regular= cell2mat(reshape(P.psth_per_position_regular,[number_of_bins^2,1])) + cell2mat(reshape(P.psth_per_position_regular_stem,[number_of_bins^2,1]));
try
    odd=cell2mat(reshape(P.psth_per_position_regular_odd,[number_of_bins^2,1]));
    even=cell2mat(reshape(P.psth_per_position_regular_even,[number_of_bins^2,1]));
    psth_max_all=max([psth_max_regular(:);odd(:);even(:)]);
catch
    psth_max_all=max([psth_max_regular(:)]);
end

current_plot=0;
for  i_x=1:1:number_of_bins
    for  i_z=1:1:number_of_bins
        current_plot=current_plot+1;
        axes('position',[position_x1_grid(i_x), position_y1_grid(i_z), panel_width1, panel_height1]);
        hold on;
        plot([0,0],[0,1],'-k','linewidth',0.25)
        temp_mean=P.psth_per_position_regular{i_z,i_x}./psth_max_all;
        temp_stem=P.psth_per_position_regular_stem{i_z,i_x}./psth_max_all;
        %         try
        %             plot(psth_time,P.psth_per_position_regular_odd{i_z,i_x}./psth_max_all,'-','Color',[1 0 0],'linewidth',0.5);
        %             plot(psth_time,P.psth_per_position_regular_even{i_z,i_x}./psth_max_all,'-','Color',[0 0 1],'linewidth',0.5);
        %         end
        %         shadedErrorBar(psth_time,temp_mean, temp_stem,'lineprops',{'-','Color',[ 0 0 0.8],'linewidth',0.75});
        lineProps.col={[ 0 0 0.8]};
        lineProps.style='-';
        lineProps.width=0.5;
        mseb(psth_time,temp_mean, temp_stem,lineProps);
        
        ylims=[0,1+eps];
        ylim(ylims);
        xlim(xl);
        if current_plot ==1
            if ~isempty(cell_number2d)
                %                             text(-2,8,sprintf('Cell %d field-size %.1f %%',cell_number2d, field_size_regular),'HorizontalAlignment','left', 'FontSize',6);
                text(-2,6.5,sprintf('Cell %d, emergence of location tuning \nonly upon reward increase',cell_number2d),'HorizontalAlignment','left', 'FontSize',6, 'fontweight', 'bold');
            end
            if xlabel_flag==1
                text(-2,-2.2,sprintf('Time to 1st contact-lick (s)'),'HorizontalAlignment','left', 'FontSize',6);
            end
            if ylabel_flag==1
                text(-8,0,'Activity (norm.)','HorizontalAlignment','left','Rotation',90, 'FontSize',6);
            end
            set(gca,'XTick',[0,xl(2)],'Ytick',ylims, 'YtickLabel', [{'0', sprintf('%.2f',psth_max_all/psth_max_all2)}],  'FontSize',6,'TickLength',[0.1,0],'TickDir','out');
        else
            set(gca,'XTick',[0,xl(2)],'XtickLabel',[],'Ytick',ylims,'YtickLabel',[], 'FontSize',6,'TickLength',[0.1,0],'TickDir','out');
            axis off
        end
    end
end


% %% Map regular reward stability
%
% ax6=axes('position',[position_x1_grid(1)+0.08,position_y1_grid(1)+0.03, panel_width_map, panel_height_map]);
% mmm=P.lickmap_fr_regular_odd;
% mmm=mmm./nanmax(mmm(:));
% imagescnan(mmm);
% max_map=max(mmm(:));
% caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
% colormap(ax6,inferno)
% %     title(sprintf('Stability r = %.2f \n Odd trials\n', P.lickmap_regular_odd_vs_even_corr), 'FontSize',6);
% title(sprintf('Stability: \n Odd trials'), 'FontSize',6);
% axis equal;
% axis tight
% set(gca,'YDir','normal');
% %     colorbar
% axis off
%
% ax6=axes('position',[position_x1_grid(1)+0.08,position_y1_grid(1), panel_width_map, panel_height_map]);
% mmm=P.lickmap_fr_regular_even;
% mmm=mmm./nanmax(mmm(:));
% imagescnan(mmm);
% max_map=max(mmm(:));
% caxis([0 max_map]); % Scale the lowest value (deep blue) to 0
% colormap(ax6,inferno)
% title(sprintf('\nEven trials'), 'FontSize',6);
% axis equal;
% axis tight;
% set(gca,'YDir','normal');
% %     colorbar
% axis off
