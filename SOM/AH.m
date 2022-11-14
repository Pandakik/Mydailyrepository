function opa = AH(J,Z,M,lambda,epsono_r)

% Copyright � 2018,  National University of Singapore, Tiantian Yin  

% for ii = 1:size(J,2)
% temp1 = ifft2(fft2(conj(Z)).*fft2(reshape(J(:,ii),M,M),2*M-1,2*M-1));
% temp2 = temp1(1:M,1:M);
% opa1(:,ii) = J(:,ii)+conj((1i*2*pi/lambda/(120*pi)*(epsono_r(:)-1))).*reshape(temp2,M^2,1);
% end


Ni = size(J,2);
J = reshape(J,M,M,Ni);
Z = repmat(Z,1,1,Ni);
%Zc = conj(Z) 返回 Z 中每个元素的复共轭。
%Y  = fft2(X) 使用快速傅里叶变换算法返回矩阵的二维傅里叶变换，这等同于计算 fft(fft(X).').'。
%     如果 X 是一个多维数组，fft2 将采用高于 2 的每个维度的二维变换。输出 Y 的大小与 X 相同。
%Y  = fft2(X,m,n) 将截断 X 或用尾随零填充 X，以便在计算变换之前形成 m×n 矩阵。
%     Y 是 m×n 矩阵。如果 X 是一个多维数组，fft2 将根据 m 和 n 决定 X 的前两个维度的形状。
opa = ifft2(fft2(conj(Z)).*fft2(J,2*M-1,2*M-1));
opa = opa(1:M,1:M,:);
opa = reshape(opa,M^2,Ni);
opa = reshape(J,M^2,Ni)+conj((1i*2*pi/lambda/(120*pi)*(repmat(epsono_r(:),1,Ni)-1))).*opa;
end
