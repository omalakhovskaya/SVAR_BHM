%%% Code to replicate the 4-variable oil market VAR(12) model proposed in:
%%% Baumeister and Hamilton, "Structural Interpretation of Vector Autoregressions
%%% with Incomplete Identification: Revisiting the Role of Oil Supply and 
%%% Demand Shocks" (October 2015)

%%% By Christiane Baumeister and James D. Hamilton (July 2015; updated Oct 2015)
%%% BENCHMARK CASE
%%% Modifications Oxana Malakhovskaya, November, 2017 
%%% Data until 2015 are available

clear all
close all
clc


data3 = xlsread('data_final8.xlsx',3);
data4 = xlsread('data_final8.xlsx',4);
data5 = xlsread('data_final8.xlsx',5);
%save data_BHM2 data2
time3=(1992+11/12:1/12:2017+4/12)';   %sample period: 1992M12 to 2017M05
time4=(1995:1/12:2017+4/12)';   %sample period: 1995M1 to 2017M05
time5=(1992+11/12:1/12:2017+4/12)';   %sample period: 1992M12 to 2017M05


data = data5; 
%time = time3; 
random = 1; % if 1 than the first guess for posterior maximization is taken randomly
            % otherwise mean/mode values of prior distributions are taken

%seednumber=140778;
seednumber= 230280;
%seednumber= 200688;
%seednumber= 111259;
%seednumber= 161059;
%seednumber= 201229;
%seednumber= 090713;
%seednumber= 250118;




rand('seed',seednumber);
%randn('seed',seednumber);

ndraws=2e4;              %number of MH iterations (paper used 2e6)
nburn=1e4;               %number of burn-in draws (paper used 1e6)

wti=1;           %'wti=1': WTI is used for entire sample; 'wti=0': RAC is used for second subsample
nlags=12;        %number of lags
hmax=25;         %impulse response horizon (17 months)
ndet=1;          %number of deterministic variables 
                 %(1: constant)
xsi=0.4;        %tuning parameter to achieve a target acceptance rate of around 30-35
                %0.4 an appropriate value for data4 and da
                
c = 14;            % number of nonzero parameters of A that we have prior information about  
kappa=2;                          %prior 

%W=xsi*eye(c);     %variance of RW-MH  

%load data_BH2                   %sample: 1958M1 to 2015M12
%load data_BHM2                    %sample: 1958M1 to 2017M05
 
% column 1: global crude oil production (in million barrels/day)
% column 2: real WTI spot oil price (deflated by US CPI)
% column 3: OECD+6NME industrial production
% column 4: 100*change in proxy for OECD crude oil inventories as a fraction of previous
%           period's oil production
% column 5: Russian macroindicator 
%           real incomes if data = data3
%           industrial production if data = data4
%           cpi if data = data5

% transformations of variables
qo=lagn(100*log(data(:,1)),1);
ip=lagn(100*log(data(:,3)),1);
rpo=lagn(100*log(data(:,2)),1);   
stocks=data(2:end,4);
rus_ind=lagn(100*log(data(:,5)),1);   
%rac=lagn(100*log(data(:,5)),1);   

yy_wti=[qo ip rpo stocks rus_ind];
%yy_rac=[qo ip rac stocks];
%time=time(2:end,1);
n=size(yy_wti,2);          %number of endogenous variables


%split sample in 2002M12
yy1=yy_wti(1:120,:);           %first subsample (10 years)
yy2=yy_wti(109:end,:);           %second subsample (10 years + previous 10 years)

% weight given to first subsample
%mu=0.5;   
mu = 1;
                              
% Get data matrices for first subsample
[xxx1,yyy1,T1]=getXy(yy1,ndet,nlags);

% Get data matrices for second subsample
[xxx2,yyy2,T2]=getXy(yy2,ndet,nlags);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     ALGORITHM FOR GETTING POSTERIORS OF A, B and D    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1a: Set parameters of the prior distributions for impact coefficients (A) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bounds = 5;
x1=-bounds:.001:0;       %grid for negative parameters
y1=0:.001:bounds;        %grid for positive parameters
z1=-bounds:.001:bounds;  %grid for parameters where no sign is imposed a priori
f1=0:.001:1;             %fraction (for beta distribution)

% alpha(qp): short-run price elasticity of oil supply (sign: positive)
c_alpha_qp = 0.1;            
sigma_alpha_qp = 0.2;       
nu_alpha_qp = 3;
prior_alpha_qp=student_pos_prior(y1,c_alpha_qp,sigma_alpha_qp,nu_alpha_qp);
%plot(y1,prior_alpha_qp,'b','linewidth',3)

% alpha(yp): short-run oil price elasticity of global demand (sign: negative)
c_alpha_yp = -0.05;
sigma_alpha_yp = 0.1;   
nu_alpha_yp = 3;
prior_alpha_yp = student_neg_prior(x1,c_alpha_yp,sigma_alpha_yp,nu_alpha_yp);
%plot(x1,prior_alpha_yp,'b','linewidth',3)

% beta(qy): income elasticity of oil demand (sign: positive)
c_beta_qy = 0.7;   
sigma_beta_qy = 0.2;   
nu_beta_qy = 3;
prior_beta_qy = student_pos_prior(y1,c_beta_qy,sigma_beta_qy,nu_beta_qy);
%plot(y1,prior_beta_qy,'b','linewidth',3)

% beta(qp): short-run price elasticity of oil demand (sign: negative)
c_beta_qp = -0.1;   
sigma_beta_qp = 0.2;     
nu_beta_qp = 3;
prior_beta_qp = student_neg_prior(x1,c_beta_qp,sigma_beta_qp,nu_beta_qp);
%plot(x1,prior_beta_qp,'b','linewidth',3)

% chi: OECD fraction of true oil inventories (about 65%)
alpha_k = 15;
beta_k = 10;
prior_chi = beta_prior(f1,alpha_k,beta_k);
%plot(f1,prior_chi,'b','linewidth',3)

% psi1: short-run production elasticity of inventory demand (sign:
%       unrestricted)
c_psi1 = 0;
sigma_psi1 = 0.5;
nu_psi1 = 3;
prior_psi1 = student_prior(z1,c_psi1,sigma_psi1,nu_psi1);
%plot(z1,prior_psi1,'b','linewidth',3)

% psi3: short-run price elasticity of inventory demand (sign: unrestricted)
c_psi3 = 0;
sigma_psi3 = 0.5;
nu_psi3 = 3;
prior_psi3 = student_prior(z1,c_psi3,sigma_psi3,nu_psi3);
%plot(z1,prior_psi3,'b','linewidth',3)

% rho: measurement error
alpha_rho = 3;
beta_rho = 9;
prior_rho = beta_prior(f1,alpha_rho,beta_rho);
%plot(f1,prior_rho,'b','linewidth',3)

%gamma1: short-run production elasticity of exchange rate (sign:
%       unrestricted)
c_gamma1= 0;
sigma_gamma1 = 0.5;
nu_gamma1 = 3;
prior_gamma1 = student_prior(z1,c_gamma1,sigma_gamma1,nu_gamma1);
%plot(z1,prior_psi3,'b','linewidth',3)

%gamma2: income elasticity of exchange rate (sign:
%       unrestricted)
c_gamma2= 0;
sigma_gamma2 = 0.5;
nu_gamma2 = 3;
prior_gamma2 = student_prior(z1,c_gamma2,sigma_gamma2,nu_gamma2);
%plot(z1,prior_psi3,'b','linewidth',3)

%gamma3: short-run price elasticity of exchange rate (sign:
%       unrestricted)
c_gamma3= 0;
sigma_gamma3 = 0.5;
nu_gamma3 = 3;
prior_gamma3 = student_prior(z1,c_gamma3,sigma_gamma3,nu_gamma3);
%plot(z1,prior_psi3,'b','linewidth',3)


%gamma4: inventories elasticity of exchange rate (sign:
%       unrestricted)
c_gamma4= 0;
sigma_gamma4 = 0.5;
nu_gamma4 = 3;
prior_gamma4 = student_prior(z1,c_gamma4,sigma_gamma4,nu_gamma4);
%plot(z1,prior_psi3,'b','linewidth',3)

%phi: (sign:
%       unrestricted)
c_phi= 0;
sigma_phi = 0.5;
nu_phi = 3;
prior_phi = student_prior(z1,c_phi,sigma_phi,nu_phi);
%plot(z1,prior_psi3,'b','linewidth',3)

%tau: short-run price elasticity of exchange rate (sign:
%       unrestricted)
c_tau= 0;
sigma_tau = 0.5;
nu_tau = 3;
prior_tau = student_prior(z1,c_tau,sigma_tau,nu_tau);
%plot(z1,prior_psi3,'b','linewidth',3)


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STEP 1b: Set informative priors on lagged coefficients (B) %
%          and for inverse of diagonal elements (D)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute standard deviation of each series residual via an OLS regression
% to be used in setting the prior (here: AR(12))
s= zeros(n,1);
uhat = zeros(T1,n);
for jj =1:n
    [s(jj),uhat(:,jj)]=sd_prior(yy1(:,jj),nlags);
end 

% See Doan (2013) for choices of values of hyperparameters (Minnesota-type prior)
lambda0=0.5;     %overall confidence in prior
lambda1=1;       %confidence on higher-order lags (lambda1 = 0 gives all lags equal weight)
lambda2=1;       %confidence in other-than-own lags 
lambda3=100;     %tightness of constant term 

% The mean for D is calibrated on diagonal elements in omega
%uhat=[uhat1 uhat2 uhat3 uhat4];
S=uhat'*uhat/T1;

     %posterior kappa 

% Specify the prior mean of the coefficients of the 4 equations of the VAR
% and their prior covariance
% PRIOR MEAN
m=zeros(n,(n*nlags+ndet));
m(1,3)=0.1;
m(3,3)=-0.1;

% PRIOR COVARIANCE 
v1 = 1:nlags;
v1 = v1'.^(-2*lambda1);
v2 = 1./diag(S);
v3 = kron(v1,v2);
v3 = lambda0^2*[v3; lambda3^2];
v3 = 1./v3;
Pinv = diag(sqrt(v3));

% Compute zetas, omega_tildeT, Xtilde, M_star

[zeta1, ~] = gettau3(kappa,eye(n),yyy1,xxx1,n);
[zeta2, ~] = gettau3(kappa,eye(n),yyy2,xxx2,n);

omega_tildeT=(mu*T1+T2)\(mu*zeta1+zeta2);
Xtilde=[sqrt(mu)*xxx1;xxx2;Pinv];
M_star=inv(Xtilde'*Xtilde);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get starting values for A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fixed parameter values

param=[c_alpha_qp;sigma_alpha_qp;nu_alpha_qp;...
       c_alpha_yp;sigma_alpha_yp;nu_alpha_yp; ...
       c_beta_qy;sigma_beta_qy;nu_beta_qy;...
       c_beta_qp;sigma_beta_qp;nu_beta_qp; ...
       alpha_k;beta_k;...
       c_psi1;sigma_psi1;nu_psi1;...
       c_psi3;sigma_psi3;nu_psi3; ...
       alpha_rho;beta_rho;... 
       c_gamma1; sigma_gamma1; nu_gamma1;...
       c_gamma2; sigma_gamma2; nu_gamma2;... 
       c_gamma3; sigma_gamma3; nu_gamma3;... 
       c_gamma4; sigma_gamma4; nu_gamma4;...
       c_phi; sigma_phi; nu_phi;...
       c_tau; sigma_tau; nu_tau];
f_anon = @(theta) -getposterior8(theta,param,S,m,yyy1,yyy2,Pinv,Xtilde,mu,n,c,kappa,T1,T2,omega_tildeT);

flag = 0; 
while flag ==0 
    if random == 1
    random_generator;  %Modified version gets random values to check up the uniqueness of local maximum. 
    else % Set arbitrary initial values for elements of A (prior mode/mean of
         % elements in A and L)
    A_old=[c_alpha_qp; c_alpha_yp; c_beta_qy; c_beta_qp; alpha_k/(alpha_k+beta_k); ...
    c_psi1; c_psi3; alpha_rho/(alpha_rho+beta_rho); c_gamma1; c_gamma2; c_gamma3; ...
    c_gamma4; c_phi; c_tau];
    flag = 1; 
    end 
save A_old0_8 A_old 
   
options = optimset('LargeScale','off','MaxFunEvals',5000, 'Display', 'iter');
[theta_max,val_max,exitm,~,~,HM] = fminunc(f_anon,A_old,options);
theta_max

if theta_max(1)>0 && theta_max(2)<0 && theta_max(3)>0 && theta_max(4)<0 && ...
        theta_max(5)>0 && theta_max(5)<1 && theta_max(8)>0 && theta_max(8)<1   
        flag = 1; 
end 
end 



%find Hessian of log posterior
if min(eig(inv(HM))) > 0
     PH = chol(inv(HM))';
else
     PH = eye(c);
end
posteriorOLD=-val_max;
A_old = theta_max; 

% RW-MH algorithm 
naccept=0;
%count=1;

% Store posterior distributions (after burn-in)
A_post_m=zeros(c,ndraws-nburn);
A_post=zeros(n,n,ndraws-nburn);
B_post=zeros(n,n*nlags+1,ndraws-nburn);
D_post=zeros(n,n,ndraws-nburn);
G_post = zeros(n,n,ndraws-nburn);
D_star_post = zeros(n,n,ndraws-nburn);

posteriors_all7 = zeros(ndraws, 1); 
A_new_all8 = zeros(ndraws,c);
A_old_all8 = zeros(ndraws,c);
increments_all7 = zeros(ndraws,c);
  
for count = 1:ndraws 
      if (count/10000) == floor(count/10000)
          count
      end
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    % STEP 4a: Generate draw for A from the RW candidate density %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %increment = xsi*PH*randn(c,1)/sqrt(0.5*(randn(1)^2 + randn(1)^2));
    increment = xsi*PH*randn(c,1);

    A_new=A_old+increment;    % fat tails
    A_new_all8(count,:) = A_new';
    A_old_all8(count,:) = A_old';
    increments_all7(count,:) = increment';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % STEP 4b: Evaluate posterior at new draw %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % impose signs/ranges
    if A_new(1)>0 && A_new(2)<0 && A_new(3)>0 && A_new(4)<0 && ...
            A_new(5)>0 && A_new(5)<1 && A_new(8)>0 && A_new(8)<1            
           
       posteriorNEW = getposterior8(A_new,param,S,m,yyy1,yyy2,Pinv,Xtilde,mu,n,c,kappa,T1,T2,omega_tildeT);
       posteriors_all8(count) = posteriorNEW;
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % STEP 5: Compute acceptance probability %
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       accept=min([exp(posteriorNEW-posteriorOLD);1]);
       u=rand(1);                     %draw from a uniform distribution
       if u<=accept
          A_old=A_new;                %we retain the new draw
          posteriorOLD=posteriorNEW;
          naccept=naccept+1;          %count the number of acceptances
       end
       end
    
    if count>nburn
         %Store results after burn-in    
         A_post_m(:,count-nburn)=A_old;  
                        
         AA_tilde=[1 0 -A_old(1) 0 0; ...
                   0 1 -A_old(2) 0 0; ...
                   1 -A_old(3:4)' -1/A_old(5) 0;...
                   -A_old(6) 0 -A_old(7) 1 0;...
                   -A_old(9:12)' 1]; 
         P=eye(n);
         P(4,3)=A_old(8);
         P(5,3)=A_old(13);
         P(5,4)=A_old(14);
         
         AA=P*AA_tilde;
         A_post(:,:,count-nburn)=AA;
         G_post(:,:,count - nburn) = P; % added in this version
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % STEP 7: Generate a draw for d(ii)^-1 from independent gamma %
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         Ytilde = [sqrt(mu)*yyy1*AA';yyy2*AA';Pinv'*m'];
         mstar = (Xtilde'*Xtilde)\(Xtilde'*Ytilde);
         omega=AA*S*AA';
         
         [~, tau_mh] = gettau3(kappa,omega,Ytilde,Xtilde,n);
         d= zeros(n,1);
         kappastar = kappa+(mu*T1+T2)/2;
         for jj = 1:n
             d(jj) = inv(gamrnd(kappastar,1/tau_mh(jj)));
         end 
         DD = diag(d);
                D_post(:,:,count-nburn)=DD;
                D_star_post(:,:,count-nburn) = inv(P)*DD*inv(P'); % added in this version
                
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % STEP 8: Generate a draw for b(i) from multivariate normal %
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
         BB = mstar + repmat(d',nlags*n+ndet,1).*(randn(n,nlags*n+ndet)*chol(M_star))';
         B_post(:,:,count-nburn)=BB';
         clear AA_tilde AA BB DD 
       end 
   end

% Compute acceptance ratio of RW-MH algorithm
acceptance_ratio=naccept/ndraws;
disp(['Acceptance ratio:' num2str(acceptance_ratio)])

save posterior_draws A_post_m A_post B_post D_post G_post D_star_post
 
% Analyze convergence of the chain
% p1=0.1;   %first 10% of the sample (for Geweke's (1992) convergence diagnostic)
% p2=0.5;   %last 50% of the sample
% autoc = convergence_diagnostics(A_post_m,p1,p2);

figure9    %plots the prior and posterior distributions for the elements in A

figure10   %computes and plots the impluse-response functions

%figure11   %computes and plots the historical decomposition

%table1     %computes variance decomposition of 12-month-ahead forecast errors

%table2     %uses inputs from figure9.m, figure10.m and table1.m (need to run those first!)

%table3     %computes historical decomposition for specific episodes
