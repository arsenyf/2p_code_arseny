%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);


% histograms

panel_width1=0.04;
panel_height1=0.04;
horizontal_dist1=0.1;
vertical_dist1=0.1;
position_x1(1)=0.1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;
position_x1(end+1)=position_x1(end)+horizontal_dist1;

position_y1(1)=0.8;
position_y1(end+1)=position_y1(end)-vertical_dist1;



panel_width2=0.04;
panel_height2=0.04;
horizontal_dist2=0.1;
vertical_dist2=0.1;
position_x2(1)=0.4;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.62;
position_y2(end+1)=position_y2(end)-vertical_dist2;




% 2d tuning on grid
horizontal_dist_between_cells_grid1=0.15;
vertical_dist_between_cells_grid1=0.08;

position_x1_grid(1)=0.1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;

position_y1_grid(1)=0.69;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;

% 2d tuning on grid

position_x2_grid(1)=0.4;
position_x2_grid(end+1)=position_x2_grid(end)+horizontal_dist_between_cells_grid1;
position_x2_grid(end+1)=position_x2_grid(end)+horizontal_dist_between_cells_grid1;
position_x2_grid(end+1)=position_x2_grid(end)+horizontal_dist_between_cells_grid1;

position_y2_grid(1)=0.8;
position_y2_grid(end+1)=position_y2_grid(end)-vertical_dist_between_cells_grid1;
position_y2_grid(end+1)=position_y2_grid(end)-vertical_dist_between_cells_grid1;






panel_width4=0.04;
panel_height4=0.04;
horizontal_dist4=0.07;
vertical_dist4=0.09;
position_x4(1)=0.65;
position_x4(end+1)=position_x4(end)+horizontal_dist4;


position_y4(1)=0.8;
position_y4(end+1)=position_y4(end)-vertical_dist4;



panel_width5=0.04;
panel_height5=0.04;
horizontal_dist5=0.065;
vertical_dist5=0.07;
position_x5(1)=0.72;
position_x5(end+1)=position_x5(end)+horizontal_dist5;
position_x5(end+1)=position_x5(end)+horizontal_dist5;

position_y5(1)=0.69;
position_y5(end+1)=position_y5(end)-vertical_dist5;
position_y5(end+1)=position_y5(end)-vertical_dist5;
position_y5(end+1)=position_y5(end)-vertical_dist5;


