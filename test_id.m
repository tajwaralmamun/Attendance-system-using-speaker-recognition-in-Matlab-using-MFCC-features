function p = test_id(name)
display('Say Id');
display('Start Speaking'); 
disp('3');
pause(1); disp('2');
pause(1); disp('1');
disp('NOW!!!');
sig = audiorecorder(44100,16,1); 
recordblocking(sig,2); 
display('Stop Speaking'); 
name1 = getaudiodata(sig); 
audiowrite(name,name1,44100); 
Fs=44100;

Tw=25;
Ts=10;
alpha=0.97;
R = [300 3700];
M = 40;
C = 20;
L = 50;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
h=hamming(200);
dis=zeros(1,9);
[ tMFCCs, ~, ~ ] = mfcc_c( name1, 44100, Tw, Ts, alpha, hamming, R, M, C, L );
directory='Train';
sub_dir=dir(['Train/Id/']);
min_val=zeros(1,length(sub_dir));
for idx = 3:length(sub_dir)
    path = [directory,'/Id/',char(sub_dir(idx).name)];
    files = dir([path,'/*.wav']);   
    L = length (files);
    dis=zeros(1,L);
    for i=1:L
        entry_str=['Train/Id/',char(sub_dir(idx).name),'/',int2str(i),'.wav'];
        [speaker,Fs]=audioread(entry_str);   
        [MFCCs,~,~] = mfcc_c(speaker, Fs, Tw, Ts, alpha, hamming, R, M, C, L );
        
        dis(i) = dtw(tMFCCs,MFCCs);     
        end
    need(idx-2)=mean(dis); % for one idx/entry folder assigning avg distance of L wave files
end 
[lowest,I] = min(need);

p=char(sub_dir(I+2).name);
