clc
clear
close all;
%% Inicialización del nodo maestro
clear;
rosinit; %Conexión con el nodo maestro
%% Declaración del robot
d1=13.7; %cm
l1=10.5; %cm
l2=10.5; %cm
l3=11.0; %cm

ws=d1+l1+l2+l3/2;

Phant(1) = Link('revolute','a',0,'alpha',0,'d',d1,'offset',0,'modified');
Phant(2) = Link('revolute','a',0,'alpha',pi/2,'d',0,'offset',pi/2,'modified');
Phant(3) = Link('revolute','a',l1,'alpha',0,'d',0,'offset',0,'modified');
Phant(4) = Link('revolute','a',l2,'alpha',0,'d',0,'offset',0,'modified');
T=transl(l3,0,0)*[0,0,1,0;1,0,0,0;0,1,0,0;0,0,0,1]
Phantom = SerialLink(Phant,'name','PhantomX','tool',T)

figure(1)
Phantom.plot([0 0 0 0],'workspace',[-ws ws -ws ws -ws+(5*ws/6) ws+(5*ws/6)], 'scale', 0.7,'noa');
Phantom.teach();
hold on
trplot(eye(4),'length',5*ws/6,'frame','0','arrow','rgb');
view(0,0)

q1=[0 -20 30 -90 -90];
q2=[0 20 -30 15 45];
q3=[0 -20 30 -55 -55];
q4=[0 -0 -30 17 45];
q=[deg2rad(q1) deg2rad(q2) deg2rad(q3) deg2rad(q4)];
%% Recepción de la posición del robot
sub=rossubscriber('Phantom_sim/joint_states'); %Creación del subscrptor
pause(1);
A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
%% Inicializador del publicador
j1=rospublisher('Phantom_sim/joint1_position_controller/command','std_msgs/Float64'); %creación publicador
j2=rospublisher('Phantom_sim/joint2_position_controller/command','std_msgs/Float64'); %creación publicador
j3=rospublisher('Phantom_sim/joint3_position_controller/command','std_msgs/Float64'); %creación publicador
j4=rospublisher('Phantom_sim/joint4_position_controller/command','std_msgs/Float64'); %creación publicador
j5=rospublisher('Phantom_sim/joint5_position_controller/command','std_msgs/Float64'); %creación publicador
j6=rospublisher('Phantom_sim/joint6_position_controller/command','std_msgs/Float64'); %creación publicador
%% Mensaje
seq=1;
for i=1:5
    figure(1)
    q=[deg2rad(q1(i)) deg2rad(q2(i)) deg2rad(q3(i)) deg2rad(q4(i))];
    Phantom.plot(q,'workspace',[-ws ws -ws ws -ws+(5*ws/6) ws+(5*ws/6)], 'scale', 0.7,'noa');
    view(30,20)
    msg1=rosmessage(j1); %Creación del mensaje
    msg2=rosmessage(j2); %Creación del mensaje
    msg3=rosmessage(j3); %Creación del mensaje
    msg4=rosmessage(j4); %Creación del mensaje
    msg1.Data=q(1);
    msg2.Data=q(2);
    msg3.Data=q(3);
    msg4.Data=q(4);
    send(j1,msg1)
    send(j2,msg2)
    send(j3,msg3)
    send(j4,msg4)
    pause(1);
end
%% Salida de ROS
rosshutdown