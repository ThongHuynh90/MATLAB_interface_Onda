%* This script is used for 2D scan testing

X.axis = 0;
X.low_pos = -1 %mm
X.high_pos = 1; %mm
X.points_num = 3;

Z.axis = 2;
Z.low_pos = 20; %mm
Z.high_pos = 21; %mm
Z.points_num = 2;

param_cal_func = 'p_rms_calc_2D';

%% Init the AIMS
 aims_connect();

cond=aims_get_conditions();

%% Run the scan
aims_move_xy(0,0);
[Waveforms,cond.fs] = Scan2D( X,Z);

%% Calculate output data. It can be the second harmonic level or RMS Voltage, defined by param_cal_func.
% The output data is in 2D corresponding to the scanning plan
%methods gpuArray
save('XZ_scan.mat','cond','Waveforms','X','Z');
return
[x,y,length]=size(Waveforms);
%data=zeros([x,y],'gpuArray'); %only active on MATLAB 64bits
data=zeros([x,y]);
B=reshape(Waveforms,x*y,length);
parfor i=1:x*y
    data(i)= max(squeeze(B(i,:)));
end
data=reshape(data,x,y);
%% plot the data here
Xpos=linspace(X.low_pos,X.high_pos,X.points_num);
Ypos=linspace(Z.low_pos,Z.high_pos,Z.points_num);
figure;

fig=image( Xpos,Ypos,data');
% colormap(gray(256));
title('Planar scan for max pressure')
xlabel('X'), ylabel('Y'), colorbar
axis equal tight

%% Data confirmation
x = find(Xpos==10);
y = find(Ypos==-5);

figure
hold on
wf=reshape(Waveforms(x,y,:),1,length);
plot(wf)
aims_move_xy(Xpos(x),Ypos(y));
calllib('SoniqClient','ClearWaveform')
calllib('SoniqClient','DigitizeWaveform');
pBufferLength = calllib('SoniqClient','GetWaveformPoints');
Buff=zeros([1 pBufferLength]);
pBuffer = libpointer('doublePtr',Buff);
calllib('SoniqClient','GetWaveformData',pBuffer,pBufferLength);
plot(pBuffer.value);

aims_move_xy(0,0);
aims_close();
