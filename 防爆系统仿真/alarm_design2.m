clc
clear %%% ���������ʷ����ļ�¼


%%
%1 �趨x(t) ����̬�ֲ�����
%18061319���գ�1998.06.16 
Norm_st=0.16 ;    %����״̬�ľ�ֵ
Sigma_1 =1.16 ;    %����״̬�ı�׼��
ABNorm_st=1+Norm_st;   %�쳣״̬�ľ�ֵ
Sigma_2 =Sigma_1 ; %�쳣״̬�ı�׼��
%%
%%2 x(t) ��Ӧ�� 3 �׻���ƽ���˲�����y(t)��̬�ֲ�������
%����ƽ���˲�������żȻ���
muy1=Norm_st; 
muy2=ABNorm_st; 
ssigma_1 =Sigma_1 /( 3^0.5 );%�����������С ��С©����
ssigma_2 =Sigma_2 /( 3^0.5 ); 
In_left =muy1-3*ssigma_1 ; %ȡֵ��Χ��˵�
In_right =muy2+3*ssigma_2 ;  %ȡֵ��Χ�Ҷ˵�
ytp =In_left : 0.1 : In_right ; %xtp ��ȡֵ
Num=length (ytp );%Num=( ��2+3��2)-( ��1-3 ��1)/0.1 �� xtp ��ȡֵ��

FAR = zeros(1,Num);
MAR = zeros(1,Num);
%%
%3  FAR��MAR�� ROC���� ytp����ֵ
for i =1: Num  
    FAR ( i )= 1-cdf ( 'norm' , ytp ( i ), muy1, ssigma_1 ); %cdf ���㶨����
    MAR ( i )= cdf ('norm' , ytp ( i ), muy2, ssigma_2 ); 
R ( i )=(( FAR( i ))^ 2+( MAR( i ))^ 2)^ 0.5 ; %���� ROC������ÿ�����ԭ��(FAR=0��MAR=0)%�ľ���
end
[ s, sn]= sort ( R); %��С�������� s��sn Ϊ s ��Ԫ����ԭ�� R�е�λ��
yotp =ytp (sn( 1)); %s1 Ϊ��Сֵ ������
display( yotp ); 
oFAR=FAR(sn( 1)); %���� FAR
oMAR=MAR(sn( 1)); %���� MAR
figure ( 1) 
subplot(1,3,2)
plot (FAR, MAR, 'linewidth' , 2) 
title ( ' �����ַ��󻬶�ƽ���˲����� ROC���� ' );
hold on
plot(FAR(sn( 1)), MAR( sn( 1)),'r*')
text (FAR(sn( 1)), MAR( sn( 1)), '������ֵ�� ' , 'FontSize' , 12) 
xlabel ('y(t) �� FAR'); 
ylabel ('y(t) �� MAR');

%%
%4
x_nor =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
x_abnor =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
x=[ x_nor , x_abnor ];
%figure ( 2)
subplot(1,3,1)
plot (x, 'linewidth' , 1)
title ( 'x(t) �Ĳ������� ' ) 
xlabel ('t' ); 
ylabel ('x(t)' ); 

%% ���� y(t)=x(t)
y=zeros ( 1, length ( x)); %��ʼ�� y ����� 2000 ��ֵ
y = x;
%%
%7 
%%���ղ��������趨�� ytp ��ȡֵ��������ÿ�� ytp �� y(t) ��t=1,2,, ?,2000 �Ƚ�
%%���ճ��޼������Ĺ��򣬼��� FAR�� MAR������ ROC���ߣ��������ŵ� ytp ȡֵ���Լ���Ӧ�� MAR�� FAR
n_FAR=zeros ( 1, Num); %�������󱨾��ĸ���n_FAR
n_MAR=zeros ( 1, Num); %������©�����ĸ���n_MAR

for i =1: Num % ��ÿ�� ytp ��ֵ������������ 1000 �� y(t) ��ֵ�Ƚ�һ��
    for j =1: 1000
        if y( j )>= ytp ( i ) % �� y ��������״̬�� ���� y ȡֵ���� ytp���󱨣� ����ÿ�� ytp ��ֵ��ȡ 1000 ��������Ƚ�
        n_FAR ( i )= n_FAR(i )+ 1; % ������ ytp(i) �����ֵ�£� �󱨵ĸ����� �����Ӧ ytp ��ֵ���󱨸���
        end
    end 
end

for i =1: Num %��ÿ�� ytp ��ֵ���������쳣�� 1000 �� y(t) ��ֵ�Ƚ�һ��
    for j =1001: 2000
        if y( j )< ytp ( i ) % �� y �����쳣״̬�� ���� y ȡֵû�г��� ytp��©����
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
yotp1 =ytp ( sn1( 1)); %sn1(1) Ϊ yotp �� ytp �����е�λ�ã�Ҳ�ǽ�������� R �������Сֵ
display ( yotp1 );
oFAR1=FAR1(sn1(1)); %���� FAR1
oMAR1 =MAR1 (sn1(1)); %���� MAR1

%figure ( 4)
subplot(1,3,3)
plot (FAR1, MAR1 , 'linewidth' , 2) 
title ( ' ��ֵ�ȽϷ��󻬶�ƽ���˲��� ROC���� ' )
hold on 
plot(FAR1( sn1( 1)), MAR1 ( sn1( 1)),'r*');
text (FAR1( sn1( 1)), MAR1 ( sn1( 1)), '������ֵ�� ' , 'FontSize' , 12);
xlabel (' ���� y(t) ��ֵ�� FAR1');
ylabel (' ���� y(t) ��ֵ�� MAR1'); 
%%
%ADD = (Td1 + Td2 + ... +TdN)/N Td = ta - t0
Td_sav = zeros(1,10);
%�������� 0.7508
optx = 0.7508;
for i = 1:10
    x_nor_tes =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
    x_abnor_tes =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
    x_test=[ x_nor_tes , x_abnor_tes ];
    
    for j = 1:2000
       if(x_test(j)>optx)
           x_test(j) = 1;
       else
           x_test(j) = 0;
       end   
    end
   %x_test = x_test-optx;
   % x_test = x_test./abs(x_test);
   % x_test = (x_test+ones(1,2000))./2;
    
    tep = 1001;
    t0  = 1001;
    while(~x_test(tep))
    tep = tep+1;
    end
    ta = tep;
 
  Td_sav(i) = ta-t0;
end
    ADD_1 = sum(Td_sav)/10;
    ADD_2 = 1*oFAR1/oMAR1;
    display(ADD_1);
    display(ADD_2);
