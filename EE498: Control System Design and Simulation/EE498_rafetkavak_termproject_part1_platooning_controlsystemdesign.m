%{
Rafet KAVAK - 2166783
EE498 - Control System Design and Simulation
Term Project - Part 1
%}
clc, clear, close all;

%% a.
tau = 0.1; % sec

s = tf('s');
G = 1/(s^2*(tau*s+1));

% figure
% bode(G);
% grid on;


%% b.
% Kp = 0.1;
% Ti = 10;
% Td = 10;

% P
% C = Kp
% 
% figure
% bode(G)
% grid on;
% hold on
% bode(C*G);
% legend('G','C*G')



% PI
% C = Kp*(1+1/(s*Ti));
% 
% figure
% bode(G)
% grid on;
% hold on
% bode(C*G);
% legend('G','C*G')



% PD
% C = Kp*(1+s*Td);
% 
% 
% figure
% bode(G)
% grid on;
% hold on
% bode(C*G);
% legend('G','C*G')

% PID

% C = Kp*(1+1/(s*Ti)+s*Td);
% 
% 
% figure
% bode(G)
% grid on;
% hold on
% bode(C*G);
% legend('G','C*G')



%% c.
syms x

C1 = (1 + 5*s - 590*s^2)/(600 - 50*s + 10*s^2);

T1 = feedback(G*C1, 1);

% figure
% step(T1);
% title('Step Response when s = -1');
% grid on;
% hold on
% fplot(heaviside(x), 'g')
% legend('Output','Input')


C2 = (32 + 80*s - 320*s^2)/(400 + 0*s + 10*s^2);

T2 = feedback(G*C2, 1);

% figure
% step(T2);
% title('Step Response when s = -2');
% grid on;
% hold on
% fplot(heaviside(x), 'g')
% legend('Output','Input')


C3 = (243 + 405*s - 130*s^2)/(400 + 50*s + 10*s^2);

T3 = feedback(G*C3, 1);
% 
% figure
% step(T3);
% title('Step Response when s = -3');
% grid on;


C4 = (1024 + 1280*s + 40*s^2)/(600 + 100*s + 10*s^2);

T4 = feedback(G*C4, 1);

% figure
% step(T4);
% title('Step Response when s = -4');
% grid on;
% hold on
% fplot(heaviside(x), 'g')
% legend('Output','Input')
% hold off

C5 = (3125 + 3125*s + 250*s^2)/(1000 + 150*s + 10*s^2);

T5 = feedback(G*C5, 1);

% figure
% step(T5);
% title('Step Response when s = -5');
% grid on;
% hold on
% fplot(heaviside(x), 'g')
% legend('Output','Input')
% hold off


C6 = (7776 + 6480*s + 560*s^2)/(1600 + 200*s + 10*s^2);

T6 = feedback(G*C6, 1);

% figure
% step(T6);
% title('Step Response when s = -6');
% grid on;
% hold on
% fplot(heaviside(x), 'g')
% legend('Output','Input')
% hold off

% figure
% step(T1)
% hold on
% step(T2)
% step(T3)
% step(T4)
% step(T5)
% step(T6)
% fplot(heaviside(x), 'g')
% hold off
% legend('s = -1', 's = -2', 's = -3', 's = -4', 's = -5', 's = -6', 'Input')
% grid on

% figure
% step(T2)
% hold on
% step(T3)
% step(T4)
% step(T5)
% step(T6)
% fplot(heaviside(x), 'g')
% hold off
% title('Step Responses for Several Pole Locations');
% legend('s = -2', 's = -3', 's = -4', 's = -5', 's = -6', 'Input')
% grid on


% figure
% step(T3)
% hold on
% step(T4)
% step(T5)
% step(T6)
% fplot(heaviside(x), 'g')
% hold off
% title('Step Responses for Several Pole Locations');
% legend('s = -3', 's = -4', 's = -5', 's = -6', 'Input')
% grid on

F = 12.5/((s+1.09611)*(s+11.40388)); % Pre-filter

% figure
% step(F*T5)
% hold on
% fplot(heaviside(x), 'g')
% hold off
% title('Step Response for s = -5 with Pre-filter');
% legend('Output', 'Input')
% grid on


%% d.

