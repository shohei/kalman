% A=[
%     90    60    90;
%     90    90    30
%     60    60    60
%     60    60    90
%     30    30    30
% ];ls
% N=size(A,1);
% mu = ones(N)*A/N;
% Va = ((A-mu)'*(A-mu))/N;

B = [
    90    90    60    60    30
    60    90    60    60    30
    90    30    60    90    30
    ];
N=size(B,2)
mu = B*ones(N)/N
Vb = ((B-mu)*(B-mu)')/N

% Ca = cov(A,1);
% Cb = cov(B',1);
% 
% Va
% Vb
% Ca
% Cb
% 
% 
% 
% 
