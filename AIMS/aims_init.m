function [ output_args ] = aims_init( input_args )
%AMIS_INIT Summary of this function goes here
%   Detailed explanation goes here

%---------------------------------- Start ----------------------------------%

%check if Matlab is 32-bit; If not, exit demo.
    matlab_bit = computer('arch');
if strcmp('win32',matlab_bit)~=1
    m01 = msgbox({'Soniq demo has detected this instance of Matlab is not 32-bit!';'';'Please run the Soniq demo in a 32-bit instance of Matlab.'},'Non 32-bit Matlab');
    fprintf('Non 32-bit Matlab. Exiting Soniq demo!\n\n')
    waitfor(m01);
    return
end

%display demo file name
fprintf('----- %s -----\n', mfilename)

%default installation paths
SoniqDLL_fullfilepath      = 'SoniqClient.dll'; %default installation path for Soniq on 64-bit Windows OS
SoniqProtoM_fullfilepath   = 'Soniq_proto.m';  %default installation path for Soniq on 64-bit Windows OS
%load Soniq dll
libloaded_sts=libisloaded ('SoniqClient'); %check if library has already been loaded; If not, try to load 
if libloaded_sts==0
    if exist(SoniqDLL_fullfilepath,'file')~=0 && exist(SoniqProtoM_fullfilepath,'file')~=0  %check if DLL file exists here. If yes, load it.
        loadlibrary(SoniqDLL_fullfilepath,@Soniq_proto);
        fprintf('Library, "%s" loaded!\n',SoniqDLL_fullfilepath)
    else
        if exist(SoniqDLL_fullfilepath,'file')==2 && exist(SoniqProtoM_fullfilepath,'file')==2 %check if DLL file exists here. If yes, load it.
            loadlibrary(SoniqDLL_fullfilepath,@Soniq_proto);
            fprintf('Library, "%s" loaded!\n',SoniqDLL_fullfilepath)
        else
            m02 = msgbox({'Could not find "SoniqClient.dll" and/or "Soniq_proto.m" in the default location(s).';'';'Exiting Soniq demo!';'';'Please contact Onda Corp. (Phone: +1.408.745.0383 | Web: www.ondacorp.com)'},'File(s) not found');
            fprintf('Could not find "SoniqClient.dll" and/or "Soniq_proto.m" in the default location(s).\nExiting Soniq demo!\nPlease contact Onda Corp. (Phone: +1.408.745.0383 | Web: www.ondacorp.com)\n')
            waitfor(m02);
            return
        end
    end
end

%check if Soniq is running
if calllib('SoniqClient','SoniqRunning')==0
   m02 = msgbox('Soniq is not running. Please start Soniq and try again!','Soniq not running');
   fprintf('Soniq is not running. Please start the Soniq program and try again!\n')
   waitfor(m02)
   
end
%open Soniq comm
calllib ('SoniqClient','OpenSoniqConnection','localhost');

buf = libpointer('cstring', blanks(200));
[retval]=calllib('SoniqClient','GetSoniqClientVersion',buf);
fprintf('Soniq %s\n',retval);
[retval]=calllib ('SoniqClient','GetUser',buf);
fprintf('User: %s\n',retval);
aims_set_00();
  Oscill_Init();
  FindPulse();
   GetCenter();
BeamAlignment();

calllib ('SoniqClient','FindPulseAutoMinMax'); 
calllib ('SoniqClient','SetScopeSensitivity',1,0.004);
calllib ('SoniqClient','FindPulse');
calllib ('SoniqClient','AutoScale');
calllib ('SoniqClient','SetPositionerLowLimit',2 , 3);%recalculate Z
calllib ('SoniqClient','SetPositionerLowLimit',1 , -200);%
calllib ('SoniqClient','SetPositionerHighLimit',1 , 200);%
aims_close();
end

function [fs, PulseDuration_us] = Oscill_Init()
calllib ('SoniqClient','SetScopeTimebase',1);
maxPoint=calllib ('SoniqClient','GetScopeMaxPoints');
calllib ('SoniqClient','SetScopePoints',maxPoint);

PulseDuration_us=10*calllib ('SoniqClient','GetScopeTimebase');
fs=calllib ('SoniqClient','GetScopePoints')/PulseDuration_us*1e6; 
calllib ('SoniqClient','SetScopeWFSource',1);
calllib ('SoniqClient','SetScopeCoupling',1 , 'AC 1M' ); 
calllib ('SoniqClient','SetScopeCoupling',2 , 'AC 1M' ); 

calllib ('SoniqClient','SetScopeTriggerSource','External'); 
calllib ('SoniqClient','SetScopeTriggerMode','Normal'); 
calllib ('SoniqClient','SetScopeTriggerCoupling','DC 1M'); 
calllib ('SoniqClient','SetScopeTriggerSlope',0 ); %0 IS FALLING EGDE, 1 IS RISING EGDE
calllib ('SoniqClient','SetScopeTriggerLevel',2 ); 
calllib ('SoniqClient','ShowScopeWaveformWindow',1);
% calllib ('SoniqClient','MessageBox','Check the Resolution bits' , 0 ); 
end
function FindPulse() 
prompt = {'Set the approximate Z (mm) :'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'60','hsv'};
Z = inputdlg(prompt,dlg_title,num_lines,defaultans);
Z=str2double(Z);
calllib ('SoniqClient','SetPosition',2 , Z);
calllib ('SoniqClient','SetDistanceTrackingEnabled',true ); 
calllib ('SoniqClient','SetDistanceTrackingOffset',2.6851 );%in micro second 
calllib ('SoniqClient','SetUseDiagonal',false ); 
calllib ('SoniqClient','FindPulseAutoMinMax'); 
calllib ('SoniqClient','SetScopeSensitivity',1,0.02);
calllib ('SoniqClient','FindPulse');
calllib ('SoniqClient','AutoScale');
calllib ('SoniqClient','SetPositionerLowLimit',2 , 3);
end
function GetCenter()
Points_num=41;
Width=10*2;
dB_level=-6;
BoolSet = true;
% calllib('SoniqClient','ShowPlaneSearchDialog');
calllib('SoniqClient','SetPlaneSearchXPoints',Points_num);
calllib('SoniqClient','SetPlaneSearchXWidth',Width);
calllib('SoniqClient','SetPlaneSearchYPoints',Points_num);
calllib('SoniqClient','SetPlaneSearchYWidth',Width);
calllib('SoniqClient','SetPlaneSearchdBLevel',dB_level);
calllib('SoniqClient','SetPlaneSearchSetToZero',true);
calllib('SoniqClient','SetPlaneSearchAlignToPeak',BoolSet);
calllib('SoniqClient','StartPlaneSearch')
end
function BeamAlignment()
calllib ('SoniqClient','SetBeamAlignmentUseAngularPositioner',false); 


calllib ('SoniqClient','SetBeamAlignmentZ1',50); 
calllib ('SoniqClient','SetBeamAlignmentXRange1',10); 
calllib ('SoniqClient','SetBeamAlignmentYRange1',10); 
calllib ('SoniqClient','SetBeamAlignmentXPoints1',21); 
calllib ('SoniqClient','SetBeamAlignmentYPoints1',21); 

calllib ('SoniqClient','SetBeamAlignmentZ2',100); 
calllib ('SoniqClient','SetBeamAlignmentXRange2',10); 
calllib ('SoniqClient','SetBeamAlignmentYRange2',10); 
calllib ('SoniqClient','SetBeamAlignmentXPoints2',21); 
calllib ('SoniqClient','SetBeamAlignmentYPoints2',21); 

% calllib ('SoniqClient','SetBeamAlignmentXLimit',double value ); 
% calllib ('SoniqClient','SetBeamAlignmentYLimit',double value ); 
% calllib ('SoniqClient','SetBeamAlignmentMaxTries',long int value ); 
% calllib ('SoniqClient','SetBeamAlignmentNZPositions',long int value ); 

calllib ('SoniqClient','SetBeamAlignmentAlignToPeak',true); 
calllib ('SoniqClient','StartBeamAlignment')

calllib ('SoniqClient','SetUseMachineCoordinates',false ); %use beam coordinator
end