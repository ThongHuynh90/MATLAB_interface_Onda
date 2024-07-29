function [ x,y,z ] = aims_get_xyz()
%aims_move_xy(0,0) Summary of this function goes here
%   x,y,z in milimeters
x=calllib('SoniqClient','GetPosition',0);%
y=calllib('SoniqClient','GetPosition',1);%
z=calllib('SoniqClient','GetPosition',2);%
end

