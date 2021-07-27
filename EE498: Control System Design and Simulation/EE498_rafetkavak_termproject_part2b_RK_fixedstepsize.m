%{
Rafet KAVAK - 2166783
EE498 - Control System Design and Simulation
Term Project - Part 2b.
Runge-Kutta for a fixed step size
%}
clc, clear, close all;

tStart = tic;

mu = 1/82.45;
mustar = 1 - mu;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explicit Runge-Kutta method (p=4) for the Apollo Satellite 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1 = @(t,x)(x(2));
f2 = @(t,x)(2*x(4) + x(1) - mustar*((x(1)+mu)/(sqrt((x(1)+mu)^2+x(3)^2))^3) - mu*((x(1)-mustar)/(sqrt((x(1)-mustar)^2+x(3)^2))^3));
f3 = @(t,x)(x(4));
f4 = @(t,x)(-2*x(2) + x(3) - mustar*((x(3))/(sqrt((x(1)+mu)^2+x(3)^2))^3) - mu*((x(3))/(sqrt((x(1)-mustar)^2+x(3)^2))^3));

f  = @(t,x)([f1(t,x);f2(t,x);f3(t,x);f4(t,x)]);

x0 = [1.2; 0; 0; -1.0494];

% =======================
% Simulation
% =======================
tend = 6.5; % final time

h = 0.001; % small step size; this is very close to the actual solution
x(:,1) = x0; % state values during the simulation
time(1) = 0; % simulation time

for kk = 1:tend/h
    x(:,kk+1) = ExplicitRungeKuttaFixedSize(time(kk),x(:,kk),h,f);
    time(kk+1) = kk*h;
end

figure;
plot(x(1,:),x(3,:));
xlabel('X')
ylabel('Y')
title('Trajectory of the Apollo Satellite')
grid on;
hold all;


% % Different step size
% h = 0.003; % larger step size
% clear x time; 
% x(:,1) = x0; % state values during the simulation
% time(1) = 0; % simulation time
% for kk = 1:tend/h
%     x(:,kk+1) = ExplicitRungeKuttaFixedSize(time(kk),x(:,kk),h,f);
%     time(kk+1) = kk*h;
% end
% 
% plot(x(1,:),x(3,:));
% xlabel('X')
% ylabel('Y')
% title('Trajectory of the Apollo Satellite')
% grid on;
% legend('h=0.001', 'h=0.003')

tEnd = toc(tStart)


function xNext = ExplicitRungeKuttaFixedSize(t,x,h,f)
% =============================
% Function computes one step
% Inputs
% - x: current state
% - h: step size
% - f: right hand side of the IVP to be simulated (given as function
% handle): https://www.mathworks.com/help/matlab/matlab_prog/pass-a-function-to-another-function.html
% Output
% - xNext: state in the next time step

% Explicit Runge-Kutta Method with 4 Stages
c1 = 0;
c2 = 1/2; 
c3 = 1/2; 
c4 = 1;

b1 = 1/6; 
b2 = 2/6; 
b3 = 2/6; 
b4 = 1/6;

a21 = 1/2; 
a31 = 0; 
a32 = 1/2; 
a41 = 0; 
a42 = 0; 
a43 = 1; 

k1 = f(t, x); 
k2 = f(t + c2*h, x + h*a21*k1); 
k3 = f(t + c3*h, x + h*a31*k1 + h*a32*k2); 
k4 = f(t + c4*h, x + h*a41*k1 + h*a42*k2 + h*a43*k3); 

xNext = x + h*(b1*k1 + b2*k2 + b3*k3 + b4*k4); % Iteration 
end