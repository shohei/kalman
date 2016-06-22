function sample2

A=[ 0 -0.7
    1 -1.5 ];
b= [0.5 1]';
c=[0 1]';

N=100;
Q=1;
R=0.1;

v=randn(N,1)*sqrtm(Q);
w=randn(N,1)*sqrtm(R);

x=zeros(N,2);
y=zeros(N,1);
y(1)=c'*x(1,:)'+w(1);
for k=2:N
   x(k,:) =A*x(k-1,:)'+b*v(k-1);
   y(k)=c'*x(k,:)'+w(k);
end

xhat = zeros(N,2);
gamma = 1;
P=gamma*eye(2);
xhat(1,:)=[0 0];

for k=2:N
   [xhat(k,:),P] = kf(A,b,0,c,Q,R,0,y(k),xhat(k-1,:),P);
end


figure(1);
clf;

subplot(211);
plot(1:N,x(:,1),'r--',1:N,xhat(:,1),'b-');
xlabel('k');
ylabel('x1');
legend('true','estimate');

subplot(212);
plot(1:N,y,'k:',1:N,x(:,2),'r--',1:N,xhat(:,2),'b-');
xlabel('k');
ylabel('x2');
legend('measured','true','estimate');



end