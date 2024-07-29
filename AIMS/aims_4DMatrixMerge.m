function [ mergeData] = aims_4DMatrixMerge(fullFileName,xLim,yLim,zLim,tLim,X,Y,Z,cond)
%aims_move_xy(0,0) Summary of this function goes here
%   x,y,z in milimeters
fileList=dir([fullFileName '_*.mat']);
mergeData=[];
dz=(Z.high_pos-Z.low_pos)*1e-3/Z.points_num;
maxDelaySample=round((Z.high_pos-Z.low_pos)*1e-3/cond.c*cond.fs);
for z_idx=1:length(fileList)
    load(sprintf('%s\\%s',fileList(z_idx).folder,fileList(z_idx).name));
    Waveforms(:,:,tLim(end)+maxDelaySample)=0;
    timeShiftSamples=round(z_idx*dz/cond.c*cond.fs);
    Waveforms=circshift(Waveforms,timeShiftSamples,3);
    mergeData(:,:,z_idx,:)=Waveforms(xLim,yLim,tLim(1):tLim(end)+maxDelaySample);
end
end
