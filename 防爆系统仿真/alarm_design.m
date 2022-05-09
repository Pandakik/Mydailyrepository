clc
clear %%% 清空所有历史程序的记录
%%
%1 设定x(t) 的正态分布参数
%18061319生日：1998.06.16 
Norm_st=0.16 ;    %正常状态的均值
Sigma_1 =1.2;    %正常状态的标准差
ABNorm_st=1+Norm_st;   %异常状态的均值
Sigma_2 =Sigma_1 ; %异常状态的标准差

%%
%绘制正太分布图
xt= -4 : 0.1 :4; %初始化
yt1=normpdf(xt,Norm_st,Sigma_1);%正太分布随机变量
yt2=normpdf(xt,ABNorm_st,Sigma_2);%正态分布随机变量
figure(1);%画图
plot(xt,yt1,'linewidth',2);grid;%画图 线宽2
hold on %保持
plot(xt,yt2,'*-','linewidth',2);%画第二个图
title('正态分布图')%标题
legend('正常','异常')%图例
%%%
%%
%初始化
muy1=Norm_st; 
muy2=ABNorm_st; 
ssigma_1 =Sigma_1 ;
ssigma_2 =Sigma_2 ;

In_left =muy1-3*ssigma_1 ; %取值范围左端点
In_right =muy2+3*ssigma_2 ;  %取值范围右端点
xtp =In_left : 0.1 : In_right ; %xtp 的取值
Num=length (xtp );%Num=( μ2+3σ2)-( μ1-3 σ1)/0.1 个 xtp 的取值点

FAR = zeros(1,Num);%初始化为0
MAR = zeros(1,Num);%初始化为0
%%
%3  FAR和MAR的 ROC曲线 ytp最优值
for i =1: Num  %循环计算每个xtp的cdf来计算 far mar
    FAR ( i )= 1-cdf ( 'norm' , xtp ( i ), muy1, ssigma_1 ); %cdf 计算定积分
    MAR ( i )= cdf ('norm' , xtp ( i ), muy2, ssigma_2 ); 
R ( i )=(( FAR( i ))^ 2+( MAR( i ))^ 2)^ 0.5 ; %计算 ROC曲线上每个点和原点(FAR=0，MAR=0)%的距离
end
[ s, sn]= sort ( R); %大到小排列序列 s，sn 为 s 中元素在原来 R中的位置
otp =xtp (sn( 1)); %s1 为最小值 即最优
display( otp ); %输出otp
oFAR=FAR(sn( 1)); %最优 FAR
oMAR=MAR(sn( 1)); %最优 MAR
figure(2)%画图
%subplot(2,2,1)
plot (FAR, MAR, 'linewidth' , 2) %画图
grid;%网格线
title ( ' 定积分法求ROC曲线 ' );%标题
hold on%保持
plot(FAR(sn( 1)), MAR( sn( 1)),'r*')%画图
text (FAR(sn( 1)), MAR( sn( 1)), '最优阈值点 ' , 'FontSize' , 12) %添加文字
xlabel (' FAR'); %坐标轴
ylabel ('MAR');%坐标轴

%%
%4
x_nor =normrnd ( Norm_st, Sigma_1 , 1, 1000); %正常状态下的 1000 个点
x_abnor =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% 产生异常状态下的 1000 个点
x=[ x_nor , x_abnor ];
figure ( 3)
%subplot(2,2,3)
plot (x, 'linewidth' , 1)
title ( 'x(t) 的采样数据 ' ) 
xlabel ('t' ); 
ylabel ('x(t)' ); 

%%
n_FAR=zeros ( 1, Num); %产生的误报警的个数n_FAR
n_MAR=zeros ( 1, Num); %产生的漏报警的个数n_MAR

for i =1: Num % 对每个xtp 的值，都对正常的 1000 个 y(t) 的值比较一遍
    for j =1: 1000
        if x( j )>= xtp ( i ) % 当 y 处于正常状态， 但是 y 取值超过 ytp（误报） ，对每个 ytp 的值，取 1000 个正常点比较
        n_FAR ( i )= n_FAR(i )+ 1; % 计算在 ytp(i) 这个阈值下， 误报的个数， 保存对应 ytp 的值的误报个数
        end
    end 
end

for i =1: Num %对每个 ytp 的值，都对正异常的 1000 个 y(t) 的值比较一遍
    for j =1001: 2000
        if x( j )< xtp ( i ) % 当 y 处于异常状态， 但是 y 取值没有超过 ytp（漏报）
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
xotp1 =xtp ( sn1( 1)); %sn1(1) 为 yotp 在 ytp 向量中的位置，也是进行排序后 R 数组的最小值
display ( xotp1 );
oFAR1=FAR1(sn1(1)); %最优 FAR1
oMAR1 =MAR1 (sn1(1)); %最优 MAR1

figure ( 3)
%subplot(2,2,4)
plot (FAR1, MAR1 , 'linewidth' , 2) %画图
grid;
title ( ' 数值比较法求ROC曲线 ' )
hold on 
plot(FAR1( sn1( 1)), MAR1 ( sn1( 1)),'r*');%画图
text (FAR1( sn1( 1)), MAR1 ( sn1( 1)), '最优阈值点 ' , 'FontSize' , 12);
xlabel ('FAR1');
ylabel ('MAR1'); 
%%
%ADD = (Td1 + Td2 + ... +TdN)/N Td = ta - t0
Td_sav = zeros(1,10);%初始化
%最优门限 0.7508
optx = xotp1;
for i = 1:10
    x_nor_tes =normrnd ( Norm_st, Sigma_1 , 1, 1000); %正常状态下的 1000 个点
    x_abnor_tes =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% 产生异常状态下的 1000 个点
    x_test=[ x_nor_tes , x_abnor_tes ];
    
    for j = 1:2000 %比较最优阈值optx 如果超过阈值则将其置1，即报警，否则，置0，不产生报警。
       if(x_test(j)>otp)
           x_test(j) = 1;
       else
           x_test(j) = 0;
       end   
    end
    
    tep = 1001;
    t0  = 1001;
    while(~x_test(tep))%从1001开始向后遍历第一个报警的时间
    tep = tep+1;
    end
    ta = tep;
   Td_sav(i) = ta-t0;%延迟时间
end

    ADD_1 = sum(Td_sav)/10;%add为td均值
    ADD_2 = 1*oMAR/(1-oMAR);%add为h*far/mar
    display(ADD_1);%输出
    display(ADD_2);%输出