function [Waveforms,fs] = Scan1D( axis)
pos=linspace(axis.low_pos,axis.high_pos,axis.points_num);
calllib('SoniqClient','GetTemperature')
calllib('SoniqClient','ClearWaveform')
calllib('SoniqClient','DigitizeWaveform');
pBufferLength = calllib('SoniqClient','GetWaveformPoints')
Buff=zeros([1 pBufferLength]);
pBuffer = libpointer('doublePtr',Buff);
Waveforms=zeros(axis.points_num,pBufferLength);
figure
hold on
i=0;
for pos_i=pos
    i=i+1;
    calllib('SoniqClient','PositionerMoveAbs',axis.axis,pos_i);%Move 1 mm
    pause(0.1);
    calllib('SoniqClient','ClearWaveform')
    calllib('SoniqClient','DigitizeWaveform');
    if(calllib('SoniqClient','GetDataValid')~=0)
        calllib('SoniqClient','GetWaveformData',pBuffer,pBufferLength);
%         plot(pBuffer.value);
         Waveforms(i,:) = pBuffer.value;
    end   
end
aims_move_xy(0,0);
timebase = calllib('SoniqClient','GetScopeTimebase');
fs = pBufferLength/(10*timebase)*1e6;
end