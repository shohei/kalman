clear all; close all;

A=[1.1269 -0.4940 0.1129
   1 0 0
   0 1 0];

B=[-0.3832 0.5919 0.5191]';

C=[1 0 0];

Plant = ss(A,[B B],C,0,-1,'inputname',{'u' 'v'},'outputname','yf');
Q = 1;
R = 1;

[kalmf,L,p,g,z] =kalman(Plant,Q,R);

a = A;
b=[B B 0*B];
c = [C 
     C];
d = [0 0 0
     0 0 1];
 P = ss(a,b,c,d,-1,...
     'inputname',{'u','v','w'},...
     'outputname',{'yf' 'y'});
 
 sys = parallel(P,kalmf,1,1,[],[]);
 SimModel = feedback(sys,1,4,2,1);
 SimModel = SimModel([1 3],[1 2 3]);
 SimModel.inputname
 SimModel.outputname
 
 t=[0:100]';
 u=sin(t/5);
 n=length(t);
 randn('seed',0);
 v=sqrt(Q)*randn(n,1);
 w=sqrt(R)*randn(n,1);
 
 [out,x]=lsim(SimModel,[v,w,u]);
 yf=out(:,1);
 ye=out(:,2);
 y=yf+w;
 subplot(211);
 plot(t,yf,'--',t,ye,'-');
 xlabel('No. of samples');
 ylabel('Output');
 legend('yf','ye')
 title('Kalman filter response');
 subplot(212);
 plot(t,yf-y,'-.',t,yf-ye,'-');
 legend('yf-y','yf-ye')
 xlabel('No. of samples');
 ylabel('Error');
 
 MeasErr = yf-y;
 MeasErrCov = sum(MeasErr.*MeasErr)/length(MeasErr)
 EstErr = yf-ye;
 EstErrCov = sum(EstErr.*EstErr)/length(EstErr)
 
 
 
 
 
 
 
 
 
 
 
 




















