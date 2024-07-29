Xpos=(-10:0.5:10);
Ypos=(-15:0.5:15);
Zpos=(-20:0.5:20);
[X,Y,Z]=meshgrid(Xpos,Ypos,Zpos);

vtkWrite('file_name.vtk', 'structured_grid', X, Y, Z, 'scalars', 'pressure', X.^2+Y+Z.^3,'binary');