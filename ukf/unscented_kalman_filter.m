function unscented_kalman_filter

clear all;
close all;

f = @(x) [x(:,1).*cos(x(:,2)),x(:,1).*sin(x(:,2))];
F = @(x) [cos(x(2)), -x(1)*sin(x(2));
    sin(x(2)), x(1)*cos(x(2))];


n =2;
mu = [10,pi/2];
sigma = [50 1;1 0.025];
N = 500;
x = mvnrnd(mu,sigma,N);

y=f(x);

ylin = ones(N,1)*f(mu) + (F(mu)*(x-ones(N,1)*mu)')';

kappa = 3-n;
L = chol(sigma);
X = [mu;
    ones(n,1)*mu + sqrt(n+kappa)*L;
    ones(n,1)*mu - sqrt(n+kappa)*L];

Ym = f(X);

w0 = kappa/(n+kappa);
wi = 1/(2*(n+kappa));
mean_yUT = sum([w0*Ym(1,:);
    wi*Ym(2:end,:)]);

Ymc = bsxfun(@minus, Ym, mean_yUT);
Ymc = [sqrt(w0)*Ymc(1,:);
       sqrt(wi)*Ymc(2:end,:)];
cov_yUT = Ymc' * Ymc;

uni = [cos(linspace(0,2*pi,100)'), sin(linspace(0,2*pi,100)')];
plot_dist = @(m,c,style_m,style_c) ...
     plot(m(1),m(2),style_m,...
          m(1)+uni*sqrtm(c)*[2;0],m(2)+uni*sqrtm(c)*[0;2],style_c);
      
subplot(221);
plot(x(:,1),x(:,2),'+',X(:,1),X(:,2),'ro');
hold on;
plot_dist(mu,sigma,'ro','r-');

subplot(222);
plot(y(:,1),y(:,2),'+');
hold on;
plot_dist(mean(y),cov(y),'ro','r-');

subplot(223);
plot(y(:,1),y(:,2),'+',ylin(:,1),ylin(:,2),'d');
hold on;
plot_dist(mean(y),cov(y),'ko','k--');
plot_dist(mean(ylin),cov(ylin),'r*','r-');

subplot(224);
plot(y(:,1),y(:,2),'+');
hold on;
plot_dist(mean(y),cov(y),'ko','k:');
plot_dist(mean_yUT,cov_yUT,'r*','r-');





end