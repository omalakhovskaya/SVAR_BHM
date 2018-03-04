disp('working on Table 3 now...')
%compute historical decomposition over specific episode

%Jan-July 1986
tbeg86=132;
tend86=138;

%Jan-Jun 2008
tbeg08=396;
tend08=401;

%July-Dec 2014
tbeg14=474;
tend14=479;

tt=time(193+nlags:end,1);
oilprice=yy2(nlags+1:end,3);

HD31_86=zeros(ndraws-nburn,1);
HD31_08=HD31_86;
HD31_14=HD31_86;

for jj=1:size(A_post,3)
    if (jj/10000) == floor(jj/10000)
          jj
    end
    HD31_86(jj,1) = historical_decomposition_m_specific(A_post(:,:,jj),B_post(:,:,jj),n,nlags, ...
                                                        yyy2,xxx2,tbeg86,tend86,1);
    HD31_08(jj,1) = historical_decomposition_m_specific(A_post(:,:,jj),B_post(:,:,jj),n,nlags, ...
                                                        yyy2,xxx2,tbeg08,tend08,3);
    HD31_14(jj,1) = historical_decomposition_m_specific(A_post(:,:,jj),B_post(:,:,jj),n,nlags, ...
                                                        yyy2,xxx2,tbeg14,tend14,1);
end

HD31_86s=sort(HD31_86);
HD31_08s=sort(HD31_08);
HD31_14s=sort(HD31_14);

alph=0.025;   
index=[round((ndraws-nburn)/2) round(alph*(ndraws-nburn)) round((1-alph)*(ndraws-nburn))];    %implies 95% coverage of the entire distribution

disp('Table 3')

disp('Jan-July 1986 (supply)')
disp('   Actual    median  lower 2.5%  upper 2.5%')
episode1=[sum(oilprice(tbeg86:tend86,1)) HD31_86s(index,1)'];
disp(episode1)

disp('Jan-Jun 2008 (consumption)')
disp('   Actual    median  lower 2.5%  upper 2.5%')
episode2=[sum(oilprice(tbeg08:tend08,1)) HD31_08s(index,1)'];
disp(episode2)

disp('July-Dec 2014 (supply)')
disp('   Actual    median  lower 2.5%  upper 2.5%')
episode3=[sum(oilprice(tbeg14:tend14,1)) HD31_14s(index,1)'];
disp(episode3)
