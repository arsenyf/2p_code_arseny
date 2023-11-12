function modulation_depth = fn_compute_generic_1D_or_2D_tuning_modulation_depth (tuning_curve)

%The function computes the modulation depth of a tuning. Tuning can be 1D (e.g., PSTH) or 2D (e.g., map)
max_fr = nanmax(tuning_curve(:));
min_fr = nanmin(tuning_curve(:));

modulation_depth = 100*(max_fr-min_fr)/max_fr;
