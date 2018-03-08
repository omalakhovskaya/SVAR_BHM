ds = D_star_post(:,:,5)
g = G_post(:,:,5)
g*ds*g'
d = D_post(:,:,5)
rho1 = -ds(3,4)/ds(3,3)
tau1 = (ds(3,4)*ds(3,5) - ds(3,3)*ds(4,5))/(ds(3,3)*ds(4,4)-ds(3,4)^2)
phi1 = (-ds(5,3) - ds(4,3)*tau1)/ds(3,3)