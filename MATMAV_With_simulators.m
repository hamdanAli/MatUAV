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
mav.set_UDPREMOTEADDR(1,{'192.168.100.10',14556})

mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();
% pause(1);
% mav.get_LocalNED(1)
%% ARM command
target=1;
start=1; % arm
stop=0;% disarm
contdown_time=5;
mav.Arm(target,start)

countdown(0,contdown_time,'Takeoff',0)
pause(contdown_time)
%takeoff
sysID=1;
mav.set_takeoffALT(sysID,-3);
mav.takeoff(sysID);
mav.toggle_OFFB(sysID,1);

%% send position setpoints
target=1;
% position setpoint, xyz in meters, Yaw in rad
x_max=3;
y_max=3;
x = [0 x_max];
y = [0 y_max];
Yaw = 0;
z = -3;
dTime= 5;
number_of_repetition = 1;

        mav.set_setpointsFlags(target,1);
        start=1; stop=0;
        mav.sendSetPoints(start);
        mav.toggle_OFFB(target,start);

for rep=1:number_of_repetition;
for i=1:2;
    for j= 1:2;
        mav.set_PositionSetPoints(target,x(i),y(j),z,Yaw);

        
        hold on
        axis([-1 5 -1 5])
        
        pause(dTime);
        plot (x(i),y(i),'b.')
        NEDx(i)=mav.get_LocalNED(target).x;
        NEDy(i)=mav.get_LocalNED(target).y;
        plot (NEDx(i),NEDy(i),'ro')
        x_error(i)=abs(((x(i)-NEDx(i))/x(i))*100);
        y_error(i)=abs(((y(i)-NEDy(i))/y(i))*100);

end
end
end
mav.set_PositionSetPoints(target,x(1),y(1),z,Yaw);
% figure % new figure
% ax1 = subplot(2,1,1); % top subplot
% ax2 = subplot(2,1,2); % bottom subplot
% plot(ax1,x_error)
% title(ax1,'X error')
% 
% 
% plot(ax2,y_error)
% title(ax2,'Y error')
% axis([ax1 ax2],[0 i 0 100]) 

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
x=5; y=5;z=-5; 
% quaternion
qw=1; qx=0; qy=0; qz=0;
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z);
start=1; stop=0;
mav.sendMocap(start); % use stop to stop streaming

%% takeoff
sysID=1;
mav.set_takeoffALT(sysID,-2);
mav.takeoff(sysID);
mav.toggle_OFFB(sysID,1);

%% send position setpoints
target=1;
% position setpoint, xyz in meters, Yaw in rad
for h= 1:2
for i= [1 -1]
    for j= [-1 1]
x=i;y=j;z=-2; Yaw_d=270;
Yaw=degtorad(Yaw_d);
mav.set_PositionSetPoints(1,x,y,z,Yaw);
mav.set_setpointsFlags(1,1);
mav.sendSetPoints(1);
mav.toggle_OFFB(1,1);
pause(6.5)
% NED=mav.get_LocalNED(1);
%      x = NED.x;
%      y = NED.y;
%      %x = NED.x;   
% plot(x,y,'o');
% axis([-2 2 -2 2]);
% hold on
% n=n+1;
    end
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

