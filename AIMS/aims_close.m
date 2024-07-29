function [ output_args ] = aims_close( input_args )
%AMIS_CLOSE Summary of this function goes here
%   Detailed explanation goes here
%  calllib ('SoniqClient','ShowScopeWaveformWindow',0);
if( calllib('SoniqClient','CloseSoniqConnection')==0)
    fprintf('Soniq is closed successfully\n')
end
end
