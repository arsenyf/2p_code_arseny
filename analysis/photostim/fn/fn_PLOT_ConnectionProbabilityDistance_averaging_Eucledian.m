function OUT=fn_PLOT_ConnectionProbabilityDistance_averaging_Eucledian(D,D_all, flag_response)
OUT=[];

distance_eucledian_bins=D(1).distance_eucledian_bins;
distance_eucledian_bins_centers= distance_eucledian_bins(1:end-1)+diff(distance_eucledian_bins)/2;


num_pairs=0;
for ii=1:1:size(D,1)
    num_pairs=num_pairs+D(ii).num_pairs;
    switch flag_response
        case 0 %all
            current_eucledian = D(ii).response_eucledian;
                case 1 %excitation
            current_eucledian = sum(D(ii).counts_eucledian_excitation,1)./sum(D_all(ii).counts_eucledian,1);
               case 2 %inhibition
            current_eucledian = sum(D(ii).counts_eucledian_inhibition,1)./sum(D_all(ii).counts_eucledian,1);
        case 3 %absolute
            current_eucledian = D(ii).response_eucledian_absolute;
            end
       eucledian_marginal(ii,:) = current_eucledian;
end

OUT.distance_eucledian_bins_centers=distance_eucledian_bins_centers;

OUT.num_pairs=num_pairs;

OUT.marginal_eucledian_mean=nanmean(eucledian_marginal,1);
OUT.marginal_eucledian_stem=nanstd(eucledian_marginal,1)./sqrt(sum(~isnan(eucledian_marginal)));



