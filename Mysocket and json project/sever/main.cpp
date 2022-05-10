#include <iostream>
#include <stdio.h>
#include <WinSock2.h>
#include <Windows.h>
#include <fstream>


#pragma comment(lib, "ws2_32.lib")
#define _CRT_SECURE_NO_WARNINGS
#define OPEN_MAX_TIMES 5

int main(void) {

	// 1.��ʼ���׽��ֿ�
	WORD wVersion;
	WSADATA wsaData;
	int err;

	// ���ð汾���������Ϊ1.1
	wVersion = MAKEWORD(1, 1);	// ����MAKEWORD(a, b) --> b | a << 8 ��a����8λ��ɸ�λ��b�ϲ�����

	// ����
	err = WSAStartup(wVersion, &wsaData);
	if (err != 0) {
		return err;
	}
	// ��飺�����λ������1 || �����λ������1
	if (LOBYTE(wsaData.wVersion) != 1 || HIBYTE(wsaData.wVersion) != 1) {
		// �����׽��ֿ�
		WSACleanup();
		return -1;
	}

	// 2.����tcp�׽���		// AF_INET:ipv4   AF_INET6:ipv6
	SOCKET sockSrv = socket(AF_INET, SOCK_STREAM, 0);

	// ׼������Ϣ
	SOCKADDR_IN addrSrv;
	addrSrv.sin_addr.S_un.S_addr = htonl(INADDR_ANY);	// ���ð�����
	addrSrv.sin_family = AF_INET;		// ���ð�����ģʽ
	addrSrv.sin_port = htons(6000);		// ���ð󶨶˿�
	// hton: host to network  x86:С��    ���紫�䣺htons���

	// 3.�󶨵�����
	int retVal = bind(sockSrv, (SOCKADDR*)&addrSrv, sizeof(SOCKADDR));
	if (retVal == SOCKET_ERROR) {
		printf("Failed bind:%d\n", WSAGetLastError());
		return -1;
	}

	// 4.������ͬʱ�ܽ���10������
	if (listen(sockSrv, 10) == SOCKET_ERROR) {
		printf("Listen failed:%d", WSAGetLastError());
		return -1;
	}

	std::cout << "Server start at port: 6000" << std::endl;

	SOCKADDR_IN addrCli;
	int len = sizeof(SOCKADDR);

	char recvBuf[100];
	char sendBuf[100];
	while (1) {
		// 5.�����������󣬷�����Կͻ��˵��׽���
		SOCKET sockConn = accept(sockSrv, (SOCKADDR*)&addrCli, &len);
		if (sockConn == SOCKET_ERROR) {
			//printf("Accept failed:%d", WSAGetLastError());
			std::cout << "Accept failed: " << WSAGetLastError() << std::endl;
			break;
		}

		//printf("Accept client IP:[%s]\n", inet_ntoa(addrCli.sin_addr));
		std::cout << "Accept client IP: " << inet_ntoa(addrCli.sin_addr) << std::endl;

		// 6.��������
		sprintf_s(sendBuf, "hello client!\n");
		int iSend = send(sockConn, sendBuf, strlen(sendBuf) + 1, 0);
		if (iSend == SOCKET_ERROR) {
			std::cout << "send failed!\n";
			break;
		}

		// 7.��������
		while (1)
		{
			recv(sockConn, recvBuf, 100, 0);
			std::cout << recvBuf << std::endl;
		}
		
		// �ر��׽���
		closesocket(sockConn);

	}


	// 8.�ر��׽���
	closesocket(sockSrv);

	// 9.�����׽��ֿ�
	WSACleanup();

	return 0;
}
