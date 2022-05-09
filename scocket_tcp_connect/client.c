#include <WinSock2.h>
#include <stdio.h>
#include <stdlib.h>
#pragma comment(lib, "ws2_32.lib")
 
int main()
{
	//�����׽���
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
 
	//�����׽���
	SOCKET sockClient = socket(AF_INET, SOCK_STREAM, 0);
	if(SOCKET_ERROR == sockClient){
		printf("Socket() error:%d", WSAGetLastError());
		return;
	}
 
	//�������������������
	if(connect(sockClient, (struct  sockaddr*)&addrSrv, sizeof(addrSrv)) == INVALID_SOCKET){
		printf("Connect failed:%d", WSAGetLastError());
		return;
	}else
	{
		//��������
		recv(sockClient, buff, sizeof(buff), 0);
		printf("%s\n", buff);
	}
	//��������
	char sendbuf[] = "hello, this is a Client....";
	send(sockClient, sendbuf, sizeof(sendbuf), 0);
	while(1){
		printf("��������Ҫ���͵�����:\n");
		scanf("%s",sendbuf);
		send(sockClient, sendbuf, sizeof(sendbuf), 0);

		memset(buff, 0, sizeof(buff));
		recv(sockClient, buff, sizeof(buff), 0);
		printf("%s\n", buff);
	}

	//�ر��׽���
	closesocket(sockClient);
	WSACleanup();
	system("pause");
	return 0;
}