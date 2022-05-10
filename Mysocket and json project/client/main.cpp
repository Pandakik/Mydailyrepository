#include <iostream>
#include <WinSock2.h>
#include<vector>
#include <Windows.h>
#include <fstream>
#include "cJSON.h"

using namespace std;

#pragma comment(lib, "ws2_32.lib")
#define _CRT_SECURE_NO_WARNINGS
#define OPEN_MAX_TIMES 5


int main(void) {

	// 1.初始化套接字库
	WORD wVersion;
	WSADATA wsaData;
	int err;

	// 可以理解为1.1
	wVersion = MAKEWORD(1, 1);	// 例：MAKEWORD(a, b) --> b | a << 8 将a左移8位变成高位与b合并起来

	// 启动
	err = WSAStartup(wVersion, &wsaData);
	if (err != 0) {
		return err;
	}
	// 检查：网络地位不等于1 || 网络高位不等于1
	if (LOBYTE(wsaData.wVersion) != 1 || HIBYTE(wsaData.wVersion) != 1) {
		// 清理套接字库
		WSACleanup();
		return -1;
	}

	// 创建TCP套接字
	SOCKET sockCli = socket(AF_INET, SOCK_STREAM, 0);

	SOCKADDR_IN addrSrv;
	addrSrv.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");	// 服务器地址
	addrSrv.sin_port = htons(6000);		// 端口号
	addrSrv.sin_family = AF_INET;		// 地址类型(ipv4)

	// 2.连接服务器
	int err_log = connect(sockCli, (SOCKADDR*)&addrSrv, sizeof(SOCKADDR));
	if (err_log == 0) {
		printf("连接服务器成功！\n");

	}
	else {
		printf("连接服务器失败！\n");
		return -1;
	}


	char recvBuf[100];
	char sendBuf[] = "你好，服务器，我是客户端！";
	vector<string> sendstr;
	sendstr.push_back("pdankik1");
	sendstr.push_back("pdankik12");
	sendstr.push_back("pdankik13");


	// 3.发送数据到服务器
	cJSON* root = cJSON_CreateObject();
	cJSON_AddItemToObject(root, "pandakik", cJSON_CreateString("8251"));
	// 写道文件中去
	char* buf = cJSON_Print(root);

	send(sockCli, buf, strlen(buf) + 1, 0);
	cJSON_Delete(root);

	//for (int i = 0; i < 3; i++)
	//{
	//	send(sockCli, sendstr[i].c_str(), strlen(sendstr[i].c_str()) + 1, 0);
	//	cout << sendstr[i] << endl;
	//}




	// 4.接收服务器的数据
	recv(sockCli, recvBuf, sizeof(recvBuf), 0);
	std::cout << recvBuf << std::endl;


	// 5.关闭套接字并清除套接字库
	closesocket(sockCli);
	WSACleanup();

	system("pause");

	return 0;
}
