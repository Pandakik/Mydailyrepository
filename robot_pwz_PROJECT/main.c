#include"hardWare.h"
#include<stdio.h>
#include<wiringPi.h>
#include"fileRead.h"
#include"wiringSerial.h"
#include<wiringPiI2C.h>
#include<math.h>
#include <sys/types.h>	       /* See NOTES */
#include <sys/socket.h>
#include <arpa/inet.h>
#include <ctype.h>
#include <unistd.h>
#include <strings.h>

#define	SlaveAddress	0x48
#define SER_IP "192.168.12.1"
#define SER_POET 24444



int main(){

    int ser_fd, cli_fd;
    struct sockaddr_in seraddr, cliaddr;
    socklen_t cliaddr_len;
    char buf[BUFSIZ], clie_ip[BUFSIZ];
    int n, i;

    myInit();
    
    int fd = wiringPiI2CSetup(SlaveAddress);
    while(-1==fd){
		    printf("Open fail\n");
		    delay(500);
    }
    
    ser_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    if(ser_fd == -1) perror("socket");
        
	  bzero(&seraddr,sizeof(seraddr));
    seraddr.sin_family = AF_INET;
    seraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    seraddr.sin_port = htons(SER_POET);
    
    bind(ser_fd, (struct sockaddr *)&seraddr, sizeof(seraddr));

    
    listen(ser_fd, 128);
    
    cliaddr_len = sizeof(cliaddr);
    cli_fd = accept(ser_fd, (struct sockaddr *)&cliaddr, &cliaddr_len);

    printf("client ip:%s,client port:%d\n",
    inet_ntop(AF_INET, &cliaddr.sin_addr.s_addr, clie_ip, sizeof(clie_ip)),
    ntohs(cliaddr.sin_port));
    while(1) {
      n = read(cli_fd, buf, sizeof(buf)); 
      int x=getDip(fd,0);
      int y=getDip(fd,1);
      int z=getDip(fd,2);
      x=getDip(fd,0);
      y=getDip(fd,1);
      z=getDip(fd,2);
      printf("x:%03d, y:%03d, z:%03d\n",x,y,z);
      if(x<73){
            readAndPut("./getUpFront.ini",1);
            delay(1000);
            buf[0]='0';
            continue;
      }else if(x>100){
            readAndPut("./getUpBack.ini",1);
            delay(1000);
            buf[0]='0';
            continue;
      }
           
             
       //write(cli_fd, buf, n);
        
        if(buf[0]=='E'){
          readAndPut("./forward.ini",0);
          buf[0]='0';
        }else if(buf[0]=='K'){
          readAndPut("./backward.ini",0);
          buf[0]='0';
        }else if(buf[0]=='G'){
          readAndPut("./turnLeft.ini",2);
          buf[0]='0';
        }else if(buf[0]=='I'){
          readAndPut("./turnRight.ini",2);
          buf[0]='0';
        }else if(buf[0]=='H'){
          readAndPut("./dance.ini",3);
          buf[0]='0';
        }else if(buf[0]=='B'){
          readAndPut("./dance.ini",4);
          buf[0]='0';
        }
    }
    close(ser_fd);
    close(cli_fd);

    	return 0;
}
