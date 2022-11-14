function opa = A(J,Z,M,lambda,epsono_r)

% Copyright � 2018,  National University of Singapore, Tiantian Yin  

% for ii = 1:size(J,2);
% temp1 = ifft2(fft2(Z).*fft2(reshape(J(:,ii),M,M),2*M-1,2*M-1));
% temp2 = temp1(1:M,1:M);
% opa1(:,ii) = J(:,ii)+((1i*2*pi/lambda/(120*pi)*(epsono_r(:)-1))).*reshape(temp2,M^2,1);
% end


Ni = size(J,2);
J = reshape(J,M,M,Ni);
Z = repmat(Z,1,1,Ni);
%ifft2 Two-dimensional inverse discrete Fourier transform
%X = ifft2(Y) 使用快速傅里叶变换算法返回矩阵的二维离散傅里叶逆变换。
%X = ifft2(Y,m,n) 在计算逆变换之前截断 Y 或用尾随零填充 Y，以形成 m×n 矩阵。
%   X 也是 m×n。如果 Y 是一个多维数组，ifft2 将根据 m 和 n 决定 Y 的前两个维度的形状。
opa = ifft2(fft2(Z).*fft2(J,2*M-1,2*M-1));
opa = opa(1:M,1:M,:);
opa = reshape(opa,M^2,Ni);
opa = reshape(J,M^2,Ni)+((1i*2*pi/lambda/(120*pi)*(repmat(epsono_r(:),1,Ni)-1))).*opa;

end 