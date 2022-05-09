#include <WinSock2.h>
#include <stdio.h>
#include <stdlib.h>
#pragma comment(lib, "ws2_32.lib")
 
int main()
{
	//加载套接字
	WSADATA wsaData;
	char buff[1024];
	memset(buff, 0, sizeof(buff));
 
	if(WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
	{
		printf("Failed to load Winsock");
		return;
	}
 
	SOCKADDR_IN addrSrv;
	addrSrv.sin_family = AF_INET;
	addrSrv.sin_port = htons(8888);
	addrSrv.sin_addr.S_un.S_addr = inet_addr("127.1.1.1");
 
	//创建套接字
	SOCKET sockClient = socket(AF_INET, SOCK_STREAM, 0);
	if(SOCKET_ERROR == sockClient){
		printf("Socket() error:%d", WSAGetLastError());
		return;
	}
 
	//向服务器发出连接请求
	if(connect(sockClient, (struct  sockaddr*)&addrSrv, sizeof(addrSrv)) == INVALID_SOCKET){
		printf("Connect failed:%d", WSAGetLastError());
		return;
	}else
	{
		//接收数据
		recv(sockClient, buff, sizeof(buff), 0);
		printf("%s\n", buff);
	}
	//发送数据
	char sendbuf[] = "hello, this is a Client....";
	send(sockClient, sendbuf, sizeof(sendbuf), 0);
	while(1){
		printf("请输入你要发送的数据:\n");
		scanf("%s",sendbuf);
		send(sockClient, sendbuf, sizeof(sendbuf), 0);

		memset(buff, 0, sizeof(buff));
		recv(sockClient, buff, sizeof(buff), 0);
		printf("%s\n", buff);
	}

	//关闭套接字
	closesocket(sockClient);
	WSACleanup();
	system("pause");
	return 0;
}