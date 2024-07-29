function data = p_2nd_harmonic_calc_2D( waveform )
%P_RMS_CAL calculate the rms value of input waveforms parallely
%   Detailed explanation goes here
% waveform must be a column vector
fs=100e6;
data= p_cost(waveform,fs);
end

function cost=p_cost(signal,fs)

[f H N] = spectrum_plot( signal,fs);
spectrum=abs(H)/max(abs(H));%Normalize

a0=0.5;
a1=1;
a2=5;
a3=0.5;


idx1 = find(f>0.9e6,1);
idx2 = find(f>2.5e6,1);
idx3 = find(f>5e6,1);


% 
win0=hann(idx1-1);
win1=hann(idx2-idx1);
win2=1.8*hann(round((idx3-idx2)/1.5));win2(idx3-idx2)=1;
win2(round(length(win2)/2):length(win2))=1;
win3=1./((f(idx3:N)/min(f(idx3:N))).^3)';

weight0=ones([idx1 1]);
weight1=ones([idx2-idx1 1]);
weight2=ones([idx3-idx2 1]);
weight3=ones([N-idx3 1]);

weight=[a0*weight0;-a1*weight1;a2*weight2;a3*weight3];
win=[win0;win1;win2;win3];
% weight=a0*weight0-a1*weight1+a2*weight2;
cost=sum(spectrum.*weight.*win);
% cost0=sum(weight0.*spectrum(1:idx1-1));
% cost1=sum(weight1.*spectrum(idx1:idx2-1));
% cost2=sum(weight2.*spectrum(idx2:idx3-1));
% cost3=sum(weight3.*spectrum(idx3:N));

end

