%%  Computational Methods for Electromagnetic Inverse Scattering 
%%  Chapter 6 Reconstructing Dielectric Scatters
%{
 The code is the noniterative inversion algorithm that is based on
 back-propogation (BP). It is used as the initialization for Gs-SOM.
%}

% Copyright � 2018,  National University of Singapore, Tiantian Yin

%clc;
close all;

%-------------------------------------------------------------------------------------
%% Parameters (keep unchanged in the inverse problem)
% Position of the cells
M = 64; % the square DOI has a dimension of MxM % This value of M is set to be smaller than the value of M used in forward problem to avoid "inverse crime". 
d = size_DOI/M; %the nearest distance of two cell centers
tx = ((-(M-1)/2):1:((M-1)/2))*d; % 1 x M
ty = (((M-1)/2):(-1):(-(M-1)/2))*d; % 1 x M
[x,y] = meshgrid(tx,ty);  % M x M
celldia = sqrt(d^2/pi)*2; % diameter of cells
cellrad = celldia/2; % radius of cells   

%-------------------------------------------------------------------------------------
%用于与电偶极子进行循环卷积以生成
% used to do circular convolution with the eletric diple to generate the
% scattered E field within DOI (used for calculation of Gd)
% note that one element in ZZ matrix corresponds to R = 0
[X_dif,Y_dif] = meshgrid(((1-M):1:(M-1))*d,((1-M):1:(M-1))*d); 
R = sqrt(X_dif.^2+Y_dif.^2); % (2M-1) x (2M-1)
ZZ = -imp*pi*cellrad/2*besselj(1,k0*cellrad)*besselh(0,1,k0*R); % (2M-1) x (2M-1)
ZZ(M,M) = -imp*pi*cellrad/2*besselh(1,1,k0*cellrad)-1i/(2*pi/lambda/(imp));  % 1 x 1
Z = zeros(2*M-1,2*M-1);
Z(1:M,1:M) = ZZ((M):(2*M-1),(M):(2*M-1));
Z((M+1):(2*M-1),(M+1):(2*M-1)) = ZZ(1:(M-1),1:(M-1));
Z(1:M,(M+1):(2*M-1)) = ZZ((M):(2*M-1),1:(M-1));
Z((M+1):(2*M-1),1:M) = ZZ(1:(M-1),(M):(2*M-1));

%-------------------------------------------------------------------------------------
% Calculation of Gs 
X_obs = repmat(X.',[1,M*M]); % M^2 x M^2
Y_obs = repmat(Y.',[1,M*M]); % M^2 x M^2
R = sqrt((X_obs-repmat(reshape(x,M*M,1).',[Ns,1])).^2+(Y_obs-repmat(reshape(y,M*M,1).',[Ns,1])).^2); % M^2 x M^2
Gs = -imp*pi*cellrad/2*besselj(1,k0*cellrad)*besselh(0,1,k0*R);% Ns x M^2

E_inc = exp(1i*k0*repmat(x(:),1,Ni).*repmat(cos(theta),M^2,1)+1i*k0*repmat(y(:),1,Ni).*repmat(sin(theta),M^2,1)); % M^2 x Ni
%% -------------------------------------------------------------------------------------

gamma = sum(E_s.*conj(Gs*Gs'*E_s),1)./sum(abs(Gs*Gs'*E_s).^2,1); % 1 x Ni
J= repmat(gamma,M^2,1).*(Gs'*E_s); % M^2 x Ni
Et = E_inc + Gd(J,Z,M); % M^2 x 1

%共轭
num = sum(J.*conj(Et),2);
den = sum(conj(Et).*Et,2);

chai = reshape(num./den,M,M); % M x M
  
clear gamma J Et num den;
save chai_for_test.mat chai;
