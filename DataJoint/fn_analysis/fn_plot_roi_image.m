function [xl,yl] = fn_plot_roi_image(plane,color_max_factor, R, axx)

radius_pixels=20;
% plane1=fetch1(IMG.Plane & key_fov_example & 'plane_num=1','mean_img_enhanced');

imagesc(plane);
caxis([0 max(plane(:))*color_max_factor])
axis off;
axis tight;
axis equal;
colormap(axx,gray)
% plot(R.roi_x_pix,R.roi_y_pix,'.b')
xx=zeros(size(plane));
for i=1:1:numel(R.roi_x_pix)
    xx(R.roi_y_pix(i),R.roi_x_pix(i))=1;
end
cc=contourc(xx);

m_cx=median(cc(1,:));
m_cy=median(cc(2,:));

idx_outlier_x= (cc(1,:)>m_cx*1.5 | cc(1,:)<m_cx*0.5);
idx_outlier_y= (cc(2,:)>m_cy*1.5 | cc(2,:)<m_cy*0.5);

idx_outlier = idx_outlier_x | idx_outlier_y;

plot(cc(1,~idx_outlier),cc(2,~idx_outlier),'-r','LineWidth',0.1)
xl=[R.roi_centroid_x-radius_pixels,R.roi_centroid_x+radius_pixels];
yl=[R.roi_centroid_y-radius_pixels,R.roi_centroid_y+radius_pixels];
xlim(xl)
ylim(yl)