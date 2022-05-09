clc
clear %%% 清空所有历史程序的记录


%%
%1 设定x(t) 的正态分布参数
%18061319生日：1998.06.16 
Norm_st=0.16 ;    %正常状态的均值
Sigma_1 =1.2 ;    %正常状态的标准差
ABNorm_st=1+Norm_st;   %异常状态的均值
Sigma_2 =Sigma_1 ; %异常状态的标准差
%%
num_k =  [3 7 9 15];%此处为循环计算3、7、9、15滤波器时的阶数初始化
far_g = zeros(1,4);%存放四个阶数滤波器下的概率法far
far_t = zeros(1,4);%存放四个阶数滤波器下的实验法far
mar_g = zeros(1,4);%存放四个阶数滤波器下的概率法mar
mar_t = zeros(1,4);%存放四个阶数滤波器下的实验法mar
add_t = zeros(1,4);%存放四个阶数滤波器下的实验法aad
%%
for kk = 1:4%四次循环分别计算3、7、9、15阶滤波器下的情况
%%
%%2 x(t) 对应的 3 阶滑动平均滤波器，y(t)正态分布参数；
%滑动平均滤波可消除偶然误差
muy1=Norm_st; 
muy2=ABNorm_st; 
ssigma_1 =Sigma_1 /( num_k(kk)^0.5 );%交叠区面积变小 减小漏爆误报
ssigma_2 =Sigma_2 /( num_k(kk)^0.5 );
In_left =muy1-3*ssigma_1 ; %取值范围左端点
In_right =muy2+3*ssigma_2 ;  %取值范围右端点
ytp =In_left : 0.1 : In_right ; %xtp 的取值
Num=length (ytp );%Num=( μ2+3σ2)-( μ1-3 σ1)/0.1 个 xtp 的取值点


%%
%绘制正太分布图
xt= -4 : 0.1 :4;
yt1=normpdf(xt,Norm_st,ssigma_1); 
yt2=normpdf(xt,ABNorm_st,ssigma_2);
figure(1);
plot(xt,yt1,'linewidth',2);grid;
hold on 
plot(xt,yt2,'*-','linewidth',2);
set(gca,'linewidth',2,'fontsize',20);
title('正态分布图')
legend('正常','异常')
%%%

FAR = zeros(1,Num);
MAR = zeros(1,Num);
%%
%3  FAR和MAR的 ROC曲线 ytp最优值
for i =1: Num  
    FAR ( i )= 1-cdf ( 'norm' , ytp ( i ), muy1, ssigma_1 ); %cdf 计算定积分
    MAR ( i )= cdf ('norm' , ytp ( i ), muy2, ssigma_2 ); 
R ( i )=(( FAR( i ))^ 2+( MAR( i ))^ 2)^ 0.5 ; %计算 ROC曲线上每个点和原点(FAR=0，MAR=0)%的距离
end
[ s, sn]= sort ( R); %大到小排列序列 s，sn 为 s 中元素在原来 R中的位置
yotp =ytp (sn( 1)); %s1 为最小值 即最优
display( yotp ); 
oFAR=FAR(sn( 1)); %最优 FAR
oMAR=MAR(sn( 1)); %最优 MAR
far_g(kk) = oFAR;
mar_g(kk) = oMAR;
figure ( 2) 
% subplot(2,2,1)
plot (FAR, MAR, 'linewidth' , 2) ;grid;
title ( ' 定积分法求滑动平均滤波法的 ROC曲线 ' );
hold on
plot(FAR(sn( 1)), MAR( sn( 1)),'r*')
set(gca,'linewidth',2,'fontsize',20);
text (FAR(sn( 1)), MAR( sn( 1)), '最优阈值点 ' , 'FontSize' , 20) 
xlabel ('y(t) 的 FAR'); 
ylabel ('y(t) 的 MAR');

%%
%4
x_nor =normrnd ( Norm_st, Sigma_1 , 1, 1000); %正常状态下的 1000 个点
x_abnor =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% 产生异常状态下的 1000 个点
x=[ x_nor , x_abnor ];
figure ( 3)
plot (x, 'linewidth' , 1)
set(gca,'linewidth',2,'fontsize',20);
title ( 'x(t) 的采样数据 ' ) 
xlabel ('t' ); 
ylabel ('x(t)' ); 

%% 其中 y(t)=((x(t)+x(t-1)+x(t-2))/3; 其中 n=3,t=n,n+1,n+2......
y=zeros ( 1, length ( x)); %初始化 y 数组的 2000 个值
for i = 1:num_k(kk)-1
    y(i) = x(i);
end

for i =num_k(kk): length ( x) 
    
    for k = 0:num_k(kk)-1
        y(i) = y(i) + x(i-k);
    end
    y(i) = y(i)/num_k(kk);
end
figure (4)
plot (y, 'linewidth' , 1)
set(gca,'linewidth',2,'fontsize',20);
title ( ' 基于 x(t) 数值的 y(t) 的数据图 ' )
xlabel ('t' )
ylabel ('y(t)')

%%
%7 
%%按照步骤三中设定的 ytp 的取值个数，将每个 ytp 与 y(t) ，t=1,2,, ?,2000 比较
%%按照超限即报警的规则，计算 FAR和 MAR，画出 ROC曲线，计算最优的 ytp 取值，以及相应的 MAR和 FAR
n_FAR=zeros ( 1, Num); %产生的误报警的个数n_FAR
n_MAR=zeros ( 1, Num); %产生的漏报警的个数n_MAR

for i =1: Num % 对每个 ytp 的值，都对正常的 1000 个 y(t) 的值比较一遍
    for j =1: 1000
        if y( j )>= ytp ( i ) % 当 y 处于正常状态， 但是 y 取值超过 ytp（误报） ，对每个 ytp 的值，取 1000 个正常点比较
        n_FAR ( i )= n_FAR(i )+ 1; % 计算在 ytp(i) 这个阈值下， 误报的个数， 保存对应 ytp 的值的误报个数
        end
    end 
end

for i =1: Num %对每个 ytp 的值，都对正异常的 1000 个 y(t) 的值比较一遍
    for j =1001: 2000
        if y( j )< ytp ( i ) % 当 y 处于异常状态， 但是 y 取值没有超过 ytp（漏报）
        n_MAR ( i )= n_MAR(i )+ 1; % 计算在 ytp(i) 这个阈值下，漏报的个数
        end
    end 
end

FAR1=n_FAR/ 1000; %误报率
MAR1=n_MAR/ 1000; %漏报率
    for i =1: Num
        R1 (i )=(( FAR1( i ))^ 2+( MAR1( i ))^ 2)^ 0.5 ; %综合值
    end

[ s1, sn1]= sort ( R1); %排序
yotp1 =ytp ( sn1( 1)); %sn1(1) 为 yotp 在 ytp 向量中的位置，也是进行排序后 R 数组的最小值
display ( yotp1 );
oFAR1=FAR1(sn1(1)); %最优 FAR1
oMAR1 =MAR1 (sn1(1)); %最优 MAR1
far_t(kk) = oFAR1;
mar_t(kk) =oMAR1;

figure ( 5)
plot (FAR1, MAR1 , 'linewidth' , 2) ;grid;
set(gca,'linewidth',2,'fontsize',20);
title ( ' 数值比较法求滑动平均滤波法 ROC曲线 ' )
hold on 
plot(FAR1( sn1( 1)), MAR1 ( sn1( 1)),'r*');
text (FAR1( sn1( 1)), MAR1 ( sn1( 1)), '最优阈值点 ' , 'FontSize' , 12);
xlabel (' 利用 y(t) 数值的 FAR1');
ylabel (' 利用 y(t) 数值的 MAR1'); 
%%
%ADD = (Td1 + Td2 + ... +TdN)/N Td = ta - t0
Td_sav = zeros(1,10);
%最优门限 0.7508
optx = yotp1;
for i = 1:10
    x_nor_tes =normrnd ( Norm_st, Sigma_1 , 1, 1000); %正常状态下的 1000 个点
    x_abnor_tes =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% 产生异常状态下的 1000 个点
    x_test=[ x_nor_tes , x_abnor_tes ];
    ys = zeros(1,2000);
for ii = 1:num_k(kk)-1
    ys(ii) = x_test(ii);
end

for ii =num_k(kk): length ( x_test) 
    
    for k = 0:num_k(kk)-1
        ys(ii) = ys(ii) + x_test(ii-k);
    end
    ys(ii) = ys(ii)/num_k(kk);
end
    for j = 1:2000
       if(ys(j)>optx)
           ys(j) = 1;
       else
           ys(j) = 0;
       end   
    end
   %x_test = x_test-optx;
   % x_test = x_test./abs(x_test);
   % x_test = (x_test+ones(1,2000))./2;
    
    tep = 1001;
    t0  = 1001;
    while(~ys(tep))
    tep = tep+1;
    end
    ta = tep;
 
  Td_sav(i) = ta-t0;
end
    ADD_1 = sum(Td_sav)/10;
    ADD_2 = 1*oMAR/(1-oMAR);%add为h*far/mar
    add_t(kk) = ADD_1;
     add_g(kk) = ADD_2;
    display(ADD_1);
    display(ADD_2);
end
figure(7)
subplot(2,2,1)
bar(far_t);
title('实验法FAR')
set(gca,'XTickLabel',{'3阶滤波','7阶滤波','9阶滤波','15阶滤波'});
subplot(2,2,2)
bar(far_g);
title('概率法FAR')
set(gca,'XTickLabel',{'3阶滤波','7阶滤波','9阶滤波','15阶滤波'});
subplot(2,2,3)
bar(mar_t);
title('实验法MAR')
set(gca,'XTickLabel',{'3阶滤波','7阶滤波','9阶滤波','15阶滤波'});
subplot(2,2,4)
bar(mar_g);
title('概率法MAR')
set(gca,'XTickLabel',{'3阶滤波','7阶滤波','9阶滤波','15阶滤波'});
figure(8)
bar(add_t);
title('实验法ADD')
set(gca,'XTickLabel',{'3阶滤波','7阶滤波','9阶滤波','15阶滤波'});

