function [ output_args ] = aims_move_xy( x,y )
%aims_move_xy(0,0) Summary of this function goes here
%   x,y in milimeters
calllib('SoniqClient','PositionerMoveAbs',0,x);%
calllib('SoniqClient','PositionerMoveAbs',1,y);%

end

