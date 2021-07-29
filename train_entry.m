function [name1] = train_entry(name)   

display('Say Entry at first');
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
end