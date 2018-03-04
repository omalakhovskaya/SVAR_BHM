function lambda = historical_decomposition_m_specific(A,b,n,p,yyy,xxx,tbeg,tend,shock)

s=tend-tbeg+1;

phi=A\b;
F=varcompanion(phi,1,n,p);
J=[eye(n) zeros(n,(p-1)*n)];
Q=eye((p-1)*n+n,(p-1)*n+n);
IRF=reshape(J*Q*J'/A,n^2,1);

%use approximation
for i=1:s
    Q=Q*F;
	IRF=([IRF reshape((J*Q*J')/A,n^2,1)]);
end

ehat=A*yyy'-b*xxx';     %structural shocks (last two containing also measurement error)

%cross-multiply the weights for the effect of a given shock on the real
%oil price (given by the relevant row of IRF) with the structural shock
%in question

HD3=zeros(s,1);

for i=1:s
    if shock==1
         HD3(i,:)=dot(IRF(3,1:i),ehat(1,tbeg+i-1:-1:tbeg));
    elseif shock==2
         HD3(i,:)=dot(IRF(7,1:i),ehat(2,tbeg+i-1:-1:tbeg));
    elseif shock==3
        HD3(i,:)=dot(IRF(11,1:i),ehat(3,tbeg+i-1:-1:tbeg));
    elseif shock==4
        HD3(i,:)=dot(IRF(15,1:i),ehat(4,tbeg+i-1:-1:tbeg));
    end
    
end

lambda=sum(HD3);
