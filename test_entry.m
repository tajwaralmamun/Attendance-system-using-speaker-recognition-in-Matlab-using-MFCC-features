function p = test_entry(name)
display('Say Entry');
display('Start Speaking'); 
disp('3');
pause(1); disp('2');
pause(1); disp('1');
disp('NOW!!!');
sig = audiorecorder(44100,16,1); 
recordblocking(sig,2); 
disp('Stop Speaking'); 
name1 = getaudiodata(sig); 
audiowrite(name,name1,44100);
%test data entry sesh 
Fs=44100;
Tw=25;%in ms
Ts=10;%in ms
alpha=0.97;%pre-emphasis filter
R = [300 3700]; %kotha bolar range
M = 26;
C = 13;%cepstral coeff num
L = 22;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
h=hamming(200); %taking 200 elements

[ tMFCCs, ~, ~ ] = mfcc_c( name1, 44100, Tw, Ts, alpha, hamming, R, M, C, L );

%tmfccs has mffcc coefficients oftest_entry sample

directory='Train';
sub_dir=dir(['Train/Entry/']);
need=zeros(1,(length(sub_dir)-2));% [length(sub_dir)-2]= folder numbers under "Entry"
for folder_no = 1:length(sub_dir)-2
    %sub_dir(idx)
    path = [directory,'/Entry/',char(sub_dir(folder_no+2).name)];
    
    files = dir([path,'/*.wav']); 
    
    L = length (files); %number of wave files present in one folder e.g "asif"
    
    dis=zeros(1,L); %distanes of all wave files in one folder e.g " asif" 
    
    for i=1:L
        entry_str=['Train/Entry/',char(sub_dir(folder_no+2).name),'/',int2str(i),'.wav'];%takes the wave files
        [speaker,Fs]=audioread(entry_str);   
        [MFCCs] = mfcc_c(speaker, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
        
        dis(i) = dtw(tMFCCs,MFCCs);    
    end
    need(folder_no)=mean(dis); % avg distance for one folder e.g "asif"
end 
[lowest,I] = min(need);

p=char(sub_dir(I+2).name);

