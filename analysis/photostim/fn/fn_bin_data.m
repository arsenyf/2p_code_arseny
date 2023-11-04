function [y_binned_mean, y_binned_stem, num_datapoints_in_bin]= fn_bin_data(x,y,bins)

for i_b = 1:1:numel(bins)-1
    idx_cor_bin = x>=bins(i_b) & x<bins(i_b+1);
    y_in_bin = y(idx_cor_bin);
    num_datapoints_in_bin (i_b) = numel(y_in_bin);
    y_binned_mean (i_b) = nanmean(y_in_bin);
    y_binned_stem (i_b) = nanstd(y_in_bin)./sqrt(numel(y_in_bin));
end
        
        