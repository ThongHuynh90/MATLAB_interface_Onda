function [Waveforms,fs,delay] = Scan1D_v1( axis,isplot)
global ps5000aSetting;
ps5000aSetting.num_average=32;
fs=ps5000aSetting.fs;
ps5000aSetting.DC_remove=1;
ps5000aSetting.corr=1;
m_ps5000a_setting_update();
pos=linspace(axis.low_pos,axis.high_pos,axis.points_num);
% calllib('SoniqClient','GetTemperature');
% calllib('SoniqClient','ClearWaveform');
% calllib('SoniqClient','DigitizeWaveform');
% pBufferLength = calllib('SoniqClient','GetWaveformPoints')
Waveforms=zeros(axis.points_num,ps5000aSetting.bufferLength);
if(isplot)
    figure
    % hold on
end
i=0;
delay=zeros(size(pos));
for pos_i=pos
    i=i+1;
    
    calllib('SoniqClient','PositionerMoveAbs',axis.axis,pos_i);%Move 1 mm
    pause(0.3);
    if(axis.axis==2)
        cond= aims_get_conditions();
        margin=2e-6;%1us
        cal_delay=round(fs*(cond.delay-margin));
        delay(i) =cal_delay;
        ps5000aSetting.trigger.delaysample=cal_delay; % Note that only apply for Z axis
        m_ps5000a_setting_update();
    end
    pause(0.2);
    wf= m_ps5000a_save_wf_autoscale();
    Waveforms(i,:) =wf(:,1);
    if(isplot)
        plot(wf(end/10:end/2,1));
        drawnow
    end
end
aims_move_xy(0,0);

end