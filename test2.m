syms alpha_qp alpha_yp beta_qy beta_qp chi psi1 psi2 psi3 rho
A_tilde = [1 0 -alpha_qp 0;...
          0  1 -alpha_yp 0;...
          1  -beta_qy -beta_qp -chi^(-1);...
          -psi1 -psi2 -psi3 1];
 A_tilde
Gamma= [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 rho 1]
    
 Gamma
 
 A = Gamma* A_tilde;
 A
 
 