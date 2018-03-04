function posterior=getposterior8(theta,param,S,m,yyy1,yyy2,Pinv,Xtilde,mu,n,c,kappa,T1,T2,omega_tildeT)

prior = getprior8(theta,param,c);
log_priors = log(prod(prior));

kappastar=kappa+(mu*T1+T2)/2;
A_tilde=[1 0 -theta(1) 0 0; ...
         0 1 -theta(2) 0 0; ...
         1 -theta(3:4)' -1/theta(5) 0;...
         -theta(6) 0 -theta(7) 1 0;...
         -theta(9:12)' 1];
P=eye(size(S,1));
P(4,3)=theta(8);
P(5,3)=theta(13);
P(5,4)=theta(14);
A=P*A_tilde;
Ytilde = [sqrt(mu)*yyy1*A';yyy2*A';Pinv'*m'];
omega=A*S*A';
[~, taustar] = gettau3(kappa, omega, Ytilde, Xtilde,n);

up=log_priors+(mu*T1+T2)/2*log(det(A*omega_tildeT*A'))+ sum(kappa*log(kappa*diag(omega)));
down = kappastar*(n*(log(2) - log(mu*T1+T2))+ sum(log(taustar)));
posterior=up-down;





