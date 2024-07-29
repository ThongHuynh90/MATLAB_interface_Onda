function [ z ] = aims_findPulse( input_args )
%AIMS_FINDPULSE Summary of this function goes here
%   Detailed explanation goes here
z=calllib ('SoniqClient','GetPosition',2); 
if z>20
calllib ('SoniqClient','FindPulseAutoMinMax'); 
else
    calllib ('SoniqClient','SetFindPulseMinDelay',0); 
    calllib ('SoniqClient','SetFindPulseMaxDelay',50 ); 
end
calllib ('SoniqClient','SetWaveformAutoscale',0);
calllib ('SoniqClient','SetScopeSensitivity',1,0.004);
calllib ('SoniqClient','FindPulse');
calllib ('SoniqClient','SetWaveformAutoscale',1);
calllib ('SoniqClient','AutoScale');
calllib ('SoniqClient','SetPositionerLowLimit',2 , 3);
z=calllib ('SoniqClient','GetPosition',2); 
end

