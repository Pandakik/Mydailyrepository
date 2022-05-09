#include <WINSOCK2.H>
#include <STDIO.H>
#include<stdlib.h>


#pragma  comment(lib,"ws2_32.lib")

int main(int argc, char* argv[])
{
	int f = 1,mode=0;
	char  sendData[] = "Send Test!\n";
	char recData[255];
	int ret=-1;
	//初始化WSA
	WORD sockVersion = MAKEWORD(2, 2);
	WSADATA data;
	if (WSAStartup(sockVersion, &data) != 0)
	{
		return 0;
	}
	//创建套接字
	SOCKET sclient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sclient == INVALID_SOCKET)
	{
		printf("invalid socket !");
		return 0;
	}
	//绑定IP地址和端口
	sockaddr_in serAddr;
	serAddr.sin_family = AF_INET;
	serAddr.sin_port = htons(8235);
	serAddr.sin_addr.S_un.S_addr = inet_addr("192.168.43.246");
	//等待连接
	if (connect(sclient, (sockaddr *)&serAddr, sizeof(serAddr)) == SOCKET_ERROR)
	{
		printf("connect error !");
		closesocket(sclient);
		return 0;
	}
	else
	{
		send(sclient, sendData, strlen(sendData), 0);
		/*sendData[14]+=1;
		if (sendData[14] == ':')
		{
			sendData[14] = '0';
			sendData[13] += 1;
		}*/
	}
	//循环接发数据
	while (f) {
		system("cls");
		fflush(stdin);

		printf("Receive(0) or Send(1)?\n");
		scanf("%d",&mode);
		if (mode)
		{
			send(sclient, sendData, strlen(sendData), 0);
		}
		else
		{
			ret = recv(sclient, recData, 255, 0);
			if (ret > 0)
			{
				recData[ret] = 0x00;
				printf(recData);
				printf("\n");
			}
			recData[0] = '\0';
		}

		printf("Continue? Yes-1,No-0\n");
		scanf("%d",&f);
	}
	closesocket(sclient);
	WSACleanup();
	return 0;
}
