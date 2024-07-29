function y= aims_get_conditions
% function y= GetAIMSconditions
%
buf = libpointer('cstring', blanks(200));
y.hydrophoneNum=calllib ('SoniqClient','GetHydrophoneSerial',buf );
y.temp = calllib ('SoniqClient','GetTemperature');
y.c    = calllib ('SoniqClient','GetVelocity');
y.delay= calllib ('SoniqClient','GetDistanceTrackingDelay')*1e-6;
y.delayOffset= calllib ('SoniqClient','GetDistanceTrackingOffset')*1e-6;

y.XAngle_dev=0;
y.YAngle_dev=0;
y.MachineCoordinates=calllib('SoniqClient','GetUseMachineCoordinates');
if(~y.MachineCoordinates)
    y.XAngle_dev=calllib ('SoniqClient','GetXAngle');
    y.YAngle_dev=calllib ('SoniqClient','GetYAngle');
end
end