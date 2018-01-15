%% test script for MatMav v2.3+
% by Mohamed Abdlekader

clear;
clc;

%% create object
number_of_targets=1;
mav=MatMav(number_of_targets);

%% Establisg serial connection
% set port name and baudrate
%mav.set_COMPORT('/dev/tty.usbserial-DN006YKX'); % on Mac
mav.set_COMPORT('COM5'); % on Windows
mav.set_BAUDRATE(57600);
% connect
mav.ConnectSerial();

%% Establish UDP connection
% set local port to listen on
% vehicles will be detected automatically once connected to selected port
mav.set_UDPREMOTEADDR(1,{'192.168.100.200',2000})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();

%% HAMDAN: here i get the NED after streaming it to target pixhawk,(result: did not get the streamed NED positon, instead the same as before 
NED_2=mav.get_LocalNED(1); 
n2=[NED_2.x NED_2.y NED_2.z]

%%

for i = 1:100000
% NED_x(i)= mav.get_LocalNED(1).x; 
% 
% NED_y(i)= mav.get_LocalNED(1).y; 
% 
% NED_z(i)= mav.get_LocalNED(1).z;
roll(i)=mav.get_Attitude(1).roll;
pause(1/100000)
end
plot(roll)

%% disconnect and clean MatMav object
mav.Disconnect();
mav.delete();
