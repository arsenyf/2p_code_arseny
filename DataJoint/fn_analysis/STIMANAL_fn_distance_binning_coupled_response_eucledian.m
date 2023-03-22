function key =STIMANAL_fn_distance_binning_coupled_response_eucledian(rel, key,DATA_all,rel_group_targets, p_val, distance_eucledian_bins,  flag_withold_trials, flag_normalize_by_total,flag_divide_by_std)
rel = rel & key;
if flag_withold_trials==0
    rel = rel & ['response_p_value1<=' num2str(p_val)];
else
    rel = rel & ['response_p_value1_odd<=' num2str(p_val)];
end

DATA=fetch((rel & rel_group_targets) & 'num_of_target_trials_used>0','*'); % we take all the cell pairs 

if flag_divide_by_std==0
    F_mean=[DATA.response_mean]';
    F_mean_odd=[DATA.response_mean_odd]';
    F_mean_even=[DATA.response_mean_even]';
elseif flag_divide_by_std==1
    F_mean=[DATA.response_mean]'./([DATA.response_std]+eps)';
    F_mean_odd=[DATA.response_mean_odd]'./([DATA.response_std]+eps)'; %have to be fixed in later versions to divide by std_odd
    F_mean_even=[DATA.response_mean_even]'./([DATA.response_std]+eps)';  %have to be fixed in later versions to divide by std_even
end

if flag_withold_trials==0
    ix_excit= F_mean>0;
    ix_inhbit= F_mean<0;
    F_data = F_mean;
else
    ix_excit= F_mean_odd>0;
    ix_inhbit= F_mean_odd<0;
    F_data = F_mean_even;
end

distance_eucledian=[DATA.response_distance_3d_um]';
distance_axial=[DATA.response_distance_axial_um]';

distance_axial_bins = unique(distance_axial);
if numel(distance_axial_bins)>0
    key.is_volumetric=true;
else
    key.is_volumetric=false;
end




distance_eucledian_all=[DATA_all.response_distance_3d_um]';


%% Eucledian binning
for i_l=1:1:numel(distance_eucledian_bins)-1
    ix_l = distance_eucledian>=distance_eucledian_bins(i_l) & distance_eucledian<distance_eucledian_bins(i_l+1);
    ix_l_all = distance_eucledian_all>=distance_eucledian_bins(i_l) & distance_eucledian_all<distance_eucledian_bins(i_l+1);
    
    if flag_normalize_by_total==1
        normalize_all=sum(ix_l_all);
        normalize_excitatory=sum(ix_l_all);
        normalize_inhibitory=sum(ix_l_all);
    elseif  flag_normalize_by_total==0
        normalize_all=sum(ix_l);
        normalize_excitatory=sum(ix_l & ix_excit);
        normalize_inhibitory=sum(ix_l & ix_inhbit);
    end
    
    
    if sum(ix_l)>0
        key.response_eucledian(i_l) =single(nansum(F_data(ix_l))/normalize_all);
        key.response_eucledian_absolute(i_l) = single(nansum(abs(F_data(ix_l)))/normalize_all);
    else
        key.response_eucledian(i_l) =NaN;
        key.response_eucledian_absolute(i_l) = NaN;
    end
    if sum(ix_l & ix_excit)>0
        key.response_eucledian_excitation(i_l) =single(nansum(F_data(ix_l & ix_excit))/normalize_excitatory);
    else
        key.response_eucledian_excitation(i_l) =NaN;
    end
    if sum(ix_l & ix_inhbit)>0
        key.response_eucledian_inhibition(i_l) =single(nansum(F_data(ix_l & ix_inhbit))/normalize_inhibitory);
    else
        key.response_eucledian_inhibition(i_l) =NaN;
    end
end
% fff=fetch1(IMG.PhotostimDATfile & key,'dat_file')
key.response_p_val=p_val;
key.num_pairs = numel(F_data);
key.distance_eucledian_bins  = distance_eucledian_bins;
key.num_targets=rel_group_targets.count;




