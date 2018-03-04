disp('working on Figure 11 now...')
% historical decomposition of the real oil price
if (ndraws-nburn)>500000
    ndraws_short=nburn+500000;   %fewer draws because of memory constraints
else ndraws_short=ndraws;
end

HD31=zeros(size(yyy2,1),ndraws_short-nburn);
HD32=HD31;
HD33=HD31;
HD34=HD31;

for jj=1:size(HD31,2)
    if (jj/10000) == floor(jj/10000)
          jj
    end
    [HD31(:,jj),HD32(:,jj),HD33(:,jj), HD34(:,jj)] = historical_decomposition_m(A_post(:,:,jj), ...
        B_post(:,:,jj),n,nlags,yyy2,xxx2);
end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HISTORICAL DECOMPOSITION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=time(193+nlags:end,1);
alph=0.025;   
index=[round(alph*(ndraws_short-nburn)) round((1-alph)*(ndraws_short-nburn)) round((ndraws_short-nburn)/2)];

% historical decomposition of real oil price growth
yhat31=sort(HD31,2);
clear HD31
yhat32=sort(HD32,2);
clear HD32
yhat33=sort(HD33,2);
clear HD33
yhat34=sort(HD34,2);
clear HD34

% sample mean of oil price
sm=mean(yy2(:,3));

figure(11)
subplot(2,1,1)
temp1=[yhat31(:,index(3)) yhat31(:,index(1)) yhat31(:,index(2))];
plotx2(temp1,t); box on; plot(t,(yy2(nlags+1:end,3)-sm),'r:','linewidth',2), hold on, plot(t,temp1(:,1),'LineWidth',2), hold on, plot(t,zeros(size(t,1),1),'k:') 
axis([1975 2015 -40 40])
title('Effect of oil supply shocks on oil price growth')
% 
subplot(2,1,2)
temp2=[yhat32(:,index(3)) yhat32(:,index(1)) yhat32(:,index(2))];
plotx2(temp2,t); box on; plot(t,(yy2(nlags+1:end,3)-sm),'r:','linewidth',2), hold on, plot(t,temp2(:,1),'LineWidth',2), hold on, plot(t,zeros(size(t,1),1),'k:')
axis([1975 2015 -40 40])
title('Effect of economic activity shocks on oil price growth')
% 
figure(12)
subplot(2,1,1)
temp3=[yhat33(:,index(3)) yhat33(:,index(1)) yhat33(:,index(2))];
plotx2(temp3,t); box on; plot(t,(yy2(nlags+1:end,3)-sm),'r:','linewidth',2), hold on, plot(t,temp3(:,1),'LineWidth',2), hold on, plot(t,zeros(size(t,1),1),'k:')
axis([1975 2015 -40 40])
title('Effect of consumption demand shocks on oil price growth')
% 
subplot(2,1,2)
temp4=[yhat34(:,index(3)) yhat34(:,index(1)) yhat34(:,index(2))];
plotx2(temp4,t); box on; plot(t,(yy2(nlags+1:end,3)-sm),'r:','linewidth',2), hold on, plot(t,temp4(:,1),'LineWidth',2), hold on, plot(t,zeros(size(t,1),1),'k:')
axis([1975 2015 -40 40])
title('Effect of inventory demand shocks on oil price growth')

%save historical_bench yhat31 yhat32 yhat33 yhat34
clear yhat31 yhat32 yhat33 yhat34
