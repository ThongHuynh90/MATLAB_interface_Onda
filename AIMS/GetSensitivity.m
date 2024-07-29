datacount=calllib ('SoniqClient','GetHydrophoneTabDataCount');
for i=1:datacount
sensitivity_array(i)=calllib ('SoniqClient','GetHydrophoneDataPointY',i);
Freqs(i)=calllib ('SoniqClient','GetHydrophoneDataPointX',i);
end

CenterFreq=calllib('SoniqClient','GetXdcrFreqMHz')
SensAtCenterFreq=calllib('SoniqClient','SetHydrophoneVperMPa')