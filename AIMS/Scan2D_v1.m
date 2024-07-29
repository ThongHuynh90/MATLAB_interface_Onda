function [Waveforms,fs] = Scan2D_v1( X,Y,varargin)
%This function scan the plane at specific z
%[Waveforms,fs] = Scan2D( X,Y,calibration_enable)
%calibration can be included by add parameter
global ps5000aSetting;

ps5000aSetting.num_average=32;
fs=ps5000aSetting.fs;
ps5000aSetting.DC_remove=1;
ps5000aSetting.corr=1;
m_ps5000a_setting_update();
cond= aims_get_conditions();

margin=2e-6;%1us
cal_delay=round(fs*(cond.delay-margin));
ps5000aSetting.trigger.delaysample=cal_delay; % Note that only apply for Z axis
m_ps5000a_setting_update();

Xpos = linspace(X.low_pos,X.high_pos,X.points_num);
Ypos = linspace(Y.low_pos,Y.high_pos,Y.points_num);

% calllib('SoniqClient','GetTemperature');
Waveforms = zeros([X.points_num,Y.points_num,ps5000aSetting.bufferLength]);
Isplot=0;
if(Isplot)
    figure;
    colorbar();
    axis equal
    xlim([X.low_pos X.high_pos]);
    ylim([Y.low_pos Y.high_pos]);
    hold on
end
yIdx = 0;
for y = Ypos
    yIdx = yIdx + 1;
    calllib('SoniqClient','PositionerMoveAbs',Y.axis,y);
    
    dir = (mod(yIdx,2)*2-1);
    xIdx = (X.points_num + 1)*mod((yIdx-1),2);
    for x = Xpos
        xIdx = xIdx + dir;
        calllib('SoniqClient','PositionerMoveAbs',X.axis,x);
        pause(0.2);
        
        wf= m_ps5000a_save_wf_autoscale();
        Waveforms(xIdx,yIdx,:) =wf(:,1);
        if(Isplot)
            plot(wf(1:end,1));hold on
            scatter(x, y,[], max(wf(:,1)),'filled');
            scatter(x,y,[], max(wf(:,1)),'filled','Marker','s')
        end
    end
    Xpos = flip(Xpos);
end

aims_move_xy(0,0);
if(nargin>=3)
    Waveforms = p_calib(Waveforms,fs);
end

end
function calib_waveforms = p_calib(Waveforms,fs)
%This function is internally used for calibration
[x,y,len] = size(Waveforms);
%data = zeros([x,y],'gpuArray'); %only active on MATLAB 64bits
B = reshape(Waveforms,x*y,len);
calib_waveforms = [];
parfor i = 1:x*y
    calib_waveforms(i,:) = m_calibration(squeeze(B(i,:))',fs);
end
len = length(calib_waveforms(1,:));
calib_waveforms = reshape(calib_waveforms,x,y,len);
m_ps5000a_close
end