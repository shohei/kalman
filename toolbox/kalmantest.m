
A=[1.1269 -0.4940 0.1129
   1 0 0
   0 1 0];

B=[-0.3832 0.5919 0.5191]';

C=[1 0 0];

Plant = ss(A,[B B],C,0,-1,'inputname',{'u' 'v'},'outputname','yf');
Q = 1;
R = 1;

[kalmf,L,p,g,z] =kalman(Plant,Q,R);




