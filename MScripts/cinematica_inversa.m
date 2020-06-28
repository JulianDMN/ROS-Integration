%% Función de cinemátiva inversa

function qNew = cinematica_inversa(T_0tool,Len,L)
%Cinemática inversa:

%Se recibe una matriz MTH con la configuracion esperada del efector final
%Se planea la trayectoria y se alcanza el punto esperado.

Xp = T_0tool(1:3,4) - Len(4)*T_0tool(1:3,3);

%Declaración de constantes:
r1 = round(sqrt(Xp(1)^2 + Xp(2)^2),10);
r2 = round(sqrt(r1^2 + (Xp(3)-Len(1))^2),10);

cq3 = round((r2^2 - Len(2)^2 - Len(3)^2)/(2*Len(2)*Len(3)),10);
sq3 = round(sqrt(1-cq3^2),10); % Tomando la parte positiva, codo arriba


gamma = round(atan2(Xp(3)-Len(1),r1)+pi,10);
phi = round(atan2(Len(3)*sq3,Len(2)+Len(3)*cq3),10);

%Obtención de parámetros articulares:

qNew(1) = round(atan2(Xp(2),Xp(1))+pi,10);
qNew(2) = atan2(sq3,cq3);
qNew(3) = (gamma - phi)+pi/2;


syms q1 q2 q3 q4 l1 l2 as real 

T01 = L(1).A(q1);
T12 = L(2).A(q2);
T12(2,1) = 0;
T12(2,2) = 0;
T12(3,3) = 0;
T23 = L(3).A(q3);


T03 = T01*T12*T23;


T03r = subs(T03,q1,qNew(1));
T03r = subs(T03r,q2,qNew(2));
T03r = subs(T03r,q3,qNew(3));

%numerico
% T03r
T03r = double(vpa(T03r));
r3 = round(norm(T_0tool(1:3,4)-T03r(1:3,4)),10);
cq4 = round((r3^2 - Len(3)^2 - Len(4)^2)/(2*Len(3)*Len(4)),10);

if qNew(1) == 0 && qNew(2) ==0 && qNew(3) ==0
    sq4 = round(-sqrt(1-cq4^2),10); % Tomando la parte positiva, muneca abajo
else
    sq4 = round(sqrt(1-cq4^2),10); % Tomando la parte positiva, muneca abajo
end
    

qNew(4) = round(atan2(sq4,cq4),10);

    

end