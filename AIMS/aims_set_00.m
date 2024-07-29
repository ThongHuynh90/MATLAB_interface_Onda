function [ output_args ] = aims_set_00( input_args )
%aims_move_xy(0,0) Summary of this function goes here
%   Detailed explanation goes here
calllib('SoniqClient','SetPosition',0,0);%
calllib('SoniqClient','SetPosition',1,0);%
calllib ('SoniqClient','SetPositionerLowLimit',0 , -40);%recalculate Z
calllib ('SoniqClient','SetPositionerLowLimit',1 , -40);%recalculate Z
calllib ('SoniqClient','SetPositionerHighLimit',0 , 40);%recalculate Z
calllib ('SoniqClient','SetPositionerHighLimit',1 , 40);%recalculate Z
end
