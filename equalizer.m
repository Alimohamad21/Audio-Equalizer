clear,clc,close all;
filepathname = input('Add a wav file here: ','s');    % input file to be filtered
[wave, fs] = audioread(filepathname);
duration = length(wave)/fs;
wave=resample(wave,70000,fs);
fs=70000;
dt=1/fs;
t=0:dt:(length(wave)*dt)-dt;  
magnitude=linspace(-fs/2,fs/2,length(wave));
wavefs=abs(fftshift(fft(wave)));
frate=input('input 1 for half sampling frequency 2 for double sampling frequency or any for normal sampling frequency: ');
if frate==1
    fs=fs/2;        % for half sampling frequency
end
if frate==2
    fs=fs*2;        % for double sampling frequency
end
g=zeros(1,9);
g(1)=input('Enter gain for range of frequencies(0-170 Hz): ');           
g(2)=input('Enter gain for range of frequencies(170-310 Hz): ');
g(3)=input('Enter gain for range of frequencies(310- 600 Hz): ');
g(4)=input('Enter gain for range of frequencies(600- 1000 Hz): ');      
g(5)=input('Enter gain for range of frequencies(1- 3 KHz): ');        % input gains for different frequencies 
g(6)=input('Enter gain for range of frequencies(3- 6 KHz): '); 
g(7)=input('Enter gain for range of frequencies(6-12 KHz): ');
g(8)=input('Enter gain for range of frequencies(12-14 KHz): ');
g(9)=input('Enter gain for range of frequencies(14-16 KHz): ');
choice=input('input 0 for IIR filter and 1 for FIR filter: ');
figure;
subplot(2,1,1)
plot(t,wave);
subplot(2,1,2)
plot(magnitude,wavefs); % plot input file in time and frequency domain
z=cell(9,1);    % initiliaze 2d arrays for poles,zeros and outputs
p=cell(9,1);
output=cell(9,1);
if choice ==0        % for IIR filter 
   [z{1}, p{1}]=butter(3,170/(fs/2));
   [z{2}, p{2}]=butter(3,[170/(fs/2) 310/(fs/2)],'bandpass');
   [z{3}, p{3}]=butter(3,[310/(fs/2) 600/(fs/2)],'bandpass');
   [z{4}, p{4}]=butter(3,[600/(fs/2) 1000/(fs/2)],'bandpass');     
   [z{5}, p{5}]=butter(3,[1000/(fs/2) 3000/(fs/2)],'bandpass');     % buttersworth filter for each frequency 
   [z{6}, p{6}]=butter(3,[3000/(fs/2) 6000/(fs/2)],'bandpass');
   [z{7}, p{7}]=butter(3,[6000/(fs/2) 12000/(fs/2)],'bandpass');
   [z{8}, p{8}]=butter(3,[12000/(fs/2) 14000/(fs/2)],'bandpass');
   [z{9}, p{9}]=butter(3,[14000/(fs/2) 16000/(fs/2)],'bandpass');
   total=[];
   for i=1:9
          figure;
          output{i}=filter(z{i}, p{i},wave);       
          subplot(2,1,1);
          plot(t,output{i});
          subplot(2,1,2);  
          plot(magnitude,abs(fftshift(fft(output{i}))));                   % plot output IIR filter of each frequency in time and frquency domain
          total=[total (10^(g(i))/20)*output{i}];       % concatenate output IIR filter for each frequency to the total output filter
   end
   figure;
   subplot(2,1,1)
   plot(t,total);                      
   subplot(2,1,2)                       % plot total output IIR filter in time and frequency domain
   plot(magnitude,abs(fftshift(fft(total))));
   figure; 
   for i=1:9
   subplot(3,3,i);
   stepz(z{i},p{i});                    % plot IIR filter step response for each frequency
   end
   figure;
   for i=1:9
   subplot(3,3,i);                      % plot IIR filter poles and zeros for each frequency
   pzmap(z{i},p{i});
   end
   for i=1:9
   figure;
   freqz(z{i},p{i});                   % plot IIR filter mag and phase for each frequency 
   end
   figure;
   for i=1:9                        
   subplot(3,3,i)                      % plot IIR filter impulse response for each frequency 
   impz(z{i},p{i})
   end
elseif choice == 1       % for FIR filter
   [z{1}, p{1}]=fir1(30,170/(fs/2));
   [z{2}, p{2}]=fir1(30,[170/(fs/2) 310/(fs/2)],'bandpass');
   [z{3}, p{3}]=fir1(30,[310/(fs/2) 600/(fs/2)],'bandpass');   
   [z{4}, p{4}]=fir1(30,[600/(fs/2) 1000/(fs/2)],'bandpass');
   [z{5}, p{5}]=fir1(30,[1000/(fs/2) 3000/(fs/2)],'bandpass');     % FIR filter for each frequency
   [z{6}, p{6}]=fir1(30,[3000/(fs/2) 6000/(fs/2)],'bandpass');
   [z{7}, p{7}]=fir1(30,[6000/(fs/2) 12000/(fs/2)],'bandpass');
   [z{8}, p{8}]=fir1(30,[12000/(fs/2) 14000/(fs/2)],'bandpass');
   [z{9}, p{9}]=fir1(30,[14000/(fs/2) 16000/(fs/2)],'bandpass');
   total=[];
    for i=1:9
          figure;
          output{i}=filter(z{i}, p{i},wave);
          subplot(2,1,1);
          plot(t,output{i});
          subplot(2,1,2);
          plot(magnitude,abs(fftshift(fft(output{i}))));   % plot output FIR filter of each frequency in time and frquency domain
          total=[total (10^(g(i))/20)*output{i}];   % concatenate output FIR filter for each frequency to the total output filter
   end
   figure;
   subplot(2,1,1)         
   plot(t,total);
   subplot(2,1,2)
   plot(magnitude,abs(fftshift(fft(total))));    % plot total output FIR  filter in time and frequency domain
   figure;
 for i=1:9
   subplot(3,3,i);                         
   stepz(z{i},1);                        % plot FIR filter step response for each frequency
  end
   figure;
   for i=1:9
   subplot(3,3,i);
   zplane(z{i},1);                    % plot FIR filter zeros for each frequency
   end
   for i=1:9
   figure;
   freqz(z{i},1);           % plot FIR filter mag and phase for each frequency
   end
   figure;
   for i=1:9
   subplot(3,3,i)
   impz(z{i},1)             % plot FIR filter impulse response for each frequency
   end
end
play=input('press 1 to play output audio file or any input to exit: ');
if play==1
    audiowrite('output.wav', total, fs);
    [wave,fs]=audioread('output.wav');      % save output file
end
