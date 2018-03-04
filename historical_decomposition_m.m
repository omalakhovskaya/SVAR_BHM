function [HD31,HD32,HD33,HD34] = historical_decomposition_m(A,b,n,p,yyy,xxx)

t=size(yyy,1);
phi=A\b;
F=varcompanion(phi,1,n,p);
J=[eye(n) zeros(n,(p-1)*n)];
Q=eye((p-1)*n+n,(p-1)*n+n);
IRF=reshape(J*Q*J'/A,n^2,1);

%use approximation
for i=1:99
    Q=Q*F;
	IRF=([IRF reshape((J*Q*J')/A,n^2,1)]);
end

IRF=[IRF zeros(16,t-100)];

ehat=A*yyy'-b*xxx';     %structural shocks (last two containing also measurement error)

%cross-multiply the weights for the effect of a given shock on the real
%oil price (given by the relevant row of IRF) with the structural shock
%in question

HD31=zeros(t,1); HD32=HD31; HD33=HD31; HD34=HD31;

for i=1:t
     
	HD31(i,:)=dot(IRF(3,1:i),ehat(1,i:-1:1));
    HD32(i,:)=dot(IRF(7,1:i),ehat(2,i:-1:1));
    HD33(i,:)=dot(IRF(11,1:i),ehat(3,i:-1:1));
    HD34(i,:)=dot(IRF(15,1:i),ehat(4,i:-1:1));
    
end


