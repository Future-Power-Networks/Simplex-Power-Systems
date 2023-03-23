% This function calculates the admittacne and swing equations for a PLL
% grid-following inverter.

% Author(s): Yitong Li

clear all
clc

%%
% Laplace operator
s = tf('s');

% Base frequency
Wbase = 2*pi*50;

%% Default parameters
% Equilibrium
I = -0.5 + 1i*(0);
V = 1;   % Stable
W = Wbase;
% Notes:
% The model is in load convention.

% PLL Bandwidth
w_pll = 30*2*pi;

% Line impdeance
Xline = 0.7;
Rline = Xline/5;

% LCL Filter
Lf = 0.05/W;
Rf = 0.05/10;
Cf = 0.02/W;
Lc = 0/W;
Rc = 0;

% Control delay
Gdel = 1;

% Current loop bandwidth
w_i = 250*2*pi;

%% Impedance analysis
% Current loop controller
kp_i = w_i*Lf;
ki_i = w_i*w_i*Lf/4;

% PLL controller
kp_pll = w_pll;
ki_pll = w_pll*w_pll / 4;
G_PLL = kp_pll + ki_pll/s;

% Line impedance
Lline = Xline/W;
Zline = (s+1i*W)*Lline + Rline;
Zline_m = [Zline,0;0,conj(Zline)];

% Inner admittance
Z_PIi = (kp_i + ki_i/s)*Gdel;
Z_inner = Z_PIi + (s+1i*W)*Lf + Rf;
% Z_inner = Z_PIi + s*Lf + Rf + 1/2*(V-conj(V))*G_PLL;
Y_inner = 1/Z_inner;
Gi_cl = Z_PIi/Z_inner;

Y_inner_p = (1 - I*G_PLL*Lf/2)/Z_inner;     % This part considers the frequency shift
Y_inner_n = I*G_PLL*Lf/2;
Y_inner_m = [Y_inner_p,       Y_inner_n;
             conj(Y_inner_n), conj(Y_inner_p)];

% Parallel admittance
Y_parallel = (s+1i*W)*Cf;
Y_parallel_m = [Y_parallel, 0;
                0,          conj(Y_parallel)];

% Outer admittance
Z_outer = (s+1i*W)*Lc + Rc + Zline;
Y_outer = 1/Z_outer;
Y_outer_m = [Y_outer, 0;
             0,       conj(Y_outer)];

% Whole-system impedance model
G_vw = 1/(2*1i)*G_PLL*[1 -1];
I0 = [1i*I;
     -1i*conj(I)];
V0 = [1i*V;
      -1i*conj(V)];
Y_inner_m_prime = Y_inner_m + (I0 - Y_inner_m*V0)*inv(s + G_vw*V0)*G_vw;
Ytot_prime = Y_inner_m_prime + Y_parallel_m + Y_outer_m;
Ztot_prime = inv(Ytot_prime);

% Calculate pole
pole_sys = pole(minreal(Ztot_prime));
pole_sys = pole_sys/2/pi;

ZoomInAxis = [-20,10,-60,60];
PlotPoleMap(pole_sys,ZoomInAxis,9999);

% %% Swing analysis
% % Swing equation: voltage-angle
% Svt = s/G_PLL + 1/2*(V + conj(V));
% Y_PLL = 1/(2*Svt)*[I,        -I;
%                    -conj(I), conj(I)];
% % Svt_prime = Ytot_prime/Svt;
% Svt_prime = Ytot_prime*Zline_m;
% 
% % Calculate roots
% root = pole(minreal(1/Svt));
% root_prime = pole(minreal(1/Svt_prime));
% 
% % Convert rad/s to Hz.
% root = root/2/pi;
% root_prime = root_prime/2/pi;
