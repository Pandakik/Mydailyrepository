%计算Tamura纹理特征

clear;I2 = imread('IMG_3634.PNG');
thresh = graythresh(I2);     %自动确定二值化阈值
I = im2bw(I2,thresh);       %对图像二值化

t0=cputime;
% I = IM2;
[Nx,Ny] = size(I);
I = ones(Nx,Ny)-I;
Ng=256;
G=double(I);

%计算粗糙度(coarseness)
Sbest=zeros(Nx,Ny);
E0h=zeros(Nx,Ny);
E0v=zeros(Nx,Ny);
E1h=zeros(Nx,Ny);
E1v=zeros(Nx,Ny);
E2h=zeros(Nx,Ny);
E2v=zeros(Nx,Ny);
E3h=zeros(Nx,Ny);
E3v=zeros(Nx,Ny);
E4h=zeros(Nx,Ny);
E4v=zeros(Nx,Ny);
E5h=zeros(Nx,Ny);
E5v=zeros(Nx,Ny);
flag=0;

for i=1:Nx
    for j=2:Ny
        E0h(i,j)=G(i,j)-G(i,j-1);
    end
end

E0h=E0h/2;

for i=1:Nx-1
    for j=1:Ny
        E0v(i,j)=G(i,j)-G(i+1,j);
    end
end
E0v=E0v/2;

%图片大小必须大于4*4才能计算E1h、E1v
if (Nx<4||Ny<4)
    flag=1;
end
if(flag==0)
    for i=1:Nx-1
        for j=3:Ny-1
            E1h(i,j)=sum(sum(G(i:i+1,j:j+1)))-sum(sum(G(i:i+1,j-2:j-1)));
        end
    end
    for i=2:Nx-2
        for j=2:Ny
            E1v(i,j)=sum(sum(G(i-1:i,j-1:j)))-sum(sum(G(i+1:i+2,j-1:j)));
        end
    end
    E1h=E1h/4;
    E1v=E1v/4;
end


%图片大小必须大于8*8才能计算E2h、E2v
if (Nx<8||Ny<8)
    flag=1;
end
if(flag==0)
    for i=2:Nx-2
        for j=5:Ny-3
            E2h(i,j)=sum(sum(G(i-1:i+2,j:j+3)))-sum(sum(G(i-1:i+2,j-4:j-1)));
        end
    end
    for i=4:Nx-4
        for j=3:Ny-1
            E2v(i,j)=sum(sum(G(i-3:i,j-2:j+1)))-sum(sum(G(i+1:i+4,j-2:j+1)));
        end
    end
    E2h=E2h/16;
    E2v=E2v/16;
end


%图片大小必须大于16*16才能计算E3h、E3v
if (Nx<16||Ny<16)
    flag=1
end
if(flag==0)
    for i=4:Nx-4
        for j=9:Ny-7
            E3h(i,j)=sum(sum(G(i-3:i+4,j:j+7)))-sum(sum(G(i-3:i+4,j-8:j-1)));
        end
    end
    for i=8:Nx-8
        for j=5:Ny-3
            E3v(i,j)=sum(sum(G(i-7:i,j-4:j+3)))-sum(sum(G(i+1:i+8,j-4:j+3)));
        end
    end
    E3h=E3h/64;
    E3v=E3v/64;
end


%图片大小必须大于32*32才能计算E4h、E4v 
if (Nx<32||Ny<32)
    flag=1;
end
if(flag==0)
    for i=8:Nx-8
        for j=17:Ny-15
            E4h(i,j)=sum(sum(G(i-7:i+8,j:j+15)))-sum(sum(G(i-7:i+8,j-16:j-1)));
        end
    end
    for i=16:Nx-16
        for j=9:Ny-7
            E4v(i,j)=sum(sum(G(i-15:i,j-8:j+7)))-sum(sum(G(i+1:i+16,j-8:j+7)));
        end
    end
    E4h=E4h/256;
    E4v=E4v/256;
end


%图片大小必须大于64*64才能计算E5h、E5v
if (Nx<64||Ny<64)
    flag=1;
end
if(flag==0)
    for i=16:Nx-16
        for j=33:Ny-31
            E5h(i,j)=sum(sum(G(i-15:i+16,j:j+31)))-sum(sum(G(i-15:i+16,j-32:j-31)));
        end
    end
    for i=32:Nx-32
        for j=17:Ny-15
            E5v(i,j)=sum(sum(G(i-31:i,j-16:j+15)))-sum(sum(G(i+1:i+32,j-16:j+15)));
        end
    end
    E5h=E5h/1024;
    E5v=E5v/1024;
end

for i=1:Nx
    for j=1:Ny
        [maxv,index]=max([E0h(i,j),E0v(i,j),E1h(i,j),E1v(i,j),E2h(i,j),E2v(i,j),E3h(i,j),E3v(i,j),E4h(i,j),E4v(i,j),E5h(i,j),E5v(i,j)]);
        k=floor((index+1)/2);
        Sbest(i,j)=2.^k;
    end
end

Fcoarseness=sum(sum(Sbest))/(Nx*Ny);
disp('粗糙度：');display(Fcoarseness)
deltaT=cputime-t0;
display(deltaT);

        


