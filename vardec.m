function cv = vardec(nvars,nsteps,ir)

%calculates variance decomposition 
cv=zeros(nvars,nvars,nsteps);

for i=1:nvars
    for j=1:nvars
        resp = squeeze(ir(i,j,:));
        vardeco = resp.*resp;               
        cv(i,j,:)=cumsum(vardeco);        %variance of the forecast error: conditional variance
    end
end


