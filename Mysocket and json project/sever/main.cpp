#include <iostream>
#include <stdio.h>
#include <WinSock2.h>
#include <Windows.h>
#include <fstream>


#pragma comment(lib, "ws2_32.lib")
#define _CRT_SECURE_NO_WARNINGS
#define OPEN_MAX_TIMES 5

int main(void) {

	// 1.初始化套接字库
	WORD wVersion;
	WSADATA wsaData;
	int err;

	// 设置版本，可以理解为1.1
	wVersion = MAKEWORD(1, 1);	// 例：MAKEWORD(a, b) --> b | a << 8 将a左移8位变成高位与b合并起来

	// 启动
	err = WSAStartup(wVersion, &wsaData);
	if (err != 0) {
		return err;
	}
	// 检查：网络低位不等于1 || 网络高位不等于1
	if (LOBYTE(wsaData.wVersion) != 1 || HIBYTE(wsaData.wVersion) != 1) {
		// 清理套接字库
		WSACleanup();
		return -1;
	}

	// 2.创建tcp套接字		// AF_INET:ipv4   AF_INET6:ipv6
	SOCKET sockSrv = socket(AF_INET, SOCK_STREAM, 0);

	// 准备绑定信息
	SOCKADDR_IN addrSrv;
	addrSrv.sin_addr.S_un.S_addr = htonl(INADDR_ANY);	// 设置绑定网卡
	addrSrv.sin_family = AF_INET;		// 设置绑定网络模式
	addrSrv.sin_port = htons(6000);		// 设置绑定端口
	// hton: host to network  x86:小端    网络传输：htons大端

	// 3.绑定到本机
	int retVal = bind(sockSrv, (SOCKADDR*)&addrSrv, sizeof(SOCKADDR));
	if (retVal == SOCKET_ERROR) {
		printf("Failed bind:%d\n", WSAGetLastError());
		return -1;
	}

	// 4.监听，同时能接收10个链接
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
		// 5.接收连接请求，返回针对客户端的套接字
		SOCKET sockConn = accept(sockSrv, (SOCKADDR*)&addrCli, &len);
		if (sockConn == SOCKET_ERROR) {
			//printf("Accept failed:%d", WSAGetLastError());
			std::cout << "Accept failed: " << WSAGetLastError() << std::endl;
			break;
		}

		//printf("Accept client IP:[%s]\n", inet_ntoa(addrCli.sin_addr));
		std::cout << "Accept client IP: " << inet_ntoa(addrCli.sin_addr) << std::endl;

		// 6.发送数据
		sprintf_s(sendBuf, "hello client!\n");
		int iSend = send(sockConn, sendBuf, strlen(sendBuf) + 1, 0);
		if (iSend == SOCKET_ERROR) {
			std::cout << "send failed!\n";
			break;
		}

		// 7.接收数据
		while (1)
		{
			recv(sockConn, recvBuf, 100, 0);
			std::cout << recvBuf << std::endl;
		}
		
		// 关闭套接字
		closesocket(sockConn);

	}


	// 8.关闭套接字
	closesocket(sockSrv);

	// 9.清理套接字库
	WSACleanup();

	return 0;
}
