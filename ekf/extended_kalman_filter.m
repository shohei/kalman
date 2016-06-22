function extended_kalman_filter


f = @(x) x + 3*cos(x/10);
h = @(x) x^3;
a = @(x) 1 - 3/10*sin(x/10)
b = 1;
c = @(x) 3*x^2;

N=50;
Q=1;
R=100;

v=  randn(N,1)*sqrtm(Q);
w = randn(N,1)*sqrtm(R);

x = zeros(N,1);
y = zeros(N,1);

x(1) = 10;
y(1) = h(x(1));

for k=2:N
   x(k) = f(x(k-1)) + b*v(k-1);
   y(k) = h(x(k)) + w(k);
end

xhat = zeros(N,1);

P = 1;
xhat(1) = x(1) +1;

for k=2:N
   [xhat(k,:),P] = ekf(f,h,a,b,c,Q,R,y(k),xhat(k-1,:),P); 
end

figure(1);
clf;

subplot(211);
plot(1:N,y,'k');
xlabel('k');
ylabel('y');

subplot(212);
plot(1:N,x,'r:',1:N,xhat,'b-');
xlabel('k');
ylabel('x');
legend('true','estimate','Location','SouthEast');

    function [xhat_new,P_new,G] = ekf(f,h,A,B,C,Q,R,y,xhat,P)
        xhat = xhat(:);
        y=y(:);
        xhatm = f(xhat);
        Pm = A(xhat)*P*A(xhat)' + B*Q*B';
        G = Pm*C(xhatm)/(C(xhatm)'*Pm*C(xhatm)+R);
        xhat_new = xhatm+G*(y-h(xhatm));
        P_new = (eye(size(A(xhat)))-G*C(xhatm)')*Pm;
    end


end