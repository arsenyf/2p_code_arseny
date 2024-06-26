function [field_density_XY, field_density_XY_with_NaN] ...
    = fn_compute_generic_2D_field3_short ...
    (X_position_bins_vector, Y_position_bins_vector, count_XY_video, count_XY_spikes, time_spent_minimum_for_2D_bins, sigma, hsize, legalize_by_neighbor_bins_flag, min_percent_coverage)

% to avoid negative "firing rates" -- which can be if instead of spikes we use df/f imaging traces
if min(count_XY_spikes(:))<0
    count_XY_spikes = count_XY_spikes - min(count_XY_spikes(:));
end


%% Computing a 2D-field for any 2D variables(X,Y), for example Place-field X-Y
%adds NaNs to any unvisited bin
count_XY_video_with_NaN=count_XY_video;
count_XY_video_with_NaN ( find(count_XY_video_with_NaN<time_spent_minimum_for_2D_bins)) = NaN;

field_density_XY=count_XY_spikes./count_XY_video; %might have NaNs if the bin literally had zero visitations
field_density_XY_with_NaN=count_XY_spikes./count_XY_video_with_NaN; %with NaNs at any unvisited bin



%% Smoothing
%==========================================================================

% Create gaussian kernel:
% sigma    Is the standard deviation of the kernel, which determines its width.
% for larger values, the kernel and is in fact wider. Our 1.5 bins
% kernel is relatively conservative in comparison to what people
% usually use.
% hsize    Is the size of the kernel: I define it as 5*round(sigma)+1
% Just in order to make sure it is long enough to facilitate suffficent
% fading of the gaussian. In practise, it is much longer then what we
% actually need!
gaussian_kernel = fspecial('gaussian',hsize,sigma);

% Smoothing = convolve with gaussian kernel:
count_XY_video_smoothed = imfilter(count_XY_video,gaussian_kernel);
count_XY_spikes_smoothed = imfilter(count_XY_spikes,gaussian_kernel);

%% "Legalize" a bin (remove NaN) if there is data in any of the bin's 8 closest neighbours:
%==========================================================================
if legalize_by_neighbor_bins_flag ==1
    
    warning off all
    count_XY_video_with_extra_edges=zeros( length(Y_position_bins_vector)+1, length(X_position_bins_vector)+1 ); %to deal with edge related problems
    count_XY_video_with_extra_edges(2:end-1,2:end-1)=count_XY_video;
    idx_timespent_density =zeros( length(Y_position_bins_vector)+1, length(X_position_bins_vector)+1 ) + NaN ; % Initialize
    
    for ii_X_bin = 2 : length(X_position_bins_vector)  % Loop over X-bins
        for ii_Y_bin = 2 : length(Y_position_bins_vector)  % Loop over Y-bins
            matrix_3x3_of_neighbors = ...
                count_XY_video_with_extra_edges( ii_Y_bin-1 : ii_Y_bin+1, ii_X_bin-1 : ii_X_bin+1 ) ;
            sum_including_the_central_bin = sum(sum( matrix_3x3_of_neighbors)); % Count the matrix_3x3_of_neighbors + the central bin itself
            if ( sum_including_the_central_bin  > 0 ), % If the animal visited any of this bin's 8 neighbors (3x3 region)
                idx_timespent_density(ii_Y_bin,ii_X_bin) = 1; % Put 1 in the central bin
            else  % If the animal did NOT visit any of this bin's 8 neighbors (3x3 region)
                idx_timespent_density(ii_Y_bin,ii_X_bin) = 0; % Put 0 in the central bin (later we will divide by this 0 and will get NaN for the firing-rate map)
            end
        end
    end
    idx_timespent_density=idx_timespent_density(2:end-1,2:end-1);
    warning on all
    
    % XY Field = Spike Density smoothed / Time-Spent Density smoothed with legalized bins:
    warning off MATLAB:divideByZero ;
    count_XY_video_smoothed_with_NaN=(count_XY_video_smoothed .* idx_timespent_density)./idx_timespent_density;
    field_density_smoothed_XY_with_NaN = count_XY_spikes_smoothed ./ count_XY_video_smoothed_with_NaN ;
    warning on MATLAB:divideByZero ;
    
else %if we don't want to legalize bins by its neighbors occupancy
    count_XY_video_smoothed_with_NaN=count_XY_video_smoothed  +count_XY_video_with_NaN.*0; %adds NaNs to unvisited locations
    field_density_smoothed_XY_with_NaN = (count_XY_spikes_smoothed ./ count_XY_video_smoothed_with_NaN);
end



