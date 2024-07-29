function aims_show_wf( )
[wf,fs]=aims_get_single_waveform();
m_spectrum_plot(wf,fs,'log','Normalize');
end

