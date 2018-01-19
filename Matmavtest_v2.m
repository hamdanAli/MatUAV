%% test script for MatMav v2.3+
% by Mohamed Abdlekader

clear;
clc;

%% create object
number_of_targets=1;
target=1;
mav=MatMav(number_of_targets);
% find available ports
mav.findPorts();

%% Establisg serial connection
% set port name and baudrate
%mav.set_COMPORT('/dev/tty.usbserial-DN006YKX'); % on Mac
mav.set_COMPORT('COM3'); % on Windows
mav.set_BAUDRATE(57600);
% connect
mav.ConnectSerial();

%% Establish UDP connection
% set local port to listen on
% vehicles will be detected automatically once connected to selected port
mav.set_UDPREMOTEADDR(1,{'192.168.100.10',2000})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();


%% get IMU date, HAMDAN: here IMU data is recived correctly
IMU=mav.get_IMUData(target)

%% get Attitude, in radians,   HAMDAN: also attitude is recived correctly
Attitude=mav.get_Attitude(target)

%% HAMDAN: here i get the NED before streaming to compare it after streaming to see if changed
%(result: got the result displayed in command window
NED_1=mav.get_LocalNED(target) 

%% HAMDAN: here i try to stream the current position (set x,y,z to 1 for expermeting)
target=1;
set=1; unset=0;
mav.set_MocapFlags(target,set)
frame=c.getFrame('rigidbody',1);
x=frame.RigidBody.x;
y=frame.RigidBody.y;
z=frame.RigidBody.z;
pos=[x y z]
% % quaternion
qw=frame.RigidBody.qw;
qx=frame.RigidBody.qx;
qy=frame.RigidBody.qy;
qz=frame.RigidBody.qz;
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z);
start=1; stop=0;
mav.sendMocap(start) % use stop to stop streaming


%% HAMDAN: here i get the NED after streaming it to target pixhawk,(result: did not get the streamed NED positon, instead the same as before 
NED_2=mav.get_LocalNED(target); 
n2=[NED_2.x NED_2.y NED_2.z]

%% disconnect and clean MatMav object
mav.Disconnect();
mav.delete();
