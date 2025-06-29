function [r, h,J]=TwoRingsHubGaussiansChangeAlpha(net,Stim,N,Nhub,T,plotFlag,ind,tau,J)
% Define the parameters
%N = 10; % Number of oscillators



%epsilon = 0.1;% tuning of the stimulus
%psi = pi/4; % Phase of the external input
psi=Stim.psi;
% Compute the connectivity matrix J
theta = (2 * (1:N) * pi) / N;
theta_hub = (2 * (1:Nhub) * pi) / Nhub;
theta=theta';
theta_hub=theta_hub';
% % % % % J=generateConnectivity;
if isempty(J)
    J=generateZeroMeanConnectivity;
end
% Define the time span for simulation
tspan = [0 T]; % Start and end times

% Define the initial conditions
h0 = zeros(N+Nhub, 1); % Initial values of h(theta_i)

% Solve the system of ODEs
[t, h] = ode23(@ode_system, tspan, h0);

% [t, h]=euler(@euler_system,0,T,h0,tau/10);
% h=h';


% Compute the corresponding r(theta_i) using ReLU transfer function
r = max(0, h);

if plotFlag
    figure(ind)
    % Plot the results
    subplot(2,4,1);
    plot(t, r(:,1:10));box off
    xlabel('Time');
    ylabel('r');
    title('Simulation of the tuned');

    subplot(2,4,3);
    plot(theta,r(end,1:N)./max(r(end,1:N)));hold on
    ylim([0 1])
    xlabel('\theta');
    ylabel('r(\theta)');
    % legend('r','Tuned pop')
    title('Normalized rates')

    subplot(2,4,4);
    plot(theta,r(end,1:N));hold on
    ylim([0 max(r(end,1:N))])
    xlabel('\theta');
    ylabel('r(\theta)');
    % legend('r','Tuned pop')
    title('Rates')

    subplot(2,4,2);
    % plot(theta,Stim.r0.*(1 + Stim.epsilon * cos(theta - psi)),'r');
    StA=warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L)';
    StA=StA-mean(StA);
    StA=Stim.r0+Stim.epsilon_r.*StA;
    % plot(theta,Stim.r0.*(Stim.epsilon_r * warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L))','r');
    plot(theta,StA);

    box off
    hold on
    xlabel('\theta');
    ylabel('I(\theta)');
    % legend('I','Tuned pop')
    title('Tuned Input')

    subplot(2,4,5);
    plot(t, r(:,N+1:N+5));box off
    xlabel('Time');
    ylabel('r');
    title('Simulation of the hubs');


    subplot(2,4,6);
    % plot(theta_hub,Stim.r0.*(1 + Stim.epsilon * cos(theta_hub - psi)),'r');
    % plot(theta_hub,Stim.r0.*(Stim.epsilon_h * warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L))','r');
    StB=warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L)';
    StB=StB-mean(StB);
    StB=Stim.r0+Stim.epsilon_h.*StB;

    plot(theta_hub,StB);

    box off
    hold on
    xlabel('\theta');
    ylabel('I(\theta)');
    % legend('I','Hub pop')
    title('Tuned input-Hubs')

    subplot(2,4,7);
    plot(theta_hub,r(end,N+1:end)./max(r(end,N+1:end)));
    ylim([0 1])
    hold on
    xlabel('\theta');
    ylabel('r(\theta)');
    % legend('r','Hub pop')
    title('Normalized rates-Hubs')

    subplot(2,4,8);
    plot(theta_hub,r(end,N+1:end));
    ylim([0 max(r(end,N+1:end))])
    hold on
    xlabel('\theta');
    ylabel('r(\theta)');
    % legend('r','Hub pop')
    title('Rates- Hubs')

end

    function J=generateZeroMeanConnectivity
        % J = zeros(N+Nhub, N+Nhub); % Connectivity matrix
        Jhub_hub = zeros(Nhub, Nhub); % Connectivity matrix
        Jreg_hub = zeros(N, Nhub);
        Jhub_reg = zeros(Nhub, N);
        Jreg_reg = zeros(N, N);

        % The difference with the previous version is here. Change net.Khub
        % to net.Kreghub, which is additional paramters that helps to
        % change alpha without changing the in-deg and out-deg (Kr and
        % Khub)
        Jreg_hub=CreatJabMat1D(N,Nhub,net.Kreghub,net.sigma_rh,net.L,N);
        Jreg_hub=Jreg_hub.*(net.J1_rh./net.Kreghub);


        Jhub_reg=CreatJabMat1D(Nhub,N,net.Khub,net.sigma_hr,net.L,N);
        Jhub_reg=Jhub_reg.*(net.J1_hr./net.Khub);

        Jreg_reg=CreatJabMat1D(N,N,net.Kr,net.sigma_rr,net.L,N);
        Jreg_reg=Jreg_reg.*(net.J1_rr./net.Kr);
        Jreg_reg=Jreg_reg+(1/N)*net.J0_rr;
        
        Jhub_hub=CreatJabMat1D(Nhub,Nhub,net.Khub,net.sigma_hh,net.L,Nhub);
        Jhub_hub=Jhub_hub.*(net.J1_hh./net.Khub);
        % Jhub_hub=(1/Nhub)*net.J0_hh.*ones(Nhub, Nhub); % global inh for the hubs!
        Jhub_hub=Jhub_hub+(1/Nhub)*net.J0_hh.*ones(Nhub, Nhub); % global inh for the hubs!


        J=[Jreg_reg, Jreg_hub;Jhub_reg, Jhub_hub];
        % % J=sparse(J);
    end



% Define the system of ODEs
    function dhdt = ode_system(t, h)
        dhdt = zeros(N, 1);
        r = max(0, h); % ReLU transfer function

        sum_term = J* r;
        % input_term = [Stim.r0.*(1 + Stim.epsilon * cos(theta - psi)); Stim.r0.*(1 + Stim.epsilon * cos(theta_hub - psi))];
        % % % input_term = [Stim.r0.*(Stim.epsilon_r * warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L))'; Stim.r0.*(Stim.epsilon_h * warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L))'];
        St1=warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L)';
        St1=St1-mean(St1);
        St2=warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L)';
        St2=St2-mean(St2);
        input_term = [Stim.r0+Stim.epsilon_r.*St1; Stim.r0+Stim.epsilon_h.*St2 ];


        dhdt = (-h + sum_term + input_term)./tau;
        %         for i = 1:N
        %             dhdt(i) = -h(i) + sum_term(i) + input_term;
        %        input_term = selfFac.L./ (1 + exp(-selfFac.b * (r(i) - selfFac.T))) + Stim.r0.*(1 + Stim.epsilon * cos(theta(i) - psi));
        %         end
    end

function dhdt = euler_system(h)
        dhdt = zeros(N, 1);
        r = max(0, h); % ReLU transfer function

        sum_term = J* r;
        % input_term = [Stim.r0.*(1 + Stim.epsilon * cos(theta - psi)); Stim.r0.*(1 + Stim.epsilon * cos(theta_hub - psi))];
        % % % input_term = [Stim.r0.*(Stim.epsilon_r * warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L))'; Stim.r0.*(Stim.epsilon_h * warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L))'];
        St1=warrped_gaussian_0L(theta - psi,net.sigma_rx,net.L)';
        St1=St1-mean(St1);
        St2=warrped_gaussian_0L(theta_hub - psi,net.sigma_hx,net.L)';
        St2=St2-mean(St2);
        input_term = [Stim.r0+Stim.epsilon_r.*St1; Stim.r0+Stim.epsilon_h.*St2 ];


        dhdt = (-h + sum_term + input_term)./tau;
        %         for i = 1:N
        %             dhdt(i) = -h(i) + sum_term(i) + input_term;
        %        input_term = selfFac.L./ (1 + exp(-selfFac.b * (r(i) - selfFac.T))) + Stim.r0.*(1 + Stim.epsilon * cos(theta(i) - psi));
        %         end
    end




    function f=warrped_gaussian_0L(x,sigma,L)
        k_vec=-100:1:100;
        f_tmp=zeros(length(k_vec),length(x)  )  ;
        k_ind=0;
        for k=k_vec
            k_ind=k_ind+1;
            f_tmp(k_ind,:)= exp(    -(x-L.*k).^2./(2*sigma^2)   );
        end
        f=1/sqrt(2*pi*sigma^2)*sum(f_tmp,1); %Bug? Should be 1/sqrt(2*pi*sigma^2)
    end


    function A=CreatJabMat1D(n1,n2,K2,sigma_rec,L,nn)
        theta_1=(0:(n1-1))./n1*2*pi;
        theta_2=(0:(n2-1))./n2*2*pi;
        p=zeros(n1,n2);
        % % % theta=
        for ii=1:n1
            p(ii,:) =warrped_gaussian_0L(theta_1(ii)-theta_2,sigma_rec,L);
                % p(ii,:) =cos(theta_1(ii)-theta_2);
            %             p(ii,:) =circshift(tmp,[0 ii-1]);
        end
        % A=p/nn;
        p     = 2*pi*K2/nn*p;
        max(max(p))
        A  = p>rand(n1,n2);
    end






    function [t, Y]=euler(f,a,b,ya,dt)
        %Input - f is the function entered as a string 'f'
        % - a and b are the left and right endpoints
        % - ya is the initial condition y(a)
        % - M is the number of steps
        %Output - E=[T' Y'] where T is the vector of abscissas and
        % Y is the vector of ordinates
        M=round((b-a)/dt);
        Y=zeros(length(ya),M+1);
        t=a:dt:b;
        Y(:,1)=ya;

        for jj=1:M
            %             Y(:,jj+1)=Y(:,jj)+h*f(Y(:,jj),t(jj));
            Y(:,jj+1)=Y(:,jj)+dt*f(Y(:,jj));

        end
    end

end





