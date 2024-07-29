
function Probe_Config( probe_name )
%PROBE_CONFIG Summary of this function goes here
%   Detailed explanation goes here
window_angle=60;%in deg
switch lower(probe_name)
    case 'm5sc'
        azimuth = 2.16;% cm
        elevation = 1.3;
        FocusLengthAzimuth=8.080; %cm, read in the log file of Aurora
        FocusLengthElevation=8.080; %cm, read in the log file of Aurora
        LineCount=52;
        activeAzimuth=azimuth;% full aperture
    case 'gen3'
        azimuth = 2.15;%cm
        elevation = 1.56;
        FocusLengthAzimuth=8.080; %cm, read in the log file of Aurora
        FocusLengthElevation=8.080; %cm, read in the log file of Aurora
        LineCount=52;
    otherwise
        disp('Undefined Probe');
end
calllib ('SoniqClient','SetXdcrScanned',true );

calllib ('SoniqClient','SetXdcrCircular',false );
calllib ('SoniqClient','SetXdcrXDim',azimuth );
calllib ('SoniqClient','SetXdcrYDim',elevation );

calllib ('SoniqClient','SetXdcrApertureXWidth',activeAzimuth ); % in cm^2
calllib ('SoniqClient','SetXdcrFLX',FocusLengthAzimuth); %Set Focus Length X
calllib ('SoniqClient','SetXdcrFLY',FocusLengthElevation); %Set Focus Length Y
calllib ('SoniqClient','SetXdcrSectorScanner',true );
calllib ('SoniqClient','SetXdcrLineIncrementalAngle',window_angle/LineCount);
calllib ('SoniqClient','SetXdcrLineCount', LineCount);
calllib ('SoniqClient','SetXdcrFrameRate',29 );
calllib ('SoniqClient','SetXdcrCranialUse',false );

end

