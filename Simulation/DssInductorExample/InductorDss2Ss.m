clear all
clc
close all

syms L1 L2
E = diag([L1,0,L2,0,0]);
A = [0,1,0,0,0;
     -1,0,0,0,1;
     0,0,0,1,0;
     0,0,-1,0,1;
     0,-1,0,-1,0];
B = [0;0;0;0;1];
C = [0,0,0,0,1];
D = 0;

[A_,B_,C_,D_,Bd,Dd]= CallDss2Ss(A,B,C,D,E);

A22 = [0,-1,-1;
       1,0,0;
       1,0,0]
   
N = null(A22.')
N = N.'
N_ = null(A22)

[t1,t2,t3] = svd(A22)