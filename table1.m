disp('working on Table 1 now...')
%
VD=zeros(n,n,hmax,size(A_post,3));
nuse=size(A_post,3);

for jj=1:nuse
    if (jj/10000) == floor(jj/10000)
          jj
    end
    ir = impulse_response_1SD_m(A_post(:,:,jj),B_post(:,:,jj),n,nlags,hmax-1,D_post(:,:,jj));
    vc = vardec(n,hmax,ir);
    VD(:,:,:,jj) = vc;
end

index0 = round(0.5*nuse);
index1 = round(0.025*nuse);
index2 = round((1 - 0.025)*nuse);

H0 = zeros(n,n,hmax);
H1 = zeros(n,n,hmax);
H2 = zeros(n,n,hmax);
HH0 = H0;

    for i = 1:n
        for j = 1:n
           K = squeeze(VD(i,j,:,:));
           K = sort(K,2);
           H0(i,j,:) = K(:,index0);
           H1(i,j,:) = K(:,index1);
           H2(i,j,:) = K(:,index2);
        end
    end
  
for s = 0:hmax-1
    % reformulate as fractions
    for i=1:n
       HH0(i,:,s+1) = H0(i,:,s+1)./squeeze(sum(H0(i,:,s+1),2))';
    end
end

% select horizon to display
ss=12;
vd_median=H0(:,:,ss)';
vd_lower=H1(:,:,ss)';
vd_upper=H2(:,:,ss)';
vd_fraction=round(100.*HH0(:,:,ss)');

disp('Table 1')
disp(['Decomposition of variance of forecast errors at horizon ' num2str(ss)])
disp('Oil production  IP   Oil price  Inventories')
disp('                Median             ')
disp(vd_median)

disp('                Lower 2.5%')
disp(vd_lower)

disp('                Upper 2.5%')
disp(vd_upper)

disp('                Percent (median)')
disp(vd_fraction)

VDP_supp=[H0(3,1,ss) H1(3,1,ss) H2(3,1,ss) round(100*HH0(3,1,ss))];
VDP_econ=[H0(3,2,ss) H1(3,2,ss) H2(3,2,ss) round(100*HH0(3,2,ss))];
VDP_cons=[H0(3,3,ss) H1(3,3,ss) H2(3,3,ss) round(100*HH0(3,3,ss))];

save VDP VDP_supp VDP_econ VDP_cons

clear VD