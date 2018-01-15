%% test script for MatMav v2.3+
%%
% THIS TEST IS WITH Simulators and it worked
% with gazebo and jmavsim
%just enter the IP address for the target mechain
% in which the simulator is runningg
clear;
clc;

%% test script for MatMav v2.3+
% by Mohamed Abdlekader

clear;
clc;
target=1;
mav=MatMav(target);
mav.set_UDPREMOTEADDR(1,{'192.168.100.9',14556})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();
% pause(1);
% mav.get_LocalNED(1)
%% ARM command
target=1;
start=1; % arm
stop=0;% disarm
mav.Arm(target,start)
%% DisARM command
target=1;
start=1; % arm
stop=0;% disarm
mav.Arm(target,stop)
%% get IMU date
target=1;
mav.get_IMUData(target)

%% get Attitude, in radians
target=1;
mav.get_Attitude(target)

%% get local NED position, in meters
target=1;
mav.get_LocalNED(target)

%% get GPS data, if available
target=1;
mav.get_GPS(target)

%% get vehicle mode
target=1;
mav.get_vehicle_mode(target)

%% stream motion capture data
target=1;
set=1; unset=0;
% set which vehicle/target you would like to send to
mav.set_MocapFlags(target,set)
% positions in NED loca frame, meters
x=1; y=1;z=1; 
% quaternion
qw=1; qx=0; qy=0; qz=0;
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z);
start=1; stop=0;
mav.sendMocap(stop); % use stop to stop streaming

%% takeoff
sysID=1;
mav.set_takeoffALT(sysID,-2);
mav.takeoff(sysID);
mav.toggle_OFFB(sysID,1);

%% send position setpoints
target=1;
% position setpoint, xyz in meters, Yaw in rad
for i= [1 -1]
    for j= [-1 1]
x=i;y=j;z=-2; Yaw_d=270;
Yaw=degtorad(Yaw_d);
mav.set_PositionSetPoints(1,x,y,z,Yaw);
mav.set_setpointsFlags(1,1);
mav.sendSetPoints(1);
mav.toggle_OFFB(1,1);
pause(1.5)
    end
end

%% land
sysID=1;
mav.Land(sysID);

%% set to MANUAL mode/ toggle offboard OFF/ stop setpoint streaming/Disarm
sysID=1;
mav.setManual(sysID)
mav.toggle_OFFB(sysID,0);
mav.sendSetPoints(0);
mav.Arm(sysID,0);

%% disconnect and clean MatMav object
mav.Disconnect();
mav.delete();

