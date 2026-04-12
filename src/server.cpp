#include "server.h"
#include <iostream>

Server::Server(int port) : port_(port) {}

void Server::start() {
    std::cout << "Edge-AI-APP running on port " << port_ << std::endl;
    // TODO: Add AI inference logic here
}
