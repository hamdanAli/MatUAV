%% test script for MatMav v2.3+
% by Mohamed Abdlekader

clear;
clc;

%% create object
number_of_targets=1;
target=1;
mav=MatMav(number_of_targets);
mav.set_UDPREMOTEADDR(1,{'192.168.100.200',2000})
mav.set_UDPLOCALPRT(14550);
mav.ConnectUDP();


%% HAMDAN:get current location from mocap
target=1;
set=1; unset=0;
mav.set_MocapFlags(target,set)
x=3;
y=2;
z=0;
n1=[x y z]
% % quaternion
qw=1;
qx=0;
qy=0;
qz=0;
mav.set_MocapData(target,qw,qx,qy,qz,x,y,z);
start=1; stop=0;
mav.sendMocap(start) % use stop to stop streaming

%mav.sendMocap(0)
%% HAMDAN: here i get the NED after streaming it to target pixhawk,(result: did not get the streamed NED positon, instead the same as before 
h=animatedline('marker','o','Color','r','LineWidth',3);
axis([-5,5,-5,5])
for k = 1:500
    NED=mav.get_LocalNED(target); 
    x = NED.x;
    y = NED.y;
    
    addpoints(h,x,y);
    drawnow
    pause(10/1000);
    if k==500 
        k
    end
end


%% disconnect and clean MatMav object
mav.Disconnect();
mav.delete();
