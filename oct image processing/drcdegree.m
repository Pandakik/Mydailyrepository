%求图像的方向度
function drcdegree()
gifs=dir(['D:\研一上\媒体计算\作业\20812050\图像粗糙度和方向度\brodatz纹理库\*.gif']);
[Ngifs,Ncols]=size(gifs);
for nump=1:Ngifs
    gifs(nump).data=imread(['D:\研一上\媒体计算\作业\20812050\图像粗糙度和方向度\brodatz纹理库\' gifs(nump).name ]); 
[row,col]=size(gifs(nump).data);
data=zeros(row,col);
data=gifs(nump).data;  
% data=imread('D:\研一上\媒体计算\作业\20812050\图像粗糙度和方向度\brodatz纹理库\D6.gif' );
% [row,col]=size(data);
data=double(data);
A=[-1,0,1;-1,0,1;-1,0,1];
B=[1,1,1;0,0,0;-1,-1,-1];
G=zeros(row,col);
theta=zeros(row,col);
vdata=zeros(row,col);
hdata=zeros(row,col);
newtheta=zeros(row,col);
a=1;b=1;%for newtheta
for i=1:row
    for j=1:col
        %讨论正常象素与边缘象素x,y取值范围的情况
        vsum=0.0;
        hsum=0.0;
        xlow=i-1;ylow=j-1;xhigh=i+1;yhigh=j+1;
        if i-1<=0
            xlow=i;
        end
        if j-1<=0
            ylow=j;
        end
        if i+1>row
            xhigh=i;
        end
        if j+1>col
            yhigh=j;
        end
        for m=xlow:xhigh
            for n=ylow:yhigh
                ltemp=m-xlow+1;
                htemp=n-ylow+1;
                if i-1<=0
                    ltemp=m+1;
                end
                if j-1<=0
                    htemp=n+1;
                end
                hsum=hsum+data(m,n)*A(ltemp,htemp);
                vsum=vsum+data(m,n)*B(ltemp,htemp);                                        
            end%for n 
        end%for m
        hdata(i,j)=hsum;
        vdata(i,j)=vsum;  
        theta(i,j)= atan(vdata(i,j)/hdata(i,j))+pi/2;
        G(i,j)=(abs(hdata(i,j))+abs(vdata(i,j)))/2;   
        if a<=row & b<=col
            if G(i,j)>50
                newtheta(a,b)=theta(i,j);
                if b<col
                    b=b+1;
                elseif b==col
                    a=a+1;
                    b=1;
                end
            end
        end%if
    end% for j
end% for i
if b==1
    a=a-1;b=col;
else
    b=b-1;
end
a;
b;
G;
% if b<col
%     newtheta(a,b+1:col)=-10;
%     newtheta(a+1:row,1:col)=-10;
% else
%     newtheta(a+1:row,1:col)=-10;
% end
newtheta=newtheta(1:a,:);
x=[0:0.5:3.5];
figure;
hist(newtheta,x);
end
