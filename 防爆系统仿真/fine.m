clc
clear %%% ���������ʷ����ļ�¼


%%
%1 �趨x(t) ����̬�ֲ�����
%18061319���գ�1998.06.16 
Norm_st=0.16 ;    %����״̬�ľ�ֵ
Sigma_1 =1.2 ;    %����״̬�ı�׼��
ABNorm_st=1+Norm_st;   %�쳣״̬�ľ�ֵ
Sigma_2 =Sigma_1 ; %�쳣״̬�ı�׼��
%%
num_k =  [3 7 9 15];%�˴�Ϊѭ������3��7��9��15�˲���ʱ�Ľ�����ʼ��
far_g = zeros(1,4);%����ĸ������˲����µĸ��ʷ�far
far_t = zeros(1,4);%����ĸ������˲����µ�ʵ�鷨far
mar_g = zeros(1,4);%����ĸ������˲����µĸ��ʷ�mar
mar_t = zeros(1,4);%����ĸ������˲����µ�ʵ�鷨mar
add_t = zeros(1,4);%����ĸ������˲����µ�ʵ�鷨aad
%%
for kk = 1:4%�Ĵ�ѭ���ֱ����3��7��9��15���˲����µ����
%%
%%2 x(t) ��Ӧ�� 3 �׻���ƽ���˲�����y(t)��̬�ֲ�������
%����ƽ���˲�������żȻ���
muy1=Norm_st; 
muy2=ABNorm_st; 
ssigma_1 =Sigma_1 /( num_k(kk)^0.5 );%�����������С ��С©����
ssigma_2 =Sigma_2 /( num_k(kk)^0.5 );
In_left =muy1-3*ssigma_1 ; %ȡֵ��Χ��˵�
In_right =muy2+3*ssigma_2 ;  %ȡֵ��Χ�Ҷ˵�
ytp =In_left : 0.1 : In_right ; %xtp ��ȡֵ
Num=length (ytp );%Num=( ��2+3��2)-( ��1-3 ��1)/0.1 �� xtp ��ȡֵ��


%%
%������̫�ֲ�ͼ
xt= -4 : 0.1 :4;
yt1=normpdf(xt,Norm_st,ssigma_1); 
yt2=normpdf(xt,ABNorm_st,ssigma_2);
figure(1);
plot(xt,yt1,'linewidth',2);grid;
hold on 
plot(xt,yt2,'*-','linewidth',2);
set(gca,'linewidth',2,'fontsize',20);
title('��̬�ֲ�ͼ')
legend('����','�쳣')
%%%

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
far_g(kk) = oFAR;
mar_g(kk) = oMAR;
figure ( 2) 
% subplot(2,2,1)
plot (FAR, MAR, 'linewidth' , 2) ;grid;
title ( ' �����ַ��󻬶�ƽ���˲����� ROC���� ' );
hold on
plot(FAR(sn( 1)), MAR( sn( 1)),'r*')
set(gca,'linewidth',2,'fontsize',20);
text (FAR(sn( 1)), MAR( sn( 1)), '������ֵ�� ' , 'FontSize' , 20) 
xlabel ('y(t) �� FAR'); 
ylabel ('y(t) �� MAR');

%%
%4
x_nor =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
x_abnor =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
x=[ x_nor , x_abnor ];
figure ( 3)
plot (x, 'linewidth' , 1)
set(gca,'linewidth',2,'fontsize',20);
title ( 'x(t) �Ĳ������� ' ) 
xlabel ('t' ); 
ylabel ('x(t)' ); 

%% ���� y(t)=((x(t)+x(t-1)+x(t-2))/3; ���� n=3,t=n,n+1,n+2......
y=zeros ( 1, length ( x)); %��ʼ�� y ����� 2000 ��ֵ
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
title ( ' ���� x(t) ��ֵ�� y(t) ������ͼ ' )
xlabel ('t' )
ylabel ('y(t)')

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
far_t(kk) = oFAR1;
mar_t(kk) =oMAR1;

figure ( 5)
plot (FAR1, MAR1 , 'linewidth' , 2) ;grid;
set(gca,'linewidth',2,'fontsize',20);
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
optx = yotp1;
for i = 1:10
    x_nor_tes =normrnd ( Norm_st, Sigma_1 , 1, 1000); %����״̬�µ� 1000 ����
    x_abnor_tes =normrnd ( ABNorm_st, Sigma_2 , 1, 1000); %%% �����쳣״̬�µ� 1000 ����
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
    ADD_2 = 1*oMAR/(1-oMAR);%addΪh*far/mar
    add_t(kk) = ADD_1;
     add_g(kk) = ADD_2;
    display(ADD_1);
    display(ADD_2);
end
figure(7)
subplot(2,2,1)
bar(far_t);
title('ʵ�鷨FAR')
set(gca,'XTickLabel',{'3���˲�','7���˲�','9���˲�','15���˲�'});
subplot(2,2,2)
bar(far_g);
title('���ʷ�FAR')
set(gca,'XTickLabel',{'3���˲�','7���˲�','9���˲�','15���˲�'});
subplot(2,2,3)
bar(mar_t);
title('ʵ�鷨MAR')
set(gca,'XTickLabel',{'3���˲�','7���˲�','9���˲�','15���˲�'});
subplot(2,2,4)
bar(mar_g);
title('���ʷ�MAR')
set(gca,'XTickLabel',{'3���˲�','7���˲�','9���˲�','15���˲�'});
figure(8)
bar(add_t);
title('ʵ�鷨ADD')
set(gca,'XTickLabel',{'3���˲�','7���˲�','9���˲�','15���˲�'});

