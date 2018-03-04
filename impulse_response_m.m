function IR = impulse_response_m(A,b,n,nlags,hmax)

rdc=inv(A);  
phi=A\b;
F=varcompanion(phi,1,n,nlags);
J=[eye(n) zeros(n,(nlags-1)*n)];
IR=[];
for h=0:hmax
    IR=cat(3,IR,(J*(F^h)*J')*rdc);
end