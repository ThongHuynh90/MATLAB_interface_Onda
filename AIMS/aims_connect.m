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
%[retval]=calllib ('SoniqClient','GetHydrophoneSerial',buf )
fprintf('Soniq %s\n',retval);
[retval]=calllib ('SoniqClient','GetUser',buf);
fprintf('User: %s\n',retval);
calllib ('SoniqClient','ShowScopeWaveformWindow',1);