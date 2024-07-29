function [ output_args ] = SoniqCommDemo2014(input_args)
%SoniqCommDemo2014: Demonstrate Matlab-Soniq communication by performing two 1D scans in left/right and front/back axes, and acquiring a waveform
%Last modified: 20140710_DG
AMIS_init();
libfunctionsview 'SoniqClient'

        %*****DO NOT CHANGE - Default Soniq Axis numbers - DO NOT CHANGE*****
        LR_axis=0; %left/right
        FB_axis=1; %front/back
        UD_axis=2; %up/down
        %*****DO NOT CHANGE - Default Soniq Axis numbers - DO NOT CHANGE*****

        %set 1D scan waveform recording OFF
        calllib('SoniqClient','Set1DScanRecordWaveforms',0);

        %set 1D scan Real-time plotting ON
        calllib('SoniqClient','Set1DScanRealTimePlotting',1);

        %set 1D scan pause
        pause_1D_scan=0; %in msec
        calllib('SoniqClient','Set1DScanPause',pause_1D_scan);

        %set Scope waveform averages
        ScopeWFAvg = 1; 
        calllib ('SoniqClient','SetScopeWFAveraging',ScopeWFAvg)

        %set After-scan option: "Gotopeak" (or "GoBack")
        calllib('SoniqClient','Set1DScanAfterScan','GotoPeak')

        % 1D Scans ---------------------------------------------------------------%
        fprintf('Scan progress:\n')

        %stop_scan flag OFF
        stop_scan=0;

        %1D scan_param=AxisName,AxisNumb,ScanStart(mm),ScanEnd(mm),ScanPoints
        scan_param={'X-axis',  LR_axis,  -5,   5,   3;...   %Assume Left-Right axis is X axis
                    'Y-axis',  FB_axis,  -5,   5,   3};     %Assume Front-Back axis is Y axis

        for n=1:size(scan_param,1);
         if stop_scan==0
                if scan_param{n,2}(1,1)==LR_axis %has to match with default Axis numbers in Soniq
                    axis_disp='(Left/Right)';
                    else if scan_param{n,2}(1,1)==FB_axis %has to match with default Axis numbers in Soniq
                            axis_disp='(Front/Back)';
                            else if scan_param{n,2}(1,1)==UD_axis %has to match with default Axis numbers in Soniq
                                axis_disp='(Up/Down)   ';
                                end
                        end
                end

                fprintf('%s %s scan...\n',scan_param{n,1},axis_disp);


                calllib('SoniqClient','Set1DScanAxis',scan_param{n,2});pause(0.2);

                calllib('SoniqClient','Set1DScanStart',scan_param{n,3});pause(0.2);
                calllib('SoniqClient','Set1DScanEnd'  ,scan_param{n,4});pause(0.2);

                calllib('SoniqClient','Set1DScanPoints',scan_param{n,5});pause(0.2);

                calllib('SoniqClient','Start1DScan');pause(1);


                %save 1D scan files (overwrite if file exists)
                if n==1
                    scanfullfilename1 = [pwd '\DemoXscan.snq'];
                    calllib ('SoniqClient','SaveFileAs', scanfullfilename1);
                    fprintf('X scan saved (%s)\n',scanfullfilename1); 

                else if n==2
                        scanfullfilename1 = [pwd '\DemoYscan.snq'];
                        calllib ('SoniqClient','SaveFileAs', scanfullfilename1);
                        fprintf('Y scan saved (%s)\n',scanfullfilename1); 

                      end
                end

                if stop_scan==0 && n < size(scan_param,1)

                    q1 =questdlg('Do you want to continue with the next scan?','Continue','Yes','No','Yes');

                    switch q1

                        case {'No'}
                            stop_scan=1;
                            fprintf('*** Scan stopped by User! ***\n')
                    end

                end %stop

         end %stop

        end
        pause(1);

        %Get Waveform ------------------------------------------------------------%
        fprintf('Capture and save a waveform?\n')
        q2a=questdlg('Capture and save waveform?','Capture waveform','Yes','No','Yes');

        switch q2a
            case {'Yes'}
                %Acquire a Wavefrom
                calllib('SoniqClient','DigitizeWaveform')

                %Save the Waveform as 'DemoWaveform.snq' file in the current directory
                wfmfullfilename1 = [pwd '\DemoWaveform.snq'];

                %check if Waveform file already exists
                if exist(wfmfullfilename1,'file')==2
                        q2b=questdlg('Wfm file exists in save directory! Overwrite?','Overwrite?','Yes','Save as','Cancel','Save as');
                        switch q2b
                            case {'Yes'}
                                 calllib ('SoniqClient','SaveFileAs', wfmfullfilename1);
                                 fprintf('Waveform saved (%s)\n',wfmfullfilename1); 

                            case {'Save as'}
                               wfmfilename1=input('Enter new file name (without ".SNQ" extension):','s');
                               wfmfullfilename1=[pwd,'\',wfmfilename1,'.snq'];

                               calllib ('SoniqClient','SaveFileAs', wfmfullfilename1);
                               fprintf('Waveform saved (%s)\n',wfmfullfilename1); 

                            case {'Cancel'}
                                fprintf('File save Cancelled by user!\n'); 
                        end
                    else
                        calllib ('SoniqClient','SaveFileAs', wfmfullfilename1);
                        fprintf('Waveform saved (%s)\n',wfmfullfilename1); 
                end

            case {'No'}
                fprintf('Waveform not saved by user.\n')
        end
AMIS_close();
end
