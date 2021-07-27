%{
Rafet KAVAK - 2166783
EE498 - Control System Design and Simulation
Term Project - Part 2b.
Runge-Kutta for a variable step size
%}
clc, clear, close all;

tStart = tic;

mu = 1/82.45;
mustar = 1-mu;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Explicit Runge-Kutta method (p=4) for the Apollo Satellite 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1 = @(t,x)(x(2));
f2 = @(t,x)(2*x(4) + x(1) - mustar*((x(1)+mu)/(sqrt((x(1)+mu)^2+x(3)^2))^3) - mu*((x(1)-mustar)/(sqrt((x(1)-mustar)^2+x(3)^2))^3));
f3 = @(t,x)(x(4));
f4 = @(t,x)(-2*x(2) + x(3) - mustar*((x(3))/(sqrt((x(1)+mu)^2+x(3)^2))^3) - mu*((x(3))/(sqrt((x(1)-mustar)^2+x(3)^2))^3));

f = @(t,x)([f1(t,x);f2(t,x);f3(t,x);f4(t,x)]);

x0 = [1.2; 0; 0; -1.0494];

% =======================
% Simulation
% =======================
tend = 0.25; % final time

h = 0.001; % small step size; this is very close to the actual solution
hmax = 10;
MAX_ITER = 20;        
rtol = 1e-7;       
tspan = 0:h:tend;   

clear x time;
t0 = 0;
alpha = 1e-2; % alpha < 1
beta = 1.5e0; % beta  > 1

[x time step] = ExplicitRungeKuttaVariableSize(t0,tend,x0,h,f,MAX_ITER,rtol,hmax,alpha,beta);

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
% t0 = 0;
% [x time] = ExplicitRungeKuttaVariableSize(t0,tend,x0,h,f,MAX_ITER,rtol,hmax);
% 
% plot(x(1,:),x(3,:));
% xlabel('X')
% ylabel('Y')
% title('Trajectory of the Apollo Satellite')
% grid on;
% legend('h=0.001', 'h=0.003')

time(end)
tEnd = toc(tStart)

function [x time step] = ExplicitRungeKuttaVariableSize(t0,tend,x0,h,f,MAX_ITER,rtol,hmax,alpha,beta)

x(:,1) = x0;
time(1) = t0;

for kk = 1:tend/h
    
    tf = time(kk) + hmax;
    xx  = x(:,kk);
    
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
    
    
    if h(kk)>hmax
        h(kk) = hmax;
    end
    hh(1) = h(kk);
    for i = 1:MAX_ITER
        
        k1 = f(time(kk), xx(:,i));
        k2 = f(time(kk) + c2*h(kk), xx(:,i) + h(kk)*a21*k1);
        k3 = f(time(kk) + c3*h(kk), xx(:,i) + h(kk)*a31*k1 + h(kk)*a32*k2);
        k4 = f(time(kk) + c4*h(kk), xx(:,i) + h(kk)*a41*k1 + h(kk)*a42*k2 + h(kk)*a43*k3);
        
        xx(:,i+1) = xx(:,i) + h(kk)*(b1*k1 + b2*k2 + b3*k3 + b4*k4); % Iteration
        
        er = Runge_Kutta(f, xx(:,i), time(kk), h(kk));
        err(i) = norm(er);
        if i == 1
            if err(i) > rtol
                h(kk) = h(kk)*alpha;
                hh(i+1) = h(kk);
            elseif  err(i) == rtol
                hh(i+1) = h(kk);
                hnext = hh(i+1);
                xf = xx(:,i+1);
            else
                h(kk)= h(kk)*beta;
                hh(i+1)= h(kk);
            end
        else
            if err(i) > rtol
                h(kk) = h(kk)*alpha;
                hh(i+1) = h(kk);
                if err(i-1) <= rtol
                    hnext = hh(i);
                    xf = xx(:,i);
                end
            elseif  err(i) == rtol
                hh(i+1) = h(kk);
                hnext = hh(i+1);
                xf = xx(:,i+1);
            else
                h(kk) = h(kk)*beta;
                hh(i+1) = h(kk);
                if err(i-1) >= rtol
                    hnext = hh(i+1);
                    xf = xx(:,i+1);
                end
            end
        end
    end
    
    
    h(kk+1) = hnext;
    step(kk) = hnext;
    x(:,kk+1) = xf;
    time(kk+1) = time(kk) + hnext;
    
    if time(kk)>=tend
        break;
    end
end
end

function [y, out] = Runge_Kutta(func, y, x0, h)

a2 = 0.25;
a3 = 0.375;
a4 = 12/13;
a6 = 0.5;

b21 = 0.25;
b31 = 3/32;
b32 = 9/32;
b41 = 1932/2197;
b42 = -7200/2197;
b43 = 7296/2197;
b51 = 439/216;
b52 = -8;
b53 = 3680/513;
b54 = -845/4104;
b61 = -8/27;
b62 = 2;
b63 = -3544/2565;
b64 = 1859/4104;
b65 = -11/40;

c1 = 25/216;
c3 = 1408/2565;
c4 = 2197/4104;
c5 = -0.20;

d1 = 1/360;
d3 = -128/4275;
d4 = -2197/75240;
d5 = 0.02;
d6 = 2/55;

h2 = a2 * h; h3 = a3 * h; h4 = a4 * h; h6 = a6 * h;

k1 = func(x0, y);
k2 = func(x0+h2, y + h * b21 * k1);
k3 = func(x0+h3, y + h * ( b31*k1 + b32*k2) );
k4 = func(x0+h4, y + h * ( b41*k1 + b42*k2 + b43*k3) );
k5 = func(x0+h,  y + h * ( b51*k1 + b52*k2 + b53*k3 + b54*k4) );
k6 = func(x0+h6, y + h * ( b61*k1 + b62*k2 + b63*k3 + b64*k4 + b65*k5) );
y = y +  h * (c1*k1 + c3*k3 + c4*k4 + c5*k5);
out = d1*k1 + d3*k3 + d4*k4 + d5*k5 + d6*k6;

end