function   fn_compute_graph_and_connectivity_stats_min_out_degree(key, p_val_threshold,min_outdegree, minimal_distance, dir_save_figure, self)
close
%Graphics
%---------------------------------
fff = figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

panel_width=0.5;
panel_height=0.7;
horizontal_distance=0.5;
vertical_distance=0.7;

position_x(1)=0.2;
position_x(end+1)=position_x(end) + horizontal_distance;

position_y(1)=0.15;
position_y(end+1)=position_y(end) - vertical_distance;



%% ETL corrected
rel_roi_temp =(IMG.ROIPositionETL - IMG.ROIBad) & (STIMANAL.NeuronOrControl & 'neurons_or_control=1') & key;
rel_group =  (STIMANAL.NeuronOrControl & 'neurons_or_control=1') & key;
rel_out_degree = STIMANAL.OutDegree & key & 'p_val=0.05' & 'max_distance_lateral=100' & sprintf('out_degree_excitatory>=%d',min_outdegree);
rel_roi = rel_roi_temp & rel_group & rel_out_degree;

if isempty(rel_roi.count)
    return
end
    
try
    zoom =fetch1(IMG.FOVEpoch & key,'zoom');
    kkk.scanimage_zoom = zoom;
    pix2dist=  fetch1(IMG.Zoom2Microns & kkk,'fov_microns_size_x') / fetch1(IMG.FOV & key, 'fov_x_size');
catch
    pix2dist= fetch1(IMG.Parameters & 'parameter_name="fov_size_microns_z1.1"', 'parameter_value')/fetch1(IMG.FOV & key, 'fov_x_size');
end

roi_num=  fetchn( rel_roi & key & STIM.ROIResponseDirectUnique & (STIMANAL.NeuronOrControl & 'neurons_or_control=1') ,'roi_number','ORDER BY roi_number');
group_num=  fetchn( (STIMANAL.NeuronOrControl & 'neurons_or_control=1') & key ,'photostim_group_num','ORDER BY photostim_group_num');
group_roi_num=  fetchn( STIM.ROIResponseDirectUnique & key & (STIMANAL.NeuronOrControl & 'neurons_or_control=1'),'roi_number','ORDER BY photostim_group_num');
roi_centroid_x=  fetchn( rel_roi  & key,'roi_centroid_x_corrected','ORDER BY roi_number')*pix2dist;
roi_centroid_y=  fetchn(  rel_roi & key,'roi_centroid_y_corrected','ORDER BY roi_number')*pix2dist;
F=(fetch( STIM.ROIInfluence2 & rel_roi &  key & 'response_mean>0' & sprintf('response_distance_lateral_um>=%.2f', minimal_distance) &  sprintf('response_p_value1<=%.5f', p_val_threshold),'*'));

[~,temp_idx]=setdiff(roi_num,group_roi_num);
if ~isempty(temp_idx)
    sprintf('Mismatch Debug')
end

if isempty(F)
    return
end
F=struct2table(F);


s=fetch(EXP2.Session & key,'*');

% Creating a Graph
M=zeros(numel(roi_num));
Mdistance=zeros(numel(roi_num));
Mpval=zeros(numel(roi_num))+1;

for i_r  = 1:1:numel(roi_num)
    [idx_roi]=find(group_roi_num==roi_num(i_r));
    F_selected=F(F.photostim_group_num ==group_num(idx_roi),:);
    if isempty(F_selected)
        M(i_r,1:numel(roi_num))=0;
        Mpval(i_r,1:numel(roi_num))=1;
        Mdistance(i_r,1:numel(roi_num))=0;
    else
        idx_rois_selected =  find(ismember(roi_num, F_selected.roi_number'));
        M(i_r,idx_rois_selected)=F_selected.response_mean';
        Mpval (i_r,idx_rois_selected)=   F_selected.response_p_value1';
        Mdistance (i_r,idx_rois_selected) =   F_selected.response_distance_lateral_um';
        
    end
end



M = M - diag(diag(M)); %setting diagonal values to 0
%             M(Mpval>p_val_threshold)=0;
%             M(Mdistance<=minimal_distance)=0;


%             idx_clusters = kmeans(M,10)
%             [~,idx_clusters_sorted]=sort(idx_clusters, 'ascend');
%
%             M_sorted = M(idx_clusters_sorted,:);
%             imagesc(M_sorted)

G = digraph(M);
LWidths = 5*abs(G.Edges.Weight)/max(abs(G.Edges.Weight));
Dout = outdegree(G);
Din = indegree(G);
try
    in_out_degree_correlation = corr(Dout,Din);
catch
    in_out_degree_correlation=NaN;
end


unidirectional_connect_number=0;
bidirectional_connect_number=0;

for i_x=1:1:size(M,1)
    idx_responsive=find(M(i_x,:)>0);
    for i_y=1:1:numel(idx_responsive)
        if M(idx_responsive(i_y),i_x)>0
            bidirectional_connect_number=bidirectional_connect_number+1;
        else
            unidirectional_connect_number=unidirectional_connect_number+1;
        end
    end
end
unidirectional_proportion=unidirectional_connect_number/(unidirectional_connect_number+bidirectional_connect_number);


key.p_val_threshold = p_val_threshold;
key.mat_response_mean=M;
key.mat_distance=Mdistance;
key.mat_response_pval=Mpval;

key.roi_num_list = roi_num;
key.photostim_group_num_list = group_roi_num;
key.in_out_degree_corr = in_out_degree_correlation;

key.out_degree_list  = Dout;
key.in_degree_list  = Din;

key.unidirectional_connect_number   = unidirectional_connect_number;
key.bidirectional_connect_number    = bidirectional_connect_number;
key.unidirectional_proportion = unidirectional_proportion;
key.min_outdegree = min_outdegree;

insert(self,key);


%% PLOTTING
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
hold on
mean_img_enhanced = fetch1(IMG.Plane & key & 'plane_num=1','mean_img_enhanced');
x_dim = [0:1:(size(mean_img_enhanced,1)-1)]*pix2dist;
y_dim = [0:1:(size(mean_img_enhanced,2)-1)]*pix2dist;

p = plot(G,'XData',roi_centroid_x,'YData',roi_centroid_y,'NodeLabel',{});
p.EdgeCData = table2array(G.Edges(:,2));
p.NodeColor = [1 0 1];
p.MarkerSize = (Dout+0.01)/5;

colormap bluewhitered
h = colorbar;
ylabel(h,sprintf('Connection strength \n(\\Delta activity z-score)'),'FontSize',20);
h.Limits	 = [0,ceil(h.Limits(2))];
h.Ticks = h.Limits;

axis xy
axis equal
xlabel('Anterior - Posterior (\mum)','FontSize',20);
ylabel('Lateral - Medial (\mum)','FontSize',20);
set(gca,'Xlim',[min(x_dim),max(x_dim)],'Xtick',[0, 100*floor(max(x_dim)/100)], 'Ylim',[min(y_dim),max(y_dim)],'Ytick',[0, 100*floor(max(y_dim)/100)],'TickLength',[0.01,0],'TickDir','out','FontSize',20)

title(sprintf('Session %d epoch %d \n anm %d  %s \n In-Out degree corr = %.2f unidirectional proportion = %.2f \n p val=%.3f\n Min out degree threshold = %d',s.session,  key.session_epoch_number,s.subject_id, s.session_date,in_out_degree_correlation, unidirectional_proportion, p_val_threshold,min_outdegree ),'FontSize',12);

%Saving the graph

dir_current_figure = [dir_save_figure];

if isempty(dir(dir_current_figure))
    mkdir (dir_current_figure)
end
figure_name_out = [dir_current_figure  'anm' num2str(s.subject_id) '_' 's' num2str(s.session ) '_' s.session_date '_epoch' num2str(key.session_epoch_number)];
eval(['print ', figure_name_out, ' -dtiff  -r500']);
eval(['print ', figure_name_out, ' -dpdf  -r500']);


