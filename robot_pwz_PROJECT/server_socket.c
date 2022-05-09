#include <stdio.h>
#include <sys/types.h>	       /* See NOTES */
#include <sys/socket.h>
#include <arpa/inet.h>
#include <ctype.h>
#include <unistd.h>
#include <strings.h>

#define SER_IP "192.168.12.1"
#define SER_POET 24444

int main(int argc, char *argv[])
{   
    int ser_fd, cli_fd;
    struct sockaddr_in seraddr, cliaddr;
    socklen_t cliaddr_len;
    char buf[BUFSIZ], clie_ip[BUFSIZ];
    int n, i;

    
    ser_fd = socket(AF_INET, SOCK_STREAM, 0);
    if(ser_fd == -1)
        perror("socket");
    
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
        //for(i = 0; i < n; i++)
         //   buf[i] = toupper(buf[i]);
         
        write(cli_fd, buf, n);
        

    }

    close(ser_fd);
    close(cli_fd);
    return 0;
}
