% Prepare histograms of posterior distribution for A
nbin=500;

for jc=1:size(A_post_m,1)
    [ag,bg]=hist(A_post_m(jc,:),nbin);
    delta=bg(1,2)-bg(1,1);
    bg_i(jc,:)=bg;
    post_i(jc,:)=ag./((ndraws-nburn)*delta);
    clear ag bg delta
end

figure(9)
subplot(3,5,1)
bar(bg_i(1,:),post_i(1,:)), hold on, plot(y1,prior_alpha_qp,'r','linewidth',2); box on
axis([0 1 0 8])
title('${\alpha}_{qp}$','interpreter','latex','fontsize',14)

subplot(3,5,2)
bar(bg_i(2,:),post_i(2,:)), hold on, plot(x1,prior_alpha_yp,'r','linewidth',2); box on
axis([-0.5 0 0 30])
title('${\alpha}_{yp}$','interpreter','latex','fontsize',14)

subplot(3,5,3)
bar(bg_i(3,:),post_i(3,:)), hold on, plot(y1,prior_beta_qy,'r','linewidth',2); box on
axis([0 1.5 0 2.5])
title('${\beta}_{qy}$','interpreter','latex','fontsize',14)

subplot(3,5,4)
bar(bg_i(4,:),post_i(4,:)), hold on, plot(x1,prior_beta_qp,'r','linewidth',2); box on
axis([-1 0 0 4])
title('${\beta}_{qp}$','interpreter','latex','fontsize',14)

subplot(3,5,5)
bar(bg_i(5,:),post_i(5,:)), hold on, plot(f1,prior_chi,'r','linewidth',2); box on
axis([0 1 0 5])
title('${\chi}$','interpreter','latex','fontsize',14)

subplot(3,5,6)
bar(bg_i(6,:),post_i(6,:)), hold on, plot(z1,prior_psi1,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\psi}_{1}$','interpreter','latex','fontsize',14)

subplot(3,5,7)
bar(bg_i(7,:),post_i(7,:)), hold on, plot(z1,prior_psi3,'r','linewidth',2); box on
axis([-1 1 0 12])
title('${\psi}_{3}$','interpreter','latex','fontsize',14)

subplot(3,5,8)
bar(bg_i(8,:),post_i(8,:)), hold on, plot(f1,prior_rho,'r','linewidth',2); box on
axis([0 1 0 7])
title('${\rho}$','interpreter','latex','fontsize',14)

subplot(3,5,9)
bar(bg_i(9,:),post_i(9,:)), hold on, plot(z1,prior_gamma1,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\gamma}_{1}$','interpreter','latex','fontsize',14)

subplot(3,5,10)
bar(bg_i(10,:),post_i(10,:)), hold on, plot(z1,prior_gamma2,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\gamma}_{2}$','interpreter','latex','fontsize',14)

subplot(3,5,11)
bar(bg_i(11,:),post_i(11,:)), hold on, plot(z1,prior_gamma3,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\gamma}_{3}$','interpreter','latex','fontsize',14)

subplot(3,5,12)
bar(bg_i(12,:),post_i(12,:)), hold on, plot(z1,prior_gamma4,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\gamma}_{4}$','interpreter','latex','fontsize',14)

subplot(3,5,13)
bar(bg_i(13,:),post_i(13,:)), hold on, plot(z1,prior_phi,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\phi}$','interpreter','latex','fontsize',14)

subplot(3,5,14)
bar(bg_i(14,:),post_i(14,:)), hold on, plot(z1,prior_tau,'r','linewidth',2); box on
axis([-2 2 0 4])
title('${\tau}$','interpreter','latex','fontsize',14)







nuse=size(A_post_m,2);
alph=0.025;   
index=[round(nuse/2) round(alph*nuse) round((1-alph)*nuse)];    %implies 95% coverage of the entire distribution

sup_ela=sort(A_post_m(1,:));      
dem_ela=sort(A_post_m(4,:));

alpha_qp=sup_ela(1,index); 
beta_qp=dem_ela(1,index);

save elasticities alpha_qp beta_qp

% disp('Median and 95% credibility sets for elements of A')
% for i = 1:size(A_post_m,1)
%     xq = sort(A_post_m(i,:));
%     xq1 = xq(1,0.025*nuse);
%     xq2 = xq(1,0.5*nuse);
%     xq3 = xq(1,0.975*nuse);
%     [i xq1 xq2 xq3]
% end

clear A_post_m