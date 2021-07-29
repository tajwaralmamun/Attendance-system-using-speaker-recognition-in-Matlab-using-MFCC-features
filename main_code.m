clc;
clear all;
close all;

K=0;
    K = menu('Bangla Voice Recognition','New Entry','Test','Exit');
    clc;
    fid = fopen('Attendance.txt','a+');
    switch K
           
            case 1
            Name=input('Enter your name :','s');
            mkdir (['Train','/','Name','/',Name]); 
            mkdir (['Train','/','Entry','/',Name]);
            mkdir (['Train','/','ID','/',Name]);
            N=input(' How many train dataset you want to create? ==>');
            for i=1:N
                filename=['Train/Entry/',Name,'/',int2str(i),'.wav'];
                Entry=train_entry(filename);
            end
            for i=1:N
                filename=['Train/Name/',Name,'/',int2str(i),'.wav'];
                Entry=train_name(filename);
            end
            for i=1:N
                filename=['Train/Id/',Name,'/',int2str(i),'.wav'];
                Entry=train_id(filename);
            end
            
        case 2
            
            p=test_entry('Test/unknown_1.wav');
            q=test_name('Test/unknown_2.wav');
            r=test_id('Test/unknown_3.wav');
            
            
            if strcmp(p,q) && strcmp(q,r)
                display('Access Granted');
                fprintf('Welcome %s',p);
                fprintf(fid, '|%s|',p);
                
            else
                display('Access Denied');
            end
        end
fclose(fid);


