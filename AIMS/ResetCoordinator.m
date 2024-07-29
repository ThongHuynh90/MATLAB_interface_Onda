
function [ output_args ] = ResetCoordinator(input_args)
%SoniqCommDemo2014: Demonstrate Matlab-Soniq communication by performing two 1D scans in left/right and front/back axes, and acquiring a waveform
%Last modified: 20140710_DG
if(strcmp(questdlg('Make sure you take off the probe ?','Caution','No','Yes','No'),'No'))
    return
end
AMIS_init();

axist=0;
calllib('SoniqClient','SetPositionerLowLimit',axist,-1000);
calllib('SoniqClient','PositionerMoveAbs',axist,-1000);%Move 10 mm
calllib('SoniqClient','SetPositionerLowLimit',axist,-50);
calllib('SoniqClient','SetPosition',axist,-50);
calllib('SoniqClient','SetPositionerHighLimit',0,-50);

axist=1;
calllib('SoniqClient','SetPositionerHighLimit',axist,1000);
calllib('SoniqClient','PositionerMoveAbs',axist,1000);%Move 10 mm
calllib('SoniqClient','SetPosition',axist,50);
% calllib('SoniqClient','SetPositionerLowLimit',axist,-50);
% calllib('SoniqClient','SetPositionerHighLimit',0,-50);

axist=2;
calllib('SoniqClient','SetPositionerHighLimit',axist,1001);
calllib('SoniqClient','SetPosition',axist,1000);
calllib('SoniqClient','SetPositionerLowLimit',axist,1);
calllib('SoniqClient','PositionerMoveAbs',axist,2);%Move 10 mm
calllib('SoniqClient','SetPosition',axist,2);
% calllib('SetPositionerLowLimit',0,0);
% calllib('PositionerMoveAbs',0,3);
% calllib('SoniqClient','PositionerMoveRel',0,-1000);%Move 10 mm
%calllib('SoniqClient','FindLimitSwitch',0,true);%Set to max limit
%calllib('SoniqClient','FindLimitSwitch',1,false);%Set to max limit
AMIS_close();
end
