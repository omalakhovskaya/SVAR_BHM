function taustar = gettau2(kappa,omega_m,Ytilde,X,n)
taustar = zeros(n,1)
for jj = 1:n 
omega = omega_m(jj,jj)
Y = Ytilde(:,jj)
tau=kappa*omega;
zetastar=(Y'*Y)-(Y'*X)*inv(X'*X)*(X'*Y);
taustar(jj)=tau+0.5*zetastar;
end 
end

