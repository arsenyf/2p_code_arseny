% Change alpha- increase the num of hubs

plotFlag=0;
plotFlagCor=0;

%num of neurons
N=10000;
% Nhub=100;
net.L=2*pi;
net.Khub=100;
net.Kr=10;

%time of simulation (in msec) and integration timescale
T=2;tau=0.01; %(in sec);
% self Fac parameters: L/(1+exp(-b(r-T)))

% Stimulus parameters: s_i=r0(1+epsilon cos(theta_i-psi))
% Stim.epsilon=0.001;and
eps_vec=[0.001  1];
% eps_vec=[ 1];
% rr_vec=[0:0.3:1.2 ];
rr_vec=[0:0.2:1.1];
% rr_vec=[0.3];
% rh_vec=[0:1:10 ];
% rh_vec=[5 ];
% rr_vec=[0.7 ];
% rh_vec=[5 ];
rh=10;
nhub_vec=[100:200:1100];
wind=ones(20,1)./20;
rmat=cell(length(eps_vec),length(rr_vec),length(nhub_vec));

%%
for ii=2:length(eps_vec)
    ii
    eps=eps_vec(ii);
    for jj=1:length(rr_vec)
        rr=rr_vec(jj);
          tic;
        for kk=1:length(nhub_vec)
          kk
          

          Nhub=nhub_vec(kk);

          net.Kreghub=N/Nhub*net.Kr;

            Stim.epsilon_r=eps;
            Stim.epsilon_h=eps;


            Stim.r0=10;
            Stim.psi=pi/2;

            ind=5;

            net.J0_rr=-3.0;
            net.J1_rr=rr;
            net.J1_hr=2;
            net.J1_rh=rh;


            net.J0_hh=-3.0; % global inhibition
            net.J1_hh=0.5; % 'lateral inhibiton'
            net.J0_hr=0.0; % global inhibition
            net.J0_rh=0.0; % global inhibition


% sigma_rr<sigma_rh<sigma_hr

            % net.sigma_rr=0.25;
            net.sigma_rr=0.1 ;
            net.sigma_rh=0.3;
            net.sigma_hr=0.9;
            % net.sigma_hh=100.5;
            net.sigma_hh=0.9;

            % net.sigma_hx=100.5;
            net.sigma_hx=0.5;
            net.sigma_rx=0.5;
            net.L=2*pi;
            % % % % net.Khub=100;
            % % % % net.Kr=10;

            J=[];
            [r, h,J]=TwoRingsHubGaussiansChangeAlpha(net,Stim,N,Nhub,T,plotFlag,ind,tau,J);
            rmat{ii,jj,kk}=r(end,:);
            theta = (2 * (1:N) * pi) / N;
            theta_hub = (2 * (1:Nhub) * pi) / Nhub;

            MDi(ii,jj,kk)=eps;
            % MDr(ii,jj,kk)=0.5.*(max(r(end,1:N))-min(r(end,1:N)))./(max(r(end,1:N))+min(r(end,1:N)));
            % MDh(ii,jj,kk)=0.5.*(max(r(end,N+1:end))-min(r(end,N+1:end)))./(max(r(end,N+1:end))+min(r(end,N+1:end)));
            
            y_r=filtfilt(wind,1,r(end,1:N));
             y_h=filtfilt(wind,1,r(end,N+1:end));

            % MDr(ii,jj,kk)=(max(r(end,1:N))-min(r(end,1:N)))./mean(r(end,1:N));
            % MDh(ii,jj,kk)=(max(r(end,N+1:end))-min(r(end,N+1:end)))./mean(r(end,N+1:end));
             
            MDr(ii,jj,kk)=(max(y_r)-min(y_r))./mean(y_r);
            MDh(ii,jj,kk)=(max(y_h)-min(y_h))./mean(y_h);
            max_MDr(ii,jj,kk)=100.*(max(y_r)-min(y_r))./max(y_r);

            % max_MDr(ii,jj,kk)=max(r(end,1:N));
            % max_MDh(ii,jj,kk)=max(r(N+1:end));
        end
        toc;
    end
end
%%
load('Heatmap_Paper_31-10-2024.mat');
alpha=nhub_vec/N;
ee=2;
endPlot=6;
figure(1)
imagesc(alpha,rr_vec(1:endPlot),log10(squeeze(max_MDr(ee,1:endPlot,:))))
set(gca,'YDir','normal')
colorbar 
title('Max rate')
figure(2)
imagesc(alpha,rr_vec(1:endPlot),(squeeze(MDr(ee,1:endPlot,:))))
set(gca,'YDir','normal')
colorbar
colormap(hot)
clim([0 max(max(squeeze(MDr(ee,1:endPlot,:))))])
 clim([0 10])

title('Modulation Depth Reg pop')
box off
xlabel('Jh->r strengh')
ylabel('Jr->r strengh')

figure(22)
imagesc(alpha,rr_vec(1:endPlot),(squeeze(MDh(ee,1:endPlot,:))))
set(gca,'YDir','normal')
colorbar 
colormap(hot)
clim([0 max(max(squeeze(MDr(ee,1:endPlot,:))))])
clim([0 10])
title('Modulation Depth Hub pop')
box off
xlabel('Jh->r strengh')
ylabel('Jr->r strengh')
%%
wind=ones(10,1)./10;
ee=2
% jj=6; kk=1;
% jj=4; kk=4;
% jj=1; kk=6  ;
jj=1; kk=1;

Nhub=nhub_vec(kk);
theta_hub = (2 * (1:Nhub) * pi) / Nhub;

figure(1)
plot(theta,filtfilt(wind,1,rmat{ee,jj,kk}(1:N)),'r');
hold on
plot(theta_hub,filtfilt(wind,1,rmat{ee,jj,kk}(N+1:end)),'b');
hold off 
xlim([0 2*pi])
box off
xlabel('stim angle (rad)')
ylabel('Rate (Hz)')
legend('Regular pop','Hub pop')
% title(sprintf('Jr->r=%.1f and Jh->r=%.1f',rr_vec(jj),rh_vec(kk)))
ylim([0 35])
axis square
