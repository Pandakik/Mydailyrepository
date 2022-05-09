#include"hardWare.h"
#include<stdio.h>
#include<wiringPi.h>
#include<sys/time.h>
#include<wiringPiI2C.h>


void myInit(){
    wiringPiSetup();
    //wiringPiI2CSetup()
    pinMode(Pin_LED,OUTPUT);
    pinMode(Pin_BEEP,OUTPUT);
    pinMode(Pin_TRIG,OUTPUT);
    pinMode(Pin_KEY01,INPUT);
    pinMode(Pin_KEY02,INPUT);
    pinMode(Pin_ECHO,INPUT); 
}

float disMeasure(){
	struct timeval tv1;
	struct timeval tv2;
	
	digitalWrite(Pin_TRIG,LOW);
	delay(10);
	digitalWrite(Pin_TRIG,HIGH);
	delay(10);
	digitalWrite(Pin_TRIG,LOW);
	
	while(!(digitalRead(Pin_ECHO)==1))
	gettimeofday(&tv1,NULL);
	while(!(digitalRead(Pin_ECHO)==0))
	gettimeofday(&tv2,NULL);
	
	float start,stop;
	start=tv1.tv_sec*1000000+tv1.tv_usec;
	stop=tv2.tv_sec*1000000+tv2.tv_usec;
	float dis=(stop-start)/1000000*34000/2;
	
	return dis;
	
	
}

int getDip(int F_fd,int flag)
{  
  int a=0;
	if  (flag==0)
 {
   wiringPiI2CWriteReg8(F_fd,SlaveAddress,0x40);
   a=wiringPiI2CReadReg8(F_fd,0x40);
 }
 else if  (flag==1)
 {
   wiringPiI2CWriteReg8(F_fd,SlaveAddress,0x41);
   a=wiringPiI2CReadReg8(F_fd,0x41);
 }
 else if  (flag==2)
 {
   wiringPiI2CWriteReg8(F_fd,SlaveAddress,0x42);
   a=wiringPiI2CReadReg8(F_fd,0x42);
 }
 return a;
}

























