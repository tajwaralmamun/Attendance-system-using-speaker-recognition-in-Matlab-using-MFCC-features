function delta_coeff = mfcc2delta(CepCoeff,d)%d -> Tw/lag

[NoOfFrame NoOfCoeff]=size(CepCoeff); %Note the size of input data

vf=(d:-1:-d); %for every "ms" of frame width
vf=vf/sum(vf.^2); % scaling
ww=ones(d,1);
cx=[CepCoeff(ww,:); CepCoeff; CepCoeff(NoOfFrame*ww,:)];
vx=reshape(filter(vf,1,cx(:)),NoOfFrame+2*d,NoOfCoeff);
vx(1:2*d,:)=[];
delta_coeff=vx;
