function GPIBtask4()

%Checking if GPIB is set up on the machine:

[status,cmdout]=system('/sbin/lsmod |grep tnt4882');
k=findstr(cmdout,'tnt4882');
if (isempty(k)|size(k,2)<3)
    fprintf(1,'Cannot verify that GPIB driver ("tnt42882") is installed:\nexecuting command "lsmod" should yield these lines (among many others): \n tnt4882                28164  0\n nec7210                23296  1 tnt4882\n gpib_common            41540  2 tnt4882,nec7210\n')
    return;
end; %ifput

[status,cmdout]=system('ls /dev/gpib0');
k=findstr(cmdout,'/dev/gpib0');
if isempty(k)
    fprintf(1,'Cannot verify that GPIB device is mounted ("/dev/gpib0") is installed:\nexecuting command "ll /dev/gpib0" should yield a line similar to:\ncrwxrwxrwx    1 root     root     160,   0 2006-07-31 09:10 /dev/gpib0\n')
    return;
end; %if

% adding the paths with GPIB-functions to matlab

  addpath(genpath('/hom/mes/src/matlab/gpib/linux'));
  
% list ing the instruments fro which functions exist
fprintf(1,'Theses are GPIB instruments for which we do \nhave functions (ignore the prefix "M"):\n');
here=pwd;
cd '/hom/mes/src/matlab/gpib/linux';
ls -d 'M*'
fprintf(1,'Try typing the start of these (without the M!) \nand hit the "tab" key to get a list of autocomplete options.\nThen try "help" followed by one of the function names \nto see the parameters that the function takes \nas inputs and those that it returns.\n');
cd(here);
  
% telling the waveform generator to put out a saw tooth at 1kHz and 5V
% amplitude

HP33120_SetSignal('RMP',1.862);
HP33120_SetFreq(1000);
HP33120_SetDCoff(1.7);
% HP33120_SetVolt(2,5);


HPE3631_SetVolt(1,5);
%short waveform generator output to scope channel 1

% reading waveform from scope and plotting it
%HP54622_AutoScale(1) % scaling Y-axis and offset (not necessary if already adjusted manually). 
%HP54622_SetVerticalRange(1,2.0,0.2) % Useful for some scopes where the knobs do not work properly!!!
HP54622_SetTimeScale(1e-3);
[time,data]=HP54622_GetData2;
%ploting the first row of data (channel 1) vs time
figure(1);
plot(time,data(1,:));
hold on;
plot(time,data(2,:));
hold off;

% now you should see a saw tooth waveform plottet in a matlab figure
% to make the axes readable and lable x- and y-axis:

set(gca,'fontsize',14)
xlabel('t [s]','fontsize',14);
ylabel('v [V]','fontsize',14);
title('Ramp at 1kHz and 5Vpp', 'fontsize',14);
grid on


% make a png file with the plot for reporting

print -dpng sawtoothplottask4_test.png

%Setting some DC voltages in a loop. Short voltage source 6V output to
%multimeter voltage input.

HPE3631_Operate;
%vo=0:5:5; %this is a command creating a vector [0 0.1 0.2 0.3 0.4 ... 1.0]
%for i=1:size(vo,2)
    %HPE3631_SetVolt(1,vo(i));
    %pause(1); % let the voltage settle for 1s before measuring!
    %vi(i)=HP34401_ReadQuick;
%end %for

%HPE3631_SetVolt(1,5);
HPE3631_SetVolt(2,5);
%figure(2);
%plot(vo,vi);

%set(gca,'fontsize',14)
%xlabel('v_{source} [V]','fontsize',14);
%ylabel('v_{meas} [V]','fontsize',14);
%title('Voltage source measured with multimeter', 'fontsize',14);
%grid on

% make a png file with the plot for reporting

%print -dpng sourcemeasureVoltagetask3.png


%end; %function