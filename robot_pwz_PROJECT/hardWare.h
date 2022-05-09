#ifndef _HARDWARE_H_
#define _HARDWARE_H_


#define Pin_TRIG 0
#define Pin_ECHO 1
#define Pin_XOUT 3
#define Pin_YOUT 4
#define Pin_LED 7
#define Pin_KEY01 5
#define Pin_KEY02 6
#define Pin_BEEP 29
#define	SlaveAddress	0x48





float disMeasure(void);
void myInit(void);
int getDip(int F_fd,int flag);


#endif
