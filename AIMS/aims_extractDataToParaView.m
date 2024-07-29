clear
% X.axis = 0;
% X.low_pos = -16 %mm
% X.high_pos = 16; %mm
% X.points_num = 33;
% 
% Y.axis = 1;
% Y.low_pos = -16 %mm
% Y.high_pos = 16; %mm
% Y.points_num = 33;
% 
% 
% Z.axis = 2;
% Z.low_pos = 10; %mm
% Z.high_pos = 50; %mm
% Z.points_num = 41;
% 
datapath='D:\GIT\Ultrasound\MATLAB\Library\AIMS\13composite\';
load(sprintf('%sScan_info.mat',datapath));

Xpos=linspace(X.low_pos,X.high_pos,X.points_num);
Ypos=linspace(Y.low_pos,Y.high_pos,Y.points_num);
Zpos=linspace(Z.low_pos,Z.high_pos,Z.points_num);

frameStep=5;
data4D=aims_4DMatrixMerge(sprintf('%sXY_scan',datapath),(1:1:33),(1:1:33),0,[200 1000],X,Y,Z,cond);
[Nx,Ny,Nz,Nt]=size(data4D);
[X,Y,Z]=meshgrid(Xpos,Ypos,Zpos);
for frame=1:frameStep:Nt
fn=sprintf('Data4D%d.vtk',frame);
vtkWrite(fn, 'structured_grid', X, Y, Z, 'scalars', 'pressure', squeeze(data4D(:,:,:,frame)),'binary');
end
% vtkwrite('transducer.vtk', 'structured_grid', kgrid.x, kgrid.y, kgrid.z, 'scalars', 'trans', transducer.all_elements_mask,'binary');