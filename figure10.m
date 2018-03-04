disp('working on Figure 10 now...')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute IRFs 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IRF=zeros(n,n,hmax-7,ndraws-nburn);
for jj=1:size(A_post,3)
    if (jj/10000) == floor(jj/10000)
          jj
    end
    IRF(:,:,:,jj)=impulse_response_m(A_post(:,:,jj),B_post(:,:,jj),n,nlags,hmax-8);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot impulse responses for one-unit shocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alph=0.025;   
index=[round(alph*(ndraws-nburn)) round((1-alph)*(ndraws-nburn)) round((ndraws-nburn)/2)];    %implies 95% coverage of the entire distribution
HO=(0:1:hmax-8)';                                                        %impulse response horizon

figure(10)
subplot(4,4,1)
x=-sort(cumsum(squeeze(IRF(1,1,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-2.5:.5:1.5)
ylabel('Oil production','fontsize',12)
title('Oil supply shock','fontsize',12)

subplot(4,4,5)
x=sort(cumsum(squeeze(IRF(1,2,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-2.5:.5:1.5)
ylabel('Oil production','fontsize',12)
title('Economic activity shock','fontsize',12)

subplot(4,4,9)
x=sort(cumsum(squeeze(IRF(1,3,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-2.5:.5:1.5)
ylabel('Oil production','fontsize',12)
title('Consumption demand shock','fontsize',12)

subplot(4,4,13)
x=sort(cumsum(squeeze(IRF(1,4,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-2.5:.5:1.5)
ylabel('Oil production','fontsize',12)
title('Inventory demand shock','fontsize',12)
xlabel('Months','fontsize',12)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,4,2)
x=-sort(cumsum(squeeze(IRF(2,1,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -.6 .3])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-4:.2:10)
ylabel('World IP','fontsize',12)
title('Oil supply shock','fontsize',12)

subplot(4,4,6)
x=sort(cumsum(squeeze(IRF(2,2,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:') 
axis([0 hmax-8 0 3])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-5:.5:10)
ylabel('World IP','fontsize',12)
title('Economic activity shock','fontsize',12)

subplot(4,4,10)
x=sort(cumsum(squeeze(IRF(2,3,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:') 
axis([0 hmax-8 -0.6 .3])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-4:.2:3)
ylabel('World IP','fontsize',12)
title('Consumption demand shock','fontsize',12)

subplot(4,4,14)
x=sort(cumsum(squeeze(IRF(2,4,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:') 
axis([0 hmax-8 -0.6 0.3])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-4:.2:3)
ylabel('World IP','fontsize',12)
title('Inventory demand shock','fontsize',12)
xlabel('Months','fontsize',11)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,4,3)
x=-sort(cumsum(squeeze(IRF(3,1,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 0 10])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-5:5:10)
ylabel('Real oil price','fontsize',12)
title('Oil supply shock','fontsize',12)

subplot(4,4,7)
x=sort(cumsum(squeeze(IRF(3,2,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 0 10])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-5:5:10)
ylabel('Real oil price','fontsize',12)
title('Economic activity shock','fontsize',12)

subplot(4,4,11)
x=sort(cumsum(squeeze(IRF(3,3,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 0 10])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-5:5:10)
title('Consumption demand shock','fontsize',12)
ylabel('Real oil price','fontsize',12)

subplot(4,4,15)
x=sort(cumsum(squeeze(IRF(3,4,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 0 10])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-5:5:10)
title('Inventory demand shock','fontsize',12)
ylabel('Real oil price','fontsize',12)
xlabel('Months','fontsize',11)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,4,4)
x=-sort(cumsum(squeeze(IRF(4,1,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-1:0.5:1)
ylabel('Stocks','fontsize',12)
title('Oil supply shock','fontsize',12)

subplot(4,4,8)
x=sort(cumsum(squeeze(IRF(4,2,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-1.5:.5:1)
ylabel('Stocks','fontsize',12)
title('Economic activity shock','fontsize',12)

subplot(4,4,12)
x=sort(cumsum(squeeze(IRF(4,3,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-1.5:.5:1)
title('Consumption demand shock','fontsize',12)
ylabel('Stocks','fontsize',12)

subplot(4,4,16)
x=sort(cumsum(squeeze(IRF(4,4,:,:)),1),2);
temp1=[x(:,index(3)) x(:,index(1)) x(:,index(2))];
plotx1(temp1,HO); box on; plot(HO,zeros(hmax-7,1),'k:')
axis([0 hmax-8 -1 2])
set(gca,'XTick',0:5:20)
set(gca,'YTick',-0.5:.5:1)
title('Inventory demand shock','fontsize',12)
ylabel('Stocks','fontsize',12)
xlabel('Months','fontsize',11)


nuse=ndraws-nburn;
alph=0.025;   
index=[nuse/2 alph*nuse (1-alph)*nuse];    %implies 95% coverage of the entire distribution
IRnorm21=zeros(1,nuse);
IRnorm23=IRnorm21;
IRnorm24=IRnorm21;

IRF21=squeeze(IRF(2,1,:,:));
IRF31=squeeze(IRF(3,1,:,:));
IRF23=squeeze(IRF(2,3,:,:));
IRF33=squeeze(IRF(3,3,:,:));
IRF24=squeeze(IRF(2,4,:,:));
IRF34=squeeze(IRF(3,4,:,:));

%Effect of oil supply shock on oil price
h=13;
for jj=1:nuse
    a=cumsum(IRF21(1:h,jj))/IRF31(1,jj);  %supply shock of 1% price increase on ec. activity
    b=cumsum(IRF23(1:h,jj))/IRF33(1,jj);  %consumption demand shock
    c=cumsum(IRF24(1:h,jj))/IRF34(1,jj);  %inventory demand shock
    IRnorm21(1,jj)=a(end,1);
    IRnorm23(1,jj)=b(end,1);
    IRnorm24(1,jj)=c(end,1);
end

IRnorm21s=sort(IRnorm21);
IRnorm23s=sort(IRnorm23);
IRnorm24s=sort(IRnorm24);

IRn21=IRnorm21s(1,index);
IRn23=IRnorm23s(1,index);
IRn24=IRnorm24s(1,index);

save IRF_norm IRn21 IRn23 IRn24

clear IRF