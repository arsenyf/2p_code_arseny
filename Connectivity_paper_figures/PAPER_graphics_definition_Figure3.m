%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);


%% fov
panel_width1_fov=0.1;
panel_height1_fov=0.1;
position_x1_fov(1)=0.2;
position_y1_fov(1)=0.8;

horizontal_dist=0.15;
vertical_dist=0.15;

%Connection Probability
panel_width1=0.05;
panel_height1=0.03;
position_x1(1)=0.23;
position_x1(end+1)=position_x1(end)+horizontal_dist;

position_y1(1)=0.755;
position_y1(end+1)=position_y1(end)-vertical_dist;
position_y1(end+1)=position_y1(end)-vertical_dist;


%Influence
horizontal_dist2=0.19;
vertical_dist2=0.065;

panel_width2=0.1;
panel_height2=0.1;
position_x2(1)=0.36;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.81;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

