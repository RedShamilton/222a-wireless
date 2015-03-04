#include <cstdlib>
#include <cstring>

#include <unistd.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <signal.h>

#include <sysexits.h>

#include <iostream>
#include <chrono>
#include <thread>

#define INTERVAL 100

static bool keepRunning = true;

void intHandler(int sig) {
	keepRunning = false;
}

using hi_res_clock = std::chrono::high_resolution_clock;

int main(int argc, char* argv[])
{
	// check for port argument
	if(argc != 2) {
		std::cerr << "Usage: " << argv[0] << " <port>" << std::endl;
		exit(EX_USAGE);
	}

	signal(SIGINT, intHandler);

	// print out clock accuracy
	std::cout << (double) hi_res_clock::period::num / hi_res_clock::period::den
		<< " seconds per clock tick" << std::endl;

	// set up socket
	struct sockaddr_in sock_in = {0};

	int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	
	if(sock < 0) {
		perror("Couldn't create socket");
		exit(1);
	}

	sock_in.sin_addr.s_addr = htonl(INADDR_ANY);
	sock_in.sin_port = htons(0);
	sock_in.sin_family = AF_INET;

	if(bind(sock, (struct sockaddr *)&sock_in, sizeof(sock_in)) != 0) {
		perror("Couldn't bind to socket");
		exit(1);
	}

	// enable braodcast
	int yes = 1;
	if(setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &yes, sizeof(int) ) != 0) {
		perror("Couldn't set to broadcast");
		exit(1);
	}

	// ready to send
	const uint16_t port = atoi(argv[1]);

	std::cout << "Now sending on port " << port << std::endl;

	//TODO: Local broadcast address using netmask?
	sock_in.sin_addr.s_addr=htonl(INADDR_BROADCAST);
	sock_in.sin_port = htons(port); // port number
	sock_in.sin_family = AF_INET;

	// times are relative to start

	for(uint32_t index = 0; keepRunning; ++index) {

		auto time = hi_res_clock::now().time_since_epoch().count();

		// pack data bytes into array
		uint8_t data[sizeof(index) + sizeof(time)];

		memcpy(&data[0], &index, sizeof(index));
		memcpy(&data[sizeof(index)], &time, sizeof(time));

		// send array
		size_t bytes_sent = sendto(sock, &data, sizeof(data), 0,
			(struct sockaddr *)&sock_in, sizeof(sock_in)
		);

		if(bytes_sent == 0) {
			break;
		} else if(bytes_sent < 0) {
			perror("Couldn't send bytes");
			exit(2);
		} else if (bytes_sent < sizeof(data)) {
			std::cerr << "Not all bytes were sent..." << std::endl;
		}

		// sleep between sends
		std::this_thread::sleep_for(std::chrono::milliseconds(INTERVAL));
	}

	// clean up
	shutdown(sock, SHUT_RDWR);
	close(sock);
}
