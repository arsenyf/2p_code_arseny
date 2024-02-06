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
% panel_width1=0.12;
% panel_height1=0.12;
% horizontal_dist1=0.1;
% vertical_dist1=0.1;
% position_x1(1)=0.06;
% position_y1(1)=0.78;


panel_width1=0.08;
panel_height1=0.06;
horizontal_dist1=0.1;
vertical_dist1=0.13;
position_x1(1)=0.12;
position_y1(1)=0.77;



% PSTH - position averaged
panel_width2=0.05;
panel_height2=0.03;
horizontal_dist2=0.09;
vertical_dist2=0.045;
position_x2(1)=0.1;
position_x2(end+1)=position_x2(end)+horizontal_dist2;
position_x2(end+1)=position_x2(end)+horizontal_dist2;


position_y2(1)=0.65;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;
position_y2(end+1)=position_y2(end)-vertical_dist2;


% Scatters
panel_width3=0.4;
panel_height3=0.2;
horizontal_dist3=0.4;
vertical_dist3=0.15;
position_x3(1)=0.4;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;
position_x3(end+1)=position_x3(end)+horizontal_dist3;

position_y3(1)=0.56;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;
position_y3(end+1)=position_y3(end)-vertical_dist3;







