global hf1 a1 a2 x y z qx qy qz qw

%  c = natnet;
%  c.ClientIP = '127.0.0.1';
%  c.HostIP = '127.0.0.1';
%  c.ConnectionType = 'Multicast';
%  c.connect

c.addlistener( 1 , 'getRigidBodiesfromMocap' )

c.enable(0)
