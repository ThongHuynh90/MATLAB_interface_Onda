%* This script is used for 2D scan testing

X.axis = 0;
X.low_pos = -16 %mm
X.high_pos = 16; %mm
X.points_num = 33;

Y.axis = 1;
Y.low_pos = -16 %mm
Y.high_pos = 16; %mm
Y.points_num = 33;


Z.axis = 2;
Z.low_pos = 10; %mm
Z.high_pos = 50; %mm
Z.points_num = 41;


param_cal_func = 'p_rms_calc_2D';
Zpos = linspace(Z.low_pos,Z.high_pos,Z.points_num);
aims_move_xy(0,0);


%% Init the AIMS
 aims_connect();

cond=aims_get_conditions();

%% Run the scan
for z_move=Zpos
    aims_move_xyz(0,0,z_move);
[Waveforms,cond.fs] = Scan2D( X,Y);

%% Calculate output data. It can be the second harmonic level or RMS Voltage, defined by param_cal_func.
% The output data is in 2D corresponding to the scanning plan
%methods gpuArray
save(sprintf('XY_scan_%1.2f.mat',z_move),'Waveforms');
end
save('XZ_scan_info.mat','cond','X','Y','Z');
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
