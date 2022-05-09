#include"fileRead.h"
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <wiringSerial.h>
#include <wiringPi.h>
#include "hardWare.h"

void readAndPut(const char * str,int flag){
    int fd = 0;
    char buff[1024 * 10];
    char cmd[12][119];
    int i = 0;
    int sd;
    int count=0;
    float dis=10;
    
	  while(-1==(sd=serialOpen("/dev/ttyAMA0",115200))){
		    printf("Open fail\n");
		    delay(500);
	  }
    fd = open(str, O_RDONLY);

    char *locate;
    read(fd, buff, sizeof(buff));
    locate = strstr(buff, "G0000");
    memset(cmd, 0, sizeof(cmd));

    for(i = 0; i < 25; i++) {
        memcpy(&cmd[i], locate, 118);
        locate += 120;
    }

        for(i = 0; i < 25; i++)
        {   if(flag==0&&i==10)return;
            else if(flag==1&&i==3) return ;
            else if(flag==2&&i==5) return ;
            else if(flag==3&&i==22) return ;
            else if(flag==4) {
              serialPrintf(sd,"#000P1500T1000!#001P1500T1000!#002P1500T1000!#003P1500T1000!#004P1500T1000!#005P1500T1000!#006P1500T1000!");
              delay(2000);
              return;
              }
            serialPrintf(sd,cmd[i]);
            printf("ACTION%d\n",i);
            if(flag==1){              
                delay(1000);
                continue;
                }
            
            if(flag==0||flag==2){    
                  while(count<60){
                    dis=disMeasure();
                    //printf("%f0.3\n",dis);
                    if(dis<10&&flag!=1){
		                serialPrintf(sd,"#000P1500T1000!#001P1500T1000!#002P1500T1000!#003P1500T1000!#004P1500T1000!#005P1500T1000!#006P1500T1000!");
                    printf("Obstacle detected in %0.2f cm\n",dis);
                    delay(100);
                    return ;
                    }
                    
                      count++;
                      delay(10);
                  }
            
                  count=0;
                  }
                  if(flag==3){
                    delay(800);
                  }
            }

}
