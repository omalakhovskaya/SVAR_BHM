A_old = zeros(c,1);

while A_old(1) <= 0 
A_old(1) = trnd(nu_alpha_qp)*sigma_alpha_qp+c_alpha_qp;
end 

while A_old(2) >= 0 
A_old(2) = trnd(nu_alpha_yp)*sigma_alpha_yp+c_alpha_yp;
end 

while A_old(3) <= 0 
A_old(3) = trnd(nu_beta_qy)*sigma_beta_qy+c_beta_qy;
end 

while A_old(4) >= 0 
A_old(4) = trnd(nu_beta_qp)*sigma_beta_qp+c_beta_qp;
end 

A_old(5) = betarnd(alpha_k, beta_k);
A_old(6) = trnd(nu_psi1)*sigma_psi1 + c_psi1;
A_old(7) = trnd(nu_psi3)*sigma_psi3 + c_psi3;
A_old(8) = betarnd(alpha_rho, beta_rho);
A_old(9) = trnd(nu_gamma1)*sigma_gamma1 + c_gamma1;
A_old(10) = trnd(nu_gamma2)*sigma_gamma2 + c_gamma2;
A_old(11) = trnd(nu_gamma3)*sigma_gamma3 + c_gamma3;
A_old(12) = trnd(nu_gamma4)*sigma_gamma4 + c_gamma4;
A_old(13) = trnd(nu_phi)*sigma_phi + c_phi;
A_old(14) = trnd(nu_tau)*sigma_tau + c_tau;



