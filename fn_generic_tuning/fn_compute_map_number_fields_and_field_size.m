function [number_of_fields,fields_size, number_of_fields_baseline_substracted, fields_size_baseline_substracted] = fn_compute_map_number_fields_and_field_size (M , threshold_for_peak)


%% Field Size
max_m = nanmax(M(:));
idx_peaks = M>max_m*threshold_for_peak;
CC = bwconncomp(idx_peaks);
number_of_fields = CC.NumObjects;
fields_size=NaN; %default
for i_f=1:1:number_of_fields
    fields_size(i_f) = numel(CC.PixelIdxList{i_f});
end
%% Field Size without baseline (after baseline subtraction)
M_without_baseline =M-nanmin(M(:));
max_m=nanmax(M_without_baseline (:));
idx_peaks = M_without_baseline>max_m*threshold_for_peak;
CC = bwconncomp(idx_peaks);
number_of_fields_baseline_substracted = CC.NumObjects;
fields_size_baseline_substracted=NaN; %default
for i_f=1:1:number_of_fields_baseline_substracted
    fields_size_baseline_substracted(i_f) = numel(CC.PixelIdxList{i_f});
end
% subplot(2,2,1)
% imagesc(M)
% 
% subplot(2,2,2)
% imagesc(M_without_baseline)
