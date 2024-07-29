function [wf, fs]= aims_get_electronic_waveform(delay_ms)
%This function save the waveform at current position
% [wf, fs]= aims_get_single_waveform(calibration_enable)
%calibration can be included by add parameter 

dl=calllib ('SoniqClient','GetScopeDelay');
% p_source=calllib ('SoniqClient','GetScopeWFSource');
% e_source=mod(p_source,2)+1;
e_source=2;
p_source=1;
calllib ('SoniqClient','SetScopeWFSource',e_source);
calllib ('SoniqClient','SetScopeDelay',delay_ms);
[wf, fs]=aims_get_single_waveform();
calllib ('SoniqClient','SetScopeWFSource',p_source);
calllib ('SoniqClient','SetScopeDelay',dl );
end