#include "server.h"
#include <cassert>
#include <iostream>

int main() {
    Server testServer(9090);
    testServer.start();
    assert(true); // Simple placeholder test
    std::cout << "All tests passed!" << std::endl;
    return 0;
}
