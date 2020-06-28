clc
clear
close all;
 
%%
clear;
rosinit; %ConexiÃ³n con el nodo maestro

sub=rossubscriber('Phantom_sim/joint_states'); %CreaciÃ³n del subscrptor
%A=sub.LatestMessage.Position; %Arreglo con los valores del mensaje
j1=rospublisher('Phantom_sim/joint1_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador
j2=rospublisher('Phantom_sim/joint2_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador
j3=rospublisher('Phantom_sim/joint3_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador
j4=rospublisher('Phantom_sim/joint4_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador
j5=rospublisher('Phantom_sim/joint5_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador
j6=rospublisher('Phantom_sim/joint6_position_controller/command','std_msgs/Float64'); %creaciÃ³n publicador

q1=[0 0];
q2=[0 0];
q3=[0 0];
q4=[0 0];
q5=[0 0];
p1=0;
p2=0;
p3=0;
a1=0;
ModoManual=1

while ModoManual==1;  

    joy = vrjoystick(1)
    Mover1 = axis(joy, 1);
    Mover2 = axis(joy, 2);
    Mover3 = axis(joy, 3);
    Mover4 = axis(joy, 4);
    MovG = button(joy, 1);
    
    a11=q1(2)-15*Mover1;
    a12=q1(2);
    a21=q2(2)-15*Mover2;
    a22=q2(2);
    a31=q3(2)+15*Mover3;
    a32=q3(2);
    a41=q4(2)-15*Mover4;
    a42=q4(2);
    
    if MovG==1;
        a51=q5(2)+3;
        a52=q5(2);
        else 
        a51=q5(2);
        a52=q5(2);
    end
    %switch MovG
    %case 1
    %    a51=q5(2)+3;
    %    a52=q5(2);
    %otherwise
    %    a51=q5(2);
    %    a52=q5(2);
    %end
    
    moverx = axis(joy, 5);
    movery = axis(joy, 6);
    
    
    posicion= [p1 p2 p3];
    angulo = [a1].';
    pp=getpose(posicion,angulo)
    
    
    
    
    
        q1=[a12 a11];
        q2=[a22 a21];
        q3=[a32 a31];
        q4=[a42 a41];
        q5=[a51 a52];
        q=[deg2rad(q1) deg2rad(q2) deg2rad(q3) deg2rad(q4) q5];
            seq=1;
            for i=1:2
                
                q=[deg2rad(q1(i)) deg2rad(q2(i)) deg2rad(q3(i)) deg2rad(q4(i)) q5];
                msg1=rosmessage(j1); %CreaciÃ³n del mensaje
                msg2=rosmessage(j2); %CreaciÃ³n del mensaje
                msg3=rosmessage(j3); %CreaciÃ³n del mensaje
                msg4=rosmessage(j4); %CreaciÃ³n del mensaje
                msg4=rosmessage(j4); %CreaciÃ³n del mensaje
                msg5=rosmessage(j5); %CreaciÃ³n del mensaje
                msg6=rosmessage(j5); %CreaciÃ³n del mensaje
                msg1.Data=q(1);
                msg2.Data=q(2);
                msg3.Data=q(3);
                msg4.Data=q(4);
                msg5.Data=q(5);
                msg6.Data=q(5);
                send(j1,msg1)
                send(j2,msg2)
                send(j3,msg3)
                send(j4,msg4)
                send(j5,msg5)
                send(j6,msg5)
            end
  
end        
%% Salida de ROS
rosshutdown