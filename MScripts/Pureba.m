clc

% Declaración del robot
l = [13.7  10.5  10.5  11]; %cm

ws=l(1)+l(2)+l(3)+l(4)/2;

Phant(1) = Link('revolute','a',0,'alpha',0,'d',l(1),'offset',0,'modified');
Phant(2) = Link('revolute','a',0,'alpha',pi/2,'d',0,'offset',pi/2,'modified');
Phant(3) = Link('revolute','a',l(2),'alpha',0,'d',0,'offset',0,'modified');
Phant(4) = Link('revolute','a',l(3),'alpha',0,'d',0,'offset',0,'modified');
T=transl(l(4),0,0)*[0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1];
Phantom = SerialLink(Phant,'name','PhantomX','tool',T);
theta = [pi/2 0 0 0 0 0 pi/2].';
interp = [0 1 1 0 1 0].';
grip=[0,0,1,1,1,0,0];
pos(1,:)=[0 0 45.7];
pos(2,:)=[10 -20 10];
pos(3,:)=[10 -20 2.5];
pos(4,:)=[10 -20 10];
pos(5,:)=[20 0 10];
pos(6,:)=[20 0 3.5];
pos(7,:)=pos(1,:);
q0=[0 0 0 0];
MTH=Phantom.fkine(q0);
%Phantom.teach();
%hold on
%trplot(eye(4),'length',10,'frame','0','arrow','rgb');
%view(30,30)

tempX=0;
tempY=0;
tempZ=0;
tempP=0;
q_sel=1;
% Choose default command line output for Lab_3

pf = getpose(pos,theta);
rz = rotz(-pi/2);
pf_z = rz*pf(:,1:3).';
pf_p = rz*pf(:,4:6).';
pf = [pf_z.' pf_p.'];
n = 8;
qs = calc_tray(q0,pf,interp,grip,n);
q0=qs(2,:);
ps = zeros(size(qs,1),6);
for i = 1:size(qs,1)
    p = Phantom.fkine([qs(i,1),qs(i,2),qs(i,3),qs(i,4)]);
    ps(i,:) = [p(1:3,3).' p(1:3,4).'];
end
%%
rosshutdown
rosinit; %Conexión con el nodo maestro

% Recepción de la posición del robot
sub=rossubscriber('Phantom_sim/joint_states'); %Creación del subscrptor
pause(1);
A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje

% Inicializador del publicador
j1=rospublisher('Phantom_sim/joint1_position_controller/command','std_msgs/Float64'); %creación publicador
j2=rospublisher('Phantom_sim/joint2_position_controller/command','std_msgs/Float64'); %creación publicador
j3=rospublisher('Phantom_sim/joint3_position_controller/command','std_msgs/Float64'); %creación publicador
j4=rospublisher('Phantom_sim/joint4_position_controller/command','std_msgs/Float64'); %creación publicador
j5=rospublisher('Phantom_sim/joint5_position_controller/command','std_msgs/Float64'); %creación publicador
j6=rospublisher('Phantom_sim/joint6_position_controller/command','std_msgs/Float64'); %creación publicador

for i = 1:size(qs,1)
    MTH=Phantom.fkine([qs(i,1),qs(i,2),qs(i,3),qs(i,4)]);
    res=deg2rad(20);
    u=abs(A(1)-qs(i,1))<=res;
    v=abs(A(5)-qs(i,2))<=res;
    w=abs(A(6)-qs(i,3))<=res;
    x=abs(A(2)-qs(i,4))<=res;
    while ~(u&&v&&w&&x)
        msg1=rosmessage(j1); %Creación del mensaje
        msg2=rosmessage(j2); %Creación del mensaje
        msg3=rosmessage(j3); %Creación del mensaje
        msg4=rosmessage(j4); %Creación del mensaje
        msg5=rosmessage(j5); %Creación del mensaje
        msg6=rosmessage(j6); %Creación del mensaje
        msg1.Data=qs(i,1);
        msg2.Data=qs(i,2);
        msg3.Data=qs(i,3);
        msg4.Data=qs(i,4);
        msg5.Data=qs(i,5);
        msg6.Data=qs(i,5);
        if (round(A(3),1)~=qs(i,5))
            if qs(i,5)~=0
                send(j1,msg1)
                send(j2,msg2)
                send(j3,msg3)
                send(j4,msg4)
            end
            pause(1)
            send(j5,msg5)
            send(j6,msg6)
            pause(0.5)
        end
        send(j1,msg1)
        send(j2,msg2)
        send(j3,msg3)
        send(j4,msg4)
        A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
        u=abs(A(1)-qs(i,1))<=res;
        v=abs(A(5)-qs(i,2))<=res;
        w=abs(A(2)-qs(i,3))<=res;
        x=abs(A(6)-qs(i,4))<=res;
    end
end
i = size(qs,1);
msg1=rosmessage(j1); %Creación del mensaje
msg2=rosmessage(j2); %Creación del mensaje
msg3=rosmessage(j3); %Creación del mensaje
msg4=rosmessage(j4); %Creación del mensaje
msg5=rosmessage(j5); %Creación del mensaje
msg6=rosmessage(j6); %Creación del mensaje
msg1.Data=qs(i,1);
msg2.Data=qs(i,2);
msg3.Data=qs(i,3);
msg4.Data=qs(i,4);
msg5.Data=qs(i,5);
msg6.Data=qs(i,5);

send(j1,msg1)
send(j2,msg2)
send(j3,msg3)
send(j4,msg4)
send(j5,msg5)
send(j6,msg6)
rosshutdown