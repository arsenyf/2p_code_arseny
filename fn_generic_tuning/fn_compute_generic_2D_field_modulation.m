function map_modulation = fn_compute_generic_2D_field_modulation (map)

max_fr = nanmax(map(:));
min_fr = nanmin(map(:));

map_modulation = 100*(max_fr-min_fr)/max_fr;
