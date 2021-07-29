function sdc_coeff = mfcc2sdc(lifted_MFCC,N,Tw,Ts,N)

ToT=size(lifted_MFCC,1); %Actual Number of Frames 
lifted_MFCC=(horzcat(lifted_MFCC', lifted_MFCC(1:Ts*(N-1),:)'))'; %Circular padding
[NoOfFrame NoOfCoeff]=size(lifted_MFCC); 
delt=(mfcc2delta(lifted_MFCC,Tw))';   %Delta Feature Computation
sd_temp=cell(1,N);                %Preparation of a cell array for delta's
for i=1:N                         %For N number of shifts
    temp=delt(:,Ts*(i-1)+1:1:end); %P: Size of shift
    sd_temp{i}=temp(:,1:ToT);     %Take only desired (i.e. ToT) no of deltas. 
end
sdc_coeff=cell2mat(sd_temp');     %Stacking the SDCs in a single variable
sdc_coeff=sdc_coeff';
%--------------------------------------------------------------------------

