function [ output_args ] = aims_move_xyz( x,y,z )
%aims_move_xy(0,0) Summary of this function goes here
%   x,y,z in milimeters
calllib('SoniqClient','PositionerMoveAbs',0,x);%
calllib('SoniqClient','PositionerMoveAbs',1,y);%
if z<3, z=3;end
calllib('SoniqClient','PositionerMoveAbs',2,z);%
end

