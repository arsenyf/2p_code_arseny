function fn_analysis_connectivity_versus_outdegree
close;
min_outdegree=[0,1,2,3,4,5,6,7,8,9,10,15,20];

rel1= STIMANAL.ConnectivityBetweenDirectlyStimulatedOnlyOverconnected   &  (STIMANAL.SessionEpochsIncludedFinal & IMG.Volumetric & 'stimpower>=100' & 'flag_include=1' );
rel = rel1  & (STIMANAL.NeuronOrControl & 'neurons_or_control=1' & 'num_targets>=50');
in_out_degree_corr_mean=[];
in_out_degree_corr_stem=[];
bidirectional_proportion_mean=[];
bidirectional_proportion_stem=[];
unidirectional_observed_to_expected_mean=[];
unidirectional_observed_to_expected_stem=[];
bidirectional_observed_to_expected_mean=[];
bidirectional_observed_to_expected_stem=[];

for i_m=1:1:numel(min_outdegree)
    temp=fetchn (rel & sprintf('min_outdegree=%d',min_outdegree(i_m)) & 'unidirectional_connect_number>10','in_out_degree_corr');
    in_out_degree_corr_mean (i_m) =nanmean( temp);
    in_out_degree_corr_stem (i_m) = nanstd (temp)/sqrt(numel(temp(~isnan(temp))));
    
    temp=1-fetchn (rel & sprintf('min_outdegree=%d',min_outdegree(i_m)) & 'unidirectional_connect_number>10','unidirectional_proportion');
    bidirectional_proportion_mean (i_m) =nanmean( temp);
    bidirectional_proportion_stem (i_m) = nanstd (temp)/sqrt(numel(temp(~isnan(temp))));
    
    unidirectional_connect_number=fetchn (rel & sprintf('min_outdegree=%d',min_outdegree(i_m)) & 'unidirectional_connect_number>10','unidirectional_connect_number');
    bidirectional_connect_number=fetchn (rel & sprintf('min_outdegree=%d',min_outdegree(i_m)) & 'unidirectional_connect_number>10','bidirectional_connect_number');
    
    out_degree_list=fetchn (rel & sprintf('min_outdegree=%d',min_outdegree(i_m)) & 'unidirectional_connect_number>10','out_degree_list');
    num_cells=[];
    out_degree_total=[];
    for i_r=1:1:numel(out_degree_list)
        num_cells(i_r)=numel(out_degree_list{i_r});
        out_degree_total(i_r)=sum(out_degree_list{i_r});
    end
    num_pairs = (num_cells.^2)-num_cells;
    prob_connection=out_degree_total./num_pairs;
    expected_connect_unidirection=2*num_pairs.*prob_connection.*(1-prob_connection);
    expected_connect_bidirection=(prob_connection.^2) .* num_pairs;
    
    temp = unidirectional_connect_number./expected_connect_unidirection';
    unidirectional_observed_to_expected_mean (i_m) =nanmean( temp);
    unidirectional_observed_to_expected_stem (i_m) = nanstd (temp)/sqrt(numel(temp(~isnan(temp))));
    
    temp = bidirectional_connect_number./expected_connect_bidirection';
    bidirectional_observed_to_expected_mean (i_m) =nanmean( temp);
    bidirectional_observed_to_expected_stem (i_m) = nanstd (temp)/sqrt(numel(temp(~isnan(temp))));
    
    
end

subplot(3,3,1)
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(min_outdegree,smooth(in_out_degree_corr_mean,5)',smooth(in_out_degree_corr_stem,5)',lineProps);
title('In out degree corr')
xlabel('Out-degree')

subplot(3,3,2)
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(min_outdegree,smooth(bidirectional_proportion_mean,5)',smooth(bidirectional_proportion_stem,5)',lineProps);
title('Bidirectional connection proportion')
xlabel('Out-degree')

subplot(3,3,3)
temp=fetchn (rel & sprintf('min_outdegree=%d',0) & 'unidirectional_connect_number>10','in_out_degree_corr');
histogram(temp,8)
xlim([-0.7,0.7])
title('In out degree corr')
xlabel('Out-degree')

subplot(3,3,4)
temp=1-fetchn (rel & sprintf('min_outdegree=%d',0) & 'unidirectional_connect_number>10','unidirectional_proportion');
histogram(temp,8)
xlim([0,0.5])
title('Bidirectional connection proportion')
xlabel('Out-degree')

subplot(3,3,5)
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(min_outdegree,smooth(unidirectional_observed_to_expected_mean,5)',smooth(unidirectional_observed_to_expected_stem,5)',lineProps);
title('Unidirectional observed/expected')

subplot(3,3,6)
lineProps.col={[0 0 0]};
lineProps.style='-';
lineProps.width=0.25;
mseb(min_outdegree,smooth(bidirectional_observed_to_expected_mean,5)',smooth(bidirectional_observed_to_expected_stem,5)',lineProps);
title('Bidirectional observed/expected')

