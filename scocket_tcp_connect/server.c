#include <WinSock2.h>
#include <stdio.h>
#include <stdlib.h>
 
#pragma comment(lib, "ws2_32.lib") 
 //gcc -o server server.c -lwsock32
int main()
{
	int iSend = 0;
	WSADATA wsaData;
	int port = 8888;
	char recvBuf[100];
 
	char buf[] = "Server: hello, I am a server....."; 
 
	if(WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
	{
		printf("Failed to load Winsock");
		return;
	}
 
	//�������ڼ������׽���
	SOCKET sockSrv = socket(AF_INET, SOCK_STREAM, 0);
 
	SOCKADDR_IN addrSrv;
	addrSrv.sin_family = AF_INET;
	addrSrv.sin_port = htons(port); //1024���ϵĶ˿ں�
	addrSrv.sin_addr.S_un.S_addr = htonl(INADDR_ANY);
 
	int retVal = bind(sockSrv, (LPSOCKADDR)&addrSrv, sizeof(SOCKADDR_IN));
	if(retVal == SOCKET_ERROR){
		printf("Failed bind:%d\n", WSAGetLastError());
		return;
	}
	if(listen(sockSrv,10) ==SOCKET_ERROR){
		printf("Listen failed:%d", WSAGetLastError());
		return;
	}
 
	SOCKADDR_IN addrClient;
	int len = sizeof(SOCKADDR);
 
	while(1)
	{
		//�ȴ��ͻ�������	
		SOCKET sockConn = accept(sockSrv, (SOCKADDR *) &addrClient, &len);
		if(sockConn == SOCKET_ERROR){
			printf("Accept failed:%d", WSAGetLastError());
			break;
		}
 
		printf("Accept client IP:[%s]\n", inet_ntoa(addrClient.sin_addr));
 
		//��������
		int iSend = send(sockConn, buf, sizeof(buf) , 0);
		if(iSend == SOCKET_ERROR){
			printf("send failed");
			break;
		}
 
 		
 		memset(recvBuf, 0, sizeof(recvBuf));
// 		//��������
 		recv(sockConn, recvBuf, sizeof(recvBuf), 0);
 		printf("%s\n", recvBuf);
 
		while(1){
			memset(recvBuf, 0, sizeof(recvBuf));
	// 		//��������
			recv(sockConn, recvBuf, sizeof(recvBuf), 0);
			printf("%s\n", recvBuf);

		printf("��������Ҫ���͵�����:\n");
		memset(buf, 0, sizeof(buf));
		scanf("%s", buf);
		iSend = send(sockConn, buf, sizeof(buf) , 0);
		if(iSend == SOCKET_ERROR){
			printf("send failed");
			break;
		}
		}
		break;
		closesocket(sockConn);
	}
	closesocket(sockSrv);
	WSACleanup();
	system("pause");
	return 0;
}
