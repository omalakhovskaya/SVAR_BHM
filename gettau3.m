function [zetastar, taustar] = gettau3(kappa,omega_m,Y,X,n)
omega = diag(omega_m);
zetastar=(Y'*Y)-(Y'*X)*inv(X'*X)*(X'*Y);
taustar=kappa*omega+0.5*diag(zetastar);
end

