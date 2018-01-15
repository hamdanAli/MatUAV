%%%%%%%%%%%%%%%%test2&&&&&&&&&&&
%porpus of test-- to see if mocap is sent to target 
% connect udp to target1
% connet natnet from NATNET
% get NED1 =target local NED 
% get NED form mocap and stream it to target
% get NED2= target local ned after stream
% check to see if mocap is streamed to target

%% clear
clear
clc

%% create object & connect udp & connect to Natnet
number_of_targets=1;
target=1;
set=1;
start=1;stop=0;
mav=MatMav(number_of_targets);

mav.set_UDPREMOTEADDR(1,{'192.168.11.144',2000})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP() 
global x y z qx qy qz qw
c=natnet
c.connect()
c.addlistener( 1 , 'getRigidBodiesfromMocap' )
%% get curretn local NED
NED_1=mav.get_LocalNED(1)
                                                
%% MAIN LOOP
for i=1:1000000
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z)
NED1=mav.get_LocalNED;
pos_z(i)=NED1.z;
end
plot (pos_z)
%% stream mocap 
mav.set_MocapFlags(1,1)
c.enable(1)
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z)

start=1; stop=0;
mav.sendMocap(start) % use stop to stop streaming
%% send current natnet NED position to target
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z)
%get current local NED
local_NED=mav.get_LocalNED
%% stop streaming
mav.sendMocap(0)
%% takeoff
sysID=1;
mav.set_takeoffALT(sysID,-2);
mav.takeoff(sysID);
mav.toggle_OFFB(sysID,1);

%% send position setpoints
target=1;
% position setpoint, xyz in meters, Yaw in rad
x=0;y=0;z=-1; Yaw=0;
mav.set_PositionSetPoints(target,x,y,z,Yaw);

mav.set_setpointsFlags(target,1);
start=1; stop=0;
mav.sendSetPoints(start);
mav.toggle_OFFB(target,start);

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

%GET NATNET POS
