function [ MFCC, FBE, frames ] = mfcc_c( speech, fs, Tw, Ts, alpha, window, R, M, N, L )

if( max(abs(speech))<=1 )
    speech = speech * 2^15; 
end

Nw = round( 1E-3*Tw*fs );    % frame duration (samples)
Ns = round( 1E-3*Ts*fs );    % frame shift (samples)

nfft = 2^nextpow2( Nw );     % length of FFT analysis
K = nfft/2+1;                % length of the unique part of the FFT



%% expression to be used

hz2mel = @( hz )( 1127*log(1+hz/700) );  

mel2hz = @( mel )( 700*exp(mel/1127)-700 ); 

dctm = @( N, M )( sqrt(2.0/M) * cos( repmat([0:N-1]',1,M) .* repmat(pi*([1:M]-0.5)/M,N,1) ) );

ceplifter = @( N, L )( 1+0.5*L*sin(pi*[0:N-1]/L) );


%% FEATURE EXTRACTION starts

%     %First order FIR Filter
speech = filter( [1 -alpha], 1, speech ); 

%Butterworth filter
n = 7;
beginFreq = R(1) / (fs/2); % lower range used  
endFreq = R(2) / (fs/2);% higher range used
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass'); % butter by default function %
speech = filter(b, a, speech); %1D array
%Pre-emphasis done


% Framing and windowing (frames as columns)
frames = vec2frames( speech, Nw, Ns, 'cols', window, false ); %2D array

% Magnitude spectrum computation (as column vectors)
MAG = abs( fft(frames,nfft,1) );
%  MAG=MAG.^2./length(MAG);

% Triangular Mel filterbank (uniformly spaced filters on mel scale)
H = trifbank( M, K, R, fs, hz2mel, mel2hz );% size of H is M x K

% Filterbank application to unique part of the magnitude spectrum
FBE = H * MAG(1:K,:); 

% DCT matrix computation
DCT = dctm( N, M );

% Conversion of logFBEs to cepstral coefficients through DCT
MFCC =  DCT * log( FBE ); 

% Cepstral lifter computation
lifter = ceplifter( N, L );% 1D array

%Cepstral liftering gives liftered cepstral coefficients
MFCC = diag( lifter ) * MFCC; 

%Shifted MFCC Delta Coefficient Computation.
 MFCC=mfcc2sdc(MFCC',N,Tw,Ts,N);

% EOF