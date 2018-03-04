% Table 2: 

load elasticities 

disp('Table 2')

disp('Supply elasticity: alpha(qp)')
disp(alpha_qp) 
disp('Demand elasticity: beta(qp)')
disp(beta_qp)

load IRF_norm

disp('Supply shock on IP after 12 months')
disp(IRn21)

disp('Consumption demand shock on IP after 12 months')
disp(IRn23)

disp('Inventory demand shock on IP after 12 months')
disp(IRn24)

load VDP

disp('MSE of oil price due to oil supply')
disp(VDP_supp)

disp('MSE of oil price due to economic activity')
disp(VDP_econ)

disp('MSE of oil price due to consumption demand')
disp(VDP_cons)

