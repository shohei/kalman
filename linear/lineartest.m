function lineartest
clear all; close all;

A=1;
b=1;
c=1;
Q=1;
R=2;
N=300;

v=randn(N,1)*sqrtm(Q);
w=randn(N,1)*sqrtm(R);

x=zeros(N,1);
y=zeros(N,1);
y(1)=c'*x(1,:)+w(1);

for k=2:N
    x(k,:)=A*x(k-1,:)'+b*v(k-1);
    y(k)=c'*x(k,:)'+w(k);
end

xhat = zeros(N,1);
P=0;
xhat(1,:)=0;

Gs(1) = 0;
Ps(1) = 0;


FigHandle = gcf;
set(FigHandle, 'Position', [100, 100, 1000, 700]);

writerObj = VideoWriter('newfile.avi');
open(writerObj);


for k=2:N
    [xhat(k,:),P,G] = kf(A,b,0,c,Q,R,0,y(k),xhat(k-1,:),P);
    Gs(k) = G;
    Ps(k) = P;
    subplot(4,1,1);
    plot(1:k,y(1:k),'k:',1:k,x(1:k),'r--',1:k,xhat(1:k),'b-');
    xlabel('No. of samples');
    legend('measured','true','estimate');
    xlim([0 N]);
    ylim([-20 20]);

    subplot(4,1,2);
    plot(1:k,x(1:k)-xhat(1:k),'b-');
    xlim([0 N]);
    title('Estimation Error')
    
    subplot(4,1,3);
    plot(1:k,Ps(1:k),'r-');
    xlim([0 N]);
    title('State Error Covariant Matrix P')
    
    subplot(4,1,4);
    plot(1:k,Gs(1:k),'g-');        
    xlim([0 N]);
    title('Kalman Gain');
    
    drawnow;

    frame = getframe(gcf);
    writeVideo(writerObj, frame);

end

close(writerObj);

% plot(N-10:N,y(N-10:N),'k:',N-10:N,x(N-10:N),'r--',N-10:N,xhat(N-10:N),'b-');
% plot(1:N,y,'k:',1:N,x,'r--',1:N,xhat,'b-');


    function [xhat_new,P_new,G] = kf(A,B,Bu,C,Q,R,u,y,xhat,P)
        
        xhat=xhat(:);
        u=u(:);
        y=y(:);
        
        xhatm = A*xhat + Bu*u;
        Pm = A*P*A' + B*Q*B';
        
        G = Pm*C/(C'*Pm*C+R);
        
        xhat_new = xhatm+G*(y-C'*xhatm);
        P_new = (eye(size(A))-G*C')*Pm;
        
    end


end