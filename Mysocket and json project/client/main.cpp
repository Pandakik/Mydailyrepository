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

	// 1.��ʼ���׽��ֿ�
	WORD wVersion;
	WSADATA wsaData;
	int err;

	// �������Ϊ1.1
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

	// ����TCP�׽���
	SOCKET sockCli = socket(AF_INET, SOCK_STREAM, 0);

	SOCKADDR_IN addrSrv;
	addrSrv.sin_addr.S_un.S_addr = inet_addr("127.0.0.1");	// ��������ַ
	addrSrv.sin_port = htons(6000);		// �˿ں�
	addrSrv.sin_family = AF_INET;		// ��ַ����(ipv4)

	// 2.���ӷ�����
	int err_log = connect(sockCli, (SOCKADDR*)&addrSrv, sizeof(SOCKADDR));
	if (err_log == 0) {
		printf("���ӷ������ɹ���\n");

	}
	else {
		printf("���ӷ�����ʧ�ܣ�\n");
		return -1;
	}


	char recvBuf[100];
	char sendBuf[] = "��ã������������ǿͻ��ˣ�";
	vector<string> sendstr;
	sendstr.push_back("pdankik1");
	sendstr.push_back("pdankik12");
	sendstr.push_back("pdankik13");


	// 3.�������ݵ�������
	cJSON* root = cJSON_CreateObject();
	cJSON_AddItemToObject(root, "pandakik", cJSON_CreateString("8251"));
	// д���ļ���ȥ
	char* buf = cJSON_Print(root);

	send(sockCli, buf, strlen(buf) + 1, 0);
	cJSON_Delete(root);

	//for (int i = 0; i < 3; i++)
	//{
	//	send(sockCli, sendstr[i].c_str(), strlen(sendstr[i].c_str()) + 1, 0);
	//	cout << sendstr[i] << endl;
	//}




	// 4.���շ�����������
	recv(sockCli, recvBuf, sizeof(recvBuf), 0);
	std::cout << recvBuf << std::endl;


	// 5.�ر��׽��ֲ�����׽��ֿ�
	closesocket(sockCli);
	WSACleanup();

	system("pause");

	return 0;
}
