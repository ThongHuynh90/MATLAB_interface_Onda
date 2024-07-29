
if(strcmp(questdlg('Make sure you take off the probe ?','Caution','No','Yes','No'),'No'))
    return
end
aims_connect();
[x,y,z]=aims_get_xyz();
aims_move_xyz(x,y,z+100);
calllib('SoniqClient','SetPosition',2,3);%
aims_move_xyz(x,y,100);
aims_move_xy(0,0);
% 
% axist=2;
% calllib('SoniqClient','SetPositionerHighLimit',axist,1001);
% calllib('SoniqClient','SetPositionerLowLimit',axist,1);
% calllib('SoniqClient','SetPosition',axist,2);
% calllib('SoniqClient','PositionerMoveAbs',axist,1001);%Move 10 mm
% calllib('SoniqClient','SetPosition',axist,2);
% 
% axist=0;
% calllib('SoniqClient','SetPositionerLowLimit',axist,-1000);
% calllib('SoniqClient','PositionerMoveAbs',axist,-1000);%Move 10 mm
% calllib('SoniqClient','SetPositionerLowLimit',axist,-50);
% calllib('SoniqClient','SetPosition',axist,-50);
% calllib('SoniqClient','SetPositionerHighLimit',0,-50);
% 
% axist=1;
% calllib('SoniqClient','SetPositionerHighLimit',axist,1000);
% calllib('SoniqClient','PositionerMoveAbs',axist,1000);%Move 10 mm
% calllib('SoniqClient','SetPosition',axist,50);
% % calllib('SoniqClient','SetPositionerLowLimit',axist,-50);
% % calllib('SoniqClient','SetPositionerHighLimit',0,-50);
% 
% % calllib('SetPositionerLowLimit',0,0);
% % calllib('PositionerMoveAbs',0,3);
% % calllib('SoniqClient','PositionerMoveRel',0,-1000);%Move 10 mm
% %calllib('SoniqClient','FindLimitSwitch',0,true);%Set to max limit
% %calllib('SoniqClient','FindLimitSwitch',1,false);%Set to max limit
aims_close();

