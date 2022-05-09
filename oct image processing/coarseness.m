%%求粗糙度coarseness

function ent=coarseness(pic,ks) 

% pic表示图像，ks求粗糙度的最大的窗口尺寸

[h w]=size(pic)

h1=h-ks;

w1=w-ks;

 

%%求平均强度

picmean=zeros(h1,w1,ks);

picmean(:,:,1)=pic(1:h1,1:w1);

for k=1:ks-1

    for i=1:h1

       for j=1:w1

           picwindow=pic(i:i+k,j:j+k);

           picmean(i,j,k+1)=mean2(picwindow);

       end

    end

end

%%求两个方向窗口不重叠的最大差值

h2=h1-ks;

w2=w1-ks;

picmax3=zeros(h2,w2,ks);

for k=1:ks

   pic_h_deference=picmean(1+k:h2+k,1:w2,k);   %水平方向

   pic_v_deference=picmean(1:h2,1+k:w2+k,k);   %垂直方向

   pic_d_deference=picmean(1+k:h2+k,1+k:w2+k,k);   %对角方向

   

   pic_h_deference=abs(pic_h_deference-picmean(1:h2,1:w2,k));

   pic_v_deference=abs(pic_v_deference-picmean(1:h2,1:w2,k));

   pic_d_deference=abs(pic_d_deference-picmean(1:h2,1:w2,k));

   picmax3(:,:,k)=max(max(pic_h_deference,pic_v_deference),pic_d_deference);

end

[picmax2,maxk]=max(picmax3,[],3);     % 确定极大值的位置

 

ent=mean2(2.^maxk);