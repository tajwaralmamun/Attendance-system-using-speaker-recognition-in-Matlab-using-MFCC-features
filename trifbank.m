function [ H, f, c ] = trifbank( M, K, R, fs, h2w, w2h ) %pg 327-328

    f_min = 0;          % filter coefficients start at this frequency (Hz)
    f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
    f = linspace( f_min, f_max, K ); % frequency range (Hz), size 1xK ,K=unique fft length
    fw = h2w( f ); %converted to mel frequency fw array, f array in Hz

    f_low = R(1);       % lower cutoff frequency (Hz) for the filterbank 
    f_high = R(2);      % upper cutoff frequency (Hz) for the filterbank 
    
    % filter cutoff frequencies (Hz) for all filters, size 1x(M+2)
    c = w2h( h2w(f_low)+[0:M+1]*((h2w(f_high)-h2w(f_low))/(M+1)) );%cut off frequency in hertz
    cw = h2w( c ); %cutoff frequency in mel

    H = zeros( M, K ); 
     %eqn for triangle            
    for m = 1:M 

        k = f>=c(m)&f<=c(m+1); % up-slope
        H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
        k = f>=c(m+1)&f<=c(m+2); % down-slope
        H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
       
    end
