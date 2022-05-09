clc
clear %%% ���������ʷ����ļ�¼
%%
%1 �趨x(t) ����̬�ֲ�����
%18061319���գ�1998.06.16 
Norm_st=0.16 ;    %����״̬�ľ�ֵ
Sigma_1 =1.2;    %����״̬�ı�׼��
ABNorm_st=1+Norm_st;   %�쳣״̬�ľ�ֵ
Sigma_2 =Sigma_1 ; %�쳣״̬�ı�׼��

%%
%������̫�ֲ�ͼ
xt= -4 : 0.1 :4; %��ʼ��
yt1=normpdf(xt,Norm_st,Sigma_1);%��̫�ֲ��������
yt2=normpdf(xt,ABNorm_st,Sigma_2);%��̬�ֲ��������
figure(1);%��ͼ
plot(xt,yt1,'linewidth',2);grid;%��ͼ �߿�2
hold on %����
plot(xt,yt2,'*-','linewidth',2);%���ڶ���ͼ
title('��̬�ֲ�ͼ')%����
legend('����','�쳣')%ͼ��
%%%
%%
%��ʼ��
muy1=Norm_st; 
muy2=ABNorm_st; 
ssigma_1 =Sigma_1 ;
ssigma_2 =Sigma_2 ;

In_left =muy1-3*ssigma_1 ; %ȡֵ��Χ��˵�
In_right =muy2+3*ssigma_2 ;  %ȡֵ��Χ�Ҷ˵�
xtp =In_left : 0.1 : In_right ; %xtp ��ȡֵ
Num=length (xtp );%Num=( ��2+3��2)-( ��1-3 ��1)/0.1 �� xtp ��ȡֵ��

FAR = zeros(1,Num);%��ʼ��Ϊ0
MAR = zeros(1,Num);%��ʼ��Ϊ0
%%
%3  FAR��MAR�� ROC���� ytp����ֵ
for i =1: Num  %ѭ������ÿ��xtp��cdf������ far mar
    FAR ( i )= 1-cdf ( 'norm' , xtp ( i ), muy1, ssigma_1 ); %cdf ���㶨����
    MAR ( i )= cdf ('norm' , xtp ( i ), muy2, ssigma_2 ); 
R ( i )=(( FAR( i ))^ 2+( MAR( i ))^ 2)^ 0.5 ; %���� ROC������ÿ�����ԭ��(FAR=0��MAR=0)%�ľ���
end
[ s, sn]= sort ( R); %��С�������� s��sn Ϊ s ��Ԫ����ԭ�� R�е�λ��
otp =xtp (sn( 1)); %s1 Ϊ��Сֵ ������
display( otp ); %���otp
oFAR=FAR(sn( 1)); %���� FAR
oMAR=MAR(sn( 1)); %���� MAR
figure(2)%��ͼ
%subplot(2,2,1)
plot (FAR, MAR, 'linewidth' , 2) %��ͼ
grid;%������
title ( ' �����ַ���ROC���� ' );%����
hold on%����
plot(FAR(sn( 1)), MAR( sn( 1)),'r*')%��ͼ
text (FAR(sn( 1)), MAR( sn( 1)), '������ֵ�� ' , 'FontSize' , 12) %�������
xlabel (' FAR'); %������
ylabel ('MAR');%������

%%
%4
x_nor =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
x_abnor =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
x=[ x_nor , x_abnor ];
figure ( 3)
%subplot(2,2,3)
plot (x, 'linewidth' , 1)
title ( 'x(t) �Ĳ������� ' ) 
xlabel ('t' ); 
ylabel ('x(t)' ); 

%%
n_FAR=zeros ( 1, Num); %�������󱨾��ĸ���n_FAR
n_MAR=zeros ( 1, Num); %������©�����ĸ���n_MAR

for i =1: Num % ��ÿ��xtp ��ֵ������������ 1000 �� y(t) ��ֵ�Ƚ�һ��
    for j =1: 1000
        if x( j )>= xtp ( i ) % �� y ��������״̬�� ���� y ȡֵ���� ytp���󱨣� ����ÿ�� ytp ��ֵ��ȡ 1000 ��������Ƚ�
        n_FAR ( i )= n_FAR(i )+ 1; % ������ ytp(i) �����ֵ�£� �󱨵ĸ����� �����Ӧ ytp ��ֵ���󱨸���
        end
    end 
end

for i =1: Num %��ÿ�� ytp ��ֵ���������쳣�� 1000 �� y(t) ��ֵ�Ƚ�һ��
    for j =1001: 2000
        if x( j )< xtp ( i ) % �� y �����쳣״̬�� ���� y ȡֵû�г��� ytp��©����
        n_MAR ( i )= n_MAR(i )+ 1; % ������ ytp(i) �����ֵ�£�©���ĸ���
        end
    end 
end

FAR1=n_FAR/ 1000; %����
MAR1=n_MAR/ 1000; %©����
    for i =1: Num
        R1 (i )=(( FAR1( i ))^ 2+( MAR1( i ))^ 2)^ 0.5 ; %�ۺ�ֵ
    end

[ s1, sn1]= sort ( R1); %����
xotp1 =xtp ( sn1( 1)); %sn1(1) Ϊ yotp �� ytp �����е�λ�ã�Ҳ�ǽ�������� R �������Сֵ
display ( xotp1 );
oFAR1=FAR1(sn1(1)); %���� FAR1
oMAR1 =MAR1 (sn1(1)); %���� MAR1

figure ( 3)
%subplot(2,2,4)
plot (FAR1, MAR1 , 'linewidth' , 2) %��ͼ
grid;
title ( ' ��ֵ�ȽϷ���ROC���� ' )
hold on 
plot(FAR1( sn1( 1)), MAR1 ( sn1( 1)),'r*');%��ͼ
text (FAR1( sn1( 1)), MAR1 ( sn1( 1)), '������ֵ�� ' , 'FontSize' , 12);
xlabel ('FAR1');
ylabel ('MAR1'); 
%%
%ADD = (Td1 + Td2 + ... +TdN)/N Td = ta - t0
Td_sav = zeros(1,10);%��ʼ��
%�������� 0.7508
optx = xotp1;
for i = 1:10
    x_nor_tes =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
    x_abnor_tes =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
    x_test=[ x_nor_tes , x_abnor_tes ];
    
    for j = 1:2000 %�Ƚ�������ֵoptx ���������ֵ������1����������������0��������������
       if(x_test(j)>otp)
           x_test(j) = 1;
       else
           x_test(j) = 0;
       end   
    end
    
    tep = 1001;
    t0  = 1001;
    while(~x_test(tep))%��1001��ʼ��������һ��������ʱ��
    tep = tep+1;
    end
    ta = tep;
   Td_sav(i) = ta-t0;%�ӳ�ʱ��
end

    ADD_1 = sum(Td_sav)/10;%addΪtd��ֵ
    ADD_2 = 1*oMAR/(1-oMAR);%addΪh*far/mar
    display(ADD_1);%���
    display(ADD_2);%���