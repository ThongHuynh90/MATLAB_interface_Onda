function data = p_rms_calc_2D( waveform )
%P_RMS_CAL calculate the rms value of input waveforms parallely
%   Detailed explanation goes here

%Convertion into 1D array may required by some function.Just enable this 
% waveform=reshape(waveform,1,length(waveform));
waveform=gpuArray(waveform);
data= sum(waveform.^2)/sqrt(2);
end

