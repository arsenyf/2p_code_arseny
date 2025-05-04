%{
# Pairwise correlation as a function of distance
-> EXP2.SessionEpoch
threshold_for_event             : double          # threshold in zscore, after binning. 0 means we don't threshold. 1 means we take only positive events exceeding 1 std, 2 means 2 std etc.
num_svd_components_removed      : int     # how many of the first svd components were removed
---
corr_histogram                        :blob        # histogram of all pairwise correlations
corr_histogram_bins                   :blob        # corresponding bins
distance_corr_all                     :blob        # average pairwise pearson coeff, binned according to lateral distance between neurons
distance_corr_positive                :blob        # average positive pairwise pearson coeff, binned according to lateral distance between neurons
distance_corr_negative                :blob        # average negative pairwise pearson coeff, binned according to lateral distance between neurons
distance_bins                         :blob        # corresponding bins
corr_histogram_per_distance           :longblob    # a matrix containing, for each distance bin, the histogram of correlations in this distance bin, binned into corr_histogram_bins
variance_explained_components         :blob        # by the SVD components
%}


classdef CorrPairwiseDistanceSVDPaperEucledian < dj.Computed
    properties
        keySource =(EXP2.SessionEpoch & IMG.ROIdeltaF & STIMANAL.MiceIncluded & IMG.PlaneCoordinates)- EXP2.SessionEpochSomatotopy-IMG.Mesoscope &  (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1');
%                 keySource =(EXP2.SessionEpoch & 'session_epoch_type="spont_only"'  & IMG.ROIdeltaF & STIMANAL.MiceIncluded & IMG.PlaneCoordinates)- EXP2.SessionEpochSomatotopy-IMG.Mesoscope &  (EXP2.Session & (STIMANAL.SessionEpochsIncludedFinalUniqueEpochs & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1'));

    end
    methods(Access=protected)
        function makeTuples(self, key)
            dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
            dir_save_fig = [dir_base  '\POP\corr_distance\dff_paper\'];
            num_svd_components_removed_vector = [0, 1, 3, 10];

            threshold_for_event_vector=[0];
            time_bin_vector=[0]; % we will bin the data into these time bins before doing SVD
            flag_zscore=1; %0 only centering the data (i.e. mean subtraction),  1 zscoring the data
            rel_data = (IMG.ROIdeltaF & key)-IMG.ROIBad;
            for it=1:1:numel(time_bin_vector)
                fn_compute_CorrPairwiseDistancePaperEucledian(key, rel_data, self, flag_zscore,time_bin_vector(it), threshold_for_event_vector, dir_save_fig, num_svd_components_removed_vector)
            end
        end
    end
end

