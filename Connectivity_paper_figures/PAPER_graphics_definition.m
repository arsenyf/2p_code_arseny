%% Graphics
%---------------------------------
figure;
% figure("Visible",false);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
set(gcf,'color',[1 1 1]);

%% behavior cartoon
panel_width1=0.12;
panel_height1=0.12;
horizontal_dist1=0.1;
vertical_dist1=0.1;
position_x1(1)=0.0675;
position_y1(1)=0.78;

%% fov
panel_width1_fov=0.07;
panel_height1_fov=0.07;
horizontal_dist1_fov=0.007;
vertical_dist1_fov=0.007;
position_x1_fov(1)=0.22+0.12;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;
position_x1_fov(end+1)=position_x1_fov(end)-horizontal_dist1_fov;

position_y1_fov(1)=0.79;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;
position_y1_fov(end+1)=position_y1_fov(end)-vertical_dist1_fov;


%% ROI traces
panel_width1_trace=0.08;
panel_height1_trace=0.015;
horizontal_dist1_trace=0.04;
vertical_dist1_trace=0.025;
position_x1_trace(1)=0.32+0.12;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;
position_x1_trace(end+1)=position_x1_trace(end)+horizontal_dist1_trace;

position_y1_trace(1)=0.84;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;
position_y1_trace(end+1)=position_y1_trace(end)-vertical_dist1_trace;


% PSTH - position averaged
panel_width2=0.03;
panel_height2=0.03;
horizontal_dist2=0.04;
vertical_dist2=0.045;
position_x2(1)=0.47+0.12;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2*1.9 -0.035;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;

position_y2(1)=0.82;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;

position_y22=0.784;

% Histograms
panel_width3=0.05;
panel_height3=0.04;
horizontal_dist3=0.1;
vertical_dist3=0.1;
position_x3(1)=0.1;
position_x3(end+1)=position_x3(end)+horizontal_dist3*0.4;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;

position_y3(1)=0.5;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;


% 2d tuning on grid
horizontal_dist_between_cells_grid1=0.085;
vertical_dist_between_cells_grid1=0.09;

position_x1_grid(1)=0.1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;
position_x1_grid(end+1)=position_x1_grid(end)+horizontal_dist_between_cells_grid1;

position_y1_grid(1)=0.67;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;
position_y1_grid(end+1)=position_y1_grid(end)-vertical_dist_between_cells_grid1;

% 2d tuning 100 cells from a given session
position_x2_grid(1)=0.28;
position_y2_grid(1)=0.7;


panel_width4=0.04;
panel_height4=0.04;
horizontal_dist4=0.07;
vertical_dist4=0.09;
position_x4(1)=0.48;
position_x4(end+1)=position_x4(end)+horizontal_dist4;
position_x4(end+1)=position_x4(end)+horizontal_dist4*1.8;

position_y4(1)=0.67;
position_y4(end+1)=position_y4(end)-vertical_dist4;

panel_width5=0.04;
panel_height5=0.04;
horizontal_dist5=0.065;
vertical_dist5=0.09;
position_x5(1)=0.66;
position_x5(end+1)=position_x5(end)+horizontal_dist5;
position_x5(end+1)=position_x5(end)+horizontal_dist5;

position_y5(1)=0.67;
position_y5(end+1)=position_y5(end)-vertical_dist5;




%% ROI images
panel_width1_roi=0.02;
panel_height1_roi=0.02;
horizontal_dist1_roi=0.04;
vertical_dist1_roi=0.025;
position_x1_roi(1)=0.41+0.12;
position_x1_roi(end+1)=position_x1_roi(end)+horizontal_dist1_roi;

position_y1_roi(1)=0.84;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;
position_y1_roi(end+1)=position_y1_roi(end)-vertical_dist1_roi;


%% Lick
panel_lick_width1=0.05;
panel_lick_height1=0.03;
position_lick_x1(1)=0.11;
position_lick_y1(1)=0.775;

panel_lick_width2=0.025;
panel_lick_height2=0.025;
position_lick_x2(1)=0.22;
position_lick_x2(end+1)=position_lick_x2(end)+0.05;
position_lick_y2(1)=0.825;
position_lick_y2(end+1)=position_lick_y2(end)-0.05;
