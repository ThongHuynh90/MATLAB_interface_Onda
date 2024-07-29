Points_num=41;
Width=20*2;
dB_level=-6;
BoolSet = true;
% calllib('SoniqClient','ShowPlaneSearchDialog');
calllib('SoniqClient','SetPlaneSearchXPoints',Points_num);
calllib('SoniqClient','GetPlaneSearchXPoints')
calllib('SoniqClient','SetPlaneSearchXWidth',Width);
calllib('SoniqClient','GetPlaneSearchXWidth')
calllib('SoniqClient','SetPlaneSearchYPoints',Points_num);
calllib('SoniqClient','GetPlaneSearchYPoints')
calllib('SoniqClient','SetPlaneSearchYWidth',Width);
calllib('SoniqClient','GetPlaneSearchYWidth')
calllib('SoniqClient','SetPlaneSearchdBLevel',dB_level);
calllib('SoniqClient','GetPlaneSearchdBLevel')
calllib('SoniqClient','SetPlaneSearchSetToZero',false);
calllib('SoniqClient','GetPlaneSearchSetToZero')
calllib('SoniqClient','SetPlaneSearchAlignToPeak',BoolSet);
calllib('SoniqClient','GetPlaneSearchAlignToPeak')
calllib('SoniqClient','GetPlaneSearchValid')
calllib('SoniqClient','GetPlaneSearchXPeakLocation')
calllib('SoniqClient','GetPlaneSearchXCenter')
calllib('SoniqClient','GetPlaneSearchYPeakLocation')
calllib('SoniqClient','GetPlaneSearchYCenter')
calllib('SoniqClient','StartPlaneSearch')