clc
clear %%% 清空所有历史程序的记录
%%% 步骤一：设定 x(t) 在正常状态和异常状态下的统计分布 , 即 x(t) 的正态分布参数
mux1=0.12 ;    %%% 正常状态的均值 mux1=0.12;
mux2=1+mux1;   %%% 异常状态的均值 mux2=1.12;
sigmax1 =1.2 ; %%% 正常状态的标准差 sigmax1=1.2;
sigmax2 =sigmax1 ; %%% 异常状态的标准差 sigmax2=1.2;

%%% 步骤二：设计与 x(t) 对应的 3 阶滑动平均滤波器，即 y(t) 随 x(t) 的正态分布参数；
muy1=mux1; %%% 和原来相同
muy2=mux2; %%% 和原来相同
sigmay1 =sigmax1 /( 3^0.5 ); %%% 等于原来的值除以根号下 3
sigmay2 =sigmax2 /( 3^0.5 ); %%% 等于原来的值除以根号下 3

%%% 步骤三：在概率密度已知情况下，设定所需遍历的 ytp 的取值及个数
%%%ytp为把测量的 y(t) 转换为警报值的阈值
I_l =muy1-3*sigmay1 ; %%% 设定 xtp 取值范围为区间 I 的左端点
I_r =muy2+3*sigmay2 ; %%% 设定 xtp 取值范围为区间 I 的右端点
ytp =I_l : 0.1 : I_r ; %%% 在区间 I 中每间隔 0.1 取一个点作为 xtp 的取值
Num=length (ytp );     %%%Num=( μ2+3σ2)-( μ1-3 σ1)/0.1 个 xtp 的取值点

FAR = zeros(1,Num);
%%% 步骤四：在概率密度已知情况下，画出关于 FAR和 MAR的 ROC曲线并找到最优的 ytp 取值
for i =1: Num %%% 对每一个 ytp 数组中的值循环
    FAR ( i )= 1-cdf ( 'norm' , ytp ( i ), muy1, sigmay1 ); %%% 利用函数指令 cdf 计算 FAR的定积分，
    %cdf （）函数计算从负无穷到 ytp(i) 下曲线和横坐标轴围成的面积， norm 代指正态分布函数
    MAR ( i )= cdf ('norm' , ytp ( i ), muy2, sigmay2 ); %%% 利用函数指令 cdf 计算 MAR的定积分，异常分布曲线中漏掉的部分，即 MAR值
R ( i )=(( FAR( i ))^ 2+( MAR( i ))^ 2)^ 0.5 ; %%% 计算 ROC曲线上每个点和原点(FAR=0，MAR=0)%的距离
end
[ s, sn]= sort ( R); %%% 将 R数组取值从小到大进行排序生成序列 s，sn 为 s 中元素在原来 R
%中的位置
yotp =ytp (sn( 1)); %%%sn(1) 为 yotp 在 ytp 向量中的位置，是最优的 ytp 取值
display( yotp ); %%% 向控制台输出 yotp 值
oFAR=FAR(sn( 1)); %%% 计算最优阈值下的最优 FAR
oMAR=MAR(sn( 1)); %%% 计算最优阈值下的最优 MAR
%===================================%
%==定积分法求滑动平均滤波法的 ROC曲线 ==%
%===================================%
figure ( 1) %%% 画出 ROC曲线图
plot (FAR, MAR, 'linewidth' , 2) %%% 设定 ROC曲线的 X 和 Y 轴分别为 FAR和 MAR
title ( ' 定积分法求滑动平均滤波法的 ROC曲线 ' ) %%% 加注图的标题
text (FAR(sn( 1)), MAR( sn( 1)), ' \leftarrow 最优阈值点 ' , 'FontSize' , 12) %%% 标注最优点
xlabel ('y(t) 的 FAR'); %%% 加注图 X 坐标名称 FAR
ylabel ('y(t) 的 MAR'); %%% 加注图 Y 坐标名称 FAR
%%% 步骤五：利用 x(t) 的概率密度函数，产生正常情况 1000 个点，异常情况 1000 个点，组成采样序列 , 并画出 x(t) 图形
x_nor =normrnd ( mux1, sigmax1 , 1, 1000); %%% 产生正常状态下的 1000 个点（normal ）,normrnd() 函数返回对应正态分布的随机点
x_abnor =normrnd ( mux2, sigmax2 , 1, 1000); %%% 产生异常状态下的 1000 个点（ abnormal ）
x=[ x_nor , x_abnor ];
%===================================%
%====利用正态分布随机值的 x(t) 图像 ====%
%===================================%
figure ( 2)
plot (x, 'linewidth' , 1)
title ( 'x(t) 的采样数据 ' ) %%%% 加注图的标题
xlabel ('t' ); %%% 加注图 X坐标名称 t
ylabel ('x(t)' ); %%% 加注图 Y坐标名称 x(t)
%%% 步骤六：由步骤五中产生的 x(t) 序列产生 y(t) 序列，并画出 y(t) 图形；
%%%% 其中 y(t)=((x(t)+x(t-1)+x(t-2))/3; 其中 n=3,t=n,n+1,n+2......
y=zeros ( 1, length ( x)); %%% 初始化 y 数组的 2000 个值
y( 1)= x(1); %%%y(t)的头几个值和 x(t) 相同
y( 20)= x( 2);
for i =3: length ( x) %%% 循环赋值
y ( i )=( x( i )+ x( i - 1)+ x(i - 2))/ 3;
end
%===================================%
%===利用随机 x(t) 的值产生的 y(t) 图像 ===%
%===================================%
figure (3)
plot (y, 'linewidth' , 1)
title ( ' 基于 x(t) 数值的 y(t) 的数据图 ' )
xlabel ('t' )
ylabel ('y(t)' )


%%% 步骤七：按照步骤三中设定的 ytp 的取值个数，将每个 ytp 与 y(t) ，t=1,2,, ?,2000 比较
%%% 按照超限即报警的规则，计算 FAR和 MAR，画出 ROC曲线，计算最优的 ytp 取值，以及相应的 MAR和 FAR
n_FAR=zeros ( 1, Num); %%% 设定对于每个 ytp 取值，产生的误报警的个数n_FAR，并初始化计数值为 0
n_MAR=zeros ( 1, Num); %%% 设定对于每个 ytp 取值，产生的漏报警的个数n_MAR，并初始化计数值为 0
for i =1: Num %%% 对每个 ytp 的值，都对正常的 1000 个 y(t) 的值比较一遍
    for j =1: 1000
        if y( j )>= ytp ( i ) %%% 当 y 处于正常状态， 但是 y 取值超过 ytp（误报） ，对每个 ytp 的值，取 1000 个正常点比较
        n_FAR ( i )= n_FAR(i )+ 1; %%% 计算在 ytp(i) 这个阈值下， 误报的个数， 保存对应 ytp 的值的误报个数
        end
    end %%%FAR1(i)=n_FAR(i)/1000; 添加于此，也可以
end
for i =1: Num %%% 对每个 ytp 的值，都对正异常的 1000 个 y(t) 的值比较一遍
    for j =1001: 2000
        if y( j )< ytp ( i ) %%% 当 y 处于异常状态， 但是 y 取值没有超过 ytp（漏报）
        n_MAR ( i )= n_MAR(i )+ 1; %%% 计算在 ytp(i) 这个阈值下，漏报的个数
        end
    end %%% MAR1(i)=n_MAR(i)/1000 添加与此，也可以
end
FAR1=n_FAR/ 1000; %%% 对数组中的每个值都除以 1000, 即计算每个 ytp 下的误报率
MAR1=n_MAR/ 1000; %%% 对数组中的每个值都除以 1000, 即计算每个 ytp 下的漏报率
    for i =1: Num
    R1 (i )=(( FAR1( i ))^ 2+( MAR1( i ))^ 2)^ 0.5 ; %%% 计算 ROC曲线上每个点和原点 (FAR=0，MAR=0)的距离 , 即综合值
    end
[ s1, sn1]= sort ( R1); %%% 将 R1取值从小到大进行排序生成序列 s1，sn1() 返回 s1 中元素在原来 R 中的位置；
yotp1 =ytp ( sn1( 1)); %%%sn1(1) 为 yotp 在 ytp 向量中的位置，也是进行排序后 R 数组的最小值
display ( yotp1 ); %%% 向控制台输出 yotp1 值
oFAR1=FAR1(sn1(1)); %%% 计算最优阈值下的最优 FAR1
oMAR1 =MAR1 (sn1(1)); %%% 计算最优阈值下的最优 MAR1
%===================================%
%===利用 y(t) 的具体数值得到 ROC图像 ====%
%===================================%
figure ( 4) %%% 画出 ROC曲线图
plot (FAR1, MAR1 , 'linewidth' , 2) %%% 设定 ROC曲线的 X和 Y轴分别为 FAR1和MAR1
title ( ' 数值比较法求滑动平均滤波法 ROC曲线 ' ) %%% 加注图的标题
text (FAR1( sn1( 1)), MAR1 ( sn1( 1)), ' \leftarrow 最优阈值点 ' , 'FontSize' , 12)
xlabel (' 利用 y(t) 数值的 FAR1'); %%% 加注图 X坐标名称 FAR1
ylabel (' 利用 y(t) 数值的 MAR1'); %%% 加注图 Y坐标名称 MAR2