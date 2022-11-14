function opa = Gd(J,Z,M)

% Copyright © 2018,  National University of Singapore, Tiantian Yin  

% for ii = 1:size(J,2);
% temp1 = ifft2(fft2(Z).*fft2(reshape(J(:,ii),M,M),2*M-1,2*M-1));
% opa1(:,ii) = reshape(temp1(1:M,1:M),M^2,1);
% end

Ni = size(J,2);
J = reshape(J,M,M,Ni);
Z = repmat(Z,1,1,Ni);
opa = ifft2(fft2(Z).*fft2(J,2*M-1,2*M-1));
opa = opa(1:M,1:M,:);
opa = reshape(opa,M^2,Ni);


end 