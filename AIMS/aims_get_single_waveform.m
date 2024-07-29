function [wf, fs, delay]= aims_get_single_waveform(varargin)
%This function save the waveform at current position
% [wf, fs]= aims_get_single_waveform(calibration_enable)
% wf is measured voltage in mV
%calibration can be included by add parameter 
calllib('SoniqClient','ClearWaveform');
calllib('SoniqClient','DigitizeWaveform');
pBufferLength = calllib('SoniqClient','GetWaveformPoints');
Buff=zeros([pBufferLength 1]);
pBuffer = libpointer('doublePtr',Buff);
if(calllib('SoniqClient','GetDataValid')~=0)
    calllib('SoniqClient','GetWaveformData',pBuffer,pBufferLength);      
else
    calllib ('SoniqClient','MessageBox','Can not get waveform' ,0);
end
wf=pBuffer.value;
timebase=calllib('SoniqClient','GetScopeTimebase');
fs=pBufferLength/(10*timebase)*1e6;
if(nargin>=1)
    wf=m_calibration(wf,fs);
end
delay = calllib('SoniqClient','GetScopeDelay')*1e-6;
% m_spectrum_plot(wf,fs,'log','Normalize');
%  get(gcf,'Position');
% set(0,'defaultfigureposition',ans);
end