%%  Computational Methods for Electromagnetic Inverse Scattering 
%%  Chapter 6 Reconstructing Dielectric Scatters
%{
 The code is used for the forward problem of Gs-SOM. 
The scattered field geerate by the scatter is obtained.
%}

% Copyright ? 2018,  National University of Singapore, Tiantian Yin

clc;
clear all;
close all;

%% Method of Moment-----------------------------------------------------------------------------------------------------------
%% Parameters (keep unchanged for both forward problem and inverse problem)
freq = 400e6;
%空气中的波长
lambda = 3e8/freq; % the wavelength in the air
%--的波数
k0 = 2*pi/lambda; % the wave number in the air
%空气阻抗
imp = 120*pi; % impedance of air
%DOI大小
size_DOI = 2; % size of DOI

%入射数量
Ni = 16; % number of incidence
%接收天线数量
Ns = 32; % number of receiving antennas

%入射角度
%angle of incidence
theta = 0:2*pi/(Ni):(2*pi-2*pi/(Ni)); % angle of incidence

%receiving antennas
%接收天线角度
phi = (0:1:(Ns-1))/Ns*2*pi; % 1 x Ns | angle of receiving antennas
%接收天线形成的圆的半径
R_obs = 3; % radius of the circle formed by receiving antennas
%接收天线坐标
X = R_obs*cos(phi); % 1 x Ns % x coordinates of receiving antennas
Y = R_obs*sin(phi); % 1 x Ns % y coordinates of receiving antennas

%恒定相对介电常数
epsono_r_c = 2; % the constant relative permittivity of the object

%单元格的位置
% Positions of the cells -----------------------------------------------------------------------------------------------------------
M = 100; % the square containing the object has a dimension of MxM
%两个细胞中心的最近距离
d = size_DOI/M; %the nearest distance of two cell centers

%以矩形中心为坐标原点建立坐标系，
tx = ((-(M-1)/2):1:((M-1)/2))*d; % 1 x M
ty = (((M-1)/2):(-1):(-(M-1)/2))*d; % 1 x M

%[x,y] 为矩形中各个cells的坐标
[x,y] = meshgrid(tx,ty);  % M x M
%细胞半径
celldia = sqrt(d^2/pi)*2; % diameter of cells 
%细胞半径
cellrad = celldia/2; % radius of cells 
 
% Relative permittivity of each cell
%构建原图像
epsono_r = ones(M,M);%每个电池的相对介电常数
epsono_r((x-0.3).^2+(y-0.6).^2<=0.2^2) = epsono_r_c;
epsono_r((x+0.3).^2+(y-0.6).^2<=0.2^2) = epsono_r_c;
epsono_r((x).^2+(y+0.2).^2>=0.3^2 & (x).^2+(y+0.2).^2<=0.6^2) = epsono_r_c;

%-----------------------------------------------------------------------------------------------------------
%用于与电偶极子进行圆卷积，以在DOI内生成散射E场（Gd的计算），注意，ZZ矩阵中的一个元素对应于R=0
% used to do circular convolution with the eletric diple to generate the scattered E field within DOI(Calculation of Gd)
% note that one element in ZZ matrix corresponds to R = 0
[X_dif,Y_dif] = meshgrid(((1-M):1:(M-1))*d,((1-M):1:(M-1))*d); %(2M-1)
R = sqrt(X_dif.^2+Y_dif.^2); % (2M-1) x (2M-1)

    %besselj是Bessel 函数，besselh是Hankel
    %J = besselj(nu,Z) 为数组 Z 中的每个元素计算第一类 Bessel 函数 Jν(z)
    
    %besselh 第三类 Bessel 函数（Hankel 函数）
    %H = besselh(nu,K,Z) 为数组 Z 中的每个元素计算第一类或第二类 Hankel 函数 Hν(K)(z)，其中 K 为 1 或 2。


%GD
ZZ = -imp*pi*cellrad/2*besselj(1,k0*cellrad)*besselh(0,1,k0*R); % (2M-1) x (2M-1)
ZZ(M,M) = -imp*pi*cellrad/2*besselh(1,1,k0*cellrad)-1i/(2*pi/lambda/(imp));  % 1 x 1

Z = zeros(2*M-1,2*M-1);
Z(1:M,1:M) = ZZ((M):(2*M-1),(M):(2*M-1));
Z((M+1):(2*M-1),(M+1):(2*M-1)) = ZZ(1:(M-1),1:(M-1));
Z(1:M,(M+1):(2*M-1)) = ZZ((M):(2*M-1),1:(M-1));
Z((M+1):(2*M-1),1:M) = ZZ(1:(M-1),(M):(2*M-1));

%入射波的定义
% Definition of the Incident Waves----------------------------------------------------------------------------------------------
E_inc = exp(1i*k0*x(:)*cos(theta(:).')+1i*k0*y(:)*sin(theta(:).')); % M^2 x Ni
b = (-i*2*pi/(lambda*imp))*repmat((epsono_r(:)-1),1,Ni).*E_inc; % M^2 x Ni

    %* repmat(A,m,n)  
    %-- 其中，A表示复制的数组模块，第二个输入参数表示该数组模块在各个维度上的复制个数
    %-- m表示横向数组模块的个数，n表示纵向数组模块的个数
    %-- 复制过后数组模块的总数为 m*n

%% Using conjugate-gradient method使用共轭梯度法
    %f(x)=1/2xTAx-bTx的极小值，Ax-bT=0
    
    %共轭梯度法就是把目标函数分成许多方向，然后不同方向分别求出极值在综合起来。
    %如果是二次优化问题，共轭梯度法理论上是可以保证最多n步一定找到最优解。
    %共轭梯度法仅利用了函数的一阶导数信息，但是克服了梯度下降收敛慢的缺点，
    %同时又避免了牛顿法求二阶导计算量大的问题，不仅是解决大型线性方程组最有用的方法之一，
    %也是解大型非线性最优化最有效的算法之一。当然，缺点就是前面我们提到的，是专门针对二次优化问题，其他场景不太适用。

%JO是M^2 x Ni的随机数 初始化
Jo = randn(M^2,Ni); % M^2 x Ni
go = AH(A(Jo,Z,M,lambda,epsono_r)-b,Z,M,lambda,epsono_r);
po = -go;

for n = 1:200; % other stopping criteria can be also used也可以使用其他停止标准
    
    alphao = -sum(conj(A(po,Z,M,lambda,epsono_r)).*(A(Jo,Z,M,lambda,epsono_r)-b),1)/norm(reshape(A(po,Z,M,lambda,epsono_r),M^2*Ni,1),'fro')^2; % 1 x Ni
    
    J = Jo+repmat(alphao,M^2,1).*po; % M^2 x Ni
    g = AH(A(J,Z,M,lambda,epsono_r)-b,Z,M,lambda,epsono_r); % M^2 x Ni
    
    betao = sum(conj(g).*(g-go),1)./sum(abs(go).^2,1); % 1 x Ni
    
    p = -g+repmat(betao,M^2,1).*po; % M^2 x N

    po = p; % M^2 x Ni
    Jo = J; % M^2 x Ni
    go = g; % M^2 x Ni
    
end

%% Generate Scatterd E field---------------------------------------------------------
% We assume that the scattered field is measured at the circle which is
% centered at the original point with a radius equal to 3

X_obs = repmat(X.',[1,M*M]); % Ns x M^2
Y_obs = repmat(Y.',[1,M*M]); % Ns x M^2
R = sqrt((X_obs-repmat(reshape(x,M*M,1).',[Ns,1])).^2+(Y_obs-repmat(reshape(y,M*M,1).',[Ns,1])).^2); % Ns x M^2

%这里的ZZ是GS
ZZ = -imp*pi*cellrad/2*besselj(1,k0*cellrad)*besselh(0,1,k0*R); % Ns x M^2
E_s = ZZ*J; % Ns x Ni

nl = 0; % noise level || eg: when noise level is 10%, nl = 0.1.
rand_real = randn(Ns,Ni);
rand_imag = randn(Ns,Ni);
E_Gaussian = 1/sqrt(2) *sqrt(1/Ns/Ni)*norm(E_s,'fro') *nl*(rand_real +1i*rand_imag);
E_s = E_s + E_Gaussian;
save E_s_for_test.mat E_s;

clearvars -except freq lambda k0 imp size_DOI Ni Ns theta phi R_obs X Y epsono_r_c E_s;