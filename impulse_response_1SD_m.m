function IR = impulse_response_1SD_m(A,b,n,nlags,hmax,D)

rdc=A\D^.5;  
phi=A\b;
F=varcompanion(phi,1,n,nlags);
J=[eye(n) zeros(n,(nlags-1)*n)];
IR=[];
for h=0:hmax
    IR=cat(3,IR,(J*(F^h)*J')*rdc);
end