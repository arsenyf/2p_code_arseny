function Supp_Fig5_dist_dependent_corr_SVD()
% close all;


figure
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);
DefaultFontSize=16;

dir_base = fetch1(IMG.Parameters & 'parameter_name="dir_root_save"', 'parameter_value');
dir_current_fig = [dir_base  '\POP\corr_distance_pop\'];


rel_data = (POP.CorrPairwiseDistanceSVDPaper & 'threshold_for_event=0') & (IMG.Volumetric - IMG.Mesoscope);
num_svd_components_removed_vector = [0, 1, 3, 10];
distance_bins = fetch1(rel_data,'distance_bins','LIMIT 1');
x=distance_bins(1:end-1)+diff(distance_bins)/2;

colors=fake_parula(numel(num_svd_components_removed_vector)+2);
min_x=25; max_x=750;
for i_c=1:1:numel(num_svd_components_removed_vector)
    key.num_svd_components_removed=num_svd_components_removed_vector(i_c);
    
    %% Spontaneous activity
    key.session_epoch_type= 'spont_photo';
    D=fetch(rel_data&key,'*');
    subplot(2,3,1)
    hold on
    if  i_c==1
        plot([x(1),x(end)],[0,0],'-k');
    end
    y = cell2mat({D.distance_corr_all}');
    for i_s = 1:1:size(D)
    var_explained(i_c,i_s) = sum(D(i_s).variance_explained_components(1:i_c))

    end
    ymean=nanmean(y,1);
    ystem=nanstd(y,1)/sqrt(size(y,1));
    shadedErrorBar(x,ymean,ystem,'lineprops',{'-','Color',colors(i_c,:)})
    %                 ylim([0,max(ymean+ystem)])
    ylabel(sprintf('Pairwise Correlation'));
    xlim([min_x max_x]);
    xlabel('Lateral Distance (\mum)');
    title(sprintf('Spontaneous activity\n'));
    ylim([-0.01 0.3]);

    %zoom in
    subplot(2,3,4)
    hold on
    if  i_c==1
        plot([x(1),x(end)],[0,0],'-k');
    end
    y = cell2mat({D.distance_corr_all}');
    ymean=nanmean(y,1);
    ystem=nanstd(y,1)/sqrt(size(y,1));
    shadedErrorBar(x,ymean,ystem,'lineprops',{'-','Color',colors(i_c,:)})
    %                 ylim([0,max(ymean+ystem)])
    ylabel(sprintf('Pairwise Correlation'));
    xlim([min_x max_x]);
    xlabel('Lateral Distance (\mum)');
    key.session_epoch_type= 'spont_only';
    D=fetch(rel_data&key,'*');
    ylim([-0.005 0.005]);
    title(sprintf('Zoom in\n'));
    
end
%var explained by first PC
var_explained_first_pc= mean(var_explained(2,:))
fig = gcf;    %or one particular figure whose handle you already know, or 0 to affect all figures
set( findall(fig, '-property', 'fontsize'), 'fontsize', DefaultFontSize)
