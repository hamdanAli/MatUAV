%% test script for MatMav v2.3+
% by Mohamed Abdlekader

clear;
clc;

%% create object
number_of_targets=1;
mav=MatMav(number_of_targets);



% Establish UDP connection
% set local port to listen on
% vehicles will be detected automatically once connected to selected port
mav.set_UDPREMOTEADDR(1,{'192.168.100.200',2000})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();

%% stream motion capture data
target=1;
set=1; unset=0;
mav.set_MocapFlags(target,set)
x=1;
y=1;
z=1;
qw=0;
qx=0;
qy=0;
qz=0;
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z)
start=1; stop=0;
mav.sendMocap(start) % use stop to stop streaming
mav.get_LocalNED(target)


%% disconnect and clean MatMav object
mav.Disconnect();
mav.delete();

