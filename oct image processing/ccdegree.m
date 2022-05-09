%求图像的粗糙度

data=IM2
[row,col]=size(data);
data=double(data);
 K=5;

for k=1:K
    for x=1:row
        for y=1:col
            sum=0;
            %讨论正常象素与边缘象素x,y取值范围的情况
            if x-pow2(k-1)>0&(x+pow2(k-1)-1)<=row
                xlow=x-pow2(k-1);
                xhigh=x+pow2(k-1)-1;
            elseif x-pow2(k-1)<=0
                xlow=1;
                xhigh=x+pow2(k-1)-1;
            elseif x+pow2(k-1)-1>row
                xlow=x-pow2(k-1);
                xhigh=row;
            end
            if y-pow2(k-1)>0&(y+pow2(k-1)-1)<=col
                ylow=y-pow2(k-1);
                yhigh=y+pow2(k-1)-1;
            elseif y-pow2(k-1)<=0
                ylow=1;
                yhigh=y+pow2(k-1)-1;
            elseif y+pow2(k-1)-1>col
                ylow=y-pow2(k-1);
                yhigh=col;
            end           
            for i=xlow:xhigh
               for j=ylow:yhigh
                   %先除以pow2(2*k)，否则sum会超过255
                   sum=sum+data(i,j)/pow2(2*k);                    
               end
            end 
            a(x,y,k)=sum;
        end
    end
end


for k=1:K
    for x=1:row
        for y=1:col
            %计算水平和垂直方向上互不重叠窗口之间的均值之差
            %讨论边界情况
            if x+pow2(k-1)<=row & x-pow2(k-1)>0
                eh(x,y,k)=a(x+pow2(k-1),y,k)-a(x-pow2(k-1),y,k);
            elseif x+pow2(k-1)>row
                eh(x,y,k)=a(row,y,k)-a(x-pow2(k-1),y,k);
            elseif x-pow2(k-1)<=0
                eh(x,y,k)=a(x+pow2(k-1),y,k)-a(1,y,k); 
            end
            if y+pow2(k-1)<=col&y-pow2(k-1)>0
                ev(x,y,k)=a(x,y+pow2(k-1),k)-a(x,y-pow2(k-1),k);
            elseif y+pow2(k-1)>col
                ev(x,y,k)=a(x,col,k)-a(x,y-pow2(k-1),k);
            elseif y-pow2(k-1)<=0
                ev(x,y,k)=a(x,y+pow2(k-1),k)-a(x,1,k);            
            end
            %计算设置最佳尺寸的k值
            if k==1
                xmax(x,y)=eh(x,y,k);
                xbestk(x,y)=k;
            elseif eh(x,y,k)>xmax(x,y)
                xmax(x,y)=eh(x,y,k);
                xbestk(x,y)=k;
            end
            if k==1
                ymax(x,y)=ev(x,y,k);
                ybestk(x,y)=k;
            elseif ev(x,y,k)>ymax(x,y)
                ymax(x,y)=ev(x,y,k);
                ybestk(x,y)=k;
            end
            
        end
    end
end
%求粗糙度
sumsbest=0.0;
sbest=zeros(row,col);
for x=1:row
        for y=1:col
            if eh(x,y,xbestk(x,y))>ev(x,y,ybestk(x,y))
                sbest(x,y)=pow2(xbestk(x,y));
            elseif ev(x,y,xbestk(x,y))>eh(x,y,ybestk(x,y));
                sbest(x,y)=pow2(ybestk(x,y));
            end
             sumsbest=sumsbest+sbest(x,y);   
        end
end
sbest;
fcrs=sumsbest/(row*col);
disp(fcrs);

