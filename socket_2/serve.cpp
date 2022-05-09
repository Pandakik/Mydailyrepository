#include <stdio.h>
#include <winsock2.h> //包含socket类的头文件
#include<stdlib.h>
#include<time.h>  

#pragma comment(lib,"ws2_32.lib")

int main(int argc, char* argv[])
{
	//初始化WSA
	WORD sockVersion = MAKEWORD(2, 2);
	WSADATA wsaData;
	int f = 1, mode = 0;
	int ret = -1;
	char sendData[] = "Times:0000\n";
	if (WSAStartup(sockVersion, &wsaData) != 0)
	{
		return 0;
	}

	//创建套接字
	SOCKET slisten = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (slisten == INVALID_SOCKET)
	{
		printf("socket error !");
		return 0;
	}

	//绑定IP和端口
	sockaddr_in sin;
	sin.sin_family = AF_INET;
	sin.sin_port = htons(8235);
	sin.sin_addr.S_un.S_addr = INADDR_ANY;
	if (bind(slisten, (LPSOCKADDR)&sin, sizeof(sin)) == SOCKET_ERROR)
	{
		printf("bind error !\n");
	}

	//开始监听
	if (listen(slisten, 5) == SOCKET_ERROR)
	{
		printf("listen error !\n");
		return 0;
	}

	//循环接收数据
	SOCKET sClient;
	sockaddr_in remoteAddr;
	int nAddrlen = sizeof(remoteAddr);
	char revData[255];
	while (f)
	{
		system("cls");
		fflush(stdin);
		printf("Wait...\n");
		sClient = accept(slisten, (SOCKADDR *)&remoteAddr, &nAddrlen);
		if (sClient == INVALID_SOCKET)
		{
			printf("accept error !");
			continue;
		}
		else
		{
			printf("Received a Response from: %s \r\n", inet_ntoa(remoteAddr.sin_addr));
			printf("Send(1) or Receive(0)?\n");
			scanf("%d", &mode);
			if (mode)
			{
				send(sClient, sendData, strlen(sendData), 0);
				sendData[9]++;
				if (sendData[9] == ':')
				{
					sendData[9] = '0';
					sendData[8] += 1;
				}
			}
			else
			{
				ret = recv(sClient, revData, 255, 0);
				if (ret > 0)
				{
					revData[ret] = '\0';
					printf(revData);
					printf("\n");
				}
				revData[0] = '\0';
				closesocket(sClient);
			}
		}
		printf("Continue or Quit(0)\n");
		scanf("%d", &f);
	}
	closesocket(slisten);
	WSACleanup();
	return 0;
}
