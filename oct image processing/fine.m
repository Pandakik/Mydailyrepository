FIG_=imread('Filename_0311.jpg');  
 FIG_1=double(FIG_(:,:,1));
FIG_2=double(FIG_(:,:,2));
FIG_3=double(FIG_(:,:,3));  
[m n]=size(FIG_1);
[t r]=meshgrid(linspace(-pi,pi,n),1:m); 
M=2*m;N=2*n;
[n_ m_]=meshgrid((1:N)-n-0.5,(1:M)-m-0.5);
T=atan2(n_,m_);
R=sqrt(m_.^2+n_.^2);                  
PIC_1=interp2(t,r,FIG_1,T,R,'linefig_r',0);
PIC_2=interp2(t,r,FIG_2,T,R,'linefig_r',0);
PIC_3=interp2(t,r,FIG_3,T,R,'linefig_r',0); 
PIC_=uint8(cat(3,PIC_1,PIC_2,PIC_3));        
subplot(1,2,1)
imshow(FIG_); title('Picture_1:Ô­Í¼')
subplot(1,2,2)
imshow(PIC_);  title('Picture_2:¼«×ø±êÍ¼')
