%%  Computational Methods for Electromagnetic Inverse Scattering 
%%  Chapter 6 Reconstructing Dielectric Scatters
%{
 The code is used for the inverse problem of Gs-SOM. The scattered field
 generated using Chap6_Gs_SOM_forward.m and the initialized reconstruction
 generated using Chap6_Backpropogatin.m are used to reconstruct the contrast
of the scatterer.
%}

% Copyright � 2018,  National University of Singapore, Tiantian Yin  

%clc;
close all;
tic


L = 15; % number of singular values used to calculate the major part of induced current
[Gs_U,Gs_S,Gs_V] = svd(Gs);

%% calculation of major part of induced current
alpha_po = Gs_U(:,1:L)'*E_s./repmat(diag(Gs_S(1:L,1:L)),1,Ni); % L x Ni
J_po = Gs_V(:,1:L)*alpha_po; % M^2 x Ni

%% the expected contrast profile
epsono_r = ones(M,M);
epsono_r((x-0.3).^2+(y-0.6).^2<=0.2^2) = epsono_r_c;
epsono_r((x+0.3).^2+(y-0.6).^2<=0.2^2) = epsono_r_c;
epsono_r((x).^2+(y+0.2).^2>=0.3^2 & (x).^2+(y+0.2).^2<=0.6^2) = epsono_r_c;
chai0 = -1i*k0/imp*(epsono_r-ones(M,M));


%% Loop
Gs_V_ne = Gs_V(:,(L+1):end); % M^2 x (M^2-L)
alpha_ne = zeros(M^2-L,Ni);  
alpha_neo = zeros(M^2-L,Ni);
rho = zeros(M^2-L,Ni);
grad = zeros(M^2-L,Ni);
B = repmat(reshape(chai,M^2,1),1,Ni).*(E_inc+Gd(J_po,Z,M))-J_po;  % M^2 x Ni
del_dat = Gs*(Gs_V_ne*alpha_ne)+Gs*J_po-E_s; % Ns x Ni
del_sta = Gs_V_ne*alpha_ne - repmat(reshape(chai,M^2,1),1,Ni).*Gd(Gs_V_ne*alpha_ne,Z,M)-B;   % M^2 x Ni
E_po = E_inc+Gd(J_po,Z,M); % M^2 x Ni
E_s_norm_sq = sum(abs(E_s).^2,1); % 1 x Ni
J_po_norm_sq = sum(abs(J_po).^2,1); % 1 x Ni



for n = 1:50;
  
        grad = (Gs*Gs_V_ne)'*(del_dat)./repmat(E_s_norm_sq,M^2-L,1)+(Gs_V_ne'*(del_sta) - Gs_V_ne'*Gd(repmat(conj(chai(:)),1,Ni).*(del_sta),conj(Z),M))./repmat(J_po_norm_sq,M^2-L,1); % (M^2-L) x Ni
        if n > 1;
        rho = grad+repmat(real(sum(conj(grad-grado).*grad,1))./sum(abs(grado).^2,1),M^2-L,1).*rhoo; % (M^2-L) x Ni
        end
        if n == 1;
        rho = grad;  % (M^2-L) x Ni
        end
        
        num = -sum(conj(Gs*(Gs_V_ne*rho)).*del_dat,1)./E_s_norm_sq-sum(conj((Gs_V_ne*rho - repmat(reshape(chai,M^2,1),1,Ni).*Gd(Gs_V_ne*rho,Z,M))).*del_sta,1)./J_po_norm_sq; % 1 x Ni
        den = sum(abs(Gs*(Gs_V_ne*rho)).^2,1)./E_s_norm_sq+sum(abs((Gs_V_ne*rho - repmat(reshape(chai,M^2,1),1,Ni).*Gd(Gs_V_ne*rho,Z,M))).^2,1)./J_po_norm_sq; % 1 x Ni
        alpha_ne = alpha_neo+repmat(num./den,M^2-L,1).*rho; % (M^2-L) x Ni
        J = J_po+Gs_V_ne*alpha_ne; % M^2 x Ni
        Et = E_inc + Gd(J,Z,M); % M^2 x Ni
        chai_num = sum(conj(Et).*J./repmat(J_po_norm_sq,M^2,1),2); % M^2 x 1
        chai_den = sum(conj(Et).*Et./repmat(J_po_norm_sq,M^2,1),2); % M^2 x 1
        chai = chai_num./chai_den; % M^2 x 1
        chai(imag(chai)>0) = 0; % M^2 x 1
        chai = 1i*imag(chai);
        grado = grad; % (M^2-L) x Ni
        alpha_neo = alpha_ne; % (M^2-L) x Ni
        rhoo = rho; % (M^2-L) x Ni
        B = repmat(reshape(chai,M^2,1),1,Ni).*(E_po)-J_po; % M^2 x Ni
        del_dat = Gs*(Gs_V_ne*alpha_ne)+Gs*J_po-E_s; % Ns x Ni
        del_sta = Gs_V_ne*alpha_ne - repmat(reshape(chai,M^2,1),1,Ni).*Gd(Gs_V_ne*alpha_ne,Z,M)-B;
        objectf1 = sum(sum((abs(del_dat)).^2,1)./E_s_norm_sq,2); % 1 x 1
        objectf2 = sum(sum((abs(del_sta)).^2,1)./J_po_norm_sq,2);% 1 x 1
        f(n) = objectf1+objectf2; % 1 x 1   objective function
        p = real(chai/(-1i*k0/imp))+ones(M^2,1); % M^2 x 1
        q = real(chai0(:)/(-1i*k0/imp))+ones(M^2,1); % M^2 x 1
        g(n) = norm(q-p)/norm(q); % 1 x 1   relative error
        chai_storage(:,n) = chai(:); % the updated contrast in each step
        
        disp(['Iter. =', num2str(n), '       f = ', num2str(f(n)),'     g = ', num2str(g(n)) ]);
  
end


chai = reshape(chai,M,M);


figure;      % figure 6.7 in book
plot(diag(log10(Gs_S)),'*');
xlabel('Singular value number,j');
ylabel('log_{10}(\sigma_j)');

figure;      % figure 6.8 in book
plot(log10(f),'*');
xlabel('Number of Iterations');
ylabel('log_{10}(f)');


figure;      % figure 6.9 in book
plot(g,'*');
xlabel('Number of Iterations');
ylabel('R_{e}');

figure; % Figure 6.10, 6.11, 6.12  in book
imagesc(tx,ty,real(chai/(-1i*k0/imp))+ones(M,M));
set(gca,'YDir','normal');
set(gcf,'color','w');
colormap(jet(256));
colorbar;


filename = sprintf('reconstruction_results_L=%d.mat',L);
save(filename,'chai','chai_storage','f','g');
toc